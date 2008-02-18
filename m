Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33102.mail.mud.yahoo.com ([209.191.69.132])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JR0hN-0001Vs-3x
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 08:46:01 +0100
Date: Sun, 17 Feb 2008 23:45:10 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <631553.2513.qm@web33102.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor commands
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2034331472=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2034331472==
Content-Type: multipart/alternative; boundary="0-1001197538-1203320710=:2513"

--0-1001197538-1203320710=:2513
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This is and update on the issue - it turned out that I do not get enough cu=
rrent so that I=0Acan tune and drive the rotor. On both Windows and Linux s=
ide my LNBs drain about =0A150 mA when connected to the Twinhan VP1041. The=
 rotor needs about 300 mA to=0Amove. So on the Windows side I measured abou=
t 440-450 mA when the dish was =0Amoving (not including a short burst at th=
e beginning of the dish drive). But on the Linux side =0AI don't seem to be=
 able to go above 300 mA. No clue why ....=0ADoes anyone know if the max cu=
rrent is controlled in some way on this cards?=0A=0AThanks in advance!=0A=
=0A----- Original Message ----=0AFrom: =D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=
=D1=80=D0=BE=D0=B2 =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 <ua0lnj@bk.ru>=0ATo=
: linux-dvb <linux-dvb@linuxtv.org>=0ASent: Monday, February 11, 2008 3:45:=
02 PM=0ASubject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor co=
mmands=0A=0A=EF=BB=BF  I think, this is becouse "Initial support for Mantis=
 VP-1041" =0Anot usability yet.=0AI use patch from Hans Werner for 1041, wo=
rks better.=0A  ----- Original Message ----- =0A  From:   Simeon =0A  Simeo=
nov =0A  To: linux-dvb =0A  Sent: Tuesday, February 12, 2008 6:47   AM=0A  =
Subject: [linux-dvb] mantis vp1041 with   strange diseqc rotor commands=0A =
 =0A=0AHi,=0A=0AI am using the latest mantis drivers from Manu's   reposito=
ry:=0Ahttp://jusst.de/hg/mantis/=0Awith my   Azureware twinhan vp1041 based=
 card.=0ALocking to DVB-S channels works fine   almost all the time with th=
e patched szap or patched mythtv.=0ADid not try   DVB-S2 yet. But what I am=
 having troubles now is the diseqc. I have a switch   behind a diseqc 1.2 r=
otor (goto stored positions).=0AThe switching works fine   under Windoz. I =
have no problems also using it with my other card in the same   box - Twinh=
an 102g.=0AInitially with the vp1041 card after a couple of diseqc   comman=
ds I would get stb0899_diseqc_fifo_empy timeout. It turned out that I   had=
 to use some very long pauses before sending a repeat command. If =0Afor   =
the 102g standart 15ms worked fine, for the vp1041 I had to use 1s! pause. =
  Then the rotor will start=0A moving very slowly with small steps  -   as =
if it is does one step , stops and then continues to the desired   position=
.If one is patient enough the rotor gets to the desired position. I   check=
ed using voltmeter the voltages that come out of the card and they seem   t=
o be good. For sending the commands I used both mythtv and hacked version o=
f   Michel Verbraak's gotox program.=0AHas anyone experienced something sim=
ilar   with stb0899 frontend? Perhaps you can give me an idea what might be=
 going   wrong?=0A=0AThanks,=0ASimeon=0A=0A=0A=0A=0A=0A        ____________=
________________________________________________________________________=0A=
Be   a better friend, newshound, and =0Aknow-it-all with Yahoo! Mobile.  Tr=
y   it now.  http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ  =
 =0A=0A=0A_______________________________________________=0Alinux-dvb   mai=
ling list=0Alinux-dvb@linuxtv.org=0Ahttp://www.linuxtv.org/cgi-bin/mailman/=
listinfo/linux-dvb=0A=0A=0A-----Inline Attachment Follows-----=0A=0A_______=
________________________________________=0Alinux-dvb mailing list=0Alinux-d=
vb@linuxtv.org=0Ahttp://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=
=0A=0A=0A=0A=0A=0A=0A      ________________________________________________=
____________________________________=0ABe a better friend, newshound, and =
=0Aknow-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_=
ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ =0A
--0-1001197538-1203320710=:2513
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div style=3D"font-family: times new roman,new york,times,seri=
f; font-size: 12pt;">This is and update on the issue - it turned out that I=
 do not get enough current so that I<br>can tune and drive the rotor. On bo=
th Windows and Linux side my LNBs drain about <br>150 mA when connected to =
the Twinhan VP1041. The rotor needs about 300 mA to<br>move. So on the Wind=
ows side I measured about 440-450 mA when the dish was <br>moving (not incl=
uding a short burst at the beginning of the dish drive). But on the Linux s=
ide <br>I don't seem to be able to go above 300 mA. No clue why ....<br>Doe=
s anyone know if the max current is controlled in some way on this cards?<b=
r><br>Thanks in advance!<br><br><div style=3D"font-family: times new roman,=
new york,times,serif; font-size: 12pt;">----- Original Message ----<br>From=
:
 =D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =D0=90=D0=BD=D0=B4=
=D1=80=D0=B5=D0=B9 &lt;ua0lnj@bk.ru&gt;<br>To: linux-dvb &lt;linux-dvb@linu=
xtv.org&gt;<br>Sent: Monday, February 11, 2008 3:45:02 PM<br>Subject: Re: [=
linux-dvb] mantis vp1041 with strange diseqc rotor commands<br><br>=0A=EF=
=BB=BF=0A=0A =0A =0A<style></style>=0A=0A<div>I think, this is becouse "<st=
rong>Initial support for Mantis VP-1041" =0A</strong>not usability yet.</di=
v>=0A<div>I use patch from Hans Werner for 1041, works better.</div>=0A<blo=
ckquote style=3D"border-left: 2px solid rgb(0, 0, 0); padding-right: 0px; p=
adding-left: 5px; margin-left: 5px; margin-right: 0px;">=0A  <div style=3D"=
font-family: arial; font-style: normal; font-variant: normal; font-weight: =
normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-=
stretch: normal;">----- Original Message ----- </div>=0A  <div style=3D"bac=
kground: rgb(228, 228, 228) none repeat scroll 0%; -moz-background-clip: -m=
oz-initial; -moz-background-origin: -moz-initial; -moz-background-inline-po=
licy: -moz-initial; font-family: arial; font-style: normal; font-variant: n=
ormal; font-weight: normal; font-size: 10pt; line-height: normal; font-size=
-adjust: none; font-stretch: normal;"><b>From:</b> =0A  <a rel=3D"nofollow"=
 title=3D"simeonov_2000@yahoo.com" ymailto=3D"mailto:simeonov_2000@yahoo.co=
m" target=3D"_blank" href=3D"mailto:simeonov_2000@yahoo.com">Simeon =0A  Si=
meonov</a> </div>=0A  <div style=3D"font-family: arial; font-style: normal;=
 font-variant: normal; font-weight: normal; font-size: 10pt; line-height: n=
ormal; font-size-adjust: none; font-stretch: normal;"><b>To:</b> <a rel=3D"=
nofollow" title=3D"linux-dvb@linuxtv.org" ymailto=3D"mailto:linux-dvb@linux=
tv.org" target=3D"_blank" href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb</=
a> </div>=0A  <div style=3D"font-family: arial; font-style: normal; font-va=
riant: normal; font-weight: normal; font-size: 10pt; line-height: normal; f=
ont-size-adjust: none; font-stretch: normal;"><b>Sent:</b> Tuesday, Februar=
y 12, 2008 6:47 =0A  AM</div>=0A  <div style=3D"font-family: arial; font-st=
yle: normal; font-variant: normal; font-weight: normal; font-size: 10pt; li=
ne-height: normal; font-size-adjust: none; font-stretch: normal;"><b>Subjec=
t:</b> [linux-dvb] mantis vp1041 with =0A  strange diseqc rotor commands</d=
iv>=0A  <div><br></div>Hi,<br><br>I am using the latest mantis drivers from=
 Manu's =0A  repository:<br><a rel=3D"nofollow" target=3D"_blank" href=3D"h=
ttp://jusst.de/hg/mantis/">http://jusst.de/hg/mantis/</a><br>with my =0A  A=
zureware twinhan vp1041 based card.<br>Locking to DVB-S channels works fine=
 =0A  almost all the time with the patched szap or patched mythtv.<br>Did n=
ot try =0A  DVB-S2 yet. But what I am having troubles now is the diseqc. I =
have a switch =0A  behind a diseqc 1.2 rotor (goto stored positions).<br>Th=
e switching works fine =0A  under Windoz. I have no problems also using it =
with my other card in the same =0A  box - Twinhan 102g.<br>Initially with t=
he vp1041 card after a couple of diseqc =0A  commands I would get stb0899_d=
iseqc_fifo_empy timeout. It turned out that I =0A  had to use some very lon=
g pauses before sending a repeat command. If <br>for =0A  the 102g standart=
 15ms worked fine, for the vp1041 I had to use 1s! pause. =0A  Then the rot=
or will start<br>&nbsp;moving very slowly with small steps&nbsp; - =0A  as =
if it is does one step , stops and then continues to the desired =0A  posit=
ion.If one is patient enough the rotor gets to the desired position. I =0A =
 checked using voltmeter the voltages that come out of the card and they se=
em =0A  to be good. For sending the commands I used both mythtv and hacked =
version of =0A  Michel Verbraak's gotox program.<br>Has anyone experienced =
something similar =0A  with stb0899 frontend? Perhaps you can give me an id=
ea what might be going =0A  wrong?<br><br>Thanks,<br>Simeon<br><br><br><br>=
<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A  _______________________________=
_____________________________________________________<br>Be =0A  a better f=
riend, newshound, and <br>know-it-all with Yahoo! Mobile.&nbsp; Try =0A  it=
 now.&nbsp; <a rel=3D"nofollow" target=3D"_blank" href=3D"http://mobile.yah=
oo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tAcJ">http://mobile.yahoo.com/;_ylt=
=3DAhu06i62sR8HDtDypao8Wcj9tAcJ</a> =0A  <br><br><br>______________________=
_________________________<br>linux-dvb =0A  mailing list<br><a rel=3D"nofol=
low" ymailto=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank" href=3D"mai=
lto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a rel=3D"nofollow"=
 target=3D"_blank" href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/=
linux-dvb">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br=
></blockquote><!-- kill --><div><br><br>-----Inline Attachment Follows-----=
<br><br>_______________________________________________<br>linux-dvb =0Amai=
ling =0Alist<br><a ymailto=3D"mailto:linux-dvb@linuxtv.org" href=3D"mailto:=
linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a href=3D"http://www.l=
inuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=3D"_blank">http://www=
.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></div></div><br></div></=
div><br>=0A      <hr size=3D1>Looking for last minute shopping deals? <a hr=
ef=3D"http://us.rd.yahoo.com/evt=3D51734/*http://tools.search.yahoo.com/new=
search/category.php?category=3Dshopping"> =0AFind them fast with Yahoo! Sea=
rch.</a></body></html>
--0-1001197538-1203320710=:2513--


--===============2034331472==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2034331472==--
