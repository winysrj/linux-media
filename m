Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3EII3f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 May 2013 04:29:35 -0400
Received: from mailout-de.gmx.net ([10.1.76.31]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M6yIl-1UO22q2Lu1-00wn6b for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 10:29:33 +0200
Message-ID: <518B5E6C.6010802@gmx.de>
Date: Thu, 09 May 2013 10:29:32 +0200
From: Eric Sander <eric.sander@gmx.de>
MIME-Version: 1.0
To: Eric Sander <eric.sander@gmx.de>
CC: linux-media@vger.kernel.org
Subject: If the board were missdetected... more information
References: <518B4C9B.4030109@gmx.de>
In-Reply-To: <518B4C9B.4030109@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, here some more info:

lsusb:
Bus 001 Device 002: ID 2013:0251 PCTV Systems

cat /proc/version
Linux version 3.7.10-1.4-desktop (geeko@buildhost) (gcc version 4.7.2 
20130108 [gcc-4_7-branch revision 195012] (SUSE Linux) ) #1 SMP PREEMPT 
Fri Apr 19 12:06:34 UTC 2013 (8ef74f8)

Opensuse 12.3

On 09.05.2013 09:13, Eric Sander wrote:
> Hi There,
> i have the TV-USB-Stick: pctv QuatroStick nano  it is misdetected as 
> Sharp S921
>
> dmesg-log:
> [ 1080.044027] usb 1-7: new high-speed USB device number 7 using ehci_hcd
> [ 1080.159731] usb 1-7: New USB device found, idVendor=2013, 
> idProduct=0251
> [ 1080.159738] usb 1-7: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=3
> [ 1080.159744] usb 1-7: Product: PCTV 520e
> [ 1080.159748] usb 1-7: Manufacturer: PCTV Systems
> [ 1080.159752] usb 1-7: SerialNumber: 00000010JR7F
> [ 1080.160066] em28xx: New device PCTV Systems PCTV 520e @ 480 Mbps 
> (2013:0251, interface 0, class 0)
> [ 1080.160070] em28xx: Audio Vendor Class interface 0 found
> [ 1080.160073] em28xx: Video interface 0 found
> [ 1080.160076] em28xx: DVB interface 0 found
> [ 1080.161045] em28xx #0: chip ID is em2884
> [ 1080.256727] em28xx #0: found i2c device @ 0xa0 [eeprom]
> [ 1080.268726] em28xx #0: Your board has no unique USB ID.
> [ 1080.268732] em28xx #0: A hint were successfully done, based on i2c 
> devicelist hash.
> [ 1080.268736] em28xx #0: This method is not 100% failproof.
> [ 1080.268738] em28xx #0: If the board were missdetected, please email 
> this log to:
> [ 1080.268741] em28xx #0:       V4L Mailing List 
> <linux-media@vger.kernel.org>
> [ 1080.268745] em28xx #0: Board detected as EM2874 Leadership ISDBT
> [ 1080.352018] em28xx #0: Identified as EM2874 Leadership ISDBT (card=77)
> [ 1080.352097] em28xx #0: Config register raw data: 0x1e
> [ 1080.352844] em28xx #0: AC97 vendor ID = 0x8ca38ca3
> [ 1080.353476] em28xx #0: AC97 features = 0x8ca3
> [ 1080.353481] em28xx #0: Unknown AC97 audio processor detected!
> [ 1080.375722] em28xx #0: v4l2 driver version 0.1.3
> [ 1080.403724] em28xx #0: V4L2 video device registered as video0
> [ 1080.404172] em28xx-audio.c: probing for em28xx Audio Vendor Class
> [ 1080.404176] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [ 1080.404179] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho 
> Chehab
> [ 1080.422057] s921: s921_attach:
> [ 1080.422066] DVB: registering new adapter (em28xx #0)
> [ 1080.422076] usb 1-7: DVB: registering adapter 0 frontend 0 (Sharp 
> S921)...
> [ 1080.422677] em28xx #0: Successfully loaded em28xx-dvb
> [ 1080.796252] em28xx #0: submit of audio urb failed
>
> feel free to ask if you have further questions.
>

