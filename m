Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp057.webpack.hosteurope.de ([80.237.132.64]:47712 "EHLO
        wp057.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbeKKHV5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Nov 2018 02:21:57 -0500
From: "martin.konopka@mknetz.de" <martin.konopka@mknetz.de>
Subject: TechnoTrend CT2-4500 remote not working
To: linux-media@vger.kernel.org
Message-ID: <236ee34e-3052-f511-36c4-5dd48c6b433b@mknetz.de>
Date: Sat, 10 Nov 2018 22:35:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

the remote on my TechnoTrend CT2-4500 is not working with kernel 4.18.
The TV-card itself works fine:

cx25840 6-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885: cx23885_dvb_register() allocating 1 frontend(s)
cx23885: cx23885[0]: cx23885 based dvb card
i2c i2c-5: Added multiplexed i2c bus 12
si2168 5-0064: Silicon Labs Si2168-B40 successfully identified
si2168 5-0064: firmware version: B 4.0.2
si2157 12-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
dvbdev: DVB: registering new adapter (cx23885[0])
cx23885 0000:17:00.0: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
sp2 4-0040: CIMaX SP2 successfully attached
cx23885: Technotrend TT-budget CT2-4500 CI MAC address: bc:ea:2b:45:05:68
cx23885: cx23885_dev_checkrevision() Hardware revision = 0xa5
cx23885: cx23885[0]/0: found at 0000:17:00.0, rev: 4, irq: 31, latency:
0, mmio: 0xfe000000


The remote is registered:

Registered IR keymap rc-fusionhdtv-mce
rc rc0: FusionHDTV as
/devices/pci0000:00/0000:00:01.2/0000:15:00.2/0000:16:00.0/0000:17:00.0/i2c-4/4-006b/rc/rc0
input: FusionHDTV as
/devices/pci0000:00/0000:00:01.2/0000:15:00.2/0000:16:00.0/0000:17:00.0/i2c-4/4-006b/rc/rc0/input18
rc rc0: lirc_dev: driver ir_kbd_i2c registered at minor = 0, scancode
receiver, no transmitter

ir-keytable reports:

Found /sys/class/rc/rc0/ (/dev/input/event15) with:
	Name: FusionHDTV
	Driver: ir_kbd_i2c, table: rc-fusionhdtv-mce
	lirc device: /dev/lirc0
	Supported protocols: unknown
	Enabled protocols: unknown
	bus: 24, vendor/product: 0000:0000, version: 0x0000
	Repeat delay = 500 ms, repeat period = 125 ms

Apparently, no protocols are reported.

evtest on /dev/input/event15 reports no events.

The error was reported before:

http://lirc.10951.n7.nabble.com/Problems-with-cx23885-IR-receiver-td10884.html

The remote is working, I verified it with a camera.

Regards,

Martin
