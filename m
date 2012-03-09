Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <minhhoang1004@yahoo.com>) id 1S5xeo-0003ED-9V
	for linux-dvb@linuxtv.org; Fri, 09 Mar 2012 12:06:47 +0100
Received: from nm30-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.238])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with smtp
	for <linux-dvb@linuxtv.org>
	id 1S5xem-0005HP-Cn; Fri, 09 Mar 2012 12:06:46 +0100
Message-ID: <1331291147.97962.YahooMailNeo@web111209.mail.gq1.yahoo.com>
Date: Fri, 9 Mar 2012 03:05:47 -0800 (PST)
From: "Admin@tydaikho.com" <minhhoang1004@yahoo.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] AverMedia A306 minicard hybrid DVB-T driver on linux.
Reply-To: linux-media@vger.kernel.org,
        "Admin@tydaikho.com" <minhhoang1004@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1530166527=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1530166527==
Content-Type: multipart/alternative; boundary="915624407-920675067-1331291147=:97962"

--915624407-920675067-1331291147=:97962
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I get troubles when i install my TV tuner on my linux system. My OS can't k=
now my card. I look for Google but i can't find the solutions. Linuxtv seem=
s not support this card:=0A"=0AAVerMedia A306 DVB-T, PAL, NTSC Mini PCIe (M=
inicard) ?=A0Unknown=0A =0A=A0"=0AHere is my result of "dmesg|grep cx":=0A"=
=0Aroot@linux:/home/hoangnm# dmesg|grep cx=0A[ =A0 10.416760] cx23885 drive=
r version 0.0.3 loaded=0A[ =A0 10.416799] cx23885 0000:07:00.0: PCI INT A -=
> Link[Z01A] -> GSI 20 (level, low) -> IRQ 20=0A[ =A0 10.416802] cx23885[0]=
: Your board isn't known (yet) to the driver.=0A[ =A0 10.416803] cx23885[0]=
: Try to pick one of the existing card configs via=0A[ =A0 10.416804] cx238=
85[0]: card=3D<n> insmod option. =A0Updating to the latest=0A[ =A0 10.41680=
5] cx23885[0]: version might help as well.=0A[ =A0 10.416807] cx23885[0]: H=
ere is a list of valid choices for the card=3D<n> insmod option:=0A[ =A0 10=
.416809] cx23885[0]: =A0 =A0card=3D0 -> UNKNOWN/GENERIC=0A=0A..............=
...........................=0A[ =A0 10.417101] CORE cx23885[0]: subsystem: =
1461:c139, board: UNKNOWN/GENERIC [card=3D0,autodetected]=0A[ =A0 10.543352=
] cx23885_dev_checkrevision() Hardware revision =3D 0xb0=0A[ =A0 10.543358]=
 cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 20, latency: 0, mmio: 0x=
f0400000=0A[ =A0 10.543365] cx23885 0000:07:00.0: setting latency timer to =
64=0A=0A"=0AAny ideas to solve this problem?=0AThank you very much! and sor=
ry about my bad English.=0A------------------------------------------------=
----------=0AYahoo: minhhoang1004 + Google: minhhoang1004 + Skype: minhhoan=
g1004 + MSN: tydaikho=0A---------------------------------------------------=
-------=0A=0A(http://tydaikho.com) =A0VS =A0(http://vnluser.net)=0A
--915624407-920675067-1331291147=:97962
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ar=
ial, helvetica, sans-serif;font-size:10pt"><div style=3D"font-family: arial=
, helvetica, sans-serif; font-size: 10pt; "><span>I get troubles when i ins=
tall my TV tuner on my linux system. My OS can't know my card. I look for G=
oogle but i can't find the solutions. Linuxtv seems not support this card:<=
/span></div><div style=3D"font-family: arial, helvetica, sans-serif; font-s=
ize: 10pt; "><span>"</span></div><div style=3D"font-family: arial, helvetic=
a, sans-serif; font-size: 10pt; "><span><table class=3D"wikitable sortable"=
 id=3D"sortable_table_id_0" style=3D"background-color: rgb(249, 249, 249); =
margin-top: 1em; margin-right: 1em; margin-bottom: 1em; margin-left: 0px; b=
ackground-image: initial; background-attachment: initial; background-origin=
: initial; background-clip: initial; border-top-width: 1px; border-right-wi=
dth: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-colo=
r:
 rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-=
color: rgb(170, 170, 170); border-left-color: rgb(170, 170, 170); border-to=
p-style: solid; border-right-style: solid; border-bottom-style: solid; bord=
er-left-style: solid; border-image: initial; border-collapse: collapse; fon=
t-family: sans-serif; line-height: 19px; "><tbody><tr><td style=3D"border-t=
op-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-le=
ft-width: 1px; border-top-color: rgb(170, 170, 170); border-right-color: rg=
b(170, 170, 170); border-bottom-color: rgb(170, 170, 170); border-left-colo=
r: rgb(170, 170, 170); border-top-style: solid; border-right-style: solid; =
border-bottom-style: solid; border-left-style: solid; border-image: initial=
; padding-top: 0.2em; padding-right: 0.2em; padding-bottom: 0.2em; padding-=
left: 0.2em; ">AVerMedia A306</td><td style=3D"border-top-width: 1px; borde=
r-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px;
 border-top-color: rgb(170, 170, 170); border-right-color: rgb(170, 170, 17=
0); border-bottom-color: rgb(170, 170, 170); border-left-color: rgb(170, 17=
0, 170); border-top-style: solid; border-right-style: solid; border-bottom-=
style: solid; border-left-style: solid; border-image: initial; padding-top:=
 0.2em; padding-right: 0.2em; padding-bottom: 0.2em; padding-left: 0.2em; "=
>DVB-T, PAL, NTSC</td><td style=3D"border-top-width: 1px; border-right-widt=
h: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-color:=
 rgb(170, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-=
color: rgb(170, 170, 170); border-left-color: rgb(170, 170, 170); border-to=
p-style: solid; border-right-style: solid; border-bottom-style: solid; bord=
er-left-style: solid; border-image: initial; padding-top: 0.2em; padding-ri=
ght: 0.2em; padding-bottom: 0.2em; padding-left: 0.2em; ">Mini PCIe (Minica=
rd)</td><td style=3D"border-top-width: 1px; border-right-width: 1px;
 border-bottom-width: 1px; border-left-width: 1px; border-top-color: rgb(17=
0, 170, 170); border-right-color: rgb(170, 170, 170); border-bottom-color: =
rgb(170, 170, 170); border-left-color: rgb(170, 170, 170); border-top-style=
: solid; border-right-style: solid; border-bottom-style: solid; border-left=
-style: solid; border-image: initial; padding-top: 0.2em; padding-right: 0.=
2em; padding-bottom: 0.2em; padding-left: 0.2em; "><font color=3D"purple"><=
span class=3D"Unicode"><b><i>?</i></b></span>&nbsp;Unknown<br></font></td><=
/tr></tbody></table></span></div><div style=3D"font-family: arial, helvetic=
a, sans-serif; font-size: 10pt; ">&nbsp;"</div><div style=3D"font-family: a=
rial, helvetica, sans-serif; font-size: 10pt; ">Here is my result of "dmesg=
|grep cx":</div><div style=3D"font-family: arial, helvetica, sans-serif; fo=
nt-size: 10pt; ">"</div><div><div><font size=3D"2">root@linux:/home/hoangnm=
# dmesg|grep cx</font></div><div><font size=3D"2">[ &nbsp; 10.416760] cx238=
85
 driver version 0.0.3 loaded</font></div><div><font size=3D"2">[ &nbsp; 10.=
416799] cx23885 0000:07:00.0: PCI INT A -&gt; Link[Z01A] -&gt; GSI 20 (leve=
l, low) -&gt; IRQ 20</font></div><div><font size=3D"2">[ &nbsp; 10.416802] =
cx23885[0]: Your board isn't known (yet) to the driver.</font></div><div><f=
ont size=3D"2">[ &nbsp; 10.416803] cx23885[0]: Try to pick one of the exist=
ing card configs via</font></div><div><font size=3D"2">[ &nbsp; 10.416804] =
cx23885[0]: card=3D&lt;n&gt; insmod option. &nbsp;Updating to the latest</f=
ont></div><div><font size=3D"2">[ &nbsp; 10.416805] cx23885[0]: version mig=
ht help as well.</font></div><div><font size=3D"2">[ &nbsp; 10.416807] cx23=
885[0]: Here is a list of valid choices for the card=3D&lt;n&gt; insmod opt=
ion:</font></div><div><font size=3D"2">[ &nbsp; 10.416809] cx23885[0]: &nbs=
p; &nbsp;card=3D0 -&gt; UNKNOWN/GENERIC</font></div><div style=3D"font-fami=
ly: arial, helvetica, sans-serif; font-size: 10pt; "><br></div><div style=
=3D"font-family:
 arial, helvetica, sans-serif; font-size: 10pt; ">.........................=
................</div><div><div><font size=3D"2">[ &nbsp; 10.417101] CORE c=
x23885[0]: subsystem: 1461:c139, board: UNKNOWN/GENERIC [card=3D0,autodetec=
ted]</font></div><div><font size=3D"2">[ &nbsp; 10.543352] cx23885_dev_chec=
krevision() Hardware revision =3D 0xb0</font></div><div><font size=3D"2">[ =
&nbsp; 10.543358] cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 20, lat=
ency: 0, mmio: 0xf0400000</font></div><div><font size=3D"2">[ &nbsp; 10.543=
365] cx23885 0000:07:00.0: setting latency timer to 64</font></div><div sty=
le=3D"font-family: arial, helvetica, sans-serif; font-size: 10pt; "><br></d=
iv></div></div><div style=3D"font-family: arial, helvetica, sans-serif; fon=
t-size: 10pt; ">"</div><div style=3D"font-family: arial, helvetica, sans-se=
rif; font-size: 10pt; ">Any ideas to solve this problem?</div><div style=3D=
"font-family: arial, helvetica, sans-serif; font-size: 10pt; ">Thank you ve=
ry much! and
 sorry about my bad English.</div><div style=3D"font-family: arial, helveti=
ca, sans-serif; font-size: 10pt; ">----------------------------------------=
------------------</div><div style=3D"font-family: arial, helvetica, sans-s=
erif; font-size: 10pt; ">Yahoo: minhhoang1004 + Google: minhhoang1004 + Sky=
pe: minhhoang1004 + MSN: tydaikho</div><div style=3D"font-family: arial, he=
lvetica, sans-serif; font-size: 10pt; ">-----------------------------------=
-----------------------<br><center></center><div>(http://tydaikho.com) &nbs=
p;VS &nbsp;(http://vnluser.net)</div><div><br></div></div></div></body></ht=
ml>
--915624407-920675067-1331291147=:97962--


--===============1530166527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1530166527==--
