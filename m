Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41450 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1CLAhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 19:37:38 -0500
Received: by iyb26 with SMTP id 26so3177268iyb.19
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2011 16:37:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinyJOVQEurOUdibvTfTNLRCWEJi_GX8=bodK4c=@mail.gmail.com>
References: <AANLkTi=RNXdb6BSLQL74NA9XMrN9mj6CNYvZgycSCQ9n@mail.gmail.com>
	<AANLkTinyJOVQEurOUdibvTfTNLRCWEJi_GX8=bodK4c=@mail.gmail.com>
Date: Sat, 12 Mar 2011 11:37:37 +1100
Message-ID: <AANLkTikCX8S=Q0=06ggw+qVAYRh=56ch3rRduyN0G7W5@mail.gmail.com>
Subject: Re: Problem with saa7134: Asus Tiger revision 1.0, subsys 1043:4857
From: Jason Hecker <jhecker@wireless.org.au>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'll add the following kernel debug info for what it's worth:

-----
Mar 12 11:22:51 mythtv kernel: [   14.025097] saa7130/34: v4l2 driver
version 0.2.16 loaded
Mar 12 11:22:51 mythtv kernel: [   14.026609] saa7134 0000:00:09.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar 12 11:22:51 mythtv kernel: [   14.026617] saa7133[0]: found at
0000:00:09.0, rev: 209, irq: 17, latency: 32, mmio: 0xec000000
Mar 12 11:22:51 mythtv kernel: [   14.026625] saa7133[0]: subsystem:
1043:4857, board: Asus Tiger Rev:1.00 [card=152,autodetected]
Mar 12 11:22:51 mythtv kernel: [   14.026649] saa7133[0]: board init: gpio is 0
Mar 12 11:22:51 mythtv kernel: [   14.200257] saa7133[0]: i2c eeprom
00: 43 10 57 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Mar 12 11:22:51 mythtv kernel: [   14.200268] saa7133[0]: i2c eeprom
10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200279] saa7133[0]: i2c eeprom
20: 01 40 01 02 03 01 01 03 08 ff 00 b6 ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200288] saa7133[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200298] saa7133[0]: i2c eeprom
40: ff 21 00 c2 96 10 03 32 15 00 ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200307] saa7133[0]: i2c eeprom
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200316] saa7133[0]: i2c eeprom
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200326] saa7133[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200335] saa7133[0]: i2c eeprom
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200344] saa7133[0]: i2c eeprom
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200354] saa7133[0]: i2c eeprom
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200363] saa7133[0]: i2c eeprom
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200372] saa7133[0]: i2c eeprom
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200382] saa7133[0]: i2c eeprom
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200391] saa7133[0]: i2c eeprom
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.200400] saa7133[0]: i2c eeprom
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Mar 12 11:22:51 mythtv kernel: [   14.660189] tuner 1-004b: chip found
@ 0x96 (saa7133[0])
Mar 12 11:22:56 mythtv kernel: [   21.620280] saa7133[0]: registered
device video0 [v4l2]
Mar 12 11:22:56 mythtv kernel: [   21.620403] saa7133[0]: registered device vbi0
Mar 12 11:22:56 mythtv kernel: [   21.620513] saa7133[0]: registered
device radio0
Mar 12 11:23:03 mythtv kernel: [   28.860185] DVB: registering new
adapter (saa7133[0])
-----

Now on the latest reboot I am getting the below.

-----
Mar 12 11:24:13 mythtv kernel: [   98.240211] DVB: registering adapter
0 frontend 0 (Philips TDA10046H DVB-T)...
Mar 12 11:24:13 mythtv kernel: [   98.400008] tda1004x: setting up
plls for 48MHz sampling clock
Mar 12 11:24:15 mythtv kernel: [  100.930007] tda1004x: found firmware
revision 0 -- invalid
Mar 12 11:24:15 mythtv kernel: [  100.930012] tda1004x: trying to boot
from eeprom
Mar 12 11:24:16 mythtv kernel: [  101.180011] tda1004x: found firmware
revision 80 -- invalid
Mar 12 11:24:16 mythtv kernel: [  101.180017] tda1004x: firmware upload failed
Mar 12 11:24:16 mythtv kernel: [  102.000014] tda1004x: setting up
plls for 48MHz sampling clock
Mar 12 11:24:18 mythtv kernel: [  103.480013] tda1004x: found firmware
revision 0 -- invalid
Mar 12 11:24:18 mythtv kernel: [  103.480018] tda1004x: waiting for
firmware upload...
Mar 12 11:24:19 mythtv kernel: [  104.780010] tda1004x: found firmware
revision 0 -- invalid
Mar 12 11:24:19 mythtv kernel: [  104.780015] tda1004x: trying to boot
from eeprom
Mar 12 11:24:22 mythtv kernel: [  107.400011] tda1004x: found firmware
revision 0 -- invalid
Mar 12 11:24:22 mythtv kernel: [  107.400016] tda1004x: waiting for
firmware upload...
Mar 12 11:25:22 mythtv kernel: [  167.160013] tda1004x: found firmware
revision 0 -- invalid
Mar 12 11:25:22 mythtv kernel: [  167.160021] tda1004x: firmware upload failed
Mar 12 11:25:25 mythtv kernel: [  170.840045] tda1004x: found firmware
revision 80 -- invalid
Mar 12 11:25:25 mythtv kernel: [  170.840051] tda1004x: firmware upload failed
------

A previous boot up had the card reporting:

Nothing has changed between power cycles.
-----
Mar 12 09:22:15 mythtv kernel: [   67.010115] DVB: registering new
adapter (saa7133[1])
Mar 12 09:22:15 mythtv kernel: [   67.010121] DVB: registering adapter
0 frontend 0 (Philips TDA10046H DVB-T)...
Mar 12 09:22:15 mythtv kernel: [   67.170007] tda1004x: setting up
plls for 48MHz sampling clock
Mar 12 09:22:17 mythtv kernel: [   69.700004] tda1004x: found firmware
revision 0 -- invalid
Mar 12 09:22:17 mythtv kernel: [   69.700007] tda1004x: trying to boot
from eeprom
Mar 12 09:22:20 mythtv kernel: [   72.170017] tda1004x: found firmware
revision 0 -- invalid
Mar 12 09:22:20 mythtv kernel: [   72.170020] tda1004x: waiting for
firmware upload...
Mar 12 09:22:51 mythtv kernel: [  103.220013] tda1004x: found firmware
revision 29 -- ok
Mar 12 09:24:46 mythtv kernel: [  217.870023] tda1004x: setting up
plls for 48MHz sampling clock
Mar 12 09:24:46 mythtv kernel: [  218.400019] tda1004x: found firmware
revision 29 -- ok
Mar 12 09:24:59 mythtv kernel: [  230.990024] tda1004x: setting up
plls for 48MHz sampling clock
Mar 12 09:24:59 mythtv kernel: [  231.520284] tda1004x: found firmware
revision 29 -- ok
