Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <pika1021@gmail.com>) id 1TpVHS-0000qz-Qe
	for linux-dvb@linuxtv.org; Mon, 31 Dec 2012 03:39:35 +0100
Received: from mail-la0-f53.google.com ([209.85.215.53])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1TpVHS-0005ni-HM; Mon, 31 Dec 2012 03:39:10 +0100
Received: by mail-la0-f53.google.com with SMTP id fn20so3276599lab.26
	for <linux-dvb@linuxtv.org>; Sun, 30 Dec 2012 18:39:09 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 10:39:09 +0800
Message-ID: <CACJzANfzaqiDvDRbkKdXPH0sQj7RN8d+Ax8wGp3X9d55oYKOUg@mail.gmail.com>
From: =?UTF-8?B?5p6X5Y2a5LuB?= <pika1021@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with 187f:0202(Siano Mobile Silicon Nice) not
	automatic loading
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1936845509=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1936845509==
Content-Type: multipart/alternative; boundary=bcaec5555556f3694a04d21cea6d

--bcaec5555556f3694a04d21cea6d
Content-Type: text/plain; charset=UTF-8

Hi,
I tried to make a DVB-T reciever which uses ID 187f:0202(Siano Mobile
Silicon Nice) work on my linux machine(Ubuntu 12.10 x86 32bit) and
eventually found that only manually load 'smsdvb' module make the dvb
device create (it won't create if just plug-in the hardware)

Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.458196] usb 2-1.2: new
high-speed USB device number 21 using ehci_hcd
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544329] usb 2-1.2: New USB
device found, idVendor=187f, idProduct=0202
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544335] usb 2-1.2: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544340] usb 2-1.2: Product: MDTV
Receiver
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544343] usb 2-1.2: Manufacturer:
MDTV Receiver
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5820.177202] smscore_set_device_mode:
firmware download success: dvb_nova_12mhz_b0.inp
Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5820.180521] usbcore: registered new
interface driver smsusb

** % sudo modprobe smsdvb **

Dec 31 10:03:12 SSD-Vubuntu kernel: [ 5923.043199] DVB: registering new
adapter (Siano Nice Digital Receiver)
Dec 31 10:03:12 SSD-Vubuntu kernel: [ 5923.043502] usb 2-1.2: DVB:
registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...

Here is another card having the similar issue
http://www.linuxtv.org/wiki/index.php/Smart_Plus

I tried to contact smsusb module's author (uris@siano-ms.com) but the
address is broken now...

Sincerely,
Henry Lin <pika1021@gmail.com>

--bcaec5555556f3694a04d21cea6d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Hi, <br></div>I tried to make a DVB-T =
reciever which uses
 ID 187f:0202(Siano Mobile Silicon Nice) work on my linux machine(Ubuntu
 12.10 x86 32bit) and eventually found that only manually load &#39;smsdvb&=
#39;=20
module make the dvb device create (it won&#39;t create if just plug-in the=
=20
hardware)<br>
<br>Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.458196] usb 2-1.2: new high-=
speed USB device number 21 using ehci_hcd<br>Dec 31 10:01:29 SSD-Vubuntu ke=
rnel: [ 5819.544329] usb 2-1.2: New USB device found, idVendor=3D187f, idPr=
oduct=3D0202<br>

Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5819.544335] usb 2-1.2: New USB devic=
e strings: Mfr=3D1, Product=3D2, SerialNumber=3D0<br>Dec 31 10:01:29 SSD-Vu=
buntu kernel: [ 5819.544340] usb 2-1.2: Product: MDTV Receiver<br>Dec 31 10=
:01:29 SSD-Vubuntu kernel: [ 5819.544343] usb 2-1.2: Manufacturer: MDTV Rec=
eiver<br>

Dec 31 10:01:29 SSD-Vubuntu kernel: [ 5820.177202] smscore_set_device_mode:=
 firmware download success: dvb_nova_12mhz_b0.inp<br>Dec 31 10:01:29 SSD-Vu=
buntu kernel: [ 5820.180521] usbcore: registered new interface driver smsus=
b<br>

<br></div>** % sudo modprobe smsdvb **<br><br>Dec 31 10:03:12 SSD-Vubuntu k=
ernel: [ 5923.043199] DVB: registering new adapter (Siano Nice Digital Rece=
iver)<br>Dec
 31 10:03:12 SSD-Vubuntu kernel: [ 5923.043502] usb 2-1.2: DVB:=20
registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...<br=
>
<br>Here is another card having the similar issue<br><a href=3D"http://www.=
linuxtv.org/wiki/index.php/Smart_Plus" target=3D"_blank">http://www.linuxtv=
.org/wiki/index.php/Smart_Plus</a></div><br></div>I tried to contact smsusb=
 module&#39;s author (<a href=3D"mailto:uris@siano-ms.com">uris@siano-ms.co=
m</a>) but the address is broken now...<br>
<br><div><div>Sincerely, <br></div>Henry Lin &lt;<a href=3D"mailto:pika1021=
@gmail.com" target=3D"_blank">pika1021@gmail.com</a>&gt;</div></div>

--bcaec5555556f3694a04d21cea6d--


--===============1936845509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1936845509==--
