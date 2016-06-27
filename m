Return-path: <linux-media-owner@vger.kernel.org>
Received: from astarte.centershock.net ([5.45.98.111]:57692 "EHLO
	astarte.centershock.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbcF0QOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 12:14:51 -0400
Received: from [192.168.178.56] (HSI-KBW-109-192-114-015.hsi6.kabel-badenwuerttemberg.de [109.192.114.15])
	by astarte.centershock.net (Postfix) with ESMTPSA id 32184107E42
	for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 18:04:48 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Problems with cx23885 IR receiver
Message-ID: <f1eb7737-983c-8314-3991-58d8d760113e@xgm.de>
Date: Mon, 27 Jun 2016 18:04:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I bought a TechnoTrend TT-budget CT2-4500 [1,2] DVB-C card.

By recommendation from that list I use the firmware from
http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-B40/4.0.11/

Aaccording to linuxtv.org my card is an OEM version of the DVB Sky T980C).

Thanks to this list, who helped me to get the TV part working. However,
the IR receiver is not working yet.

I do a modprobe ir-kbd-i2c, the journal then says:

kernel: Registered IR keymap rc-fusionhdtv-mce
kernel: input: i2c IR (FusionHDTV) as /devices/virtual/rc/rc0/input20
kernel: rc rc0: i2c IR (FusionHDTV) as /devices/virtual/rc/rc0
kernel: ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-7/7-006b/ir0
[cx23885[0]]

The device works as a dev/input device:

# ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event17) with:
        Driver ir-kbd-i2c, table rc-fusionhdtv-mce
        Supported protocols: unknown
        Enabled protocols: unknown
        Name: i2c IR (FusionHDTV)
        bus: 24, vendor/product: 0000:0000, version: 0x0000
        Repeat delay = 500 ms, repeat period = 125 ms

However, I can get no results from event17 using `cat /dev/input/event17`.

The remote works (I can see the IR blinking using a cellphone camera)

Also, lircd gets no results:

# lircd --loglevel=debug --nodaemon -H dev/input -d /dev/input/event17
lircd-0.9.3a[2273]: Warning: Running as root
lircd-0.9.3a[2273]: Info: Using remote: Technotrend.
lircd-0.9.3a[2273]: Notice: lircd(devinput) ready, using /var/run/lirc/lircd

Now using irw /var/run/lirc/lircd also get's no signales from the remote.

Any hints you might have? Any more lowlevel debugging ideas?

Thanks,
Florian

[1] http://www.technotrend.eu/2984/TT-budget_CT2-4500_CI.html
[2] https://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-budget_CT2-4500_CI
[3] https://github.com/OpenELEC/dvb-firmware/tree/master/firmware
[4] https://aur.archlinux.org/packages/openelec-dvb-firmware/
[5] https://www.linuxtv.org/wiki/index.php/DVBSky_T980C
