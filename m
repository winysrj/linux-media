Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61595 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2IFQna (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 12:43:30 -0400
Received: by iahk25 with SMTP id k25so2255155iah.19
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2012 09:43:30 -0700 (PDT)
From: "John Weber" <rjohnweber@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Using omap3-isp-live example application on beagleboard with DVI
Date: Thu, 6 Sep 2012 11:43:26 -0500
Message-ID: <090701cd8c4e$be38bea0$3aaa3be0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

My goal is to better understand how to write an application that makes use
of the omap3isp and media controller frameworks and v4l2.  I'm attempting to
make use of Laurent's omap3-isp-live example application as a starting point
and play with the AEC/WB capability.

My problem is that when I start the live application, the display turns blue
(it seems when the chromakey fill is done), but no video appears on the
display.  I do think that I'm getting good (or at least statistics) from the
ISP because I can change the view in front of the camera (by putting my hand
in front of the lens) and the gain settings change.

root@beagleboard:~# live

Device /dev/video6 opened: OMAP3 ISP resizer output (media).

viewfinder configured for 2011 1024x768

AEWB: #win 10x7 start 16x74 size 256x256 inc 30x30

Device /dev/video7 opened: omap_vout ().

3 buffers requested.

Buffer 0 mapped at address 0x40279000.

Buffer 1 mapped at address 0x40402000.

Buffer 2 mapped at address 0x4059e000.

3 buffers requested.

Buffer 0 valid.

Buffer 1 valid.

Buffer 2 valid.

AE: factor 3.1250 exposure 2000 sensor gain 12

AE: factor 1.6018 exposure 2000 sensor gain 19

AE: factor 1.1346 exposure 2000 sensor gain 21

AE: factor 1.0446 exposure 2000 sensor gain 21

AE: factor 1.0448 exposure 2000 sensor gain 21

AE: factor 1.0444 exposure 2000 sensor gain 21

AE: factor 1.0443 exposure 2000 sensor gain 21

AE: factor 1.0445 exposure 2000 sensor gain 21

AE: factor 1.0438 exposure 2000 sensor gain 21

AE: factor 1.0448 exposure 2000 sensor gain 21

AE: factor 1.0461 exposure 2000 sensor gain 21

AE: factor 1.0897 exposure 2000 sensor gain 22

AE: factor 2.6543 exposure 2000 sensor gain 58       <   Me obstructing the
camera FOV using my hand causes the factor and gain to rise

AE: factor 1.2345 exposure 2000 sensor gain 71       <

AE: factor 1.1631 exposure 2000 sensor gain 82       <

AE: factor 0.9797 exposure 2000 sensor gain 80       <

AE: factor 0.9709 exposure 2000 sensor gain 77       <

frame rate: 6.597745 fps

AE: factor 0.9633 exposure 2000 sensor gain 74       <

AE: factor 0.6130 exposure 2000 sensor gain 45       <

AE: factor 0.9271 exposure 2000 sensor gain 41       <

AE: factor 1.0130 exposure 2000 sensor gain 41       <

AE: factor 1.0504 exposure 2000 sensor gain 43       <

AE: factor 1.0411 exposure 2000 sensor gain 44       <

AE: factor 1.0271 exposure 2000 sensor gain 45       <

AE: factor 1.0602 exposure 2000 sensor gain 47       <

AE: factor 1.1278 exposure 2000 sensor gain 53       <

AE: factor 1.1870 exposure 2000 sensor gain 62       <

AE: factor 1.1074 exposure 2000 sensor gain 68       <

AE: factor 1.0716 exposure 2000 sensor gain 72       <

AE: factor 0.4074 exposure 2000 sensor gain 29       <

AE: factor 0.8033 exposure 2000 sensor gain 23

AE: factor 0.9741 exposure 2000 sensor gain 22

AE: factor 1.0115 exposure 2000 sensor gain 22


I did have to change the omap_vout driver slightly to increase the buffer
size.  I was getting errors in the application attempted to allocate USERPTR
buffers for 1024x768 frames:

root@beagleboard:~# live

Device /dev/video6 opened: OMAP3 ISP resizer output (media).

viewfinder configured for 2011 1024x768

AEWB: #win 10x7 start 16x74 size 256x256 inc 30x30

Device /dev/video7 opened: omap_vout ().

3 buffers requested.

Buffer 0 mapped at address 0x40302000.

Buffer 1 mapped at address 0x404df000.

Buffer 2 mapped at address 0x4066e000.

3 buffers requested.

Buffer 0 too small (1572864 bytes required, 1474560 bytes available.)  

So, I changed drivers/media/video/omap/omap_voutdef.h to increase the buffer
size slightly.

/* Max Resolution supported by the driver */
#define VID_MAX_WIDTH		1280	/* Largest width */
#define VID_MAX_HEIGHT		768  	/* Largest height */ <-- Was 720

I'm pretty sure that wasn't the only way to solve the problem, but it did
allow the live application to run without errors.

I am using a patched variant of the current Angstrom mainline (3.2.16) with
the MT9P031 sensor and a DVI display on Beagleboard-xM and am able to run
the following commands and see a live video stream on the display.  I
suspect that this indicates that hardware setup works:

media-ctl -v -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP
resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'

media-ctl -v -f '"mt9p031 2-0048":0 [SGRBG12 1024x768], "OMAP3 ISP CCDC":2
[SGRBG10 1024x768], "OMAP3 ISP preview":1 [UYVY 10006x760], "OMAP3 ISP
resizer":1 [UYVY 1024x768]'

yavta -f UYVY -s 1024x768 -n 8 --skip 3 --capture=1000 --stdout /dev/video6
| mplayer - -demuxer rawvideo -rawvideo w=1024:h=768:format=uyvy -vo fbdev

Thanks for any tips or assistance!

John

