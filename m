Return-path: <linux-media-owner@vger.kernel.org>
Received: from alpha.mini.pw.edu.pl ([194.29.178.1]:55808 "EHLO
	alpha.mini.pw.edu.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbaEKSby (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 May 2014 14:31:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by alpha.mini.pw.edu.pl (Postfix) with ESMTP id ADE782A200E
	for <linux-media@vger.kernel.org>; Sun, 11 May 2014 20:21:46 +0200 (CEST)
Received: from alpha.mini.pw.edu.pl ([127.0.0.1])
	by localhost (alpha.mini.pw.edu.pl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5JRKaLuOMD75 for <linux-media@vger.kernel.org>;
	Sun, 11 May 2014 20:21:41 +0200 (CEST)
Received: from [192.168.1.100] (178235096052.warszawa.vectranet.pl [178.235.96.52])
	(using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by alpha.mini.pw.edu.pl (Postfix) with ESMTPSA id 134BB2A2008
	for <linux-media@vger.kernel.org>; Sun, 11 May 2014 20:21:41 +0200 (CEST)
Message-ID: <536FBFEC.4020208@mini.pw.edu.pl>
Date: Sun, 11 May 2014 20:22:36 +0200
From: Marek Kozlowski <kozlowsm@mini.pw.edu.pl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: WinTV-HVR900 - sound ripped/noise with recent kernels
References: <536FBAAD.7090002@mini.pw.edu.pl>
In-Reply-To: <536FBAAD.7090002@mini.pw.edu.pl>
Content-Type: multipart/mixed;
 boundary="------------030604030505030004010707"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030604030505030004010707
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

:-)
I'm using ArchLinux up-to-date (most recent stable kernels, today:
3.14.3-1). tvtime + sound via:

$ sox -G -t alsa hw:1,0 -t alsa

Worked for a very long time. Recently (~last month) the sound stopped
working. Precisely: the sound seems to be "ripped", with some "noise" or
"echo" - numerous short distortions/interruptions.

My logs as an attachment.

Best regards,
Marek


--------------030604030505030004010707
Content-Type: text/plain; charset=UTF-8;
 name="hauppauge.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hauppauge.log"

May 11 19:30:39 localhost kernel: [  163.322810] em28xx: New device  WinTV HVR-900 @ 480 Mbps (2040:6502, interface 0, class 0)
May 11 19:30:39 localhost kernel: [  163.322814] em28xx: Audio interface 0 found (Vendor Class)
May 11 19:30:39 localhost kernel: [  163.322816] em28xx: Video interface 0 found: isoc
May 11 19:30:39 localhost kernel: [  163.322817] em28xx: DVB interface 0 found: isoc
May 11 19:30:39 localhost kernel: [  163.322941] em28xx: chip ID is em2882/3
May 11 19:30:39 localhost kernel: [  163.475951] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0xa43f30dd
May 11 19:30:39 localhost kernel: [  163.475954] em2882/3 #0: EEPROM info:
May 11 19:30:39 localhost kernel: [  163.475956] em2882/3 #0: 	AC97 audio (5 sample rates)
May 11 19:30:39 localhost kernel: [  163.475958] em2882/3 #0: 	500mA max power
May 11 19:30:39 localhost kernel: [  163.475961] em2882/3 #0: 	Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
May 11 19:30:39 localhost kernel: [  163.475963] em2882/3 #0: Identified as Hauppauge WinTV HVR 900 (R2) (card=18)
May 11 19:30:39 localhost kernel: [  163.477259] tveeprom 8-0050: Hauppauge model 65018, rev B2C0, serial# 1133187
May 11 19:30:39 localhost kernel: [  163.477262] tveeprom 8-0050: tuner model is Xceive XC3028 (idx 120, type 71)
May 11 19:30:39 localhost kernel: [  163.477264] tveeprom 8-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
May 11 19:30:39 localhost kernel: [  163.477266] tveeprom 8-0050: audio processor is None (idx 0)
May 11 19:30:39 localhost kernel: [  163.477267] tveeprom 8-0050: has radio
May 11 19:30:39 localhost kernel: [  163.477269] em2882/3 #0: analog set to isoc mode.
May 11 19:30:39 localhost kernel: [  163.477270] em2882/3 #0: dvb set to isoc mode.
May 11 19:30:39 localhost kernel: [  163.477316] usbcore: registered new interface driver em28xx
May 11 19:30:39 localhost kernel: [  163.728521] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff:
May 11 19:30:39 localhost kernel: [  163.728529]  excluding 0xc0000-0xd3fff 0xdc000-0xfffff
May 11 19:30:39 localhost kernel: [  163.728547] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff:
May 11 19:30:39 localhost kernel: [  163.728553]  excluding 0xa0000000-0xa0ffffff
May 11 19:30:39 localhost kernel: [  163.728566] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff:
May 11 19:30:39 localhost kernel: [  163.728571]  excluding 0x60000000-0x60ffffff
May 11 19:30:39 localhost kernel: [  163.843962] em2882/3 #0: Registering V4L2 extension
May 11 19:30:39 localhost kernel: [  163.888071] tvp5150 8-005c: chip found @ 0xb8 (em2882/3 #0)
May 11 19:30:39 localhost kernel: [  163.888076] tvp5150 8-005c: tvp5150am1 detected.
May 11 19:30:39 localhost kernel: [  163.939389] tuner 8-0061: Tuner -1 found with type(s) Radio TV.
May 11 19:30:39 localhost kernel: [  164.023724] xc2028 8-0061: creating new instance
May 11 19:30:39 localhost kernel: [  164.023728] xc2028 8-0061: type set to XCeive xc2028/xc3028 tuner
May 11 19:30:39 localhost kernel: [  164.023840] em2882/3 #0: Config register raw data: 0xd0
May 11 19:30:39 localhost kernel: [  164.024583] em2882/3 #0: AC97 vendor ID = 0xffffffff
May 11 19:30:39 localhost kernel: [  164.024950] em2882/3 #0: AC97 features = 0x6a90
May 11 19:30:39 localhost kernel: [  164.024952] em2882/3 #0: Empia 202 AC97 audio processor detected
May 11 19:30:39 localhost kernel: [  164.345328] em2882/3 #0: V4L2 video device registered as video0
May 11 19:30:39 localhost kernel: [  164.345332] em2882/3 #0: V4L2 VBI device registered as vbi0
May 11 19:30:39 localhost kernel: [  164.345336] em2882/3 #0: V4L2 extension successfully initialized
May 11 19:30:39 localhost kernel: [  164.345338] em28xx: Registered (Em28xx v4l2 Extension) extension
May 11 19:30:39 localhost kernel: [  164.606599] xc2028 8-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
May 11 19:30:39 localhost kernel: [  164.687726] em2882/3 #0: Binding audio extension
May 11 19:30:39 localhost kernel: [  164.687730] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
May 11 19:30:39 localhost kernel: [  164.687731] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho Chehab
May 11 19:30:39 localhost kernel: [  164.687766] em2882/3 #0: Endpoint 0x83 high-speed on intf 0 alt 7 interval = 8, size 196
May 11 19:30:39 localhost kernel: [  164.687768] em2882/3 #0: Number of URBs: 1, with 64 packets and 192 size
May 11 19:30:39 localhost kernel: [  164.688383] em2882/3 #0: Audio extension successfully initialized
May 11 19:30:39 localhost kernel: [  164.688386] em28xx: Registered (Em28xx Audio Extension) extension
May 11 19:30:39 localhost kernel: [  164.720335] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
May 11 19:30:39 localhost kernel: [  164.720339] Bluetooth: BNEP filters: protocol multicast
May 11 19:30:39 localhost kernel: [  164.720348] Bluetooth: BNEP socket layer initialized
May 11 19:30:39 localhost kernel: [  165.598735] em2882/3 #0: Binding DVB extension
May 11 19:30:39 localhost kernel: [  166.031299] psmouse serio2: alps: Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
May 11 19:30:39 localhost kernel: [  167.571602] psmouse serio2: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
May 11 19:30:39 localhost kernel: [  167.814548] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input14
May 11 19:30:39 localhost kernel: [  168.889346] xc2028 8-0061: attaching existing instance
May 11 19:30:39 localhost kernel: [  168.889352] xc2028 8-0061: type set to XCeive xc2028/xc3028 tuner
May 11 19:30:39 localhost kernel: [  168.889360] em2882/3 #0: em2882/3 #0/2: xc3028 attached
May 11 19:30:39 localhost kernel: [  168.889362] DVB: registering new adapter (em2882/3 #0)
May 11 19:30:39 localhost kernel: [  168.889367] usb 8-1: DVB: registering adapter 0 frontend 0 (Micronas DRXD DVB-T)...
May 11 19:30:39 localhost kernel: [  168.890182] em2882/3 #0: DVB extension successfully initialized
May 11 19:30:39 localhost kernel: [  168.890185] em28xx: Registered (Em28xx dvb Extension) extension
May 11 19:30:39 localhost kernel: [  169.965737] em2882/3 #0: Registering input extension
May 11 19:30:39 localhost kernel: [  170.003344] Registered IR keymap rc-hauppauge
May 11 19:30:39 localhost kernel: [  170.003497] input: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1d.7/usb8/8-1/rc/rc0/input15
May 11 19:30:39 localhost kernel: [  170.003651] rc0: em28xx IR (em2882/3 #0) as /devices/pci0000:00/0000:00:1d.7/usb8/8-1/rc/rc0
May 11 19:30:39 localhost kernel: [  170.003950] em2882/3 #0: Input extension successfully initalized
May 11 19:30:39 localhost kernel: [  170.003952] em28xx: Registered (Em28xx Input Extension) extension
[-------]
May 11 19:46:27 localhost kernel: [ 1121.566600] xc2028 8-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
May 11 19:46:28 localhost kernel: [ 1122.598633] MTS (4), id 00000000000000ff:
May 11 19:46:28 localhost kernel: [ 1122.598640] xc2028 8-0061: Loading firmware for type=MTS (4), id 0000000100000007.
May 11 19:46:29 localhost kernel: [ 1123.907272] xc2028 8-0061: Loading firmware for type=MTS (4), id 00000003000000e0.



--------------030604030505030004010707--
