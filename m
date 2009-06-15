Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:1051 "EHLO surfers.oz.agile.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbZFOBx5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 21:53:57 -0400
Received: from pacific.oz.agile.tv (pacific.oz.agile.tv [192.168.16.16])
	by surfers.oz.agile.tv (Postfix) with SMTP id 4DC8CA6E85
	for <linux-media@vger.kernel.org>; Mon, 15 Jun 2009 11:33:15 +1000 (EST)
Date: Mon, 15 Jun 2009 11:33:15 +1000
From: Bob Hepple <bhepple@promptu.com>
To: linux-media@vger.kernel.org
Subject: Re: My DVB-card is flooding the consol with
 "recv bulk message failed"
Message-Id: <20090615113315.0fdfbe62.bhepple@promptu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To add another data-point, I am also getting this error with the same
board ... as far as I have been able to test, it's something that was
OK in 2.6.27, regressed in 2.6.28 and is still a problem in 2.6.30.

Note that this is the rev.1 DViCO

lsb_release -rd
Description:    Ubuntu karmic (development branch)
Release:        9.10

uname -a
Linux nina 2.6.30-8-generic #9-Ubuntu SMP Wed Jun 3 15:23:55 UTC 2009 i686 GNU/Linux

I get spammed by this console message every 1 second and the board does not operate:
[ 375.385180] dvb-usb: bulk message failed: -110 (4/0)

I see the same problem with mythbuntu-9.04 (2.6.28)

So I put in a new disc and installed Fedora-10 (2.6.27) with the same
firmware: /lib/firmware/xc3028-v27.fw
... and it's working fine now.

Earlier history: It was working fine on Ubuntu Hardy (it was an earlier
kernel (2.6.20??) with the v4l-dvb drivers downloaded with hg and compiled
locally). Ubuntu Intrepid was also OK.

I also tried powering off, removing the power cable and taking the
board out of the machine before re-trying in a different PCI slot - it
made no difference.

lsusb gives:
Bus 002 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4 (ZL10353+xc2028/xc302 (initialized)
Bus 002 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4 (ZL10353+xc2028/xc302 (initialized)

>From /var/log/messages, it seems to be loading the firmware but then running into problems with writing to the zl10353:

Jun 13 15:01:45 nina kernel: [ 26.488234] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
Jun 13 15:01:45 nina kernel: [ 26.488611] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jun 13 15:01:45 nina kernel: [ 26.519611] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
Jun 13 15:01:45 nina kernel: [ 26.937373] cxusb: No IR receiver detected on this device.
Jun 13 15:01:45 nina kernel: [ 26.937383] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Jun 13 15:01:45 nina kernel: [ 27.057256] xc2028 2-0061: creating new instance
Jun 13 15:01:45 nina kernel: [ 27.057262] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
Jun 13 15:01:45 nina kernel: [ 27.057887] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized and connected.
Jun 13 15:01:45 nina kernel: [ 27.057913] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
Jun 13 15:01:45 nina kernel: [ 27.058049] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jun 13 15:01:45 nina kernel: [ 27.089208] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
Jun 13 15:01:45 nina kernel: [ 27.136536] cxusb: No IR receiver detected on this device.
Jun 13 15:01:45 nina kernel: [ 27.136545] DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
Jun 13 15:01:45 nina kernel: [ 27.136737] xc2028 3-0061: creating new instance
Jun 13 15:01:45 nina kernel: [ 27.136741] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
Jun 13 15:01:45 nina kernel: [ 27.137404] dvb-usb: DViCO FusionHDTV DVB-T Dual Digital 4 successfully initialized and connected.
.
.
.
Jun 13 15:02:25 nina kernel: [ 118.801333] i2c-adapter i2c-2: firmware: requesting xc3028-v27.fw
Jun 13 15:02:25 nina kernel: [ 118.922171] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Jun 13 15:02:25 nina kernel: [ 118.932344] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Jun 13 15:02:27 nina kernel: [ 120.659451] xc2028 2-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
Jun 13 15:02:27 nina kernel: [ 120.685823] xc2028 2-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
Jun 13 15:02:27 nina kernel: [ 120.989117] i2c-adapter i2c-3: firmware: requesting xc3028-v27.fw
Jun 13 15:02:27 nina kernel: [ 120.993890] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Jun 13 15:02:27 nina kernel: [ 121.004235] xc2028 3-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
Jun 13 15:02:29 nina kernel: [ 122.735596] xc2028 3-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.
Jun 13 15:02:29 nina kernel: [ 122.762090] xc2028 3-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
Jun 13 15:02:30 nina kernel: [ 123.853864] usbcore: registered new interface driver hiddev
Jun 13 15:02:30 nina kernel: [ 123.853884] usbcore: registered new interface driver usbhid
Jun 13 15:02:30 nina kernel: [ 123.853887] usbhid: v2.6:USB HID core driver
Jun 13 15:02:30 nina kernel: [ 123.868170] zl10353: write to reg 62 failed (err = -121)!
Jun 13 15:02:32 nina kernel: [ 125.868184] zl10353: write to reg 50 failed (err = -121)!
Jun 13 15:03:03 nina kernel: [ 157.456355] IRQ 16/nvidia: IRQF_DISABLED is not guaranteed on shared IRQs
Jun 13 15:03:03 nina kernel: [ 157.522631] agpgart-nvidia 0000:00:00.0: AGP 2.0 bridge
Jun 13 15:03:03 nina kernel: [ 157.522647] agpgart-nvidia 0000:00:00.0: putting AGP V2 device into 4x mode
Jun 13 15:03:03 nina kernel: [ 157.522712] nvidia 0000:02:00.0: putting AGP V2 device into 4x mode
Jun 13 15:03:20 nina kernel: [ 174.112106] zl10353_read_register: readreg error (reg=80, ret==-121)
Jun 13 15:03:22 nina kernel: [ 176.112111] zl10353: write to reg 50 failed (err = -121)!
Jun 13 15:03:24 nina kernel: [ 178.116116] zl10353: write to reg 55 failed (err = -121)!
Jun 13 15:03:26 nina kernel: [ 180.116129] zl10353: write to reg ea failed (err = -121)!


-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
