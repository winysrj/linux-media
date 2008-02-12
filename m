Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from web33106.mail.mud.yahoo.com ([209.191.69.136])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JOjtX-0000nT-FO
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 02:25:12 +0100
Date: Mon, 11 Feb 2008 17:24:39 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: =?utf-8?B?0J/RgNC40LTQstC+0YDQvtCyINCQ0L3QtNGA0LXQuQ==?= <ua0lnj@bk.ru>,
	linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <922065.65936.qm@web33106.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] mantis vp1041 with strange diseqc rotor commands
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2025204005=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2025204005==
Content-Type: multipart/alternative; boundary="0-1312109846-1202779479=:65936"

--0-1312109846-1202779479=:65936
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9,=0A=0ADo you have a rotor? If i=
t works OK which program do you use to drive it?=0A=0A----- Original Messag=
e ----=0AFrom: =D0=9F=D1=80=D0=B8=D0=B4=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =D0=
=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 <ua0lnj@bk.ru>=0ATo: linux-dvb <linux-dvb=
@linuxtv.org>=0ASent: Monday, February 11, 2008 3:45:02 PM=0ASubject: Re: [=
linux-dvb] mantis vp1041 with strange diseqc rotor commands=0A=0A=0A=EF=BB=
=BF=0A=0A =0A =0A=0A=0AI think, this is becouse "Initial support for Mantis=
 VP-1041" =0Anot usability yet.=0A=0AI use patch from Hans Werner for 1041,=
 works better.=0A=0A=0A  ----- Original Message ----- =0A=0A  From: =0A  Si=
meon =0A  Simeonov =0A=0A  To: linux-dvb =0A=0A  Sent: Tuesday, February 12=
, 2008 6:47 =0A  AM=0A=0A  Subject: [linux-dvb] mantis vp1041 with =0A  str=
ange diseqc rotor commands=0A=0A  =0A=0AHi,=0A=0AI am using the latest mant=
is drivers from Manu's =0A  repository:=0Ahttp://jusst.de/hg/mantis/=0Awith=
 my =0A  Azureware twinhan vp1041 based card.=0ALocking to DVB-S channels w=
orks fine =0A  almost all the time with the patched szap or patched mythtv.=
=0ADid not try =0A  DVB-S2 yet. But what I am having troubles now is the di=
seqc. I have a switch =0A  behind a diseqc 1.2 rotor (goto stored positions=
).=0AThe switching works fine =0A  under Windoz. I have no problems also us=
ing it with my other card in the same =0A  box - Twinhan 102g.=0AInitially =
with the vp1041 card after a couple of diseqc =0A  commands I would get stb=
0899_diseqc_fifo_empy timeout. It turned out that I =0A  had to use some ve=
ry long pauses before sending a repeat command. If =0Afor =0A  the 102g sta=
ndart 15ms worked fine, for the vp1041 I had to use 1s! pause. =0A  Then th=
e rotor will start=0A moving very slowly with small steps  - =0A  as if it =
is does one step , stops and then continues to the desired =0A  position.If=
 one is patient enough the rotor gets to the desired position. I =0A  check=
ed using voltmeter the voltages that come out of the card and they seem =0A=
  to be good. For sending the commands I used both mythtv and hacked versio=
n of =0A  Michel Verbraak's gotox program.=0AHas anyone experienced somethi=
ng similar =0A  with stb0899 frontend? Perhaps you can give me an idea what=
 might be going =0A  wrong?=0A=0AThanks,=0ASimeon=0A=0A=0A=0A=0A=0A      =
=0A  ______________________________________________________________________=
______________=0ABe =0A  a better friend, newshound, and =0Aknow-it-all wit=
h Yahoo! Mobile.  Try =0A  it now.  http://mobile.yahoo.com/;_ylt=3DAhu06i6=
2sR8HDtDypao8Wcj9tAcJ =0A  =0A=0A=0A_______________________________________=
________=0Alinux-dvb =0A  mailing list=0Alinux-dvb@linuxtv.org=0Ahttp://www=
.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=0A=0A=0A-----Inline Attachm=
ent Follows-----=0A=0A_______________________________________________=0Alin=
ux-dvb =0Amailing =0Alist=0Alinux-dvb@linuxtv.org=0Ahttp://www.linuxtv.org/=
cgi-bin/mailman/listinfo/linux-dvb=0A=0A=0A=0A=0A=0A=0A      ______________=
______________________________________________________________________=0ALo=
oking for last minute shopping deals?  =0AFind them fast with Yahoo! Search=
.  http://tools.search.yahoo.com/newsearch/category.php?category=3Dshopping
--0-1312109846-1202779479=:65936
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman,new york,times,serif;fon=
t-size:12pt"><div style=3D"font-family: times new roman,new york,times,seri=
f; font-size: 12pt;">Thanks =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9,<br><br>Do=
 you have a rotor? If it works OK which program do you use to drive it?<br>=
<br><div style=3D"font-family: times new roman,new york,times,serif; font-s=
ize: 12pt;">----- Original Message ----<br>From: =D0=9F=D1=80=D0=B8=D0=B4=
=D0=B2=D0=BE=D1=80=D0=BE=D0=B2 =D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9 &lt;ua0=
lnj@bk.ru&gt;<br>To: linux-dvb &lt;linux-dvb@linuxtv.org&gt;<br>Sent: Monda=
y, February 11, 2008 3:45:02 PM<br>Subject: Re: [linux-dvb] mantis vp1041 w=
ith strange diseqc rotor commands<br><br>=0A=EF=BB=BF=0A=0A =0A =0A<style><=
/style>=0A=0A<div>I think, this is becouse "<strong>Initial support for Man=
tis VP-1041" =0A</strong>not usability yet.</div>=0A<div>I use patch from H=
ans Werner for 1041, works better.</div>=0A<blockquote style=3D"border-left=
: 2px solid rgb(0, 0, 0); padding-right: 0px; padding-left: 5px; margin-lef=
t: 5px; margin-right: 0px;">=0A  <div style=3D"font-family: arial; font-sty=
le: normal; font-variant: normal; font-weight: normal; font-size: 10pt; lin=
e-height: normal; font-size-adjust: none; font-stretch: normal;">----- Orig=
inal Message ----- </div>=0A  <div style=3D"background: rgb(228, 228, 228) =
none repeat scroll 0%; -moz-background-clip: -moz-initial; -moz-background-=
origin: -moz-initial; -moz-background-inline-policy: -moz-initial; font-fam=
ily: arial; font-style: normal; font-variant: normal; font-weight: normal; =
font-size: 10pt; line-height: normal; font-size-adjust: none; font-stretch:=
 normal;"><b>From:</b> =0A  <a rel=3D"nofollow" title=3D"simeonov_2000@yaho=
o.com" ymailto=3D"mailto:simeonov_2000@yahoo.com" target=3D"_blank" href=3D=
"mailto:simeonov_2000@yahoo.com">Simeon =0A  Simeonov</a> </div>=0A  <div s=
tyle=3D"font-family: arial; font-style: normal; font-variant: normal; font-=
weight: normal; font-size: 10pt; line-height: normal; font-size-adjust: non=
e; font-stretch: normal;"><b>To:</b> <a rel=3D"nofollow" title=3D"linux-dvb=
@linuxtv.org" ymailto=3D"mailto:linux-dvb@linuxtv.org" target=3D"_blank" hr=
ef=3D"mailto:linux-dvb@linuxtv.org">linux-dvb</a> </div>=0A  <div style=3D"=
font-family: arial; font-style: normal; font-variant: normal; font-weight: =
normal; font-size: 10pt; line-height: normal; font-size-adjust: none; font-=
stretch: normal;"><b>Sent:</b> Tuesday, February 12, 2008 6:47 =0A  AM</div=
>=0A  <div style=3D"font-family: arial; font-style: normal; font-variant: n=
ormal; font-weight: normal; font-size: 10pt; line-height: normal; font-size=
-adjust: none; font-stretch: normal;"><b>Subject:</b> [linux-dvb] mantis vp=
1041 with =0A  strange diseqc rotor commands</div>=0A  <div><br></div>Hi,<b=
r><br>I am using the latest mantis drivers from Manu's =0A  repository:<br>=
<a rel=3D"nofollow" target=3D"_blank" href=3D"http://jusst.de/hg/mantis/">h=
ttp://jusst.de/hg/mantis/</a><br>with my =0A  Azureware twinhan vp1041 base=
d card.<br>Locking to DVB-S channels works fine =0A  almost all the time wi=
th the patched szap or patched mythtv.<br>Did not try =0A  DVB-S2 yet. But =
what I am having troubles now is the diseqc. I have a switch =0A  behind a =
diseqc 1.2 rotor (goto stored positions).<br>The switching works fine =0A  =
under Windoz. I have no problems also using it with my other card in the sa=
me =0A  box - Twinhan 102g.<br>Initially with the vp1041 card after a coupl=
e of diseqc =0A  commands I would get stb0899_diseqc_fifo_empy timeout. It =
turned out that I =0A  had to use some very long pauses before sending a re=
peat command. If <br>for =0A  the 102g standart 15ms worked fine, for the v=
p1041 I had to use 1s! pause. =0A  Then the rotor will start<br>&nbsp;movin=
g very slowly with small steps&nbsp; - =0A  as if it is does one step , sto=
ps and then continues to the desired =0A  position.If one is patient enough=
 the rotor gets to the desired position. I =0A  checked using voltmeter the=
 voltages that come out of the card and they seem =0A  to be good. For send=
ing the commands I used both mythtv and hacked version of =0A  Michel Verbr=
aak's gotox program.<br>Has anyone experienced something similar =0A  with =
stb0899 frontend? Perhaps you can give me an idea what might be going =0A  =
wrong?<br><br>Thanks,<br>Simeon<br><br><br><br><br><br>&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; =0A  ___________________________________________________________=
_________________________<br>Be =0A  a better friend, newshound, and <br>kn=
ow-it-all with Yahoo! Mobile.&nbsp; Try =0A  it now.&nbsp; <a rel=3D"nofoll=
ow" target=3D"_blank" href=3D"http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HD=
tDypao8Wcj9tAcJ">http://mobile.yahoo.com/;_ylt=3DAhu06i62sR8HDtDypao8Wcj9tA=
cJ</a> =0A  <br><br><br>_______________________________________________<br>=
linux-dvb =0A  mailing list<br><a rel=3D"nofollow" ymailto=3D"mailto:linux-=
dvb@linuxtv.org" target=3D"_blank" href=3D"mailto:linux-dvb@linuxtv.org">li=
nux-dvb@linuxtv.org</a><br><a rel=3D"nofollow" target=3D"_blank" href=3D"ht=
tp://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://www.linuxtv=
.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote><!-- kill --><d=
iv><br><br>-----Inline Attachment Follows-----<br><br>_____________________=
__________________________<br>linux-dvb =0Amailing =0Alist<br><a ymailto=3D=
"mailto:linux-dvb@linuxtv.org" href=3D"mailto:linux-dvb@linuxtv.org">linux-=
dvb@linuxtv.org</a><br><a href=3D"http://www.linuxtv.org/cgi-bin/mailman/li=
stinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/=
listinfo/linux-dvb</a></div></div><br></div></div><br>=0A      <hr size=3D1=
>Looking for last minute shopping deals? <a href=3D"http://us.rd.yahoo.com/=
evt=3D51734/*http://tools.search.yahoo.com/newsearch/category.php?category=
=3Dshopping"> =0AFind them fast with Yahoo! Search.</a></body></html>
--0-1312109846-1202779479=:65936--


--===============2025204005==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2025204005==--
