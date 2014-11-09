Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <levente@csehs.com>) id 1XnXNz-0008RM-PN
	for linux-dvb@linuxtv.org; Sun, 09 Nov 2014 19:38:53 +0100
Received: from mx6.datanet.hu ([194.149.13.165])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1XnXNx-00038s-7j; Sun, 09 Nov 2014 19:38:50 +0100
Received: from datanet.hu (unknown [91.120.40.70])
	by mx6.datanet.hu (DataNet) with ESMTP id E3152130C68
	for <linux-dvb@linuxtv.org>; Sun,  9 Nov 2014 19:38:47 +0100 (CET)
Received: from SL510 (catv-78-139-19-54.catv.broadband.hu [78.139.19.54])
	(Authenticated sender: DHL)
	by datanet.hu (Postfix) with ESMTPA id 725FE20D6A
	for <linux-dvb@linuxtv.org>; Sun,  9 Nov 2014 19:38:47 +0100 (CET)
From: "Cseh Levente" <levente@csehs.com>
To: <linux-dvb@linuxtv.org>
Date: Sun, 9 Nov 2014 19:38:48 +0100
Message-ID: <000c01cffc4c$66b92f00$342b8d00$@csehs.com>
MIME-Version: 1.0
Content-Language: hu
Subject: [linux-dvb] PCTV Picostick 74e stops working after V4L installation
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1885721034=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============1885721034==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000D_01CFFC54.C8802F10"
Content-Language: hu

This is a multipart message in MIME format.

------=_NextPart_000_000D_01CFFC54.C8802F10
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Sorry to 'attack you like this', I thought I'd ask you if you have any idea
what could be the reason why the Picostick 74e and ITE9033 USB DVB-T tuners
disappear right after I install the Cine S2 card. Actually this one works
great, but the other cards (that used to work) will not have registered
frontends anymore.

I attached a dmesg output, perhaps this could be of use, unfortunately it
doesn't tell anything to me...

I'd appreciate if you could direct me in the right direction.

Thanks a lot,

Levente

root@TVHead:~# dmesg | grep -i dvb

[    5.160848] dvb_core: module verification failed: signature and/or
required key missing - tainting kernel

[    5.286611] DDBridge driver detected: Digital Devices Cine S2 V6.5 DVB
adapter

[    5.287854] Port 0 (TAB 1): DUAL DVB-S2

[    5.290943] DVB: registering new adapter (DDBridge)

[    5.290944] DVB: registering new adapter (DDBridge)

[    5.585549] ddbridge 0000:02:00.0: DVB: registering adapter 0 frontend 0
(STV090x Multistandard)...

[    5.620416] ddbridge 0000:02:00.0: DVB: registering adapter 1 frontend 0
(STV090x Multistandard)...

[    6.027653] dvb_as102: module is from the staging directory, the quality
is unknown, you have been warned.

[    6.027669] dvb_as102: module is from the staging directory, the quality
is unknown, you have been warned.

[    6.027733] dvb_as102: disagrees about version of symbol
dvb_frontend_detach

[    6.027735] dvb_as102: Unknown symbol dvb_frontend_detach (err -22)

[    6.027739] dvb_as102: disagrees about version of symbol
dvb_unregister_frontend

[    6.027740] dvb_as102: Unknown symbol dvb_unregister_frontend (err -22)

[    6.027743] dvb_as102: disagrees about version of symbol
dvb_register_frontend

[    6.027744] dvb_as102: Unknown symbol dvb_register_frontend (err -22)

[    6.027856] dvb_as102: disagrees about version of symbol
dvb_frontend_detach

[    6.027858] dvb_as102: Unknown symbol dvb_frontend_detach (err -22)

[    6.027862] dvb_as102: disagrees about version of symbol
dvb_unregister_frontend

[    6.027863] dvb_as102: Unknown symbol dvb_unregister_frontend (err -22)

[    6.027868] dvb_as102: disagrees about version of symbol
dvb_register_frontend

[    6.027870] dvb_as102: Unknown symbol dvb_register_frontend (err -22)

[    6.178608] dvb_usb_v2: disagrees about version of symbol dvb_dmxdev_init

[    6.178611] dvb_usb_v2: Unknown symbol dvb_dmxdev_init (err -22)

[    6.178626] dvb_usb_v2: disagrees about version of symbol
dvb_register_adapter

[    6.178627] dvb_usb_v2: Unknown symbol dvb_register_adapter (err -22)

[    6.178639] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter_204

[    6.178640] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter_204 (err -22)

[    6.178643] dvb_usb_v2: disagrees about version of symbol dvb_dmx_release

[    6.178644] dvb_usb_v2: Unknown symbol dvb_dmx_release (err -22)

[    6.178708] dvb_usb_v2: disagrees about version of symbol dvb_net_init

[    6.178709] dvb_usb_v2: Unknown symbol dvb_net_init (err -22)

[    6.178712] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter

[    6.178713] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter (err -22)

[    6.178716] dvb_usb_v2: disagrees about version of symbol
dvb_dmxdev_release

[    6.178717] dvb_usb_v2: Unknown symbol dvb_dmxdev_release (err -22)

[    6.178722] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter_raw

[    6.178723] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter_raw (err -22)

[    6.178727] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_detach

[    6.178728] dvb_usb_v2: Unknown symbol dvb_frontend_detach (err -22)

[    6.178731] dvb_usb_v2: disagrees about version of symbol dvb_net_release

[    6.178732] dvb_usb_v2: Unknown symbol dvb_net_release (err -22)

[    6.178738] dvb_usb_v2: disagrees about version of symbol
dvb_unregister_frontend

[    6.178739] dvb_usb_v2: Unknown symbol dvb_unregister_frontend (err -22)

[    6.178743] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_resume

[    6.178744] dvb_usb_v2: Unknown symbol dvb_frontend_resume (err -22)

[    6.178746] dvb_usb_v2: disagrees about version of symbol
dvb_register_frontend

[    6.178747] dvb_usb_v2: Unknown symbol dvb_register_frontend (err -22)

[    6.178749] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_suspend

[    6.178750] dvb_usb_v2: Unknown symbol dvb_frontend_suspend (err -22)

[    6.178753] dvb_usb_v2: disagrees about version of symbol
dvb_unregister_adapter

[    6.178754] dvb_usb_v2: Unknown symbol dvb_unregister_adapter (err -22)

[    6.178757] dvb_usb_v2: disagrees about version of symbol dvb_dmx_init

[    6.178758] dvb_usb_v2: Unknown symbol dvb_dmx_init (err -22)

[    6.178871] dvb_usb_v2: disagrees about version of symbol dvb_dmxdev_init

[    6.178873] dvb_usb_v2: Unknown symbol dvb_dmxdev_init (err -22)

[    6.178883] dvb_usb_v2: disagrees about version of symbol
dvb_register_adapter

[    6.178884] dvb_usb_v2: Unknown symbol dvb_register_adapter (err -22)

[    6.178892] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter_204

[    6.178893] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter_204 (err -22)

[    6.178896] dvb_usb_v2: disagrees about version of symbol dvb_dmx_release

[    6.178897] dvb_usb_v2: Unknown symbol dvb_dmx_release (err -22)

[    6.178902] dvb_usb_v2: disagrees about version of symbol dvb_net_init

[    6.178903] dvb_usb_v2: Unknown symbol dvb_net_init (err -22)

[    6.178905] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter

[    6.178906] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter (err -22)

[    6.178909] dvb_usb_v2: disagrees about version of symbol
dvb_dmxdev_release

[    6.178910] dvb_usb_v2: Unknown symbol dvb_dmxdev_release (err -22)

[    6.178914] dvb_usb_v2: disagrees about version of symbol
dvb_dmx_swfilter_raw

[    6.178915] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter_raw (err -22)

[    6.178918] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_detach

[    6.178919] dvb_usb_v2: Unknown symbol dvb_frontend_detach (err -22)

[    6.178922] dvb_usb_v2: disagrees about version of symbol dvb_net_release

[    6.178923] dvb_usb_v2: Unknown symbol dvb_net_release (err -22)

[    6.178927] dvb_usb_v2: disagrees about version of symbol
dvb_unregister_frontend

[    6.178928] dvb_usb_v2: Unknown symbol dvb_unregister_frontend (err -22)

[    6.178932] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_resume

[    6.178933] dvb_usb_v2: Unknown symbol dvb_frontend_resume (err -22)

[    6.178935] dvb_usb_v2: disagrees about version of symbol
dvb_register_frontend

[    6.178936] dvb_usb_v2: Unknown symbol dvb_register_frontend (err -22)

[    6.178938] dvb_usb_v2: disagrees about version of symbol
dvb_frontend_suspend

[    6.178939] dvb_usb_v2: Unknown symbol dvb_frontend_suspend (err -22)

[    6.178942] dvb_usb_v2: disagrees about version of symbol
dvb_unregister_adapter

[    6.178943] dvb_usb_v2: Unknown symbol dvb_unregister_adapter (err -22)

[    6.178945] dvb_usb_v2: disagrees about version of symbol dvb_dmx_init

[    6.178946] dvb_usb_v2: Unknown symbol dvb_dmx_init (err -22)

[   61.247127] ddbridge 0000:02:00.0: DVB: adapter 1 frontend 0 frequency 0
out of range (950000..2150000)

[   61.278664] ddbridge 0000:02:00.0: DVB: adapter 0 frontend 0 frequency 0
out of range (950000..2150000)

root@TVHead:~#

root@TVHead:~# lsdvb

 

                lsdvb: Simple utility to list PCI/PCIe DVB devices

                Version: 0.0.4

                Copyright (C) Manu Abraham

 

ddbridge (0:3 0:21) on PCI Domain:0 Bus:2 Device:0 Function:0

        DEVICE:0 ADAPTER:0 FRONTEND:0 (STV090x Multistandard)

                 FE_QPSK Fmin=950MHz Fmax=2150MHz

        DEVICE:0 ADAPTER:1 FRONTEND:0 (STV090x Multistandard)

                 FE_QPSK Fmin=950MHz Fmax=2150MHz

root@TVHead:~#


------=_NextPart_000_000D_01CFFC54.C8802F10
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 15 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0cm;
	mso-margin-bottom-alt:auto;
	margin-left:0cm;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
span.E-mailStlus17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 70.85pt 70.85pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DHU =
link=3D"#0563C1" vlink=3D"#954F72"><div class=3DWordSection1><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>Hi,=
<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt;orphans: =
auto;widows: auto;-webkit-text-stroke-width: 0px;word-spacing:0px'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>Sor=
ry to 'attack you like this', I thought I'd ask you if you have any idea =
what could be the reason why the Picostick 74e and ITE9033 USB DVB-T =
tuners disappear right after I install the Cine S2 card. Actually this =
one works great, but the other cards (that used to work) will not have =
registered frontends anymore.<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt;orphans: =
auto;widows: auto;-webkit-text-stroke-width: 0px;word-spacing:0px'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>I =
attached a dmesg output, perhaps this could be of use, unfortunately it =
doesn't tell anything to me...<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt;orphans: =
auto;widows: auto;-webkit-text-stroke-width: 0px;word-spacing:0px'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>I'd=
 appreciate if you could direct me in the right =
direction.<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt;orphans: =
auto;widows: auto;-webkit-text-stroke-width: 0px;word-spacing:0px'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>Tha=
nks a lot,<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:10.5pt;font-family:"Arial",sans-serif;color:black'>Lev=
ente<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>root=
@TVHead:~# dmesg | grep -i dvb<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.160848] dvb_core: module verification failed: =
signature and/or&nbsp; required key missing - tainting =
kernel<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.286611] DDBridge driver detected: Digital Devices Cine =
S2 V6.5 DVB adapter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.287854] Port 0 (TAB 1): DUAL =
DVB-S2<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.290943] DVB: registering new adapter =
(DDBridge)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.290944] DVB: registering new adapter =
(DDBridge)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.585549] ddbridge 0000:02:00.0: DVB: registering =
adapter 0 frontend 0 (STV090x Multistandard)...<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 5.620416] ddbridge 0000:02:00.0: DVB: registering =
adapter 1 frontend 0 (STV090x Multistandard)...<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027653] dvb_as102: module is from the staging =
directory, the quality is unknown, you have been =
warned.<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027669] dvb_as102: module is from the staging =
directory, the quality is unknown, you have been =
warned.<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027733] dvb_as102: disagrees about version of symbol =
dvb_frontend_detach<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027735] dvb_as102: Unknown symbol dvb_frontend_detach =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027739] dvb_as102: disagrees about version of symbol =
dvb_unregister_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027740] dvb_as102: Unknown symbol =
dvb_unregister_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027743] dvb_as102: disagrees about version of symbol =
dvb_register_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027744] dvb_as102: Unknown symbol =
dvb_register_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027856] dvb_as102: disagrees about version of symbol =
dvb_frontend_detach<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027858] dvb_as102: Unknown symbol dvb_frontend_detach =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027862] dvb_as102: disagrees about version of symbol =
dvb_unregister_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027863] dvb_as102: Unknown symbol =
dvb_unregister_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027868] dvb_as102: disagrees about version of symbol =
dvb_register_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.027870] dvb_as102: Unknown symbol =
dvb_register_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178608] dvb_usb_v2: disagrees about version of symbol =
dvb_dmxdev_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178611] dvb_usb_v2: Unknown symbol dvb_dmxdev_init =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178626] dvb_usb_v2: disagrees about version of symbol =
dvb_register_adapter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178627] dvb_usb_v2: Unknown symbol =
dvb_register_adapter (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178639] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter_204<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178640] dvb_usb_v2: Unknown symbol =
dvb_dmx_swfilter_204 (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178643] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178644] dvb_usb_v2: Unknown symbol dvb_dmx_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178708] dvb_usb_v2: disagrees about version of symbol =
dvb_net_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178709] dvb_usb_v2: Unknown symbol dvb_net_init (err =
-22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178712] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178713] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178716] dvb_usb_v2: disagrees about version of symbol =
dvb_dmxdev_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178717] dvb_usb_v2: Unknown symbol dvb_dmxdev_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178722] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter_raw<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178723] dvb_usb_v2: Unknown symbol =
dvb_dmx_swfilter_raw (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178727] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_detach<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178728] dvb_usb_v2: Unknown symbol dvb_frontend_detach =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178731] dvb_usb_v2: disagrees about version of symbol =
dvb_net_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178732] dvb_usb_v2: Unknown symbol dvb_net_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178738] dvb_usb_v2: disagrees about version of symbol =
dvb_unregister_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178739] dvb_usb_v2: Unknown symbol =
dvb_unregister_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178743] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_resume<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178744] dvb_usb_v2: Unknown symbol dvb_frontend_resume =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178746] dvb_usb_v2: disagrees about version of symbol =
dvb_register_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178747] dvb_usb_v2: Unknown symbol =
dvb_register_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178749] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_suspend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178750] dvb_usb_v2: Unknown symbol =
dvb_frontend_suspend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178753] dvb_usb_v2: disagrees about version of symbol =
dvb_unregister_adapter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178754] dvb_usb_v2: Unknown symbol =
dvb_unregister_adapter (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178757] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178758] dvb_usb_v2: Unknown symbol dvb_dmx_init (err =
-22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178871] dvb_usb_v2: disagrees about version of symbol =
dvb_dmxdev_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178873] dvb_usb_v2: Unknown symbol dvb_dmxdev_init =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178883] dvb_usb_v2: disagrees about version of symbol =
dvb_register_adapter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178884] dvb_usb_v2: Unknown symbol =
dvb_register_adapter (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178892] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter_204<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178893] dvb_usb_v2: Unknown symbol =
dvb_dmx_swfilter_204 (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178896] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178897] dvb_usb_v2: Unknown symbol dvb_dmx_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178902] dvb_usb_v2: disagrees about version of symbol =
dvb_net_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178903] dvb_usb_v2: Unknown symbol dvb_net_init (err =
-22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178905] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178906] dvb_usb_v2: Unknown symbol dvb_dmx_swfilter =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178909] dvb_usb_v2: disagrees about version of symbol =
dvb_dmxdev_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178910] dvb_usb_v2: Unknown symbol dvb_dmxdev_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178914] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_swfilter_raw<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178915] dvb_usb_v2: Unknown symbol =
dvb_dmx_swfilter_raw (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178918] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_detach<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178919] dvb_usb_v2: Unknown symbol dvb_frontend_detach =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178922] dvb_usb_v2: disagrees about version of symbol =
dvb_net_release<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178923] dvb_usb_v2: Unknown symbol dvb_net_release =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178927] dvb_usb_v2: disagrees about version of symbol =
dvb_unregister_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178928] dvb_usb_v2: Unknown symbol =
dvb_unregister_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178932] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_resume<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178933] dvb_usb_v2: Unknown symbol dvb_frontend_resume =
(err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178935] dvb_usb_v2: disagrees about version of symbol =
dvb_register_frontend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178936] dvb_usb_v2: Unknown symbol =
dvb_register_frontend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178938] dvb_usb_v2: disagrees about version of symbol =
dvb_frontend_suspend<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178939] dvb_usb_v2: Unknown symbol =
dvb_frontend_suspend (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178942] dvb_usb_v2: disagrees about version of symbol =
dvb_unregister_adapter<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178943] dvb_usb_v2: Unknown symbol =
dvb_unregister_adapter (err -22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178945] dvb_usb_v2: disagrees about version of symbol =
dvb_dmx_init<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp;&nbsp; 6.178946] dvb_usb_v2: Unknown symbol dvb_dmx_init (err =
-22)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp; 61.247127] ddbridge 0000:02:00.0: DVB: adapter 1 frontend 0 =
frequency 0 out of range (950000..2150000)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>[&nb=
sp;&nbsp; 61.278664] ddbridge 0000:02:00.0: DVB: adapter 0 frontend 0 =
frequency 0 out of range (950000..2150000)<o:p></o:p></span></p><p =
style=3D'mso-margin-top-alt:8.4pt;margin-right:0cm;margin-bottom:8.4pt;ma=
rgin-left:0cm;text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>root=
@TVHead:~#<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>root=
@TVHead:~# lsdvb<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'><o:p=
>&nbsp;</o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; lsdvb: Simple utility to list PCI/PCIe DVB =
devices<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; Version: 0.0.4<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; Copyright (C) Manu Abraham<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'><o:p=
>&nbsp;</o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>ddbr=
idge (0:3 0:21) on PCI Domain:0 Bus:2 Device:0 =
Function:0<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEVICE:0 ADAPTER:0 FRONTEND:0 =
(STV090x Multistandard)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; FE_QPSK Fmin=3D950MHz =
Fmax=3D2150MHz<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEVICE:0 ADAPTER:1 FRONTEND:0 =
(STV090x Multistandard)<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; FE_QPSK Fmin=3D950MHz =
Fmax=3D2150MHz<o:p></o:p></span></p><p =
style=3D'text-align:justify;line-height:16.2pt'><span =
style=3D'font-size:8.0pt;font-family:"Arial",sans-serif;color:black'>root=
@TVHead:~#<o:p></o:p></span></p></div></body></html>
------=_NextPart_000_000D_01CFFC54.C8802F10--



--===============1885721034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1885721034==--
