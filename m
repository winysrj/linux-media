Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:54301 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0CSNm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 09:42:56 -0400
Date: Fri, 19 Mar 2010 14:42:50 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitri Belimov <d.belimov@gmail.com>, linux-media@vger.kernel.org,
	"Timothy D. Lenz" <tlenz@vorgon.com>
Subject: [PATCH] FusionHDTV: Use quick reads for I2C IR device probing
Message-ID: <20100319144250.5553055c@hyperion.delvare>
In-Reply-To: <20100316120502.3a9323ac@hyperion.delvare>
References: <20100301153645.5d529766@glory.loctelecom.ru>
	<1267442919.3110.20.camel@palomino.walls.org>
	<20100316120502.3a9323ac@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 16 Mar 2010 12:05:02 +0100, Jean Delvare wrote:
> Executive summary (as I understand it): the card that no longer works
> is a DViCO FusionHDTV7 Dual Express
> (CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP), bridge driver cx23885. It
> has 2 xc5000 chips at I2C address 0x64 (on 2 different I2C buses, of
> course), and an IR chip at 0x6b (on the first of these 2 I2C buses.)
> The latter is reported to be missing with recent dvb-v4l trees.
> 
> The first thing to check is whether an ir_video I2C device is created
> or not. Look in /sys/bus/i2c/devices, list all the entries there. You
> should see two *-0064 entries for the xc5000 chips. You should also
> see, but you probably won't, one *-006b entry for the IR chip. The
> following command should let us know right away what is there:
> 
> $ grep . /sys/bus/i2c/devices/*/name
> 
> The ir_video device is supposed to be probed by cx23885_i2c_register().
> If it is not created, it means that the probe failed. Maybe these chips
> do not like the probe mechanism used by i2c-core (quick write) and only
> reply to reads? In that case, we'd need to use reads to detect it. The
> i2c core doesn't give us enough control to do this cleanly, but this
> could be added if the need exists. In the meantime, we can do the probe
> ourselves and instantiate the device unconditionally (by using
> i2c_new_device instead of i2c_new_probed_device).

We have been debugging over IRC with Timothy, and I have a fix which he
tested successfully. Basically, the problem is that the IR device on
his chip only replies to read commands, but when switching ir-kbd-i2c
to the standard device driver binding model in kernel 2.6.31, I changed
the probing method from quick read to quick write as a side effect.
This is why the IR device was no longer being detected. Using a quick
read again solves the issue. Here comes a fix, tested by Timothy for
the cx23885 part, untested for the cx88 part but I'd be very surprised
if cx88-based FusionHDTV did not need the exact same fix

* * * * *

IR support on FusionHDTV cards is broken since kernel 2.6.31. One side
effect of the switch to the standard binding model for IR I2C devices
was to let i2c-core do the probing instead of the ir-kbd-i2c driver.
There is a slight difference between the two probe methods: i2c-core
uses 0-byte writes, while the ir-kbd-i2c was using 0-byte reads. As
some IR I2C devices only support reads, the new probe method fails to
detect them.

For now, revert to letting the driver do the probe, using 0-byte
reads. In the future, i2c-core will be extended to let callers of
i2c_new_probed_device() provide a custom probing function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: "Timothy D. Lenz" <tlenz@vorgon.com>
---
This fix applies to kernels 2.6.31 to 2.6.34. Should be sent to Linus
quickly.

 drivers/media/video/cx23885/cx23885-i2c.c |   12 +++++++++++-
 drivers/media/video/cx88/cx88-i2c.c       |   16 +++++++++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc1.orig/drivers/media/video/cx23885/cx23885-i2c.c	2010-02-25 09:10:33.000000000 +0100
+++ linux-2.6.34-rc1/drivers/media/video/cx23885/cx23885-i2c.c	2010-03-18 13:33:05.000000000 +0100
@@ -365,7 +365,17 @@ int cx23885_i2c_register(struct cx23885_
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list);
+		/*
+		 * We can't call i2c_new_probed_device() because it uses
+		 * quick writes for probing and the IR receiver device only
+		 * replies to reads.
+		 */
+		if (i2c_smbus_xfer(&bus->i2c_adap, addr_list[0], 0,
+				   I2C_SMBUS_READ, 0, I2C_SMBUS_QUICK,
+				   NULL) >= 0) {
+			info.addr = addr_list[0];
+			i2c_new_device(&bus->i2c_adap, &info);
+		}
 	}
 
 	return bus->i2c_rc;
--- linux-2.6.34-rc1.orig/drivers/media/video/cx88/cx88-i2c.c	2010-02-25 09:08:40.000000000 +0100
+++ linux-2.6.34-rc1/drivers/media/video/cx88/cx88-i2c.c	2010-03-18 13:33:05.000000000 +0100
@@ -188,10 +188,24 @@ int cx88_i2c_init(struct cx88_core *core
 			0x18, 0x6b, 0x71,
 			I2C_CLIENT_END
 		};
+		const unsigned short *addrp;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&core->i2c_adap, &info, addr_list);
+		/*
+		 * We can't call i2c_new_probed_device() because it uses
+		 * quick writes for probing and at least some R receiver
+		 * devices only reply to reads.
+		 */
+		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
+			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
+					   I2C_SMBUS_READ, 0,
+					   I2C_SMBUS_QUICK, NULL) >= 0) {
+				info.addr = *addrp;
+				i2c_new_device(&core->i2c_adap, &info);
+				break;
+			}
+		}
 	}
 	return core->i2c_rc;
 }


-- 
Jean Delvare
