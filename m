Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lit.cz ([213.250.192.15]:40855 "EHLO mail.bezdrat.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186AbZARAdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 19:33:43 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.bezdrat.net (Postfix) with ESMTP id 4CFB2C011
	for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 01:24:34 +0100 (CET)
Received: from mail.bezdrat.net ([127.0.0.1])
	by localhost (mail.bezdrat.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u6L79C44cZc3 for <linux-media@vger.kernel.org>;
	Sun, 18 Jan 2009 01:24:33 +0100 (CET)
Received: from edas.lit.cz (edas.lit.cz [213.250.198.38])
	by mail.bezdrat.net (Postfix) with ESMTP id 0FCD2C003
	for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 01:24:32 +0100 (CET)
Message-ID: <497276BF.3040900@an.y-co.de>
Date: Sun, 18 Jan 2009 01:24:31 +0100
From: Martin Edlman <ac@an.y-co.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Analog TV on Leadtek PxDVR 3200 H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a problem with module cx23885, it doesn't create the /dev/video0 device.

My config:

Leadtek PxDVR 3200 H Analog/DVB card
Linux - Fedora 10 (2.6.27.9-159.fc10.x86_64)
V4L/DVB repository from http://linuxtv.org/hg/v4l-dvb as the TV card is not
supported by the distro kernel drivers.
I have an analog signal (DVB in 2010).

I compiled the v4l/dvb kernel modules against kernel headers and installed.
Then I depmod'ed new modules, removed all old v4l modules (rmmod) and
inserted new ones (modprobe). The card was detected, but there is no
/dev/video0 device, only /dev/dvb/adapter0/demux0,dvr0,frontend0,net0.

So I cannot run tvtime or any other tv application which tries to open
/dev/video0. (opening /dev/dvd/adapter0/"whatever" doesn't help).

How can I make it creating /dev/video0 device?

Regards, Martin


Here is my dmesg debug output from cx23885

# modprobe cx23885 debug=1 v4l_debug=1 i2c_debug=1 vbi_debug=1 video_debug=1
Jan 18 01:56:45 htpc1 kernel: cx23885 driver version 0.0.1 loaded
Jan 18 01:56:45 htpc1 kernel: cx23885 0000:04:00.0: PCI INT A -> Link[LN2A]
-> GSI 18 (level, low) -> IRQ 18
Jan 18 01:56:45 htpc1 kernel: CORE cx23885[0]: subsystem: 107d:6681, board:
Leadtek Winfast PxDVR3200 H [card=12,autodetected]
Jan 18 01:56:45 htpc1 kernel: <W 88 01<7>cx23885[0]/0:  01<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: <W 88 01<7>cx23885[0]/0:  00<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: cx25840' 2-0044: cx25  0-21 found @ 0x88
(cx23885[0])
Jan 18 01:56:45 htpc1 kernel: <W 88 08<7>cx23885[0]/0:  d4<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: <W 88 01<7>cx23885[0]/0:  60<7>cx23885[0]/0:
 1d<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: <W 88 01<7>cx23885[0]/0:  64<7>cx23885[0]/0:
 00<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: <W a0 00 >
Jan 18 01:56:45 htpc1 kernel:  20<7>cx23885[0]/0:  00<7>cx23885[0]/0:
13<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
20<7>cx23885[0]/0:  00<7>cx23885[0]/0:  13<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  20<7>cx23885[0]/0:
00<7>cx23885[0]/0:  13<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  20<7>cx23885[0]/0:  00<7>cx23885[0]/0:
13<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
08<7>cx23885[0]/0:  00<7>cx23885[0]/0:  18<7>cx23885[0]/0:
03<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
03<7>cx23885[0]/0:  9d<7>cx23885[0]/0:  0c<7>cx23885[0]/0:
03<7>cx23885[0]/0:  05<7>cx23885[0]/0:  00<7>cx23885[0]/0:
0e<7>cx23885[0]/0:  01<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  20<7>cx23885[0]/0:  00<7>cx23885[0]/0
Jan 18 01:56:45 htpc1 kernel: :  13<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  50<7>cx23885[0]/0:  03<7>cx23885[0]/0:
05<7>cx23885[0]/0:  00<7>cx23885[0]/0:  04<7>cx23885[0]/0:
80<7>cx23885[0]/0:  00<7>cx23885[0]/0:  08<7>cx23885[0]/0:
2c<7>cx23885[0]/0:  00<7>cx23885[0]/0:  05<7>cx23885[0]/0:
00<7>cx23885[0]/0:  7d<7>cx23885[0]/0:  10<7>cx23885[0]/0:
81<7>cx23885[0]/0:  66<7>cx23885[0]/0:  0c<7>cx23885[0]/0:
03<7>cx23885[0]/0:  05<7>cx23885[0]/0:  80<7>cx23885[0]/0:
0e<7>cx23885[0]/0:  01<7>cx23885[0]/0:  00<7>cx23885[0]/0:
00<7>cx23885[0]/0:  82<7>cx23885[0]/0:  01<7>cx23885[0]/0:
00<7>cx23885[0]/0:  22<7>cx23885[0]/0:  78<7>cx23885[0]/0:
00<7>cx23885[0]/0:  00<7>cx23885[0]/0:  00<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/
Jan 18 01:56:45 htpc1 kernel: 0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]
Jan 18 01:56:45 htpc1 kernel: /0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0
Jan 18 01:56:45 htpc1 kernel: ]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
 ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:
ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  ff<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: cx23885_dvb_register() allocating 1 frontend(s)
Jan 18 01:56:45 htpc1 kernel: cx23885[0]: cx23885 based dvb card
Jan 18 01:56:45 htpc1 kernel: <W 1e 7f<7>cx23885[0]/0:  R<7>cx23885[0]/0:
14<7>cx23885[0]/0:  >
Jan 18 01:56:45 htpc1 kernel: xc2028 1-0061: creating new instance
Jan 18 01:56:45 htpc1 kernel: xc2028 1-0061: type set to XCeive
xc2028/xc3028 tuner
Jan 18 01:56:45 htpc1 kernel: DVB: registering new adapter (cx23885[0])
Jan 18 01:56:45 htpc1 kernel: DVB: registering adapter 0 frontend 0
(Zarlink ZL10353 DVB-T)...
Jan 18 01:56:45 htpc1 kernel: cx23885_dev_checkrevision() Hardware revision
= 0xb0
Jan 18 01:56:45 htpc1 kernel: cx23885[0]/0: found at 0000:04:00.0, rev: 2,
irq: 18, latency: 0, mmio: 0xfea00000


-- 
Martin Edlman			[web]    http://an.y-co.de
ANY CODE			[mobile] +420 774 692 633
c/c++,c#,java,php,perl,		[jabber] an.y-co.de @ njs.netlab.cz
sql,xhtml,css			[skype]  an.y-co.de
