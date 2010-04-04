Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:58092 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab0DDOMm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Apr 2010 10:12:42 -0400
Date: Sun, 4 Apr 2010 16:12:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux I2C <linux-i2c@vger.kernel.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] i2c: Add support for custom probe function
Message-ID: <20100404161237.29d109a5@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The probe method used by i2c_new_probed_device() may not be suitable
for all cases. Let the caller provide its own, optional probe
function.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 Documentation/i2c/instantiating-devices   |    2 
 drivers/i2c/i2c-core.c                    |   65 ++++++++++++++++-------------
 drivers/macintosh/therm_windtunnel.c      |    4 -
 drivers/media/video/bt8xx/bttv-i2c.c      |    2 
 drivers/media/video/cx18/cx18-i2c.c       |    3 -
 drivers/media/video/em28xx/em28xx-cards.c |    2 
 drivers/media/video/ivtv/ivtv-i2c.c       |    9 ++--
 drivers/media/video/v4l2-common.c         |    3 -
 drivers/usb/host/ohci-pnx4008.c           |    2 
 drivers/video/matrox/i2c-matroxfb.c       |    2 
 include/linux/i2c.h                       |    7 ++-
 11 files changed, 58 insertions(+), 43 deletions(-)

--- linux-2.6.34-rc3.orig/drivers/i2c/i2c-core.c	2010-04-03 21:09:36.000000000 +0200
+++ linux-2.6.34-rc3/drivers/i2c/i2c-core.c	2010-04-04 13:28:17.000000000 +0200
@@ -1376,17 +1376,46 @@ static int i2c_detect(struct i2c_adapter
 	return err;
 }
 
+/*
+ * Legacy default probe function, mostly relevant for SMBus. The default
+ * probe method is a quick write, but it is known to corrupt the 24RF08
+ * EEPROMs due to a state machine bug, and could also irreversibly
+ * write-protect some EEPROMs, so for address ranges 0x30-0x37 and 0x50-0x5f,
+ * we use a byte read instead. Also, some bus drivers don't implement quick
+ * write, so we fallback to a byte read in that case too.
+ * Returns 1 if probe succeeded, 0 if not.
+ */
+static int i2c_default_probe(struct i2c_adapter *adap, unsigned short addr)
+{
+	int err;
+	union i2c_smbus_data dummy;
+
+	if ((addr & ~0x07) == 0x30 || (addr & ~0x0f) == 0x50
+	 || !i2c_check_functionality(adap, I2C_FUNC_SMBUS_QUICK))
+		err = i2c_smbus_xfer(adap, addr, 0, I2C_SMBUS_READ, 0,
+				     I2C_SMBUS_BYTE, &dummy);
+	else
+		err = i2c_smbus_xfer(adap, addr, 0, I2C_SMBUS_WRITE, 0,
+				     I2C_SMBUS_QUICK, NULL);
+
+	return err >= 0;
+}
+
 struct i2c_client *
 i2c_new_probed_device(struct i2c_adapter *adap,
 		      struct i2c_board_info *info,
-		      unsigned short const *addr_list)
+		      unsigned short const *addr_list,
+		      int (*probe)(struct i2c_adapter *, unsigned short addr))
 {
 	int i;
 
-	/* Stop here if the bus doesn't support probing */
-	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_READ_BYTE)) {
-		dev_err(&adap->dev, "Probing not supported\n");
-		return NULL;
+	if (!probe) {
+		/* Stop here if the bus doesn't support probing */
+		if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_READ_BYTE)) {
+			dev_err(&adap->dev, "Probing not supported\n");
+			return NULL;
+		}
+		probe = i2c_default_probe;
 	}
 
 	for (i = 0; addr_list[i] != I2C_CLIENT_END; i++) {
@@ -1404,29 +1433,9 @@ i2c_new_probed_device(struct i2c_adapter
 			continue;
 		}
 
-		/* Test address responsiveness
-		   The default probe method is a quick write, but it is known
-		   to corrupt the 24RF08 EEPROMs due to a state machine bug,
-		   and could also irreversibly write-protect some EEPROMs, so
-		   for address ranges 0x30-0x37 and 0x50-0x5f, we use a byte
-		   read instead. Also, some bus drivers don't implement
-		   quick write, so we fallback to a byte read it that case
-		   too. */
-		if ((addr_list[i] & ~0x07) == 0x30
-		 || (addr_list[i] & ~0x0f) == 0x50
-		 || !i2c_check_functionality(adap, I2C_FUNC_SMBUS_QUICK)) {
-			union i2c_smbus_data data;
-
-			if (i2c_smbus_xfer(adap, addr_list[i], 0,
-					   I2C_SMBUS_READ, 0,
-					   I2C_SMBUS_BYTE, &data) >= 0)
-				break;
-		} else {
-			if (i2c_smbus_xfer(adap, addr_list[i], 0,
-					   I2C_SMBUS_WRITE, 0,
-					   I2C_SMBUS_QUICK, NULL) >= 0)
-				break;
-		}
+		/* Test address responsiveness */
+		if (probe(adap, addr_list[i]))
+			break;
 	}
 
 	if (addr_list[i] == I2C_CLIENT_END) {
--- linux-2.6.34-rc3.orig/drivers/macintosh/therm_windtunnel.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/macintosh/therm_windtunnel.c	2010-04-04 10:12:14.000000000 +0200
@@ -323,10 +323,10 @@ do_attach( struct i2c_adapter *adapter )
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "therm_ds1775", I2C_NAME_SIZE);
-		i2c_new_probed_device(adapter, &info, scan_ds1775);
+		i2c_new_probed_device(adapter, &info, scan_ds1775, NULL);
 
 		strlcpy(info.type, "therm_adm1030", I2C_NAME_SIZE);
-		i2c_new_probed_device(adapter, &info, scan_adm1030);
+		i2c_new_probed_device(adapter, &info, scan_adm1030, NULL);
 
 		if( x.thermostat && x.fan ) {
 			x.running = 1;
--- linux-2.6.34-rc3.orig/drivers/media/video/bt8xx/bttv-i2c.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/media/video/bt8xx/bttv-i2c.c	2010-04-04 10:12:14.000000000 +0200
@@ -411,7 +411,7 @@ void __devinit init_bttv_i2c_ir(struct b
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
+		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list, NULL);
 	}
 }
 
--- linux-2.6.34-rc3.orig/drivers/media/video/cx18/cx18-i2c.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/media/video/cx18/cx18-i2c.c	2010-04-04 10:12:14.000000000 +0200
@@ -117,7 +117,8 @@ static int cx18_i2c_new_ir(struct cx18 *
 		break;
 	}
 
-	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;
+	return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
+	       -1 : 0;
 }
 
 int cx18_i2c_register(struct cx18 *cx, unsigned idx)
--- linux-2.6.34-rc3.orig/drivers/media/video/em28xx/em28xx-cards.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/media/video/em28xx/em28xx-cards.c	2010-04-04 10:12:14.000000000 +0200
@@ -2334,7 +2334,7 @@ void em28xx_register_i2c_ir(struct em28x
 
 	if (dev->init_data.name)
 		info.platform_data = &dev->init_data;
-	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
 }
 
 void em28xx_card_setup(struct em28xx *dev)
--- linux-2.6.34-rc3.orig/drivers/media/video/ivtv/ivtv-i2c.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/media/video/ivtv/ivtv-i2c.c	2010-04-04 10:12:14.000000000 +0200
@@ -182,8 +182,8 @@ static int ivtv_i2c_new_ir(struct ivtv *
 			return -1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, type, I2C_NAME_SIZE);
-		return i2c_new_probed_device(adap, &info, addr_list) == NULL
-								     ? -1 : 0;
+		return i2c_new_probed_device(adap, &info, addr_list, NULL)
+							   == NULL ? -1 : 0;
 	}
 
 	/* Only allow one IR receiver to be registered per board */
@@ -220,7 +220,8 @@ static int ivtv_i2c_new_ir(struct ivtv *
 	info.platform_data = init_data;
 	strlcpy(info.type, type, I2C_NAME_SIZE);
 
-	return i2c_new_probed_device(adap, &info, addr_list) == NULL ? -1 : 0;
+	return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
+	       -1 : 0;
 }
 
 /* Instantiate the IR receiver device using probing -- undesirable */
@@ -248,7 +249,7 @@ struct i2c_client *ivtv_i2c_new_ir_legac
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-	return i2c_new_probed_device(&itv->i2c_adap, &info, addr_list);
+	return i2c_new_probed_device(&itv->i2c_adap, &info, addr_list, NULL);
 }
 
 int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
--- linux-2.6.34-rc3.orig/drivers/media/video/v4l2-common.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/media/video/v4l2-common.c	2010-04-04 10:12:14.000000000 +0200
@@ -837,7 +837,8 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_
 
 	/* Create the i2c client */
 	if (info->addr == 0 && probe_addrs)
-		client = i2c_new_probed_device(adapter, info, probe_addrs);
+		client = i2c_new_probed_device(adapter, info, probe_addrs,
+					       NULL);
 	else
 		client = i2c_new_device(adapter, info);
 
--- linux-2.6.34-rc3.orig/drivers/usb/host/ohci-pnx4008.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/usb/host/ohci-pnx4008.c	2010-04-04 10:12:14.000000000 +0200
@@ -329,7 +329,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(i2c_info.type, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
-						   normal_i2c);
+						   normal_i2c, NULL);
 	i2c_put_adapter(i2c_adap);
 	if (!isp1301_i2c_client) {
 		err("failed to connect I2C to ISP1301 USB Transceiver");
--- linux-2.6.34-rc3.orig/drivers/video/matrox/i2c-matroxfb.c	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/drivers/video/matrox/i2c-matroxfb.c	2010-04-04 10:12:14.000000000 +0200
@@ -190,7 +190,7 @@ static void* i2c_matroxfb_probe(struct m
 			};
 
 			i2c_new_probed_device(&m2info->maven.adapter,
-					      &maven_info, addr_list);
+					      &maven_info, addr_list, NULL);
 		}
 	}
 	return m2info;
--- linux-2.6.34-rc3.orig/include/linux/i2c.h	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/include/linux/i2c.h	2010-04-04 10:12:14.000000000 +0200
@@ -278,12 +278,15 @@ i2c_new_device(struct i2c_adapter *adap,
 
 /* If you don't know the exact address of an I2C device, use this variant
  * instead, which can probe for device presence in a list of possible
- * addresses.
+ * addresses. The "probe" callback function is optional. If it is provided,
+ * it must return 1 on successful probe, 0 otherwose. If it is not provided,
+ * a default probing method is used.
  */
 extern struct i2c_client *
 i2c_new_probed_device(struct i2c_adapter *adap,
 		      struct i2c_board_info *info,
-		      unsigned short const *addr_list);
+		      unsigned short const *addr_list,
+		      int (*probe)(struct i2c_adapter *, unsigned short addr));
 
 /* For devices that use several addresses, use i2c_new_dummy() to make
  * client handles for the extra addresses.
--- linux-2.6.34-rc3.orig/Documentation/i2c/instantiating-devices	2010-03-20 14:27:51.000000000 +0100
+++ linux-2.6.34-rc3/Documentation/i2c/instantiating-devices	2010-04-04 10:12:14.000000000 +0200
@@ -102,7 +102,7 @@ static int __devinit usb_hcd_pnx4008_pro
 	memset(&i2c_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(i2c_info.name, "isp1301_pnx", I2C_NAME_SIZE);
 	isp1301_i2c_client = i2c_new_probed_device(i2c_adap, &i2c_info,
-						   normal_i2c);
+						   normal_i2c, NULL);
 	i2c_put_adapter(i2c_adap);
 	(...)
 }


-- 
Jean Delvare
