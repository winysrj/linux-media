Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41183 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1IDSi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2011 14:38:57 -0400
Received: by pzk37 with SMTP id 37so7602484pzk.1
        for <linux-media@vger.kernel.org>; Sun, 04 Sep 2011 11:38:56 -0700 (PDT)
Message-ID: <4E63D3F2.8090500@gmail.com>
Date: Sun, 04 Sep 2011 15:39:30 -0400
From: Mauricio Henriquez <buhochileno@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: spca1528 device (Device 015: ID 04fc:1528 Sunplus Technology)..libv4l2:
 error turning on	stream: Timer expired issue
Content-Type: multipart/mixed;
 boundary="------------080904000104060900060008"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080904000104060900060008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi guys,

Not sure if is the right place to ask since this device use a gspca driver
and not sure if that driver is related to uvc or not, if not please point
me to the right place...

Recently I'm trying to make work a Sunplus crappy mini HD USB camera, lsusb
list this info related to the device:

Picture Transfer Protocol (PIMA 15470)
Bus 001 Device 015: ID 04fc:1528 Sunplus Technology Co., Ltd

  idVendor           0x04fc Sunplus Technology Co., Ltd
   idProduct          0x1528
   bcdDevice            1.00
   iManufacturer           1 Sunplus Co Ltd
   iProduct                2 General Image Devic
   iSerial                 0
...

Using the gspca-2.13.6 on my Fed12 (2.6.31.6-166.fc12.i686.PAE kernel), the
device is listed as /dev/video1 and no error doing a dmesg...but trying to
make it work, let say with xawtv, I get:

This is xawtv-3.95, running on Linux/i686 (2.6.31.6-166.fc12.i686.PAE)
xinerama 0: 1600x900+0+0
WARNING: No DGA direct video mode for this display.
/dev/video1 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Missing charsets in String to FontSet conversion
Warning: Missing charsets in String to FontSet conversion
libv4l2: error turning on stream: Timer expired
ioctl: VIDIOC_STREAMON(int=1): Timer expired
ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
v4l2: oops: select timeout

..or doing:
xawtv -c /dev/video1 -nodga -novm -norandr -noxv -noxv-video

I get:
ioctl: VIDIOC_STREAMON(int=1): Timer expired
ioctl: VIDIOC_S_STD(std=0x0 []): Invalid argument
v4l2: oops: select timeout
libv4l2: error turning on stream: Timer expired
libv4l2: error reading: Invalid argument


vlc, cheese, etc give me similar "Timeout" related messages...

I read some post about similar devices (but ID 12 or 14) that successfully
works with gspca, so it seems that this one is close to work but may be need
a fix on some timeout or something similar on the driver...

Any clue of what can be done?..any suggestions or right place to ask?, do
you need any other info to help to dig into the problem?

Thanks a lot.

Mauricio

-- 
Mauricio R. Henriquez Schott
Escuela de Ingeniería en Computación
Universidad Austral de Chile - Sede Puerto Montt
Los Pinos S/N, Balneario de Pelluco, Puerto Montt - Chile
Tel: 65-487440
Fax: 65-277156
mail: mauriciohenriquez@uach.cl


--------------080904000104060900060008
Content-Type: text/x-vcard; charset=utf-8;
 name="buhochileno.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="buhochileno.vcf"

begin:vcard
fn:Mauricio Henriquez
n:Henriquez;Mauricio
org;quoted-printable:Universidad Austral de Chile - Sede Puerto Montt;Escuela de Computaci=C3=B3n
adr:;;Los Pinos S/N Balneario de Pelluco;Puerto Montt;Llanquihue;5480000;Chile
email;internet:mauriciohenriquez@uach.cl
title:Docente
tel;work:65-487440
tel;fax:65-277156
url:http://www.monobotics.ic.uach.cl
version:2.1
end:vcard


--------------080904000104060900060008--
