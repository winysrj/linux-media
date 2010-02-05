Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <prjackson68@gmail.com>) id 1NdS8h-00029n-CL
	for linux-dvb@linuxtv.org; Fri, 05 Feb 2010 18:38:44 +0100
Received: from mail-ew0-f218.google.com ([209.85.219.218])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NdS8g-00023y-OE; Fri, 05 Feb 2010 18:38:43 +0100
Received: by ewy10 with SMTP id 10so2075589ewy.11
	for <linux-dvb@linuxtv.org>; Fri, 05 Feb 2010 09:38:41 -0800 (PST)
From: "Peter Jackson" <prjackson68@gmail.com>
To: <linux-dvb@linuxtv.org>
Date: Fri, 5 Feb 2010 17:38:42 -0000
Message-ID: <004401caa68a$13182e90$39488bb0$@com>
MIME-Version: 1.0
Content-Language: en-gb
Subject: Re: [linux-dvb] Compro VideoMate U80 DVB-T USB 2.0 High
	Definition	Digital TV Stick
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1817556431=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============1817556431==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0045_01CAA68A.13182E90"
Content-Language: en-gb

This is a multipart message in MIME format.

------=_NextPart_000_0045_01CAA68A.13182E90
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I am having problems with the same device.

 

USB ID 185B:0150

 

After following the instructions with the UDEV rules. The /DEV/DVB folders
were created and the I could see the tuner in Kaffeine. However there is no
signal and I cannot therefore tune in any stations. ( I have checked to make
sure the antenna is connected!)

 

Also once the UDEV rules are changed lsusb returns nothing.

 

In DMESG

 

I see the following 

 

[    9.573327] rtl2831u_module_init:
[    9.573364] rtl2831u_probe: interface:0
[    9.573369] dvb-usb: found a 'VideoMate U90' in warm state.
[    9.577646] rtl2831u_power_ctrl: onoff:1 < sys_0:e0 gpo:01
[    9.577653] rtl2831u_power_ctrl: onoff:1 > sys_0:e0 gpo:01
[    9.578181] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[    9.579592] DVB: registering new adapter (VideoMate U90)
[    9.580086] rtl2831u_frontend_attach:
[    9.596099] rtl2831u_rw_udev: usb_control_msg failed:-32
[    9.596106] rtl2831u_frontend_attach: tuner:2
[    9.829777] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   10.233111] DVB: registering adapter 0 frontend 0 (Realtek RTL2830
DVB-T)...
[   10.233239] rtl2831u_tuner_attach:
[   10.339793] ip_tables: (C) 2000-2006 Netfilter Core Team
[   10.434693] MXL5005S: Attached at address 0xc6
[   10.436329] rtl2831u_power_ctrl: onoff:0 < sys_0:e0 gpo:01
[   10.436336] rtl2831u_power_ctrl: onoff:0 > sys_0:e0 gpo:01
[   10.436755] dvb-usb: VideoMate U90 successfully initialized and
connected.
[   10.436833] usbcore: registered new interface driver dvb_usb_rtl2831u
[   12.558067]   alloc irq_desc for 22 on node -1
[   12.558074]   alloc kstat_irqs on node -1

Comparing this to other people's logs the 

 

[    9.596099] rtl2831u_rw_udev: usb_control_msg failed:-32

 

Is different. Does anyone know what that means?

 

Thanks
Peter


------=_NextPart_000_0045_01CAA68A.13182E90
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-GB link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>I am having problems with the same =
device.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>USB ID 185B:0150<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>After following the instructions with the UDEV =
rules. The
/DEV/DVB folders were created and the I could see the tuner in Kaffeine. =
However
there is no signal and I cannot therefore tune in any stations. ( I have =
checked
to make sure the antenna is connected!)<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Also once the UDEV rules are changed lsusb returns =
nothing.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>In DMESG<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I see the following <o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><span =
style=3D'font-size:12.0pt;
font-family:"Times New Roman","serif"'>[&nbsp;&nbsp;&nbsp; 9.573327]
rtl2831u_module_init:</span><br>
[&nbsp;&nbsp;&nbsp; 9.573364] rtl2831u_probe: interface:0<br>
[&nbsp;&nbsp;&nbsp; 9.573369] dvb-usb: found a 'VideoMate U90' in warm =
state.<br>
[&nbsp;&nbsp;&nbsp; 9.577646] rtl2831u_power_ctrl: onoff:1 &lt; sys_0:e0 =
gpo:01<br>
[&nbsp;&nbsp;&nbsp; 9.577653] rtl2831u_power_ctrl: onoff:1 &gt; sys_0:e0 =
gpo:01<br>
[&nbsp;&nbsp;&nbsp; 9.578181] dvb-usb: will pass the complete MPEG2 =
transport
stream to the software demuxer.<br>
[&nbsp;&nbsp;&nbsp; 9.579592] DVB: registering new adapter (VideoMate =
U90)<br>
[&nbsp;&nbsp;&nbsp; 9.580086] rtl2831u_frontend_attach:<br>
[&nbsp;&nbsp;&nbsp; 9.596099] rtl2831u_rw_udev: usb_control_msg =
failed:-32<br>
[&nbsp;&nbsp;&nbsp; 9.596106] rtl2831u_frontend_attach: tuner:2<br>
[&nbsp;&nbsp;&nbsp; 9.829777] Installing knfsd (copyright (C) 1996 <a
href=3D"mailto:okir@monad.swb.de">okir@monad.swb.de</a>).<br>
[&nbsp;&nbsp; 10.233111] DVB: registering adapter 0 frontend 0 (Realtek =
RTL2830
DVB-T)...<br>
[&nbsp;&nbsp; 10.233239] rtl2831u_tuner_attach:<br>
[&nbsp;&nbsp; 10.339793] ip_tables: (C) 2000-2006 Netfilter Core =
Team<br>
[&nbsp;&nbsp; 10.434693] MXL5005S: Attached at address 0xc6<br>
[&nbsp;&nbsp; 10.436329] rtl2831u_power_ctrl: onoff:0 &lt; sys_0:e0 =
gpo:01<br>
[&nbsp;&nbsp; 10.436336] rtl2831u_power_ctrl: onoff:0 &gt; sys_0:e0 =
gpo:01<br>
[&nbsp;&nbsp; 10.436755] dvb-usb: VideoMate U90 successfully initialized =
and
connected.<br>
[&nbsp;&nbsp; 10.436833] usbcore: registered new interface driver
dvb_usb_rtl2831u<br>
[&nbsp;&nbsp; 12.558067]&nbsp;&nbsp; alloc irq_desc for 22 on node =
-1<br>
[&nbsp;&nbsp; 12.558074]&nbsp;&nbsp; alloc kstat_irqs on node =
-1<o:p></o:p></p>

<p class=3DMsoNormal>Comparing this to other people&#8217;s logs the =
<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>[&nbsp;&nbsp;&nbsp; 9.596099] rtl2831u_rw_udev:
usb_control_msg failed:-32<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Is different. Does anyone know what that =
means?<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Thanks<br>
Peter<o:p></o:p></p>

</div>

</body>

</html>

------=_NextPart_000_0045_01CAA68A.13182E90--



--===============1817556431==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1817556431==--
