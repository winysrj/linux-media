Return-path: <mchehab@pedra>
Received: from n5.bullet.mail.gq1.yahoo.com ([67.195.9.85]:35172 "HELO
	n5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752055Ab0HUT2C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 15:28:02 -0400
Message-ID: <970079.51877.qm@web112502.mail.gq1.yahoo.com>
Date: Sat, 21 Aug 2010 12:28:01 -0700 (PDT)
From: dave garello <davegarello@yahoo.com>
Subject: em28xx: new board id [1f71:3301]
To: linux-media@vger.kernel.org
In-Reply-To: <S1752033Ab0HUTQq/20100821191646Z+154@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

I'm testing with ubuntu 10.4 LTS on Dell Mini 10V

Model: Gadmei UTV330 USB 2.0
Vendor/Product id:  [1f71:3301].

Tests Made:
-Compile em28xx no error [work]
-Cannot make /dev/video1 (/devvideo0 occupied by webcam)

$ lsusb
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 413c:02b0 Dell Computer Corp. 
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 1bcf:0007 Sunplus Innovation Technology Inc. 
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 007: ID 1f71:3301  
Bus 001 Device 004: ID 0bda:0158 Realtek Semiconductor Corp. Mass Storage Device
Bus 001 Device 003: ID 064e:a129 Suyin Corp. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

$ cat /proc/modules | grep em28xx
em28xx 85730 0 - Live 0xf844e000
v4l2_common 17381 1 em28xx, Live 0xf86f7000
videobuf_vmalloc 4575 1 em28xx, Live 0xf84f2000
videobuf_core 16681 2 em28xx,videobuf_vmalloc, Live 0xf84e2000
ir_common 5123 1 em28xx, Live 0xf8378000
ir_core 13322 7 ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,em28xx,ir_rc5_decoder,ir_common,ir_nec_decoder, Live 0xf82a7000
tveeprom 11038 1 em28xx, Live 0xf8075000
videodev 42138 3 em28xx,v4l2_common,uvcvideo, Live 0xf827d000

[   13.431225] usbcore: registered new interface driver em28xx
[   13.431238] em28xx driver loaded




      

