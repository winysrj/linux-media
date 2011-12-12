Return-path: <linux-media-owner@vger.kernel.org>
Received: from seiner.com ([66.178.130.209]:50000 "EHLO www.seiner.lan"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752618Ab1LLBEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 20:04:06 -0500
Received: from www.seiner.lan ([192.168.128.6] ident=yan)
	by www.seiner.lan with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <yan@seiner.com>)
	id 1RZuJI-0003QF-To
	for linux-media@vger.kernel.org; Sun, 11 Dec 2011 17:04:04 -0800
Message-ID: <4EE55304.9090707@seiner.com>
Date: Sun, 11 Dec 2011 17:04:04 -0800
From: Yan Seiner <yan@seiner.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx231xx kernel oops
References: <4EDC25F1.4000909@seiner.com>    <1323058527.12343.3.camel@palomino.walls.org>    <4EDC4C84.2030904@seiner.com> <4EDC4E9B.40301@seiner.com>    <4EDCB6D1.1060508@seiner.com>    <1098bb19-5241-4be4-a916-657c0b599efd@email.android.com> <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com>
In-Reply-To: <c0667c34eccf470314966c2426b00af4.squirrel@mail.seiner.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm resurrecting an older thread.  I have a Hauppage USB Live2 connected 
to a MIPS box running openWRT.  I tried this earlier on a older hardware 
running the 3.0.3 kernel.  This is with newer hardware running 
2.6.39.4.  The driver attempts to allocate 800MB (!!!) of memory for the 
buffer and fails with a kernel crash.  I'm not including any kernel 
crash stuff as it has all the symbols stripped.

This seems to be the key message:

[  514.770000] unable to allocate 805398992 bytes for transfer buffer 0

What can I do to narrow down the allocation problem?

system type        : Atheros AR9132 rev 2
machine            : Buffalo WZR-HP-G300NH
processor        : 0
cpu model        : MIPS 24Kc V7.4
BogoMIPS        : 265.42

Bus 001 Device 005: ID 2040:c200 Hauppauge

[   34.560000] cx231xx v4l2 driver loaded.
[   34.570000] cx231xx #0: New device Hauppauge Hauppauge Device @ 480 
Mbps (2040:c200) with 5 interfaces
[   34.580000] cx231xx #0: registering interface 1
[   34.580000] cx231xx #0: bad senario!!!!!
[   34.590000] cx231xx #0: config_info=0
[   34.590000] cx231xx #0: can't change interface 1 alt no. to 3: Max. 
Pkt size = 0
[   34.600000] usb 1-1.2: selecting invalid altsetting 3
[   34.600000] cx231xx #0: can't change interface 1 alt no. to 3 (err=-22)
[   34.610000] cx231xx #0: can't change interface 1 alt no. to 1: Max. 
Pkt size = 0
[   34.620000] usb 1-1.2: selecting invalid altsetting 1
[   34.620000] cx231xx #0: can't change interface 1 alt no. to 1 (err=-22)
[   34.630000] cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
[   34.740000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   34.760000] cx231xx #0: Changing the i2c master port to 3
[   34.760000] cx25840 0-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[   34.790000] cx25840 0-0044:  Firmware download size changed to 16 
bytes max length
[   36.770000] cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw firmware 
(16382 bytes)
[   36.810000] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.1
[   36.840000] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[   36.890000] cx231xx #0: video_mux : 0
[   36.900000] cx231xx #0: do_mode_ctrl_overrides : 0xb000
[   36.900000] cx231xx #0: do_mode_ctrl_overrides NTSC
[   36.910000] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[   36.920000] cx231xx #0: cx231xx #0/0: registered device vbi0
[   36.930000] cx231xx #0: V4L2 device registered as video0 and vbi0
[   36.930000] cx231xx #0: EndPoint Addr 0x8f00, Alternate settings: 1
[   36.940000] cx231xx #0: Alternate setting 0, max size= 8
[   36.940000] cx231xx #0: EndPoint Addr 0x8f00, Alternate settings: 1
[   36.950000] cx231xx #0: Alternate setting 0, max size= 8
[   36.960000] cx231xx #0: EndPoint Addr 0x8f00, Alternate settings: 1
[   36.960000] cx231xx #0: Alternate setting 0, max size= 8
[   36.970000] cx231xx #0: EndPoint Addr 0x8f00, Alternate settings: 1
[   36.970000] cx231xx #0: Alternate setting 0, max size= 8
[   36.980000] usbcore: registered new interface driver cx231xx
[   37.230000] ar71xx-wdt: enabling watchdog timer


root@rtmovies:/www/tmp/root/etc# fswebcam -r 320x240
--- Opening /dev/video0...
Trying source module v4l2...
/dev/video0 opened.
No input was specified, using the first.
VIDIOC_QBUF: Cannot allocate memory
Unable to use mmap. Using read instead.
--- Capturing frame...
VIDIOC_DQBUF: Invalid argument
No frames captured.



-- 
Few people are capable of expressing with equanimity opinions which differ from the prejudices of their social environment. Most people are even incapable of forming such opinions.
    Albert Einstein

