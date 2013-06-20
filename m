Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38216 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3FTGSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 02:18:14 -0400
Received: by mail-lb0-f169.google.com with SMTP id d10so5500815lbj.28
        for <linux-media@vger.kernel.org>; Wed, 19 Jun 2013 23:18:11 -0700 (PDT)
Received: from glory.local ([2a02:2808:2801:30:200:f0ff:fe93:7229])
        by mx.google.com with ESMTPSA id t15sm10010148lbh.16.2013.06.19.23.18.09
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Wed, 19 Jun 2013 23:18:10 -0700 (PDT)
Date: Thu, 20 Jun 2013 16:18:07 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org
Subject: [uvcvideo] webcam+RK3066+3.0.8
Message-ID: <20130620161807.577dde05@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/NU7VOG5oGk8dC8r4q9Et_rR"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/NU7VOG5oGk8dC8r4q9Et_rR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello

Last year some chines factory release TV Android stick based on RK3066 dual-core ARM CPU (1-1.5GHz per core)
Some people burn up 3.0.8 linux kernel and debian/ubuntu on it.

We want use it for OpenCV image recognition. 
Debian wheezy armhv works well. Kernel is

Linux arm 3.0.8+ #26 SMP PREEMPT Mon Mar 18 11:30:34 MSK 2013 armv7l GNU/Linux

Kernel detect webcam, make /dev/video0 but view windows showed only green image no video.

ii  mplayer2                              2.0-554-gf63dbad-1+b1              armhf        next generation movie player for Unix-like systems
ii  smplayer                              0.8.0-1                            armhf        complete front-end for MPlayer and MPlayer2
ii  smplayer-themes                       0.1.20+dfsg-1                      all          complete front-end for MPlayer - icon themes
ii  smplayer-translations                 0.8.0-1                            all          complete front-end for MPlayer and MPlayer2 - translation files

Anyone can help for detect a problem?

Attache dmesg with debug and lsusb -v for webcam.

In my linux main system (Debian wheezy, kernel 3.2) this webcam works well.

With my best regards, Dmitry.

--MP_/NU7VOG5oGk8dC8r4q9Et_rR
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.log

[DHD] 
[   14.116327] Dongle Host Driver, version 5.90.125.69
[   14.695966] warning: process `colord-sane' used the deprecated sysctl system call with 8.1.2.
[   15.113532] rk30_lcdc_blank>>>>>0
[   16.201553] wl_bss_connect_done succeeded status=(0x9)
[   16.240345] wl_bss_connect_done succeeded status=(0x11)
[   27.459786] eth1: no IPv6 routers present
[  797.838693] rk30_lcdc_blank>>>>>0
[  797.838715] rk30_lcdc_blank>>>>>1
[  797.838729] rk30_lcdc_blank>>>>>4
[  804.035348] rk30-hdmi rk30-hdmi: PLAY_BACK
[  806.245353] rk30-hdmi rk30-hdmi: PLAY_BACK
[  807.555349] rk30-hdmi rk30-hdmi: PLAY_BACK
[  809.765491] rk30-hdmi rk30-hdmi: PLAY_BACK
[  811.075440] rk30-hdmi rk30-hdmi: PLAY_BACK
[  813.316342] rk30-hdmi rk30-hdmi: PLAY_BACK
[  814.616349] rk30-hdmi rk30-hdmi: PLAY_BACK
[  816.826343] rk30-hdmi rk30-hdmi: PLAY_BACK
[ 5127.086644] rk30_lcdc_blank>>>>>0
[ 5127.086677] rk30_lcdc_blank>>>>>0
[ 5140.091329] rk30_lcdc_blank>>>>>0
[ 5140.095667] rk30_lcdc_blank>>>>>0
[ 5359.908588] usb 1-1: USB disconnect, device number 2
[ 5364.508686] usb 1-1: new high speed USB device number 3 using usb20_otg
[ 5364.920160] hub 1-1:1.0: USB hub found
[ 5364.920309] hub 1-1:1.0: 4 ports detected
[ 5371.274334] usb 1-1.4: new low speed USB device number 4 using usb20_otg
[ 5371.403953] input: Plus More Enterprise LTD. USB-compliant keyboard as /devices/platform/usb20_otg/usb1/1-1/1-1.4/1-1.4:1.0/input/input5
[ 5371.404752] generic-usb 0003:0518:0001.0004: input,hidraw0: USB HID v1.10 Keyboard [Plus More Enterprise LTD. USB-compliant keyboard] on usb-usb20_otg-1.4/input0
[ 5371.409596] input: Plus More Enterprise LTD. USB-compliant keyboard as /devices/platform/usb20_otg/usb1/1-1/1-1.4/1-1.4:1.1/input/input6
[ 5371.410655] generic-usb 0003:0518:0001.0005: input,hidraw1: USB HID v1.10 Mouse [Plus More Enterprise LTD. USB-compliant keyboard] on usb-usb20_otg-1.4/input1
[ 5447.181535] usb 1-1.3: new high speed USB device number 5 using usb20_otg
[ 5447.433960] media: Linux media interface: v0.10
[ 5447.456456] Linux video capture interface: v2.00
[ 5447.456478] WARNING: You are using an experimental version of the media stack.
[ 5447.456485] 	As the driver is backported to an older kernel, it doesn't offer
[ 5447.456491] 	enough quality for its usage in production.
[ 5447.456496] 	Use it with care.
[ 5447.456499] Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
[ 5447.456506] 	4ca286610f664acf3153634f3930acd2de993a9f [media] radio-rtrack2: fix mute bug
[ 5447.456513] 	8b21eb17e749c9693eaea065f0eb95365006495c [media] radio-isa: fix querycap capabilities code
[ 5447.456520] 	c93396e13576928a073154b5715761ff8a998368 [media] gspca: Remove gspca-specific debug magic
[ 5447.482962] uvcvideo: Found UVC 1.00 device A4 TECH USB2.0 PC Camera J (0ac8:c40a)
[ 5447.486366] input: A4 TECH USB2.0 PC Camera J as /devices/platform/usb20_otg/usb1/1-1/1-1.3/1-1.3:1.0/input/input7
[ 5447.488956] usbcore: registered new interface driver uvcvideo
[ 5447.488969] USB Video Class driver (1.1.1)
[ 5561.567182] uvcvideo: Failed to query (SET_CUR) UVC control 2 on unit 2: -32 (exp. 2).
[ 5561.568048] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5561.568670] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5647.064322] uvcvideo: Failed to query (SET_CUR) UVC control 2 on unit 2: -32 (exp. 2).
[ 5647.065064] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5647.065561] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5685.958007] rk30_lcdc_blank>>>>>0
[ 5687.468845] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.482833] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.484720] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.499316] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.501178] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.513943] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.528438] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.537669] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.545669] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.553669] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.561669] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.569789] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.612806] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.625680] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.639433] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.653807] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.667059] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.680694] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.694308] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.708180] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.709177] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.724803] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.780678] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.793807] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.806559] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.817123] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.826045] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.834297] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.884418] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.908823] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.932808] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.945695] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.959434] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.973187] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5687.985815] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5688.009562] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5688.023312] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5688.037066] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 5689.164812] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.178194] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.192201] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.206443] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.220697] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.221812] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.235070] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.237068] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.251205] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.253064] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.266446] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.280323] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.294566] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.308695] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.309942] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.324191] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.325442] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.338696] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.352692] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.366821] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.380444] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.412817] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.428554] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.438184] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.447810] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.456676] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.464803] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.472803] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.480929] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.489802] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.497799] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.505930] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.516308] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.532428] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.620430] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.628552] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5689.641324] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 5690.916814] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.930566] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.932811] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.945326] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.956949] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.970690] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.972809] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5690.985947] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.000767] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.014922] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.023177] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.031053] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.039174] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.047049] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.055175] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.063175] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.071051] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.077316] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.085678] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.093808] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.100684] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.148423] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.164695] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.180306] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.188301] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.196301] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.204309] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.220425] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.221426] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.229802] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.238174] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.252426] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.412212] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.413549] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.414549] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.415545] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.416543] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.417544] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.418543] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.419689] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.420925] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.421925] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.422917] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.423794] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.424670] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.425668] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.433932] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.442547] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.451174] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.452670] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.460422] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.468301] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.476304] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.484301] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5691.623302] uvcvideo: Failed to query (SET_CUR) UVC control 6 on unit 2: -32 (exp. 2).
[ 5692.502062] rk30_lcdc_blank>>>>>0
[ 5692.564443] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.574877] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.590451] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.603330] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.604820] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.618202] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.633205] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.647875] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.662951] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.677457] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.692014] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.693323] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.707075] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.709070] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.722701] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.736827] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.748952] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.762570] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.775334] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.789094] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.802830] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.816197] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.825055] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.833684] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.841316] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.849086] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.857181] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.865312] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.873314] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.881435] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.889435] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.897805] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.905934] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.914689] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.924435] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.932312] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.940316] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.948307] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.956310] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5692.964310] uvcvideo: Failed to query (SET_CUR) UVC control 9 on unit 2: -32 (exp. 2).
[ 5698.005802] rk30_lcdc_blank>>>>>0
[ 5703.840389] rk30_lcdc_blank>>>>>0
[ 5709.129334] rk30_lcdc_blank>>>>>0
[ 5714.341680] rk30_lcdc_blank>>>>>0
[ 5719.437925] rk30_lcdc_blank>>>>>0
[ 5724.468008] rk30_lcdc_blank>>>>>0
[ 5729.680690] rk30_lcdc_blank>>>>>0
[ 5734.794573] rk30_lcdc_blank>>>>>0
[ 5739.872564] rk30_lcdc_blank>>>>>0
[ 5742.888199] uvcvideo: Failed to query (SET_CUR) UVC control 8 on unit 2: -32 (exp. 2).
[ 5743.639196] uvcvideo: Failed to query (SET_CUR) UVC control 8 on unit 2: -32 (exp. 2).
[ 5744.039104] uvcvideo: Failed to query (SET_CUR) UVC control 8 on unit 2: -32 (exp. 2).
[ 5744.950548] rk30_lcdc_blank>>>>>0
[ 5747.860819] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.876827] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.892558] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.893681] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.911311] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.920555] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.929934] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.939313] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.940807] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.950181] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.959313] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.968558] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.977936] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.988431] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5747.997938] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.007183] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.015429] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.023428] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.031310] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.039931] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.047804] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.076310] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.236945] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.250696] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.252957] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.266572] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.268815] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.282450] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.296692] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5748.309958] uvcvideo: Failed to query (SET_CUR) UVC control 11 on unit 1: -32 (exp. 2).
[ 5750.964828] rk30_lcdc_blank>>>>>0
[ 6013.631915] rk30_lcdc_blank>>>>>1
[ 6014.196327] rk30_lcdc_blank>>>>>0
[ 6074.008244] rk30_lcdc_blank>>>>>1
[ 6074.701904] rk30_lcdc_blank>>>>>0
[ 6078.324917] rk30_lcdc_blank>>>>>1
[ 6079.169381] rk30_lcdc_blank>>>>>0
[ 6085.558269] rk30_lcdc_blank>>>>>1
[ 6086.446431] rk30_lcdc_blank>>>>>0
[ 6091.774975] rk30_lcdc_blank>>>>>1
[ 6092.301667] rk30_lcdc_blank>>>>>0
[ 6094.318503] rk30_lcdc_blank>>>>>0
[ 6097.374938] rk30_lcdc_blank>>>>>1
[ 6097.911765] rk30_lcdc_blank>>>>>0
[ 6100.306886] rk30_lcdc_blank>>>>>0
[ 6104.324950] rk30_lcdc_blank>>>>>1
[ 6105.064215] rk30_lcdc_blank>>>>>0
[ 6106.424197] rk30_lcdc_blank>>>>>0
[ 6108.858274] rk30_lcdc_blank>>>>>1
[ 6109.457006] rk30_lcdc_blank>>>>>0
[ 6110.886867] rk30_lcdc_blank>>>>>0
[ 6154.463913] no layer of lcdc1 is used,go to standby!
[ 6154.463923] lcdc1 win1 closed
[ 6154.494819] wait for new frame start time out!
[ 6154.494840] lcdc1 wakeup from stanby
[ 6154.494853] lcdc1 win1 open
[ 6154.498837] rk30_lcdc_blank>>>>>1
[ 6154.513952] lcdc1 win0 open
[ 6154.528232] rk30_lcdc_blank>>>>>0
[ 6154.528251] lcdc1 win0 closed
[ 6154.599135] lcdc1 win0 open
[ 6155.243807] rk30_lcdc_blank>>>>>0
[ 6172.535898] rk30_lcdc_blank>>>>>0
[ 6172.536795] rk30_lcdc_blank>>>>>0
[ 6298.894907] lcdc1 win0 closed
[ 6331.368172] no layer of lcdc1 is used,go to standby!
[ 6331.368184] lcdc1 win1 closed
[ 6331.393032] wait for new frame start time out!
[ 6331.393059] lcdc1 wakeup from stanby
[ 6331.393075] lcdc1 win1 open
[ 6331.398700] rk30_lcdc_blank>>>>>1
[ 6331.411811] lcdc1 win0 open
[ 6331.411865] rk30_lcdc_blank>>>>>0
[ 6331.411883] lcdc1 win0 closed
[ 6331.481821] lcdc1 win0 open
[ 6332.071405] rk30_lcdc_blank>>>>>0
[ 6344.423789] rk30_lcdc_blank>>>>>0
[ 6344.424383] rk30_lcdc_blank>>>>>0
[ 6453.457284] rk30_lcdc_blank>>>>>0
[ 6497.959773] lcdc1 win0 closed
[ 6591.980691] rk30_lcdc_blank>>>>>1
[ 6591.993927] lcdc1 win0 open
[ 6592.009769] rk30_lcdc_blank>>>>>0
[ 6592.009784] lcdc1 win0 closed
[ 6592.064368] lcdc1 win0 open
[ 6592.573859] rk30_lcdc_blank>>>>>0
[ 6597.056915] rk30_lcdc_blank>>>>>1
[ 6597.060672] rk30_lcdc_blank>>>>>0
[ 6597.060685] lcdc1 win0 closed
[ 6597.113939] lcdc1 win0 open
[ 6597.738368] rk30_lcdc_blank>>>>>0
[ 6601.486694] rk30_lcdc_blank>>>>>1
[ 6601.494077] rk30_lcdc_blank>>>>>0
[ 6601.494092] lcdc1 win0 closed
[ 6601.547345] lcdc1 win0 open
[ 6602.172613] rk30_lcdc_blank>>>>>0
[ 6607.336209] rk30_lcdc_blank>>>>>1
[ 6607.344275] rk30_lcdc_blank>>>>>0
[ 6607.344291] lcdc1 win0 closed
[ 6607.398085] lcdc1 win0 open
[ 6607.933178] rk30_lcdc_blank>>>>>0
[ 6612.028032] rk30_lcdc_blank>>>>>1
[ 6612.044137] rk30_lcdc_blank>>>>>0
[ 6612.044152] lcdc1 win0 closed
[ 6612.097987] lcdc1 win0 open
[ 6612.661780] rk30_lcdc_blank>>>>>0
[ 6617.677930] rk30_lcdc_blank>>>>>1
[ 6617.694329] rk30_lcdc_blank>>>>>0
[ 6617.694353] lcdc1 win0 closed
[ 6617.747743] lcdc1 win0 open
[ 6618.284007] rk30_lcdc_blank>>>>>0
[ 6620.352403] rk30_lcdc_blank>>>>>0
[ 6624.743095] lcdc1 win0 closed
[ 6644.099630] rk30_lcdc_blank>>>>>1
[ 6644.665120] rk30_lcdc_blank>>>>>0
[ 6663.242552] rk30_lcdc_blank>>>>>0
[ 6663.243035] rk30_lcdc_blank>>>>>0
[ 6782.520937] rk30_lcdc_blank>>>>>1
[ 6783.024366] rk30_lcdc_blank>>>>>0
[ 6806.769058] no layer of lcdc1 is used,go to standby!
[ 6806.769067] lcdc1 win1 closed
[ 6806.796846] wait for new frame start time out!
[ 6806.796878] lcdc1 wakeup from stanby
[ 6806.796886] lcdc1 win1 open
[ 6806.800521] rk30_lcdc_blank>>>>>1
[ 6806.815596] lcdc1 win0 open
[ 6806.830268] rk30_lcdc_blank>>>>>0
[ 6806.830285] lcdc1 win0 closed
[ 6806.902461] lcdc1 win0 open
[ 6807.465699] rk30_lcdc_blank>>>>>0
[ 6829.143409] rk30_lcdc_blank>>>>>0
[ 6829.144018] rk30_lcdc_blank>>>>>0
[ 6919.901068] rk30_lcdc_blank>>>>>0
[ 6924.921408] rk30_lcdc_blank>>>>>0
[ 6929.927714] rk30_lcdc_blank>>>>>0
[ 6934.937066] rk30_lcdc_blank>>>>>0
[ 6939.950114] rk30_lcdc_blank>>>>>0
[ 6944.953542] rk30_lcdc_blank>>>>>0
[ 6952.234761] rk30_lcdc_blank>>>>>0
[ 6957.271448] rk30_lcdc_blank>>>>>0
[ 6962.279248] rk30_lcdc_blank>>>>>0
[ 6967.289677] rk30_lcdc_blank>>>>>0
[ 6972.309751] rk30_lcdc_blank>>>>>0
[ 6977.330302] rk30_lcdc_blank>>>>>0
[ 6982.345655] rk30_lcdc_blank>>>>>0
[ 6987.357819] rk30_lcdc_blank>>>>>0
[ 6992.379769] rk30_lcdc_blank>>>>>0
[ 6997.394422] rk30_lcdc_blank>>>>>0
[ 7002.411018] rk30_lcdc_blank>>>>>0
[ 7007.412448] rk30_lcdc_blank>>>>>0
[ 7012.414523] rk30_lcdc_blank>>>>>0
[ 7017.420475] rk30_lcdc_blank>>>>>0
[ 7022.451130] rk30_lcdc_blank>>>>>0
[ 7027.490288] rk30_lcdc_blank>>>>>0
[ 7032.514937] rk30_lcdc_blank>>>>>0
[ 7037.528577] rk30_lcdc_blank>>>>>0
[ 7042.553379] rk30_lcdc_blank>>>>>0
[ 7047.559909] rk30_lcdc_blank>>>>>0
[ 7052.583916] rk30_lcdc_blank>>>>>0
[ 7057.585165] rk30_lcdc_blank>>>>>0
[ 7062.596648] rk30_lcdc_blank>>>>>0
[ 7067.601319] rk30_lcdc_blank>>>>>0
[ 7072.621567] rk30_lcdc_blank>>>>>0
[ 7077.651215] rk30_lcdc_blank>>>>>0
[ 7082.667143] rk30_lcdc_blank>>>>>0
[ 7087.673599] rk30_lcdc_blank>>>>>0
[ 7092.684805] rk30_lcdc_blank>>>>>0
[ 7097.688987] rk30_lcdc_blank>>>>>0
[ 7102.703542] rk30_lcdc_blank>>>>>0
[ 7107.723297] rk30_lcdc_blank>>>>>0
[ 7112.724147] rk30_lcdc_blank>>>>>0
[ 7117.745760] rk30_lcdc_blank>>>>>0
[ 7122.764275] rk30_lcdc_blank>>>>>0
[ 7127.770072] rk30_lcdc_blank>>>>>0
[ 7132.776429] rk30_lcdc_blank>>>>>0
[ 7137.792824] rk30_lcdc_blank>>>>>0
[ 7142.808745] rk30_lcdc_blank>>>>>0
[ 7147.829784] rk30_lcdc_blank>>>>>0
[ 7152.850433] rk30_lcdc_blank>>>>>0
[ 7157.853256] rk30_lcdc_blank>>>>>0
[ 7162.863997] rk30_lcdc_blank>>>>>0
[ 7168.363960] rk30_lcdc_blank>>>>>0
[ 7283.420044] rk30_lcdc_blank>>>>>0
[ 7319.977463] uvcvideo: Failed to query (SET_CUR) UVC control 2 on unit 2: -32 (exp. 2).
[ 7319.978212] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[ 7319.978849] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[ 7466.975743] rk30-hdmi rk30-hdmi: PLAY_BACK
[ 7467.092545] rk30-hdmi rk30-hdmi: PLAY_BACK
[ 7467.242532] rk30-hdmi rk30-hdmi: PLAY_BACK
[90098.717292] rk30-hdmi rk30-hdmi: PLAY_BACK
[90099.030506] rk30-hdmi rk30-hdmi: PLAY_BACK
[90100.807483] rk30-hdmi rk30-hdmi: PLAY_BACK
[90101.027394] rk30-hdmi rk30-hdmi: PLAY_BACK
[90102.787463] rk30-hdmi rk30-hdmi: PLAY_BACK
[90143.630264] lcdc1 win0 closed
[90163.063230] rk30_lcdc_blank>>>>>1
[90163.567505] rk30_lcdc_blank>>>>>0
[90173.797150] rk30_lcdc_blank>>>>>0
[90173.797523] rk30_lcdc_blank>>>>>0
[90382.704492] uvcvideo: uvc_v4l2_open
[90382.704574] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCAP)
[90382.704597] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.704616] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_STD)
[90382.704631] uvcvideo: Unsupported ioctl 0x80085617
[90382.704641] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_PARM)
[90382.704922] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMSTD)
[90382.704940] uvcvideo: Unsupported ioctl 0xc0485619
[90382.705023] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
[90382.705108] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
[90382.705127] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_INPUT)
[90382.705235] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
[90382.705277] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUM_FMT)
[90382.705368] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.705387] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
[90382.705406] uvcvideo: Trying format 0x56595559 (YUYV): 640x480.
[90382.705419] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[90382.707479] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.707516] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
[90382.707535] uvcvideo: Trying format 0x32315659 (YV12): 640x480.
[90382.707547] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[90382.709563] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMINPUT)
[90382.709583] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_INPUT)
[90382.709601] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMSTD)
[90382.709624] uvcvideo: Unsupported ioctl 0xc0485619
[90382.710195] uvcvideo: uvc_v4l2_ioctl(VIDIOC_ENUMSTD)
[90382.710215] uvcvideo: Unsupported ioctl 0xc0485619
[90382.711082] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.711102] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
[90382.711126] uvcvideo: Trying format 0x56595559 (YUYV): 640x480.
[90382.711139] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[90382.713188] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.713208] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
[90382.713225] uvcvideo: Trying format 0x56595559 (YUYV): 640x480.
[90382.713242] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[90382.715315] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.715334] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_FMT)
[90382.715351] uvcvideo: Trying format 0x56595559 (YUYV): 640x480.
[90382.715371] uvcvideo: Using default frame interval 33333.3 us (30.0 fps).
[90382.719237] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.719262] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.719271] uvcvideo: uvc_v4l2_ioctl(VIDIOC_G_FMT)
[90382.719307] uvcvideo: uvc_v4l2_ioctl(VIDIOC_REQBUFS)
[90382.720058] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYBUF)
[90382.720187] uvcvideo: uvc_v4l2_mmap
[90382.720731] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
[90382.720750] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYBUF)
[90382.720768] uvcvideo: uvc_v4l2_mmap
[90382.721269] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
[90382.721283] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90382.721301] uvcvideo: Control 0x00980909 not found.
[90382.721415] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
[90382.721431] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90382.721677] uvcvideo: Failed to query (SET_CUR) UVC control 2 on unit 2: -32 (exp. 2).
[90382.721759] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
[90382.721775] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90382.722062] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
[90382.722073] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90382.722305] uvcvideo: Failed to query (SET_CUR) UVC control 7 on unit 2: -32 (exp. 2).
[90382.722388] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QUERYCTRL)
[90382.722403] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90382.722677] uvcvideo: Failed to query (SET_CUR) UVC control 3 on unit 2: -32 (exp. 2).
[90382.723487] uvcvideo: uvc_v4l2_ioctl(VIDIOC_STREAMON)
[90382.724202] uvcvideo: Device requested 2688 B/frame bandwidth.
[90382.724212] uvcvideo: Selecting alternate setting 6 (2688 B/frame bandwidth).
[90382.725572] uvcvideo: Allocated 5 URB buffers of 32x2688 bytes each.
[90382.725667] uvcvideo: uvc_v4l2_poll
[90383.283393] uvcvideo: Marking buffer as bad (error bit set).
[90383.283408] uvcvideo: Frame complete (EOF found).
[90383.283417] uvcvideo: EOF in empty payload.
[90383.283429] uvcvideo: Dropping payload (out of sync).
[90383.675437] uvcvideo: frame 1 stats: 0/2/33 packets, 0/0/33 pts (!early initial), 32/33 scr, last pts/stc/sof 1449123036/1449245108/1493
[90383.684123] uvcvideo: Marking buffer as bad (error bit set).
[90383.684136] uvcvideo: Frame complete (EOF found).
[90383.684145] uvcvideo: EOF in empty payload.
[90383.684156] uvcvideo: Dropping payload (out of sync).
[90383.726725] uvcvideo: uvc_v4l2_poll
[90383.726966] uvcvideo: uvc_v4l2_poll
[90384.076184] uvcvideo: frame 2 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1458725156/1458863180/1893
[90384.080369] uvcvideo: Marking buffer as bad (error bit set).
[90384.080381] uvcvideo: Frame complete (EOF found).
[90384.080389] uvcvideo: EOF in empty payload.
[90384.080401] uvcvideo: Dropping payload (out of sync).
[90384.476434] uvcvideo: frame 3 stats: 0/2/11 packets, 0/0/11 pts (!early initial), 10/11 scr, last pts/stc/sof 1468327276/1468373251/242
[90384.480619] uvcvideo: Marking buffer as bad (error bit set).
[90384.480631] uvcvideo: Frame complete (EOF found).
[90384.480639] uvcvideo: EOF in empty payload.
[90384.480650] uvcvideo: Dropping payload (out of sync).
[90384.576666] uvcvideo: frame 4 stats: 0/2/12 packets, 0/0/12 pts (!early initial), 11/12 scr, last pts/stc/sof 1477929396/1477979323/642
[90384.580867] uvcvideo: Marking buffer as bad (error bit set).
[90384.580879] uvcvideo: Frame complete (EOF found).
[90384.580887] uvcvideo: EOF in empty payload.
[90384.580899] uvcvideo: Dropping payload (out of sync).
[90384.660933] uvcvideo: frame 5 stats: 0/2/13 packets, 0/0/13 pts (!early initial), 12/13 scr, last pts/stc/sof 1480331496/1480385341/742
[90384.665241] uvcvideo: Marking buffer as bad (error bit set).
[90384.665253] uvcvideo: Frame complete (EOF found).
[90384.665261] uvcvideo: EOF in empty payload.
[90384.665274] uvcvideo: Dropping payload (out of sync).
[90384.728019] uvcvideo: uvc_v4l2_poll
[90384.728123] uvcvideo: uvc_v4l2_poll
[90384.729305] uvcvideo: frame 6 stats: 0/2/20 packets, 0/0/20 pts (!early initial), 19/20 scr, last pts/stc/sof 1482333246/1482410356/827
[90384.733872] uvcvideo: Marking buffer as bad (error bit set).
[90384.733884] uvcvideo: Frame complete (EOF found).
[90384.733892] uvcvideo: EOF in empty payload.
[90384.733904] uvcvideo: Dropping payload (out of sync).
[90384.793934] uvcvideo: frame 7 stats: 0/2/33 packets, 0/0/33 pts (!early initial), 32/33 scr, last pts/stc/sof 1483934646/1484057368/895
[90384.798243] uvcvideo: Marking buffer as bad (error bit set).
[90384.798255] uvcvideo: Frame complete (EOF found).
[90384.798263] uvcvideo: EOF in empty payload.
[90384.798276] uvcvideo: Dropping payload (out of sync).
[90384.862289] uvcvideo: frame 8 stats: 0/2/17 packets, 0/0/17 pts (!early initial), 16/17 scr, last pts/stc/sof 1485536046/1485602380/960
[90384.866870] uvcvideo: Marking buffer as bad (error bit set).
[90384.866882] uvcvideo: Frame complete (EOF found).
[90384.866890] uvcvideo: EOF in empty payload.
[90384.866901] uvcvideo: Dropping payload (out of sync).
[90384.926914] uvcvideo: frame 9 stats: 0/2/30 packets, 0/0/30 pts (!early initial), 29/30 scr, last pts/stc/sof 1487137446/1487249392/1028
[90384.931117] uvcvideo: Marking buffer as bad (error bit set).
[90384.931128] uvcvideo: Frame complete (EOF found).
[90384.931137] uvcvideo: EOF in empty payload.
[90384.931148] uvcvideo: Dropping payload (out of sync).
[90384.995181] uvcvideo: frame 10 stats: 0/2/13 packets, 0/0/13 pts (!early initial), 12/13 scr, last pts/stc/sof 1488738846/1488791404/1092
[90384.999619] uvcvideo: Marking buffer as bad (error bit set).
[90384.999631] uvcvideo: Frame complete (EOF found).
[90384.999640] uvcvideo: EOF in empty payload.
[90384.999651] uvcvideo: Dropping payload (out of sync).
[90385.059685] uvcvideo: frame 11 stats: 0/2/25 packets, 0/0/25 pts (!early initial), 24/25 scr, last pts/stc/sof 1490340246/1490435416/1161
[90385.068370] uvcvideo: Marking buffer as bad (error bit set).
[90385.068382] uvcvideo: Frame complete (EOF found).
[90385.068390] uvcvideo: EOF in empty payload.
[90385.068402] uvcvideo: Dropping payload (out of sync).
[90385.128433] uvcvideo: frame 12 stats: 0/2/39 packets, 0/0/39 pts (!early initial), 38/39 scr, last pts/stc/sof 1491941646/1492085429/1230
[90385.132869] uvcvideo: Marking buffer as bad (error bit set).
[90385.132881] uvcvideo: Frame complete (EOF found).
[90385.132889] uvcvideo: EOF in empty payload.
[90385.132901] uvcvideo: Dropping payload (out of sync).
[90385.192934] uvcvideo: frame 13 stats: 0/2/24 packets, 0/0/24 pts (!early initial), 23/24 scr, last pts/stc/sof 1493543046/1493633440/1294
[90385.201620] uvcvideo: Marking buffer as bad (error bit set).
[90385.201632] uvcvideo: Frame complete (EOF found).
[90385.201641] uvcvideo: EOF in empty payload.
[90385.201656] uvcvideo: Dropping payload (out of sync).
[90385.261684] uvcvideo: frame 14 stats: 0/2/38 packets, 0/0/38 pts (!early initial), 37/38 scr, last pts/stc/sof 1495144446/1495283453/1363
[90385.266118] uvcvideo: Marking buffer as bad (error bit set).
[90385.266129] uvcvideo: Frame complete (EOF found).
[90385.266138] uvcvideo: EOF in empty payload.
[90385.266149] uvcvideo: Dropping payload (out of sync).
[90385.326182] uvcvideo: frame 15 stats: 0/2/22 packets, 0/0/22 pts (!early initial), 21/22 scr, last pts/stc/sof 1496745846/1496831464/1427
[90385.334869] uvcvideo: Marking buffer as bad (error bit set).
[90385.334881] uvcvideo: Frame complete (EOF found).
[90385.334890] uvcvideo: EOF in empty payload.
[90385.334901] uvcvideo: Dropping payload (out of sync).
[90385.394931] uvcvideo: frame 16 stats: 0/2/36 packets, 0/0/36 pts (!early initial), 35/36 scr, last pts/stc/sof 1498347246/1498481477/1496
[90385.399243] uvcvideo: Marking buffer as bad (error bit set).
[90385.399255] uvcvideo: Frame complete (EOF found).
[90385.399263] uvcvideo: EOF in empty payload.
[90385.399277] uvcvideo: Dropping payload (out of sync).
[90385.463305] uvcvideo: frame 17 stats: 0/2/20 packets, 0/0/20 pts (!early initial), 19/20 scr, last pts/stc/sof 1499948646/1500026488/1561
[90385.467876] uvcvideo: Marking buffer as bad (error bit set).
[90385.467889] uvcvideo: Frame complete (EOF found).
[90385.467897] uvcvideo: EOF in empty payload.
[90385.467908] uvcvideo: Dropping payload (out of sync).
[90385.527934] uvcvideo: frame 18 stats: 0/2/34 packets, 0/0/34 pts (!early initial), 33/34 scr, last pts/stc/sof 1501550046/1501673500/1629
[90385.532242] uvcvideo: Marking buffer as bad (error bit set).
[90385.532253] uvcvideo: Frame complete (EOF found).
[90385.532262] uvcvideo: EOF in empty payload.
[90385.532275] uvcvideo: Dropping payload (out of sync).
[90385.596310] uvcvideo: frame 19 stats: 0/2/17 packets, 0/0/17 pts (!early initial), 16/17 scr, last pts/stc/sof 1503151446/1503218512/1694
[90385.600871] uvcvideo: Marking buffer as bad (error bit set).
[90385.600884] uvcvideo: Frame complete (EOF found).
[90385.600893] uvcvideo: EOF in empty payload.
[90385.600904] uvcvideo: Dropping payload (out of sync).
[90385.660932] uvcvideo: frame 20 stats: 0/2/30 packets, 0/0/30 pts (!early initial), 29/30 scr, last pts/stc/sof 1504752846/1504865524/1762
[90385.665118] uvcvideo: Marking buffer as bad (error bit set).
[90385.665129] uvcvideo: Frame complete (EOF found).
[90385.665138] uvcvideo: EOF in empty payload.
[90385.665149] uvcvideo: Dropping payload (out of sync).
[90385.729167] uvcvideo: frame 21 stats: 0/2/13 packets, 0/0/13 pts (!early initial), 12/13 scr, last pts/stc/sof 1506354246/1506407536/1826
[90385.729180] uvcvideo: uvc_v4l2_poll
[90385.729284] uvcvideo: uvc_v4l2_poll
[90385.733748] uvcvideo: Marking buffer as bad (error bit set).
[90385.733760] uvcvideo: Frame complete (EOF found).
[90385.733769] uvcvideo: EOF in empty payload.
[90385.733780] uvcvideo: Dropping payload (out of sync).
[90385.793808] uvcvideo: frame 22 stats: 0/2/25 packets, 0/0/25 pts (!early initial), 24/25 scr, last pts/stc/sof 1507955646/1508054548/1895
[90385.802495] uvcvideo: Marking buffer as bad (error bit set).
[90385.802507] uvcvideo: Frame complete (EOF found).
[90385.802515] uvcvideo: EOF in empty payload.
[90385.802527] uvcvideo: Dropping payload (out of sync).
[90385.862556] uvcvideo: frame 23 stats: 0/2/41 packets, 0/0/41 pts (!early initial), 40/41 scr, last pts/stc/sof 1509557046/1509704561/1964
[90385.866994] uvcvideo: Marking buffer as bad (error bit set).
[90385.867007] uvcvideo: Frame complete (EOF found).
[90385.867015] uvcvideo: EOF in empty payload.
[90385.867027] uvcvideo: Dropping payload (out of sync).
[90385.927056] uvcvideo: frame 24 stats: 0/2/25 packets, 0/0/25 pts (!early initial), 24/25 scr, last pts/stc/sof 1511158446/1511252572/2028
[90385.935747] uvcvideo: Marking buffer as bad (error bit set).
[90385.935759] uvcvideo: Frame complete (EOF found).
[90385.935767] uvcvideo: EOF in empty payload.
[90385.935778] uvcvideo: Dropping payload (out of sync).
[90385.995793] uvcvideo: frame 25 stats: 0/2/39 packets, 0/0/39 pts (!early initial), 38/39 scr, last pts/stc/sof 1512759846/1512902585/49
[90386.000242] uvcvideo: Marking buffer as bad (error bit set).
[90386.000253] uvcvideo: Frame complete (EOF found).
[90386.000262] uvcvideo: EOF in empty payload.
[90386.000275] uvcvideo: Dropping payload (out of sync).
[90386.060293] uvcvideo: frame 26 stats: 0/2/23 packets, 0/0/23 pts (!early initial), 22/23 scr, last pts/stc/sof 1514361246/1514450596/114
[90386.068999] uvcvideo: Marking buffer as bad (error bit set).
[90386.069013] uvcvideo: Frame complete (EOF found).
[90386.069022] uvcvideo: EOF in empty payload.
[90386.069033] uvcvideo: Dropping payload (out of sync).
[90386.129059] uvcvideo: frame 27 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1515962646/1516100608/182
[90386.133498] uvcvideo: Marking buffer as bad (error bit set).
[90386.133509] uvcvideo: Frame complete (EOF found).
[90386.133518] uvcvideo: EOF in empty payload.
[90386.133529] uvcvideo: Dropping payload (out of sync).
[90386.193559] uvcvideo: frame 28 stats: 0/2/22 packets, 0/0/22 pts (!early initial), 21/22 scr, last pts/stc/sof 1517564046/1517648620/247
[90386.202243] uvcvideo: Marking buffer as bad (error bit set).
[90386.202255] uvcvideo: Frame complete (EOF found).
[90386.202264] uvcvideo: EOF in empty payload.
[90386.202278] uvcvideo: Dropping payload (out of sync).
[90386.262290] uvcvideo: frame 29 stats: 0/2/36 packets, 0/0/36 pts (!early initial), 35/36 scr, last pts/stc/sof 1519165446/1519298632/316
[90386.266621] uvcvideo: Marking buffer as bad (error bit set).
[90386.266634] uvcvideo: Frame complete (EOF found).
[90386.266642] uvcvideo: EOF in empty payload.
[90386.266653] uvcvideo: Dropping payload (out of sync).
[90386.330683] uvcvideo: frame 30 stats: 0/2/20 packets, 0/0/20 pts (!early initial), 19/20 scr, last pts/stc/sof 1520766846/1520843644/380
[90386.335248] uvcvideo: Marking buffer as bad (error bit set).
[90386.335261] uvcvideo: Frame complete (EOF found).
[90386.335270] uvcvideo: EOF in empty payload.
[90386.335284] uvcvideo: Dropping payload (out of sync).
[90386.395439] uvcvideo: frame 31 stats: 0/2/33 packets, 0/0/33 pts (!early initial), 32/33 scr, last pts/stc/sof 1522368246/1522490656/449
[90386.399751] uvcvideo: Marking buffer as bad (error bit set).
[90386.399764] uvcvideo: Frame complete (EOF found).
[90386.399772] uvcvideo: EOF in empty payload.
[90386.399784] uvcvideo: Dropping payload (out of sync).
[90386.463807] uvcvideo: frame 32 stats: 0/2/16 packets, 0/0/16 pts (!early initial), 15/16 scr, last pts/stc/sof 1523969646/1524038668/513
[90386.468374] uvcvideo: Marking buffer as bad (error bit set).
[90386.468387] uvcvideo: Frame complete (EOF found).
[90386.468396] uvcvideo: EOF in empty payload.
[90386.468407] uvcvideo: Dropping payload (out of sync).
[90386.528433] uvcvideo: frame 33 stats: 0/2/31 packets, 0/0/31 pts (!early initial), 30/31 scr, last pts/stc/sof 1525571046/1525685680/582
[90386.532622] uvcvideo: Marking buffer as bad (error bit set).
[90386.532635] uvcvideo: Frame complete (EOF found).
[90386.532643] uvcvideo: EOF in empty payload.
[90386.532656] uvcvideo: Dropping payload (out of sync).
[90386.596680] uvcvideo: frame 34 stats: 0/2/14 packets, 0/0/14 pts (!early initial), 13/14 scr, last pts/stc/sof 1527172446/1527227692/646
[90386.601118] uvcvideo: Marking buffer as bad (error bit set).
[90386.601131] uvcvideo: Frame complete (EOF found).
[90386.601139] uvcvideo: EOF in empty payload.
[90386.601151] uvcvideo: Dropping payload (out of sync).
[90386.661168] uvcvideo: frame 35 stats: 0/2/26 packets, 0/0/26 pts (!early initial), 25/26 scr, last pts/stc/sof 1528773846/1528871704/714
[90386.669878] uvcvideo: Marking buffer as bad (error bit set).
[90386.669891] uvcvideo: Frame complete (EOF found).
[90386.669900] uvcvideo: EOF in empty payload.
[90386.669911] uvcvideo: Dropping payload (out of sync).
[90386.729933] uvcvideo: frame 36 stats: 0/2/40 packets, 0/0/40 pts (!early initial), 39/40 scr, last pts/stc/sof 1530375246/1530521717/783
[90386.730343] uvcvideo: uvc_v4l2_poll
[90386.730455] uvcvideo: uvc_v4l2_poll
[90386.734374] uvcvideo: Marking buffer as bad (error bit set).
[90386.734388] uvcvideo: Frame complete (EOF found).
[90386.734397] uvcvideo: EOF in empty payload.
[90386.734408] uvcvideo: Dropping payload (out of sync).
[90386.794424] uvcvideo: frame 37 stats: 0/2/24 packets, 0/0/24 pts (!early initial), 23/24 scr, last pts/stc/sof 1531976646/1532069728/848
[90386.803122] uvcvideo: Marking buffer as bad (error bit set).
[90386.803130] uvcvideo: Frame complete (EOF found).
[90386.803135] uvcvideo: EOF in empty payload.
[90386.803142] uvcvideo: Dropping payload (out of sync).
[90386.863169] uvcvideo: frame 38 stats: 0/2/39 packets, 0/0/39 pts (!early initial), 38/39 scr, last pts/stc/sof 1533578046/1533719740/916
[90386.867632] uvcvideo: Marking buffer as bad (error bit set).
[90386.867646] uvcvideo: Frame complete (EOF found).
[90386.867654] uvcvideo: EOF in empty payload.
[90386.867665] uvcvideo: Dropping payload (out of sync).
[90386.927685] uvcvideo: frame 39 stats: 0/2/23 packets, 0/0/23 pts (!early initial), 22/23 scr, last pts/stc/sof 1535179446/1535267752/981
[90386.936626] uvcvideo: Marking buffer as bad (error bit set).
[90386.936640] uvcvideo: Frame complete (EOF found).
[90386.936648] uvcvideo: EOF in empty payload.
[90386.936659] uvcvideo: Dropping payload (out of sync).
[90386.996665] uvcvideo: frame 40 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1536780846/1536923764/1050
[90387.000997] uvcvideo: Marking buffer as bad (error bit set).
[90387.001010] uvcvideo: Frame complete (EOF found).
[90387.001018] uvcvideo: EOF in empty payload.
[90387.001029] uvcvideo: Dropping payload (out of sync).
[90387.061056] uvcvideo: frame 41 stats: 0/2/23 packets, 0/0/23 pts (!early initial), 22/23 scr, last pts/stc/sof 1538382246/1538468776/1114
[90387.069748] uvcvideo: Marking buffer as bad (error bit set).
[90387.069759] uvcvideo: Frame complete (EOF found).
[90387.069768] uvcvideo: EOF in empty payload.
[90387.069779] uvcvideo: Dropping payload (out of sync).
[90387.129790] uvcvideo: frame 42 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1539983646/1540118788/1183
[90387.134120] uvcvideo: Marking buffer as bad (error bit set).
[90387.134133] uvcvideo: Frame complete (EOF found).
[90387.134141] uvcvideo: EOF in empty payload.
[90387.134153] uvcvideo: Dropping payload (out of sync).
[90387.198182] uvcvideo: frame 43 stats: 0/2/21 packets, 0/0/21 pts (!early initial), 20/21 scr, last pts/stc/sof 1541585046/1541663800/1247
[90387.202875] uvcvideo: Marking buffer as bad (error bit set).
[90387.202888] uvcvideo: Frame complete (EOF found).
[90387.202897] uvcvideo: EOF in empty payload.
[90387.202908] uvcvideo: Dropping payload (out of sync).
[90387.262915] uvcvideo: frame 44 stats: 0/2/34 packets, 0/0/34 pts (!early initial), 33/34 scr, last pts/stc/sof 1543186446/1543313812/1316
[90387.267246] uvcvideo: Marking buffer as bad (error bit set).
[90387.267257] uvcvideo: Frame complete (EOF found).
[90387.267266] uvcvideo: EOF in empty payload.
[90387.267279] uvcvideo: Dropping payload (out of sync).
[90387.331307] uvcvideo: frame 45 stats: 0/2/18 packets, 0/0/18 pts (!early initial), 17/18 scr, last pts/stc/sof 1544787846/1544858824/1381
[90387.335873] uvcvideo: Marking buffer as bad (error bit set).
[90387.335885] uvcvideo: Frame complete (EOF found).
[90387.335894] uvcvideo: EOF in empty payload.
[90387.335905] uvcvideo: Dropping payload (out of sync).
[90387.395915] uvcvideo: frame 46 stats: 0/2/31 packets, 0/0/31 pts (!early initial), 30/31 scr, last pts/stc/sof 1546389246/1546505836/1449
[90387.400117] uvcvideo: Marking buffer as bad (error bit set).
[90387.400129] uvcvideo: Frame complete (EOF found).
[90387.400137] uvcvideo: EOF in empty payload.
[90387.400148] uvcvideo: Dropping payload (out of sync).
[90387.464180] uvcvideo: frame 47 stats: 0/2/15 packets, 0/0/15 pts (!early initial), 14/15 scr, last pts/stc/sof 1547990646/1548047848/1513
[90387.468620] uvcvideo: Marking buffer as bad (error bit set).
[90387.468632] uvcvideo: Frame complete (EOF found).
[90387.468640] uvcvideo: EOF in empty payload.
[90387.468652] uvcvideo: Dropping payload (out of sync).
[90387.528685] uvcvideo: frame 48 stats: 0/2/27 packets, 0/0/27 pts (!early initial), 26/27 scr, last pts/stc/sof 1549592046/1549691860/1582
[90387.537371] uvcvideo: Marking buffer as bad (error bit set).
[90387.537384] uvcvideo: Frame complete (EOF found).
[90387.537393] uvcvideo: EOF in empty payload.
[90387.537405] uvcvideo: Dropping payload (out of sync).
[90387.597683] uvcvideo: frame 49 stats: 0/2/41 packets, 0/0/41 pts (!early initial), 40/41 scr, last pts/stc/sof 1551193446/1551341872/1651
[90387.602115] uvcvideo: Marking buffer as bad (error bit set).
[90387.602125] uvcvideo: Frame complete (EOF found).
[90387.602132] uvcvideo: EOF in empty payload.
[90387.602142] uvcvideo: Dropping payload (out of sync).
[90387.662166] uvcvideo: frame 50 stats: 0/2/27 packets, 0/0/27 pts (!early initial), 26/27 scr, last pts/stc/sof 1552794846/1552895884/1715
[90387.670873] uvcvideo: Marking buffer as bad (error bit set).
[90387.670886] uvcvideo: Frame complete (EOF found).
[90387.670894] uvcvideo: EOF in empty payload.
[90387.670905] uvcvideo: Dropping payload (out of sync).
[90387.730934] uvcvideo: frame 51 stats: 0/2/41 packets, 0/0/41 pts (!early initial), 40/41 scr, last pts/stc/sof 1554396246/1554545897/1784
[90387.731514] uvcvideo: uvc_v4l2_poll
[90387.731621] uvcvideo: uvc_v4l2_poll
[90387.735371] uvcvideo: Marking buffer as bad (error bit set).
[90387.735383] uvcvideo: Frame complete (EOF found).
[90387.735391] uvcvideo: EOF in empty payload.
[90387.735402] uvcvideo: Dropping payload (out of sync).
[90387.795432] uvcvideo: frame 52 stats: 0/2/26 packets, 0/0/26 pts (!early initial), 25/26 scr, last pts/stc/sof 1555997646/1556093908/1849
[90387.804122] uvcvideo: Marking buffer as bad (error bit set).
[90387.804134] uvcvideo: Frame complete (EOF found).
[90387.804142] uvcvideo: EOF in empty payload.
[90387.804151] uvcvideo: Dropping payload (out of sync).
[90387.864161] uvcvideo: frame 53 stats: 0/2/40 packets, 0/0/40 pts (!early initial), 39/40 scr, last pts/stc/sof 1557599046/1557743920/1917
[90387.868499] uvcvideo: Marking buffer as bad (error bit set).
[90387.868512] uvcvideo: Frame complete (EOF found).
[90387.868520] uvcvideo: EOF in empty payload.
[90387.868532] uvcvideo: Dropping payload (out of sync).
[90387.928557] uvcvideo: frame 54 stats: 0/2/24 packets, 0/0/24 pts (!early initial), 23/24 scr, last pts/stc/sof 1559200446/1559288932/1982
[90387.937246] uvcvideo: Marking buffer as bad (error bit set).
[90387.937260] uvcvideo: Frame complete (EOF found).
[90387.937268] uvcvideo: EOF in empty payload.
[90387.937282] uvcvideo: Dropping payload (out of sync).
[90387.997288] uvcvideo: frame 55 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1560801846/1560938944/3
[90388.001619] uvcvideo: Marking buffer as bad (error bit set).
[90388.001630] uvcvideo: Frame complete (EOF found).
[90388.001639] uvcvideo: EOF in empty payload.
[90388.001651] uvcvideo: Dropping payload (out of sync).
[90388.061651] uvcvideo: frame 56 stats: 0/2/21 packets, 0/0/21 pts (!early initial), 20/21 scr, last pts/stc/sof 1562403246/1562483956/67
[90388.070247] uvcvideo: Marking buffer as bad (error bit set).
[90388.070260] uvcvideo: Frame complete (EOF found).
[90388.070268] uvcvideo: EOF in empty payload.
[90388.070282] uvcvideo: Dropping payload (out of sync).
[90388.130290] uvcvideo: frame 57 stats: 0/2/35 packets, 0/0/35 pts (!early initial), 34/35 scr, last pts/stc/sof 1564004646/1564130968/136
[90388.134620] uvcvideo: Marking buffer as bad (error bit set).
[90388.134631] uvcvideo: Frame complete (EOF found).
[90388.134640] uvcvideo: EOF in empty payload.
[90388.134651] uvcvideo: Dropping payload (out of sync).
[90388.198667] uvcvideo: frame 58 stats: 0/2/18 packets, 0/0/18 pts (!early initial), 17/18 scr, last pts/stc/sof 1565606046/1565675980/200
[90388.203247] uvcvideo: Marking buffer as bad (error bit set).
[90388.203259] uvcvideo: Frame complete (EOF found).
[90388.203268] uvcvideo: EOF in empty payload.
[90388.203281] uvcvideo: Dropping payload (out of sync).
[90388.263312] uvcvideo: frame 59 stats: 0/2/31 packets, 0/0/31 pts (!early initial), 30/31 scr, last pts/stc/sof 1567207446/1567322992/269
[90388.267504] uvcvideo: Marking buffer as bad (error bit set).
[90388.267518] uvcvideo: Frame complete (EOF found).
[90388.267527] uvcvideo: EOF in empty payload.
[90388.267538] uvcvideo: Dropping payload (out of sync).
[90388.331558] uvcvideo: frame 60 stats: 0/2/14 packets, 0/0/14 pts (!early initial), 13/14 scr, last pts/stc/sof 1568808846/1568865004/333
[90388.335995] uvcvideo: Marking buffer as bad (error bit set).
[90388.336007] uvcvideo: Frame complete (EOF found).
[90388.336016] uvcvideo: EOF in empty payload.
[90388.336027] uvcvideo: Dropping payload (out of sync).
[90388.396057] uvcvideo: frame 61 stats: 0/2/26 packets, 0/0/26 pts (!early initial), 25/26 scr, last pts/stc/sof 1570410246/1570509016/401
[90388.404745] uvcvideo: Marking buffer as bad (error bit set).
[90388.404757] uvcvideo: Frame complete (EOF found).
[90388.404765] uvcvideo: EOF in empty payload.
[90388.404777] uvcvideo: Dropping payload (out of sync).
[90388.464790] uvcvideo: frame 62 stats: 0/2/41 packets, 0/0/41 pts (!early initial), 40/41 scr, last pts/stc/sof 1572011646/1572159028/470
[90388.469249] uvcvideo: Marking buffer as bad (error bit set).
[90388.469261] uvcvideo: Frame complete (EOF found).
[90388.469270] uvcvideo: EOF in empty payload.
[90388.469283] uvcvideo: Dropping payload (out of sync).
[90388.529307] uvcvideo: frame 63 stats: 0/2/25 packets, 0/0/25 pts (!early initial), 24/25 scr, last pts/stc/sof 1573613046/1573707040/535
[90388.537997] uvcvideo: Marking buffer as bad (error bit set).
[90388.538010] uvcvideo: Frame complete (EOF found).
[90388.538019] uvcvideo: EOF in empty payload.
[90388.538030] uvcvideo: Dropping payload (out of sync).
[90388.598058] uvcvideo: frame 64 stats: 0/2/39 packets, 0/0/39 pts (!early initial), 38/39 scr, last pts/stc/sof 1575214446/1575357052/603
[90388.602497] uvcvideo: Marking buffer as bad (error bit set).
[90388.602509] uvcvideo: Frame complete (EOF found).
[90388.602517] uvcvideo: EOF in empty payload.
[90388.602529] uvcvideo: Dropping payload (out of sync).
[90388.662541] uvcvideo: frame 65 stats: 0/2/23 packets, 0/0/23 pts (!early initial), 22/23 scr, last pts/stc/sof 1576815846/1576905064/668
[90388.671244] uvcvideo: Marking buffer as bad (error bit set).
[90388.671257] uvcvideo: Frame complete (EOF found).
[90388.671266] uvcvideo: EOF in empty payload.
[90388.671280] uvcvideo: Dropping payload (out of sync).
[90388.731436] uvcvideo: frame 66 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1578417246/1578555076/737
[90388.732677] uvcvideo: uvc_v4l2_poll
[90388.732783] uvcvideo: uvc_v4l2_poll
[90388.735873] uvcvideo: Marking buffer as bad (error bit set).
[90388.735885] uvcvideo: Frame complete (EOF found).
[90388.735894] uvcvideo: EOF in empty payload.
[90388.735905] uvcvideo: Dropping payload (out of sync).
[90388.795930] uvcvideo: frame 67 stats: 0/2/22 packets, 0/0/22 pts (!early initial), 21/22 scr, last pts/stc/sof 1580018646/1580106088/801
[90388.804619] uvcvideo: Marking buffer as bad (error bit set).
[90388.804631] uvcvideo: Frame complete (EOF found).
[90388.804638] uvcvideo: EOF in empty payload.
[90388.804647] uvcvideo: Dropping payload (out of sync).
[90388.864678] uvcvideo: frame 68 stats: 0/2/37 packets, 0/0/37 pts (!early initial), 36/37 scr, last pts/stc/sof 1581620046/1581756100/870
[90388.868992] uvcvideo: Marking buffer as bad (error bit set).
[90388.869003] uvcvideo: Frame complete (EOF found).
[90388.869010] uvcvideo: EOF in empty payload.
[90388.869020] uvcvideo: Dropping payload (out of sync).
[90388.933040] uvcvideo: frame 69 stats: 0/2/21 packets, 0/0/21 pts (!early initial), 20/21 scr, last pts/stc/sof 1583221446/1583301112/934
[90388.937750] uvcvideo: Marking buffer as bad (error bit set).
[90388.937762] uvcvideo: Frame complete (EOF found).
[90388.937771] uvcvideo: EOF in empty payload.
[90388.937782] uvcvideo: Dropping payload (out of sync).
[90388.997806] uvcvideo: frame 70 stats: 0/2/34 packets, 0/0/34 pts (!early initial), 33/34 scr, last pts/stc/sof 1584822846/1584951124/1003
[90389.002125] uvcvideo: Marking buffer as bad (error bit set).
[90389.002137] uvcvideo: Frame complete (EOF found).
[90389.002144] uvcvideo: EOF in empty payload.
[90389.002154] uvcvideo: Dropping payload (out of sync).
[90389.066158] uvcvideo: frame 71 stats: 0/2/18 packets, 0/0/18 pts (!early initial), 17/18 scr, last pts/stc/sof 1586424246/1586496136/1067
[90389.070622] uvcvideo: Marking buffer as bad (error bit set).
[90389.070630] uvcvideo: Frame complete (EOF found).
[90389.070635] uvcvideo: EOF in empty payload.
[90389.070643] uvcvideo: Dropping payload (out of sync).
[90389.130666] uvcvideo: frame 72 stats: 0/2/32 packets, 0/0/32 pts (!early initial), 31/32 scr, last pts/stc/sof 1588025646/1588140148/1136
[90389.134871] uvcvideo: Marking buffer as bad (error bit set).
[90389.134883] uvcvideo: Frame complete (EOF found).
[90389.134892] uvcvideo: EOF in empty payload.
[90389.134903] uvcvideo: Dropping payload (out of sync).
[90389.198932] uvcvideo: frame 73 stats: 0/2/14 packets, 0/0/14 pts (!early initial), 13/14 scr, last pts/stc/sof 1589627046/1589682160/1200
[90389.203376] uvcvideo: Marking buffer as bad (error bit set).
[90389.203388] uvcvideo: Frame complete (EOF found).
[90389.203396] uvcvideo: EOF in empty payload.
[90389.203408] uvcvideo: Dropping payload (out of sync).
[90389.263433] uvcvideo: frame 74 stats: 0/2/26 packets, 0/0/26 pts (!early initial), 25/26 scr, last pts/stc/sof 1591228446/1591326172/1269
[90389.272371] uvcvideo: Marking buffer as bad (error bit set).
[90389.272386] uvcvideo: Frame complete (EOF found).
[90389.272394] uvcvideo: EOF in empty payload.
[90389.272405] uvcvideo: Dropping payload (out of sync).
[90389.332560] uvcvideo: frame 75 stats: 0/2/40 packets, 0/0/40 pts (!early initial), 39/40 scr, last pts/stc/sof 1592829846/1592982184/1338
[90389.336995] uvcvideo: Marking buffer as bad (error bit set).
[90389.337007] uvcvideo: Frame complete (EOF found).
[90389.337015] uvcvideo: EOF in empty payload.
[90389.337027] uvcvideo: Dropping payload (out of sync).
[90389.397059] uvcvideo: frame 76 stats: 0/2/26 packets, 0/0/26 pts (!early initial), 25/26 scr, last pts/stc/sof 1594431246/1594533196/1402
[90389.401242] uvcvideo: Marking buffer as bad (error bit set).
[90389.401253] uvcvideo: Frame complete (EOF found).
[90389.401261] uvcvideo: EOF in empty payload.
[90389.401275] uvcvideo: Dropping payload (out of sync).
[90389.465308] uvcvideo: frame 77 stats: 0/2/10 packets, 0/0/10 pts (!early initial), 9/10 scr, last pts/stc/sof 1596032646/1596075208/1467
[90389.469748] uvcvideo: Marking buffer as bad (error bit set).
[90389.469760] uvcvideo: Frame complete (EOF found).
[90389.469768] uvcvideo: EOF in empty payload.
[90389.469779] uvcvideo: Dropping payload (out of sync).
[90389.529806] uvcvideo: frame 78 stats: 0/2/22 packets, 0/0/22 pts (!early initial), 21/22 scr, last pts/stc/sof 1597634046/1597719220/1535
[90389.538495] uvcvideo: Marking buffer as bad (error bit set).
[90389.538508] uvcvideo: Frame complete (EOF found).
[90389.538516] uvcvideo: EOF in empty payload.
[90389.538527] uvcvideo: Dropping payload (out of sync).
[90389.598559] uvcvideo: frame 79 stats: 0/2/36 packets, 0/0/36 pts (!early initial), 35/36 scr, last pts/stc/sof 1599235446/1599369232/1604
[90389.602874] uvcvideo: Marking buffer as bad (error bit set).
[90389.602887] uvcvideo: Frame complete (EOF found).
[90389.602895] uvcvideo: EOF in empty payload.
[90389.602907] uvcvideo: Dropping payload (out of sync).
[90389.666916] uvcvideo: frame 80 stats: 0/2/20 packets, 0/0/20 pts (!early initial), 19/20 scr, last pts/stc/sof 1600836846/1600914244/1668
[90389.671503] uvcvideo: Marking buffer as bad (error bit set).
[90389.671517] uvcvideo: Frame complete (EOF found).
[90389.671525] uvcvideo: EOF in empty payload.
[90389.671536] uvcvideo: Dropping payload (out of sync).
[90389.731687] uvcvideo: frame 81 stats: 0/2/33 packets, 0/0/33 pts (!early initial), 32/33 scr, last pts/stc/sof 1602438246/1602561256/1737
[90389.733844] uvcvideo: uvc_v4l2_poll
[90389.734271] uvcvideo: uvc_v4l2_ioctl(VIDIOC_STREAMOFF)
[90389.734683] uvcvideo: uvc_v4l2_ioctl(VIDIOC_DQBUF)
[90389.735040] uvcvideo: uvc_v4l2_ioctl(VIDIOC_S_CTRL)
[90389.735068] uvcvideo: Control 0x00980909 not found.
[90389.735182] uvcvideo: uvc_v4l2_release

--MP_/NU7VOG5oGk8dC8r4q9Et_rR
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=lsusb.log


Bus 001 Device 005: ID 0ac8:c40a Z-Star Microelectronics Corp. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x0ac8 Z-Star Microelectronics Corp.
  idProduct          0xc40a 
  bcdDevice            1.00
  iManufacturer           1 A4 TECH
  iProduct                2 A4 TECH USB2.0 PC Camera J
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          593
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           79
        dwClockFrequency       24.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x0004020e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
          Zoom (Absolute)
          Privacy
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000547f
          Brightness
          Contrast
          Hue
          Saturation
          Sharpness
          Gamma
          White Balance Temperature
          Power Line Frequency
          White Balance Temperature, Auto
          Digital Multiplier
        iProcessing             0 
        bmVideoStandards     0x 9
          None
          SECAM - 625/50
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {5dc717a9-1941-da11-ae0e-000d56ac7b4c}
        bNumControl            14
        bNrPins                 1
        baSourceID( 0)          1
        bControlSize            3
        bmControls( 0)       0xf9
        bmControls( 1)       0x1f
        bmControls( 2)       0x80
        iExtension              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x000a  1x 10 bytes
        bInterval               5
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      223
        bEndPointAddress                  130
        bmInfo                              0
        bTerminalLink                       3
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       1
        bControlSize                        1
        bmaControls( 0)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                5
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                147456000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 48660480
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 36864000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                 12165120
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  9216000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            26
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        352
        wHeight( 1)                       288
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        176
        wHeight( 3)                       144
        wWidth( 4)                        160
        wHeight( 4)                       120
        bNumCompressionPatterns             5
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     0 (Unspecified)
        bTransferCharacteristics            0 (Unspecified)
        bMatrixCoefficients                 0 (Unspecified)
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0080  1x 128 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b00  2x 768 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0c00  2x 1024 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       6
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1380  3x 896 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       7
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       2 Streaming
      bFunctionProtocol       0 
      iFunction               3 USB2.0 Camera Audio
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              3 USB2.0 Camera Audio
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           39
        bInCollection           1
        baInterfaceNr( 0)       3
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Microphone
        bAssocTerminal          0
        bNrChannels             1
        wChannelConfig     0x0000
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 2
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x00
        bmaControls( 1)      0x43
          Mute Control
          Volume Control
          Automatic Gain Control
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               2
        iTerminal               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                35
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            9 Discrete
        tSamFreq[ 0]         8000
        tSamFreq[ 1]        11025
        tSamFreq[ 2]        12000
        tSamFreq[ 3]        16000
        tSamFreq[ 4]        22050
        tSamFreq[ 5]        24000
        tSamFreq[ 6]        32000
        tSamFreq[ 7]        44100
        tSamFreq[ 8]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0062  1x 98 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

--MP_/NU7VOG5oGk8dC8r4q9Et_rR--
