Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout2.freenet.de ([195.4.92.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <majamaki@freenet.de>) id 1KeZS2-0007Yj-EH
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 20:02:33 +0200
Received: from [195.4.92.13] (helo=3.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID exim) (port 25) (Exim 4.69 #65)
	id 1KeZRy-0005e1-Kq
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 20:02:26 +0200
Received: from www11.emo.freenet-rz.de ([194.97.107.204]:50331)
	by 3.mx.freenet.de with esmtp (port 25) (Exim 4.69 #65)
	id 1KeZRy-0006pB-Jt
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 20:02:26 +0200
Received: from www-data by www11.emo.freenet-rz.de with local (Exim 4.67 1
	(Panther_1)) id 1KeZMO-0006GQ-LJ
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 19:56:40 +0200
To: linux-dvb@linuxtv.org
From: majamaki@freenet.de
MIME-Version: 1.0
Message-Id: <E1KeZMO-0006GQ-LJ@www11.emo.freenet-rz.de>
Date: Sat, 13 Sep 2008 19:56:40 +0200
Subject: [linux-dvb] Technotrend S-1500 and CI - CI not really working with
	Conax?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0176755080=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0176755080==
Content-Type: multipart/alternative; boundary=b_01_2ecb9d0007870eed8a8be27ee6509f1e

--b_01_2ecb9d0007870eed8a8be27ee6509f1e
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//DE"><HTML><HEAD><=
META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; charset=3Dus-ascii">=
<TITLE>Message</TITLE></HEAD><BODY>I had this impression from linuxtv site =
that TT S-1500 and CI would be supported.<br>Anyway card runs fine - I am r=
eceiving 2 satellites with multifeed antenna and I was able<br>to create ch=
annels.conf files for both with scan. szap also locks on channels from both=
 satellites.<br>Problem is that the other satellite (Thor) requires Conax c=
ard, but when I  CI slot<br>it is acknowledged in dmesg by:<br><br>dvb_ca a=
dapter 0: DVB CAM detected and initialised successfully
<br><br>but now I do not get picture even from free channels anymore. szap =
still locks alright.<br>Also interesting is to mention that with gnutv -cam=
menu I am able to get access to cammenu<br>which is in finnish so I assume =
it is really originating from my conax card.<br><br>Also when tuning with g=
nutv (with Conax card in the slot) I get a lock on a free channel and I can=
<br>watch it then few seconds with mplayer - < /dev/dvb/adapter0/dvr0 comma=
nd but after these seconds<br>gnutv reports something about CAM (does not l=
ook like error or anything like this) and the picture goes<br>black.<br><br=
>Have I misunderstood the supported but and have my hopes too high or am I =
just missing something<br>I need to do first (load some modules or so?)<br>=
<br>I would appreciate every bit of help since I find little information ab=
out this approach, lot more about using a smartcard<br>reader and sc-plugin=
s and other methods...<br><br>Haven't bothered to plug in my hardware on my=
 second Windows computer, I know only from my digibox that card works<br>an=
d is activated...<br>=0A=0A=0A<br>--<br><!-- AdSpace freenet EMO Webmail Ba=
nner --> =0A<a href=3D"http://adserver.freenet.de/click.ng/site=3Dfn&prod=
=3Dchetools&kat=3Dinhalte&tbl=3Dwebmail&ppos=3D14&TransactionID=3D122132860=
0623927&rgtg=3D256" target=3D"_blank"><img src=3D"http://adserver.freenet.d=
e/image.ng/site=3Dfn&prod=3Dchetools&kat=3Dinhalte&tbl=3Dwebmail&ppos=3D14&=
TransactionID=3D1221328600623927&rgtg=3D256" border=3D"0"></a><!-- / AdSpac=
e -->=0A</BODY></HTML>
--b_01_2ecb9d0007870eed8a8be27ee6509f1e
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

I had this impression from linuxtv site that TT S-1500 and CI would be supp=
orted.=0AAnyway card runs fine - I am receiving 2 satellites with multifeed=
 antenna and I was able=0Ato create channels.conf files for both with scan.=
 szap also locks on channels from both satellites.=0AProblem is that the ot=
her satellite (Thor) requires Conax card, but when I  CI slot=0Ait is ackno=
wledged in dmesg by:=0A=0Advb_ca adapter 0: DVB CAM detected and initialise=
d successfully=0A=0Abut now I do not get picture even from free channels an=
ymore. szap still locks alright.=0AAlso interesting is to mention that with=
 gnutv -cammenu I am able to get access to cammenu=0Awhich is in finnish so=
 I assume it is really originating from my conax card.=0A=0AAlso when tunin=
g with gnutv (with Conax card in the slot) I get a lock on a free channel a=
nd I can=0Awatch it then few seconds with mplayer - < /dev/dvb/adapter0/dvr=
0 command but after these seconds=0Agnutv reports something about CAM (does=
 not look like error or anything like this) and the picture goes=0Ablack.=
=0A=0AHave I misunderstood the supported but and have my hopes too high or =
am I just missing something=0AI need to do first (load some modules or so?)=
=0A=0AI would appreciate every bit of help since I find little information =
about this approach, lot more about using a smartcard=0Areader and sc-plugi=
ns and other methods...=0A=0AHaven't bothered to plug in my hardware on my =
second Windows computer, I know only from my digibox that card works=0Aand =
is activated...=0A=0AHeute schon ge"freeMail"t?=0AJetzt kostenlose E-Mail-A=
dresse sichern!=0Ahttp://email.freenet.de/dienste/emailoffice/produktuebers=
icht/basic/mail/index.html?pid=3D6831=0A
--b_01_2ecb9d0007870eed8a8be27ee6509f1e--


--===============0176755080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0176755080==--
