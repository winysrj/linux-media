Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <minhhoang1004@yahoo.com>) id 1S7tcp-00032m-8s
	for linux-dvb@linuxtv.org; Wed, 14 Mar 2012 20:12:43 +0100
Received: from nm23.bullet.mail.sp2.yahoo.com ([98.139.91.93])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with smtp
	for <linux-dvb@linuxtv.org>
	id 1S7tcn-00074Y-CK; Wed, 14 Mar 2012 20:12:43 +0100
Message-ID: <1331752239.9153.YahooMailNeo@web111205.mail.gq1.yahoo.com>
Date: Wed, 14 Mar 2012 12:10:39 -0700 (PDT)
From: "Admin@tydaikho.com" <minhhoang1004@yahoo.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] Driver for AverMedia A306 minicard hybrid DVB-T ?
Reply-To: linux-media@vger.kernel.org,
        "Admin@tydaikho.com" <minhhoang1004@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1176967314=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1176967314==
Content-Type: multipart/alternative; boundary="1138709303-1498328394-1331752239=:9153"

--1138709303-1498328394-1331752239=:9153
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I got my card. My system recorgnize it but Linuxtv driver may not support .=
=0A=0AHere is my result of "lspci" command:=0A07:00.0 Multimedia video cont=
roller [0400]: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder [=
14f1:8852] (rev 02)=0ASubsystem: Avermedia Technologies Inc Device [1461:c1=
39]=0AFlags: bus master, fast devsel, latency 0, IRQ 20=0AMemory at f040000=
0 (64-bit, non-prefetchable) [size=3D2M]=0ACapabilities: [40] Express Endpo=
int, MSI 00=0ACapabilities: [80] Power Management version 2=0ACapabilities:=
 [90] Vital Product Data=0ACapabilities: [a0] MSI: Enable- Count=3D1/1 Mask=
able- 64bit+=0ACapabilities: [100] Advanced Error Reporting=0ACapabilities:=
 [200] Virtual Channel=0AKernel driver in use: cx23885=0AAnd here is my "dm=
esg|grep cx" command result:=0A=0At@debian:/home/hoangnm# dmesg|grep cx=0A[=
 =A0 =A05.293797] 632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media] cx25821:=
 Add a card definition for No brand cards that have: subvendor =3D 0x0000 s=
ubdevice =3D 0x0000=0A[ =A0 =A06.173793] 632fba4d012458fd5fedc678fb9b0f8bc5=
9ceda2 [media] cx25821: Add a card definition for No brand cards that have:=
 subvendor =3D 0x0000 subdevice =3D 0x0000=0A[ =A0 =A06.217052] 632fba4d012=
458fd5fedc678fb9b0f8bc59ceda2 [media] cx25821: Add a card definition for No=
 brand cards that have: subvendor =3D 0x0000 subdevice =3D 0x0000=0A[ =A0 =
=A06.581338] cx23885 driver version 0.0.3 loaded=0A[ =A0 =A06.590852] cx238=
85 0000:07:00.0: PCI INT A -> Link[Z01A] -> GSI 20 (level, low) -> IRQ 20=
=0A[ =A0 =A06.600404] cx23885[0]: Your board isn't known (yet) to the drive=
r.=0A[ =A0 =A06.600405] cx23885[0]: Try to pick one of the existing card co=
nfigs via=0A[ =A0 =A06.600405] cx23885[0]: card=3D<n> insmod option. =A0Upd=
ating to the latest=0A[ =A0 =A06.600406] cx23885[0]: version might help as =
well.=0A[ =A0 =A06.667500] cx23885[0]: Here is a list of valid choices for =
the card=3D<n> insmod option:=0A[ =A0 =A06.677064] cx23885[0]: =A0 =A0card=
=3D0 -> UNKNOWN/GENERIC=0A[ =A0 =A06.686514] cx23885[0]: =A0 =A0card=3D1 ->=
 Hauppauge WinTV-HVR1800lp=0A..............................................=
..................=0A[ =A0 =A06.714456] cx23885[0]: =A0 =A0card=3D34 -> Ter=
raTec Cinergy T PCIe Dual=0A[ =A0 =A06.758272] CORE cx23885[0]: subsystem: =
1461:c139, board: UNKNOWN/GENERIC [card=3D0,autodetected]=0A[ =A0 =A06.8842=
19] cx23885_dev_checkrevision() Hardware revision =3D 0xb0=0A[ =A0 =A06.884=
224] cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 20, latency: 0, mmio=
: 0xf0400000=0A[ =A0 =A06.884229] cx23885 0000:07:00.0: setting latency tim=
er to 64=0A[ =A0 =A06.884233] IRQ 20/cx23885[0]: IRQF_DISABLED is not guara=
nteed on shared IRQs=0A=0A=A0I don't know how to get my card works on my sy=
stem. I must reboot to Windows 7 whenever i want to get some TV programs. I=
t is not good. I ask to support from you?=0AThank you and good work!=0A----=
------------------------------------------------------=0AYahoo: minhhoang10=
04 + Google: minhhoang1004 + Skype: minhhoang1004 + MSN: tydaikho=0A-------=
---------------------------------------------------=0A=0A(http://tydaikho.c=
om) =A0VS =A0(http://vnluser.net)=0A
--1138709303-1498328394-1331752239=:9153
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ar=
ial, helvetica, sans-serif;font-size:10pt"><div style=3D"font-family: arial=
, helvetica, sans-serif; font-size: 10pt; "><span>I got my card. My system =
recorgnize it but Linuxtv driver may not support .</span></div><div style=
=3D"font-family: arial, helvetica, sans-serif; font-size: 10pt; "><span><br=
></span></div><div style=3D"font-family: arial, helvetica, sans-serif; font=
-size: 10pt; "><span>Here is my result of "lspci" command:</span></div><div=
><span><div><font size=3D"2">07:00.0 Multimedia video controller [0400]: Co=
nexant Systems, Inc. CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 0=
2)</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" style=
=3D"white-space:pre">=09</span>Subsystem: Avermedia Technologies Inc Device=
 [1461:c139]</font></div><div><font size=3D"2"><span class=3D"Apple-tab-spa=
n" style=3D"white-space:pre">=09</span>Flags: bus master, fast devsel, late=
ncy 0, IRQ
 20</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" style=
=3D"white-space:pre">=09</span>Memory at f0400000 (64-bit, non-prefetchable=
) [size=3D2M]</font></div><div><font size=3D"2"><span class=3D"Apple-tab-sp=
an" style=3D"white-space:pre">=09</span>Capabilities: [40] Express Endpoint=
, MSI 00</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" s=
tyle=3D"white-space:pre">=09</span>Capabilities: [80] Power Management vers=
ion 2</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" styl=
e=3D"white-space:pre">=09</span>Capabilities: [90] Vital Product Data</font=
></div><div><font size=3D"2"><span class=3D"Apple-tab-span" style=3D"white-=
space:pre">=09</span>Capabilities: [a0] MSI: Enable- Count=3D1/1 Maskable- =
64bit+</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" sty=
le=3D"white-space:pre">=09</span>Capabilities: [100] Advanced Error Reporti=
ng</font></div><div><font size=3D"2"><span class=3D"Apple-tab-span" style=
=3D"white-space:pre">=09</span>Capabilities: [200]
 Virtual Channel</font></div><div><font size=3D"2"><span class=3D"Apple-tab=
-span" style=3D"white-space:pre">=09</span>Kernel driver in use: cx23885</f=
ont></div><div style=3D"font-family: arial, helvetica, sans-serif; font-siz=
e: 10pt; ">And here is my "dmesg|grep cx" command result:</div><div style=
=3D"font-family: arial, helvetica, sans-serif; font-size: 10pt; "><br></div=
><div><div><font size=3D"2">t@debian:/home/hoangnm# dmesg|grep cx</font></d=
iv><div><font size=3D"2">[ &nbsp; &nbsp;5.293797] <span class=3D"Apple-tab-=
span" style=3D"white-space:pre">=09</span>632fba4d012458fd5fedc678fb9b0f8bc=
59ceda2 [media] cx25821: Add a card definition for No brand cards that have=
: subvendor =3D 0x0000 subdevice =3D 0x0000</font></div><div><font size=3D"=
2">[ &nbsp; &nbsp;6.173793] <span class=3D"Apple-tab-span" style=3D"white-s=
pace:pre">=09</span>632fba4d012458fd5fedc678fb9b0f8bc59ceda2 [media] cx2582=
1: Add a card definition for No brand cards that have: subvendor =3D 0x0000=
 subdevice =3D
 0x0000</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.217052] <span cl=
ass=3D"Apple-tab-span" style=3D"white-space:pre">=09</span>632fba4d012458fd=
5fedc678fb9b0f8bc59ceda2 [media] cx25821: Add a card definition for No bran=
d cards that have: subvendor =3D 0x0000 subdevice =3D 0x0000</font></div><d=
iv><font size=3D"2">[ &nbsp; &nbsp;6.581338] cx23885 driver version 0.0.3 l=
oaded</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.590852] cx23885 00=
00:07:00.0: PCI INT A -&gt; Link[Z01A] -&gt; GSI 20 (level, low) -&gt; IRQ =
20</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.600404] cx23885[0]: Y=
our board isn't known (yet) to the driver.</font></div><div><font size=3D"2=
">[ &nbsp; &nbsp;6.600405] cx23885[0]: Try to pick one of the existing card=
 configs via</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.600405] cx2=
3885[0]: card=3D&lt;n&gt; insmod option. &nbsp;Updating to the latest</font=
></div><div><font size=3D"2">[ &nbsp; &nbsp;6.600406] cx23885[0]: version m=
ight help as
 well.</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.667500] cx23885[0=
]: Here is a list of valid choices for the card=3D&lt;n&gt; insmod option:<=
/font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.677064] cx23885[0]: &nbs=
p; &nbsp;card=3D0 -&gt; UNKNOWN/GENERIC</font></div><div><font size=3D"2">[=
 &nbsp; &nbsp;6.686514] cx23885[0]: &nbsp; &nbsp;card=3D1 -&gt; Hauppauge W=
inTV-HVR1800lp</font></div><div style=3D"font-family: arial, helvetica, san=
s-serif; font-size: 10pt; ">...............................................=
.................</div><div><div><font size=3D"2">[ &nbsp; &nbsp;6.714456] =
cx23885[0]: &nbsp; &nbsp;card=3D34 -&gt; TerraTec Cinergy T PCIe Dual</font=
></div><div><font size=3D"2">[ &nbsp; &nbsp;6.758272] CORE cx23885[0]: subs=
ystem: 1461:c139, board: UNKNOWN/GENERIC [card=3D0,autodetected]</font></di=
v><div><font size=3D"2">[ &nbsp; &nbsp;6.884219] cx23885_dev_checkrevision(=
) Hardware revision =3D 0xb0</font></div><div><font size=3D"2">[ &nbsp; &nb=
sp;6.884224]
 cx23885[0]/0: found at 0000:07:00.0, rev: 2, irq: 20, latency: 0, mmio: 0x=
f0400000</font></div><div><font size=3D"2">[ &nbsp; &nbsp;6.884229] cx23885=
 0000:07:00.0: setting latency timer to 64</font></div><div><font size=3D"2=
">[ &nbsp; &nbsp;6.884233] IRQ 20/cx23885[0]: IRQF_DISABLED is not guarante=
ed on shared IRQs</font></div><div style=3D"font-family: arial, helvetica, =
sans-serif; font-size: 10pt; "><br></div></div></div></span></div><div styl=
e=3D"font-family: arial, helvetica, sans-serif; font-size: 10pt; ">&nbsp;I =
don't know how to get my card works on my system. I must reboot to Windows =
7 whenever i want to get some TV programs. It is not good. I ask to support=
 from you?</div><div style=3D"font-family: arial, helvetica, sans-serif; fo=
nt-size: 10pt; ">Thank you and good work!</div><div style=3D"font-family: a=
rial, helvetica, sans-serif; font-size: 10pt; ">---------------------------=
-------------------------------</div><div style=3D"font-family: arial, helv=
etica,
 sans-serif; font-size: 10pt; ">Yahoo: minhhoang1004 + Google: minhhoang100=
4 + Skype: minhhoang1004 + MSN: tydaikho</div><div style=3D"font-family: ar=
ial, helvetica, sans-serif; font-size: 10pt; ">----------------------------=
------------------------------<br><center></center><div>(http://tydaikho.co=
m) &nbsp;VS &nbsp;(http://vnluser.net)</div><div><br></div></div></div></bo=
dy></html>
--1138709303-1498328394-1331752239=:9153--


--===============1176967314==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1176967314==--
