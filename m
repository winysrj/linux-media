Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s25.bay0.hotmail.com ([65.54.246.161])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ota1998@hotmail.com>) id 1KKvMY-00044w-2A
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 15:23:39 +0200
Message-ID: <BAY102-W4202669C08AC67C5BCB7A0BC8A0@phx.gbl>
From: toy ota <ota1998@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Mon, 21 Jul 2008 15:23:03 +0200
MIME-Version: 1.0
Subject: [linux-dvb]  Latest TT3200 Status
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0681674382=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0681674382==
Content-Type: multipart/alternative;
	boundary="_893a29d0-0bdf-4eba-98c3-5fdcaa27eaf9_"

--_893a29d0-0bdf-4eba-98c3-5fdcaa27eaf9_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable


Hello=2C>I need the (patch_sca_szap.diff) fileThis file is still available =
from this post:http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026423.=
html

I have installed friday Linux Mythbuntu and now my TT-3200 is finally worki=
ng.=20
I can lock most dvb-s TP and even some (but not all) dvb-s2 TP (Anixe HD lo=
cks but decoding is not fast enough without GPU help).
For dvb-s2 i use szap2. I have followed Goga777 instructions with a mix of =
others advice (frontend.h=2C compat.h=2C patch -p1 are names familar to me =
now !).=20

Alain.


2 screenshots:
http://img339.imageshack.us/img339/5866/ab311636vto0.png

http://img168.imageshack.us/img168/2205/ab3mux111636vbx9.png

grep "CANAL+"  /opt/ab3.szap
CANAL+:11636:v:2:30405:0:0:769:0
/opt/dvb/dvb-apps/util/szap# ./szap  -c /opt/ab3.szap "CANAL+"
dvbstream  -o 8192 | vlc -  =20

For dvb-s2: szap2 -t2 -c /opt/ab3.szap ANIXEHD

-t2 =3D dvb-s2

_________________________________________________________________
Emportez vos amis et vos emails partout=85 A la c=F4te=2C en ville ou dans =
le fin fond des Ardennes !
http://windowslivemobile.msn.com/?lang=3Dfr-BE=

--_893a29d0-0bdf-4eba-98c3-5fdcaa27eaf9_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
<font size=3D"2" face=3D"Arial"><pre>Hello=2C</pre><pre>&gt=3BI need the (p=
atch_sca_szap.diff) file</pre><pre>This file is still available from this p=
ost:</pre><pre><a href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2008-J=
une/026423.html" target=3D"_blank">http://www.linuxtv.org/pipermail/linux-d=
vb/2008-June/026423.html</a><br><br>I have installed friday Linux Mythbuntu=
 and now my TT-3200 is finally working. <br>I can lock most dvb-s TP and ev=
en some (but not all) dvb-s2 TP (Anixe HD locks but decoding is not fast en=
ough without GPU help).<br>For dvb-s2 i use szap2. I have followed Goga777 =
instructions with a mix of others advice (frontend.h=2C compat.h=2C patch -=
p1 are names familar to me now !). <br><br>Alain.<br><br><br>2 screenshots:=
<br><a class=3D"EC_moz-txt-link-freetext" href=3D"http://img339.imageshack.=
us/img339/5866/ab311636vto0.png" target=3D"_blank">http://img339.imageshack=
.us/img339/5866/ab311636vto0.png</a><br><br><a class=3D"EC_moz-txt-link-fre=
etext" href=3D"http://img168.imageshack.us/img168/2205/ab3mux111636vbx9.png=
" target=3D"_blank">http://img168.imageshack.us/img168/2205/ab3mux111636vbx=
9.png</a><br><br><font size=3D"2" face=3D"Arial"><pre>grep "CANAL+"  /opt/a=
b3.szap<br>CANAL+:11636:v:2:30405:0:0:769:0<br>/opt/dvb/dvb-apps/util/szap#=
 ./szap  -c /opt/ab3.szap "CANAL+"<br>dvbstream  -o 8192 | vlc -   <br><br>=
For dvb-s2: szap2 -t2 -c /opt/ab3.szap ANIXEHD<br><br>-t2 =3D dvb-s2</pre><=
/font><br></pre></font><br /><hr />Emportez vos amis et vos emails partout=
=85  <a href=3D'http://windowslivemobile.msn.com/?lang=3Dfr-BE' target=3D'_=
new'>A la c=F4te=2C en ville ou dans le fin fond des Ardennes !</a></body>
</html>=

--_893a29d0-0bdf-4eba-98c3-5fdcaa27eaf9_--


--===============0681674382==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0681674382==--
