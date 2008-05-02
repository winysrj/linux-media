Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web23106.mail.ird.yahoo.com ([217.146.189.46])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <juanantonio_garcia_01@yahoo.es>) id 1JryfT-0003Qj-2T
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 19:03:34 +0200
Date: Fri, 2 May 2008 17:02:56 +0000 (GMT)
From: Juan Antonio Garcia <juanantonio_garcia_01@yahoo.es>
To: Aidan Thornton <makosoft@googlemail.com>
MIME-Version: 1.0
Message-ID: <690868.46111.qm@web23106.mail.ird.yahoo.com>
Cc: Jakob Steidl <j.steidl@liwest.at>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB driver for Pinnacle PCTV200e and PCTV60e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1181083220=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1181083220==
Content-Type: multipart/alternative; boundary="0-1487326817-1209747776=:46111"

--0-1487326817-1209747776=:46111
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thanks for the hints.=0A=0AI made a driver update yesterday for kernel 2.6.=
24 using the last v4l tree I got:=0Av4l-dvb-2daeefda69fe, so probably that =
will be much more closer to the actual tree.=0A- Is there any way to submit=
 it for review?=0A=0AAbout your hints:=0A- you mean that static variables w=
ill be an issue.=0ACould then be better to include those variables in dvb_u=
sb_device_properties?=0A=0A- Yes, the register increment has no use. I can =
remove it away.=0A=0A- I also got feedback that the debug information is no=
t handled correctly in the driver.=0ACould you advice on that one?=0A=0AI a=
m really no expert, I have just been following the examples.=0ABut since it=
 is working, it would be great if people could use the driver.=0A=0AJuan=0A=
=0A----- Mensaje original ----=0ADe: Aidan Thornton <makosoft@googlemail.co=
m>=0APara: Juan Antonio Garcia <juanantonio_garcia_01@yahoo.es>=0ACC: Marku=
s Rechberger <mrechberger@gmail.com>; Jakob Steidl <j.steidl@liwest.at>; li=
nux-dvb@linuxtv.org=0AEnviado: viernes, 2 de mayo, 2008 12:24:07=0AAsunto: =
Re: [linux-dvb] DVB driver for Pinnacle PCTV200e and PCTV60e=0A=0AOn Thu, M=
ay 1, 2008 at 8:58 PM, Markus Rechberger <mrechberger@gmail.com> wrote:=0A>=
 Hi,=0A>=0A>=0A>  On 5/1/08, Juan Antonio Garcia <juanantonio_garcia_01@yah=
oo.es> wrote:=0A>  >=0A>  > Hi,=0A>  >=0A>  > I updated the driver for bein=
g supported in kernel 2.6.24 (Ubuntu 8.04).=0A>  >=0A>  > I am distributing=
 the update thought the Ubuntu forums, but it would be=0A>  > better to dis=
tribute it to more users. So Linux has more HW supported.=0A>  >=0A>  > Wha=
t it should be done so it is included in the v4l tree?=0A>  >=0A>=0A>  I fo=
rwarded the mail to the linux-dvb ML.=0A>=0A>  > Now the driver supports 2 =
devices:=0A>  >=0A>  > - Pinnacle PCTV 200e=0A>  > - Pinnacle PCTV 60e=0A> =
 >=0A>  > The driver wiki is:=0A>  >=0A>  > http://www.linuxtv.org/wiki/ind=
ex.php/Pinnacle_PCTV_200e=0A>  >=0A>=0A>  Markus=0A=0AHi,=0A=0AThis driver =
seems like it should be trivial to get working on=0Alinux-dvb, which is whe=
re you want it - the tree you've based it on=0Aisn't much longer for this w=
orld. (I don't think any of the code=0Ayou're using has changed significant=
ly between Markus' branch and the=0Amain one). It needs some cleanup, thoug=
h. At a glance:=0A=0A- Don't use C++-style comments (the single-line // one=
s)=0A- The whole "addr =3D=3D pctv200e_mt2060_config.i2c_address" part look=
s=0Aiffy; I think you should remove this and use i2c_gate_ctrl instead.=0AU=
nfortunately, I'm not sure this'll work currently, since mt2060=0Adoesn't a=
ppear to support it.=0A- ctrl_msg_last_device/ctrl_msg_last_operation must =
go - they won't=0Awork right if you use multiple devices of this type. The =
code in the=0A"if (ctrl_msg_last_device =3D=3D 0)" section can probably go =
elsewhere,=0Abut I'm not sure where=0A- Why are you incrementing the regist=
er value in pctv200e_ctrl_msg?=0A=0AThe linuxtv developers will probably be=
 able to give you more advice.=0A=0AAidan=0A=0A=0A=0A=0A=0A=0A      _______=
_______________________________________ =0AYahoo! Solidario. Intercambia lo=
s objetos que ya no necesitas y ayuda a mantener un entorno m=C3=A1s ecol=
=C3=B3gico.
--0-1487326817-1209747776=:46111
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><style type=3D"text/css"><!-- DIV {margin:0px;} --></style></he=
ad><body><div style=3D"font-family:times new roman, new york, times, serif;=
font-size:12pt"><div style=3D"font-family: times new roman,new york,times,s=
erif; font-size: 12pt;">Thanks for the hints.<br>=0A<br>=0AI made a driver =
update yesterday for kernel 2.6.24 using the last v4l tree I got:<br>v4l-dv=
b-2daeefda69fe, so probably that will be much more closer to the actual tre=
e.<br>- Is there any way to submit it for review?<br><br>About your hints:<=
br>- you mean that static variables will be an issue.<br>Could then be bett=
er to include those variables in dvb_usb_device_properties?<br><br>- Yes, t=
he register increment has no use. I can remove it away.<br><br>- I also got=
 feedback that the debug information is not handled correctly in the driver=
.<br>Could you advice on that one?<br><br>I am really no expert, I have jus=
t been following the examples.<br>But since it is working, it would be grea=
t if people could use the driver.<br><br>Juan<br><br><div style=3D"font-fam=
ily: times new roman,new york,times,serif; font-size: 12pt;">----- Mensaje =
original ----<br>De: Aidan Thornton &lt;makosoft@googlemail.com&gt;<br>Para=
: Juan Antonio Garcia
 &lt;juanantonio_garcia_01@yahoo.es&gt;<br>CC: Markus Rechberger &lt;mrechb=
erger@gmail.com&gt;; Jakob Steidl &lt;j.steidl@liwest.at&gt;; linux-dvb@lin=
uxtv.org<br>Enviado: viernes, 2 de mayo, 2008 12:24:07<br>Asunto: Re: [linu=
x-dvb] DVB driver for Pinnacle PCTV200e and PCTV60e<br><br>On Thu, May 1, 2=
008 at 8:58 PM, Markus Rechberger &lt;<a ymailto=3D"mailto:mrechberger@gmai=
l.com" href=3D"mailto:mrechberger@gmail.com">mrechberger@gmail.com</a>&gt; =
wrote:<br>&gt; Hi,<br>&gt;<br>&gt;<br>&gt;&nbsp; On 5/1/08, Juan Antonio Ga=
rcia &lt;<a ymailto=3D"mailto:juanantonio_garcia_01@yahoo.es" href=3D"mailt=
o:juanantonio_garcia_01@yahoo.es">juanantonio_garcia_01@yahoo.es</a>&gt; wr=
ote:<br>&gt;&nbsp; &gt;<br>&gt;&nbsp; &gt; Hi,<br>&gt;&nbsp; &gt;<br>&gt;&n=
bsp; &gt; I updated the driver for being supported in kernel 2.6.24 (Ubuntu=
 8.04).<br>&gt;&nbsp; &gt;<br>&gt;&nbsp; &gt; I am distributing the update =
thought the Ubuntu forums, but it would be<br>&gt;&nbsp; &gt; better to
 distribute it to more users. So Linux has more HW supported.<br>&gt;&nbsp;=
 &gt;<br>&gt;&nbsp; &gt; What it should be done so it is included in the v4=
l tree?<br>&gt;&nbsp; &gt;<br>&gt;<br>&gt;&nbsp; I forwarded the mail to th=
e linux-dvb ML.<br>&gt;<br>&gt;&nbsp; &gt; Now the driver supports 2 device=
s:<br>&gt;&nbsp; &gt;<br>&gt;&nbsp; &gt; - Pinnacle PCTV 200e<br>&gt;&nbsp;=
 &gt; - Pinnacle PCTV 60e<br>&gt;&nbsp; &gt;<br>&gt;&nbsp; &gt; The driver =
wiki is:<br>&gt;&nbsp; &gt;<br>&gt;&nbsp; &gt; <a href=3D"http://www.linuxt=
v.org/wiki/index.php/Pinnacle_PCTV_200e" target=3D"_blank">http://www.linux=
tv.org/wiki/index.php/Pinnacle_PCTV_200e</a><br>&gt;&nbsp; &gt;<br>&gt;<br>=
&gt;&nbsp; Markus<br><br>Hi,<br><br>This driver seems like it should be tri=
vial to get working on<br>linux-dvb, which is where you want it - the tree =
you've based it on<br>isn't much longer for this world. (I don't think any =
of the code<br>you're using has changed significantly between Markus'
 branch and the<br>main one). It needs some cleanup, though. At a glance:<b=
r><br>- Don't use C++-style comments (the single-line // ones)<br>- The who=
le "addr =3D=3D pctv200e_mt2060_config.i2c_address" part looks<br>iffy; I t=
hink you should remove this and use i2c_gate_ctrl instead.<br>Unfortunately=
, I'm not sure this'll work currently, since mt2060<br>doesn't appear to su=
pport it.<br>- ctrl_msg_last_device/ctrl_msg_last_operation must go - they =
won't<br>work right if you use multiple devices of this type. The code in t=
he<br>"if (ctrl_msg_last_device =3D=3D 0)" section can probably go elsewher=
e,<br>but I'm not sure where<br>- Why are you incrementing the register val=
ue in pctv200e_ctrl_msg?<br><br>The linuxtv developers will probably be abl=
e to give you more advice.<br><br>Aidan<br></div><br></div></div><br>=0A=0A=
=0A=0A=0A=0A=0A      <hr size=3D1><br><font face=3D"Verdana" size=3D"-2"><a=
 href=3D"http://us.rd.yahoo.com/mailuk/taglines/isp/control/*http://us.rd.y=
ahoo.com/evt=3D52433/*http://green.yahoo.com/es/dia-de-la-tierra/">Yahoo! S=
olidario.</a><br>Intercambia los objetos que ya no necesitas y ayuda a mant=
ener un entorno m=C3=A1s ecol=C3=B3gico.<br></font></body></html>
--0-1487326817-1209747776=:46111--


--===============1181083220==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1181083220==--
