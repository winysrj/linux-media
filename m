Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <takacsk2004@yahoo.com>) id 1X09Kk-0007I3-Cd
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2014 15:03:26 +0200
Received: from nm20-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.45])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-7) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1X09Kh-0008Mj-29; Thu, 26 Jun 2014 15:03:22 +0200
References: <9FC53147-8519-4BFC-9E42-D449B057C0E3@gmail.com>
Message-ID: <1403787796.13560.YahooMailNeo@web120702.mail.ne1.yahoo.com>
Date: Thu, 26 Jun 2014 06:03:16 -0700
From: Kalman Takacs <takacsk2004@yahoo.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <9FC53147-8519-4BFC-9E42-D449B057C0E3@gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Terratec Cinergy C support
Reply-To: linux-media@vger.kernel.org, Kalman Takacs <takacsk2004@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1846034448=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1846034448==
Content-Type: multipart/alternative; boundary="-74892456-735192526-1403787796=:13560"

---74892456-735192526-1403787796=:13560
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Do you have one like this? =0Aftp://ftp.terratec.de/Receiver/Cinergy_C_PCI_=
HD/TechnicalData/TERRATEC_Cinergy_C_PCI_HD_Technical_Data_EN.pdf=0Aftp://ft=
p.terratec.de/Receiver/Cinergy_C_PCI_HD/=0A=0AHD is mentioned in the produc=
t name.=0A=0AVery strange that the (sub)devices match with the ones at the =
LinuxTV Wiki, but the vendor codes are different.=0A1822 is Twinhan, but yo=
u have 1820. =0A153b is Terratec, but you have 1539.=0A=0AMy first guess is=
 that the card is not connected properly. Try to remove it and place it int=
o another PCI slot.=0A=0A=0A=0A=0A=0AOn Thursday, June 26, 2014 9:26 AM, Th=
omas L=C3=A9t=C3=A9 <bistory@gmail.com> wrote:=0A =0A=0A=0AHi everyone !=0A=
I just discovered that Terratec made an other revision of their Cinergy C P=
CI card (it is a DVB-C lci card). I tried to install it on a debian system =
with the kernel 3.2.0 and with back port 3.14 without success, I have no de=
vice in /dev/dvb.=0AThe wiki page ( http://www.linuxtv.org/wiki/index.php/T=
erraTec_Cinergy_C_DVB-C ) shows a card with a black PCB but mine has a whit=
e one. The weird thing is that the box says it supports HDTV so I guess I o=
wn a HD version even it is not mentioned on the product name.=0A=0Alspci -v=
nn shows that :=0A=0A04:00.0 Multimedia controller [0480]: InfiniCon System=
s Inc. Device [1820:4e35] (rev 01)=0A=C2=A0=C2=A0=C2=A0 Subsystem: ATELIER =
INFORMATIQUES et ELECTRONIQUE ETUDES S.A. Device [1539:1178]=0A=C2=A0=C2=A0=
=C2=A0 Flags: bus master, medium devsel, latency 32, IRQ 8=0A=C2=A0=C2=A0=
=C2=A0 Memory at 90100000 (32-bit, prefetchable) [disabled] [size=3D4K]=0A=
=0AI found no information on this hardware yet=E2=80=A6=0A=0AI=E2=80=99m cu=
rrently building latest sources but I don=E2=80=99t think it will help so m=
uch.=0A=0ADo you have any clue that could lead supporting this device on li=
nux ?=0A=0AThanks !=0A_______________________________________________=0Alin=
ux-dvb users mailing list=0AFor V4L/DVB development, please use instead lin=
ux-media@vger.kernel.org=0Alinux-dvb@linuxtv.org=0Ahttp://www.linuxtv.org/c=
gi-bin/mailman/listinfo/linux-dvb
---74892456-735192526-1403787796=:13560
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif;fo=
nt-size:12pt">Do you have one like this? <br style=3D"">ftp://ftp.terratec.=
de/Receiver/Cinergy_C_PCI_HD/TechnicalData/TERRATEC_Cinergy_C_PCI_HD_Techni=
cal_Data_EN.pdf<br class=3D"" style=3D"">ftp://ftp.terratec.de/Receiver/Cin=
ergy_C_PCI_HD/<br><br>HD is mentioned in the product name.<br><br style=3D"=
" class=3D"">Very strange that the (sub)devices match with the ones at the =
LinuxTV Wiki, but the vendor codes are different.<br style=3D"" class=3D"">=
1822 is Twinhan, but you have 1820. <br>153b is Terratec, but you have 1539=
.<br><br>My first guess is that the card is not connected properly. Try to =
remove it and place it into another PCI slot.<br style=3D"" class=3D""><br>=
<br style=3D"" class=3D""> <div class=3D"qtdSeparateBR"><br><br></div><div =
style=3D"display: block;" class=3D"yahoo_quoted"> <div class=3D"" style=3D"=
font-family: HelveticaNeue,
 Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif; font-size: 12=
pt;"> <div class=3D"" style=3D"font-family: HelveticaNeue, Helvetica Neue, =
Helvetica, Arial, Lucida Grande, sans-serif; font-size: 12pt;"> <div style=
=3D"" class=3D"" dir=3D"ltr"> <font style=3D"" class=3D"" face=3D"Arial" si=
ze=3D"2"> On Thursday, June 26, 2014 9:26 AM, Thomas L=C3=A9t=C3=A9 &lt;bis=
tory@gmail.com&gt; wrote:<br style=3D"" class=3D""> </font> </div>  <br sty=
le=3D"" class=3D""><br style=3D"" class=3D""> <div style=3D"" class=3D"">Hi=
 everyone !<br style=3D"" class=3D"">I just discovered that Terratec made a=
n other revision of their Cinergy C PCI card (it is a DVB-C lci card). I tr=
ied to install it on a debian system with the kernel 3.2.0 and with back po=
rt 3.14 without success, I have no device in /dev/dvb.<br style=3D"" class=
=3D"">The wiki page ( <a style=3D"" class=3D"" href=3D"http://www.linuxtv.o=
rg/wiki/index.php/TerraTec_Cinergy_C_DVB-C" target=3D"_blank">http://www.li=
nuxtv.org/wiki/index.php/TerraTec_Cinergy_C_DVB-C
 </a>) shows a card with a black PCB but mine has a white one. The weird th=
ing is that the box says it supports HDTV so I guess I own a HD version eve=
n it is not mentioned on the product name.<br style=3D"" class=3D""><br sty=
le=3D"" class=3D"">lspci -vnn shows that :<br style=3D"" class=3D""><br sty=
le=3D"" class=3D"">04:00.0 Multimedia controller [0480]: InfiniCon Systems =
Inc. Device [1820:4e35] (rev 01)<br style=3D"" class=3D"">&nbsp;&nbsp;&nbsp=
; Subsystem: ATELIER INFORMATIQUES et ELECTRONIQUE ETUDES S.A. Device [1539=
:1178]<br style=3D"" class=3D"">&nbsp;&nbsp;&nbsp; Flags: bus master, mediu=
m devsel, latency 32, IRQ 8<br style=3D"" class=3D"">&nbsp;&nbsp;&nbsp; Mem=
ory at 90100000 (32-bit, prefetchable) [disabled] [size=3D4K]<br style=3D""=
 class=3D""><br style=3D"" class=3D"">I found no information on this hardwa=
re yet=E2=80=A6<br style=3D"" class=3D""><br style=3D"" class=3D"">I=E2=80=
=99m currently building latest sources but I don=E2=80=99t think it will he=
lp so much.<br style=3D"" class=3D""><br style=3D"" class=3D"">Do
 you have any clue that could lead supporting this device on linux ?<br sty=
le=3D"" class=3D""><br style=3D"" class=3D"">Thanks !<br style=3D"" class=
=3D"">_______________________________________________<br style=3D"" class=
=3D"">linux-dvb users mailing list<br style=3D"" class=3D"">For V4L/DVB dev=
elopment, please use instead <a style=3D"" class=3D"" ymailto=3D"mailto:lin=
ux-media@vger.kernel.org" href=3D"mailto:linux-media@vger.kernel.org">linux=
-media@vger.kernel.org</a><br style=3D"" class=3D""><a style=3D"" class=3D"=
" ymailto=3D"mailto:linux-dvb@linuxtv.org" href=3D"mailto:linux-dvb@linuxtv=
.org">linux-dvb@linuxtv.org</a><br style=3D"" class=3D""><a style=3D"" clas=
s=3D"" href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" t=
arget=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb<=
/a><br style=3D"" class=3D""><br style=3D"" class=3D""></div>  </div> </div=
>  </div> </div></body></html>
---74892456-735192526-1403787796=:13560--


--===============1846034448==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1846034448==--
