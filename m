Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <luciano.faletti@hotmail.com>) id 1Z0GHf-0003UX-Qb
	for linux-dvb@linuxtv.org; Wed, 03 Jun 2015 23:33:16 +0200
Received: from blu004-omc3s24.hotmail.com ([65.55.116.99])
	by mail.tu-berlin.de (exim-4.76/mailfrontend-5) with esmtps
	[UNKNOWN:AES256-SHA256:256] for <linux-dvb@linuxtv.org>
	id 1Z0GHd-00058p-7I; Wed, 03 Jun 2015 23:33:10 +0200
Message-ID: <BLU185-W6304EA5BA0F2C9BB8CEF26F5B40@phx.gbl>
From: Luciano Faletti <luciano.faletti@hotmail.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
Date: Wed, 3 Jun 2015 18:31:41 -0300
MIME-Version: 1.0
Subject: [linux-dvb] Geniatech Mygica S2870 STK8096-PVR drivers
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0177361534=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0177361534==
Content-Type: multipart/alternative;
	boundary="_63f116b3-f66e-4d7e-8616-05f6352a9cfc_"

--_63f116b3-f66e-4d7e-8616-05f6352a9cfc_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi folks=2C

I had acquired Geniatech Mygica S2870 usb for digital TV. Installed the lat=
est dvb drivers from http://git.linuxtv.org/media_build.git .
However=2C it doesn't seem to load the drivers when plugged in. No /dev/dvb=
 devices are created.
Below is the output I get when plugging in=2C which shows no module is load=
ed:

[  198.762635] usb 3-2: new high-speed USB device number 3 using xhci_hcd
[  198.779253] usb 3-2: New USB device found=2C idVendor=3D10b8=2C idProduc=
t=3D1faa
[  198.779261] usb 3-2: New USB device strings: Mfr=3D1=2C Product=3D2=2C S=
erialNumber=3D3
[  198.779265] usb 3-2: Product: STK8096-PVR
[  198.779267] usb 3-2: Manufacturer: Geniatech
[  198.779270] usb 3-2: SerialNumber: 1

Same issue was reported here
http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/8=
7747

Do you have any update if this device would work=2C and how?

I'm on Ubuntu with linux kernel 3.13.0-53-generic.

Thanks in advance=2C
Luciano
 		 	   		  =

--_63f116b3-f66e-4d7e-8616-05f6352a9cfc_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'>Hi folks=2C<br><br>I had acquire=
d Geniatech Mygica S2870 usb for digital TV. Installed the latest dvb drive=
rs from <a href=3D"http://git.linuxtv.org/media_build.git" target=3D"_blank=
" class=3D"c_nobdr t_prs">http://git.linuxtv.org/media_build.git</a> .<br>H=
owever=2C it doesn't seem to load the drivers when plugged in. No /dev/dvb =
devices are created.<br>Below is the output I get when plugging in=2C which=
 shows no module is loaded:<br><br>[&nbsp=3B 198.762635] usb 3-2: new high-=
speed USB device number 3 using xhci_hcd<br>[&nbsp=3B 198.779253] usb 3-2: =
New USB device found=2C idVendor=3D10b8=2C idProduct=3D1faa<br>[&nbsp=3B 19=
8.779261] usb 3-2: New USB device strings: Mfr=3D1=2C Product=3D2=2C Serial=
Number=3D3<br>[&nbsp=3B 198.779265] usb 3-2: Product: STK8096-PVR<br>[&nbsp=
=3B 198.779267] usb 3-2: Manufacturer: Geniatech<br>[&nbsp=3B 198.779270] u=
sb 3-2: SerialNumber: 1<br><br>Same issue was reported here<br><a href=3D"h=
ttp://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/87=
747" target=3D"_blank">http://permalink.gmane.org/gmane.linux.drivers.video=
-input-infrastructure/87747</a><br><br>Do you have any update if this devic=
e would work=2C and how?<br><br>I'm on Ubuntu with linux kernel 3.13.0-53-g=
eneric.<br><br>Thanks in advance=2C<br>Luciano<br> 		 	   		  </div></body>
</html>=

--_63f116b3-f66e-4d7e-8616-05f6352a9cfc_--


--===============0177361534==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0177361534==--
