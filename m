Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:59731 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0FHIBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jun 2010 04:01:05 -0400
Date: Tue, 8 Jun 2010 10:01:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] V4L/DVB: Use custom I2C probing function mechanism
Message-ID: <20100608100100.35bdae0f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that i2c-core offers the possibility to provide custom probing
function for I2C devices, let's make use of it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/i2c/i2c-core.c                    |    7 +++++++
 drivers/media/video/cx23885/cx23885-i2c.c |   15 ++++-----------
 drivers/media/video/cx88/cx88-i2c.c       |   19 ++++---------------
 include/linux/i2c.h                       |    3 +++
 4 files changed, 18 insertions(+), 26 deletions(-)

--- linux-2.6.35-rc2.orig/drivers/media/video/cx23885/cx23885-i2c.c	2010-06-07 16:12:38.000000000 +0200
+++ linux-2.6.35-rc2/drivers/media/video/cx23885/cx23885-i2c.c	2010-06-08 09:17:06.000000000 +0200
@@ -365,17 +365,10 @@ int cx23885_i2c_register(struct cx23885_
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		/*
-		 * We can't call i2c_new_probed_device() because it uses
-		 * quick writes for probing and the IR receiver device only
-		 * replies to reads.
-		 */
-		if (i2c_smbus_xfer(&bus->i2c_adap, addr_list[0], 0,
-				   I2C_SMBUS_READ, 0, I2C_SMBUS_QUICK,
-				   NULL) >= 0) {
-			info.addr = addr_list[0];
-			i2c_new_device(&bus->i2c_adap, &info);
-		}
+		/* Use quick read command for probe, some IR chips don't
+		 * support writes */
+		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list,
+				      i2c_probe_func_quick_read);
 	}
 
 	return bus->i2c_rc;
--- linux-2.6.35-rc2.orig/drivers/media/video/cx88/cx88-i2c.c	2010-06-07 16:12:38.000000000 +0200
+++ linux-2.6.35-rc2/drivers/media/video/cx88/cx88-i2c.c	2010-06-08 09:17:06.000000000 +0200
@@ -188,24 +188,13 @@ int cx88_i2c_init(struct cx88_core *core
 			0x18, 0x6b, 0x71,
 			I2C_CLIENT_END
 		};
-		const unsigned short *addrp;
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		/*
-		 * We can't call i2c_new_probed_device() because it uses
-		 * quick writes for probing and at least some R receiver
-		 * devices only reply to reads.
-		 */
-		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
-			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
-					   I2C_SMBUS_READ, 0,
-					   I2C_SMBUS_QUICK, NULL) >= 0) {
-				info.addr = *addrp;
-				i2c_new_device(&core->i2c_adap, &info);
-				break;
-			}
-		}
+		/* Use quick read command for probe, some IR chips don't
+		 * support writes */
+		i2c_new_probed_device(&core->i2c_adap, &info, addr_list,
+				      i2c_probe_func_quick_read);
 	}
 	return core->i2c_rc;
 }
--- linux-2.6.35-rc2.orig/drivers/i2c/i2c-core.c	2010-06-07 16:12:38.000000000 +0200
+++ linux-2.6.35-rc2/drivers/i2c/i2c-core.c	2010-06-08 09:17:06.000000000 +0200
@@ -1453,6 +1453,13 @@ static int i2c_detect(struct i2c_adapter
 	return err;
 }
 
+int i2c_probe_func_quick_read(struct i2c_adapter *adap, unsigned short addr)
+{
+	return i2c_smbus_xfer(adap, addr, 0, I2C_SMBUS_READ, 0,
+			      I2C_SMBUS_QUICK, NULL) >= 0;
+}
+EXPORT_SYMBOL_GPL(i2c_probe_func_quick_read);
+
 struct i2c_client *
 i2c_new_probed_device(struct i2c_adapter *adap,
 		      struct i2c_board_info *info,
--- linux-2.6.35-rc2.orig/include/linux/i2c.h	2010-06-07 16:15:10.000000000 +0200
+++ linux-2.6.35-rc2/include/linux/i2c.h	2010-06-08 09:19:07.000000000 +0200
@@ -292,6 +292,9 @@ i2c_new_probed_device(struct i2c_adapter
 		      unsigned short const *addr_list,
 		      int (*probe)(struct i2c_adapter *, unsigned short addr));
 
+/* Common custom probe functions */
+extern int i2c_probe_func_quick_read(struct i2c_adapter *, unsigned short addr);
+
 /* For devices that use several addresses, use i2c_new_dummy() to make
  * client handles for the extra addresses.
  */


-- 
Jean Delvare
