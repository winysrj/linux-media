Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35356 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752604AbcKHKGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2016 05:06:23 -0500
Received: by mail-wm0-f54.google.com with SMTP id a197so234719953wmd.0
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2016 02:06:22 -0800 (PST)
Received: from toshiba (90-145-46-101.wxdsl.nl. [90.145.46.101])
        by smtp.gmail.com with ESMTPSA id u64sm91130wmd.6.2016.11.08.02.06.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Nov 2016 02:06:21 -0800 (PST)
Message-ID: <5821a39d.43921c0a.501fd.07e9@mx.google.com>
Date: Tue, 8 Nov 2016 11:05:23 +0100
From: mjs <mjstork@gmail.com>
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Problem retrieving zl10353 information: Resource temporarily
 unavailable (but signal =71% ?)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to get a dvb-t usb-stick to work with debian.

     Components: em2882 - xc3028l (uses XC3028L-V36.fw) - ce6353 (zl10353) - tvp5150 - emp202
     Kernel:     4.7.0-0.bpo.1-686-pae - debian 8
     i2c device: eeprom @ 0xa0 - tvp5150 @ 0xb8 - tuner(analog) @0xc2 (from dmesg 2.6 kernel)

I got to this point:

     femon -H:
     FE: Zarlink ZL10353 DVB-T (DVBT)
     Problem retrieving frontend information: Resource temporarily unavailable
     status  C    | signal  71% | snr  74% | ber -1080313980 | unc -1218616323 | 


Using next (G)PIO settings, enable more did not improve anything:

	static struct em28xx_reg_seq zolid_tuner[] = {
	//	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	 10},
	//	{EM2820_R08_GPIO_CTRL,	 0,		EM_GPIO_4,	 10},
	//	{EM2820_R08_GPIO_CTRL,	EM_GPIO_4,	EM_GPIO_4,	 10},
		{	-1,		-1,		-1,		 -1},
	};
	static struct em28xx_reg_seq zolid_digital[] = {
	//	{EM2820_R08_GPIO_CTRL,	0x6e,		~EM_GPIO_4,	100},
	//	{EM2880_R04_GPO,	0x04,		0xff,		100},	/* zl10353 reset ? */
		{EM2880_R04_GPO,	0x08,		0xff,		 10},	/* zl10353 to connect tuner (dmesg) */
	//	{EM2880_R04_GPO,	0x0c,		0xff,		 10},
		{	-1,		-1,		-1,		 -1},
	};
	static struct em28xx_reg_seq zolid_analog[] = {
		{EM2820_R08_GPIO_CTRL,	0x6d,		~EM_GPIO_4,	 10},	/* em202 (dmesg) */
	//	{EM2880_R04_GPO,	0x04,		0xff,		100},
	//	{EM2880_R04_GPO,	0x08,		0xff,		 10},
	//	{EM2880_R04_GPO,	0x0c,		0xff,		 10},
		{	-1,		-1,		-1,		 -1},

Two years ago I used snoop and perl tools on the ms-windows-driver and got next result:
40 00 00 00 04 00 01 00 >>> 04, 08 or 0c
19 times alternating 08 and 0c, and the last one was 04 followed by 0c
Also 40 00 00 00 08 00 01 00 >>>  6a, 6b, 6f, 7a, 7f, fd, fe or ff
I tried all of them in the second Coulomb zolid_digital as EM2820_R09_GPIO_CTRL, no improvement.

I do have a data-sheet em2882, did search trough linux-media and used duck-duck-go trying to get relevant info, no luck at this point.

Question:
Where to find knowledge about the em2882 GPIO and GPO ?
And naturally, any tips or advice is appreciated.

Thanks in advance.

Marcel Stork (Netherlands)





lsusb:
Bus 005 Device 002: ID eb1a:2883 eMPIA Technology, Inc. 
----------
/dev/dvb/adapter0 with demux0, drv0, frontend0 and net0 is created.
----------
dmesg:
[ 1897.124737] em28xx: New device  USB 2883 Device @ 480 Mbps (eb1a:2883, interface 0, class 0)
[ 1897.124745] em28xx: Audio interface 0 found (Vendor Class)
[ 1897.124750] em28xx: Video interface 0 found: isoc
[ 1897.124754] em28xx: DVB interface 0 found: isoc
[ 1897.124896] em28xx: chip ID is em2882/3
[ 1897.230009] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x85dd871e
[ 1897.230017] em2882/3 #0: EEPROM info:
[ 1897.230020] em2882/3 #0: 	AC97 audio (5 sample rates)
[ 1897.230024] em2882/3 #0: 	500mA max power
[ 1897.230029] em2882/3 #0: 	Table at offset 0x24, strings=0x226a, 0x108c, 0x0000
[ 1897.230035] em2882/3 #0: Identified as :ZOLID HYBRID TV STICK (card=100)
[ 1897.230040] em2882/3 #0: analog set to isoc mode.
[ 1897.230044] em2882/3 #0: dvb set to isoc mode.
[ 1897.230280] usbcore: registered new interface driver em28xx
[ 1897.291557] em2882/3 #0: Registering V4L2 extension
[ 1897.313877] tvp5150 7-005c: tvp5150 (4.0) chip found @ 0xb8 (em2882/3 #0)
[ 1897.313885] tvp5150 7-005c: tvp5150am1 detected.
[ 1897.327869] tuner 7-0061: Tuner -1 found with type(s) Radio TV.
[ 1897.376267] xc2028 7-0061: creating new instance
[ 1897.376277] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[ 1897.376495] em2882/3 #0: Config register raw data: 0xd0
   <FAT TXT>   [ 1897.377246] em2882/3 #0: AC97 vendor ID = 0xffffffff
   <FAT TXT>   [ 1897.377621] em2882/3 #0: AC97 features = 0x6a90
[ 1897.377626] em2882/3 #0: Empia 202 AC97 audio processor detected
[ 1897.399113] usb 5-3: firmware: direct-loading firmware xc3028L-v36.fw
[ 1897.399129] xc2028 7-0061: Loading 81 firmware images from xc3028L-v36.fw, type: xc2028 firmware, ver 3.6
[ 1897.524132] xc2028 7-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
   <FAT TXT>   [ 1898.511621] MTS (4), id 00000000000000ff:
[ 1898.511630] xc2028 7-0061: Loading firmware for type=MTS (4), id 0000000000000007.
[ 1898.809002] em2882/3 #0: V4L2 video device registered as video0
[ 1898.809009] em2882/3 #0: V4L2 VBI device registered as vbi0
[ 1898.809994] em2882/3 #0: V4L2 extension successfully initialized
[ 1898.810000] em28xx: Registered (Em28xx v4l2 Extension) extension
[ 1898.971663] em2882/3 #0: Binding audio extension
[ 1898.971672] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 1898.971676] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab
[ 1898.971803] em2882/3 #0: Endpoint 0x83 high-speed on intf 0 alt 7 interval = 8, size 196
[ 1898.971809] em2882/3 #0: Number of URBs: 1, with 64 packets and 192 size
[ 1898.973416] em2882/3 #0: Audio extension successfully initialized
[ 1898.973422] em28xx: Registered (Em28xx Audio Extension) extension
[ 1899.030697] em2882/3 #0: Binding DVB extension
[ 1899.322508] xc2028 7-0061: attaching existing instance
[ 1899.322518] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[ 1899.322523] em2882/3 #0: em2882/3 #0/2: xc3028 attached
[ 1899.322528] DVB: registering new adapter (em2882/3 #0)
[ 1899.322539] usb 5-3: DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[ 1899.323318] em2882/3 #0: DVB extension successfully initialized
[ 1899.323329] em28xx: Registered (Em28xx dvb Extension) extension
