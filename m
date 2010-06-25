Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48596 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0FYJZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jun 2010 05:25:14 -0400
Received: by qyk38 with SMTP id 38so499004qyk.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jun 2010 02:25:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 25 Jun 2010 17:25:13 +0800
Message-ID: <AANLkTilsMviOOwo1IWpyfNkd5jeSMU9SozqvgcamBdF_@mail.gmail.com>
Subject: Question on newly build uvcvideo.ko
From: Samuel Xu <samuel.xu.tech@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI:
I am using a ASUS netbook with a USB 2.0 web camera (04f2:b071 Chicony
Electronics Co., Ltd 2.0M UVC WebCam / CNF7129)
I installed Linux, and the default uvcvideo.ko works (I tried
gstreamer-properties, which can find CNF7129 device and show correct
video camera test).
While I want to try the newest V4L2 build, So I follow
http://www.linuxtv.org/wiki to:
1: get the src code v4l-dvb-9652f85e688a.tar.gz
2: make and make install on my netbook.
3: reboot system

lsmod shows me uvcvideo module has been loaded, while
gstreamer-properties can't find CNF7129 device, so I can't use this
USB 2.0 web camera now.

I also tried re-install original workable Linux, and make v4l again.
Then copy the newly build uvcvideo.ko to
/lib/modules/2.6.33.xx/kernel/drivers/media/video/uvc/
module still can be found from lsmod, while gstreamer-properties still
can't find CNF7129 device.


Does it mean I must do some code modification for 04f2:b071 device
before I build v4l driver?


Thanks!
Samuel

-----------------------------Here is lsusb -v information of my
webcam--------------------------------------
Bus 001 Device 004: ID 04f2:b071 Chicony Electronics Co., Ltd 2.0M UVC
WebCam / CNF7129
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x04f2 Chicony Electronics Co., Ltd
  idProduct          0xb071 2.0M UVC WebCam / CNF7129
  bcdDevice           15.44
  iManufacturer           2 Chicony Electronics Co., Ltd.
  iProduct                1 CNF7129
  iSerial                 3 SN0001
...........................
