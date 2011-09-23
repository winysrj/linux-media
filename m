Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1IWRFT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 13:05:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: greg@kroah.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] tm6000: Fix some CodingStyle issues
Date: Fri, 23 Sep 2011 14:04:53 -0300
Message-Id: <1316797494-23237-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/staging/tm6000/tm6000-core.c     |   20 ++++++++++----------
 drivers/staging/tm6000/tm6000-dvb.c      |    4 ++--
 drivers/staging/tm6000/tm6000-i2c.c      |   16 ++++++++--------
 drivers/staging/tm6000/tm6000-regs.h     |    2 +-
 drivers/staging/tm6000/tm6000-usb-isoc.h |    2 +-
 drivers/staging/tm6000/tm6000.h          |    4 ++--
 6 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 6d0803c..9783616 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -52,18 +52,18 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	}
 
 	if (tm6000_debug & V4L2_DEBUG_I2C) {
-		printk("(dev %p, pipe %08x): ", dev->udev, pipe);
+		printk(KERN_DEBUG "(dev %p, pipe %08x): ", dev->udev, pipe);
 
-		printk("%s: %02x %02x %02x %02x %02x %02x %02x %02x ",
+		printk(KERN_CONT "%s: %02x %02x %02x %02x %02x %02x %02x %02x ",
 			(req_type & USB_DIR_IN) ? " IN" : "OUT",
 			req_type, req, value&0xff, value>>8, index&0xff,
 			index>>8, len&0xff, len>>8);
 
 		if (!(req_type & USB_DIR_IN)) {
-			printk(">>> ");
+			printk(KERN_CONT ">>> ");
 			for (i = 0; i < len; i++)
-				printk(" %02x", buf[i]);
-			printk("\n");
+				printk(KERN_CONT " %02x", buf[i]);
+			printk(KERN_CONT "\n");
 		}
 	}
 
@@ -76,14 +76,14 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	if (tm6000_debug & V4L2_DEBUG_I2C) {
 		if (ret < 0) {
 			if (req_type &  USB_DIR_IN)
-				printk("<<< (len=%d)\n", len);
+				printk(KERN_DEBUG "<<< (len=%d)\n", len);
 
-			printk("%s: Error #%d\n", __FUNCTION__, ret);
+			printk(KERN_CONT "%s: Error #%d\n", __func__, ret);
 		} else if (req_type &  USB_DIR_IN) {
-			printk("<<< ");
+			printk(KERN_CONT "<<< ");
 			for (i = 0; i < len; i++)
-				printk(" %02x", buf[i]);
-			printk("\n");
+				printk(KERN_CONT " %02x", buf[i]);
+			printk(KERN_CONT "\n");
 		}
 	}
 
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 8f2a50b..5e6c129 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -330,7 +330,7 @@ static int register_dvb(struct tm6000_core *dev)
 	dvb->demux.write_to_decoder = NULL;
 	ret = dvb_dmx_init(&dvb->demux);
 	if (ret < 0) {
-		printk("tm6000: dvb_dmx_init failed (errno = %d)\n", ret);
+		printk(KERN_ERR "tm6000: dvb_dmx_init failed (errno = %d)\n", ret);
 		goto frontend_err;
 	}
 
@@ -340,7 +340,7 @@ static int register_dvb(struct tm6000_core *dev)
 
 	ret =  dvb_dmxdev_init(&dvb->dmxdev, &dvb->adapter);
 	if (ret < 0) {
-		printk("tm6000: dvb_dmxdev_init failed (errno = %d)\n", ret);
+		printk(KERN_ERR "tm6000: dvb_dmxdev_init failed (errno = %d)\n", ret);
 		goto dvb_dmx_err;
 	}
 
diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 76a8e3a..0290bbf 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -189,7 +189,7 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			/* 1 or 2 byte write followed by a read */
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
 			i2c_dprintk(2, "; joined to read %s len=%d:",
 				    i == num - 2 ? "stop" : "nonstop",
 				    msgs[i + 1].len);
@@ -211,17 +211,17 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			}
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
 		} else {
 			/* write bytes */
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
-					printk(" %02x", msgs[i].buf[byte]);
+					printk(KERN_CONT " %02x", msgs[i].buf[byte]);
 			rc = tm6000_i2c_send_regs(dev, addr, msgs[i].buf[0],
 				msgs[i].buf + 1, msgs[i].len - 1);
 		}
 		if (i2c_debug >= 2)
-			printk("\n");
+			printk(KERN_CONT "\n");
 		if (rc < 0)
 			goto err;
 	}
@@ -259,7 +259,7 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev)
 		p++;
 		if (0 == (i % 16))
 			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
-		printk(" %02x", dev->eedata[i]);
+		printk(KERN_CONT " %02x", dev->eedata[i]);
 		if ((dev->eedata[i] >= ' ') && (dev->eedata[i] <= 'z'))
 			bytes[i%16] = dev->eedata[i];
 		else
@@ -269,14 +269,14 @@ static int tm6000_i2c_eeprom(struct tm6000_core *dev)
 
 		if (0 == (i % 16)) {
 			bytes[16] = '\0';
-			printk("  %s\n", bytes);
+			printk(KERN_CONT "  %s\n", bytes);
 		}
 	}
 	if (0 != (i%16)) {
 		bytes[i%16] = '\0';
 		for (i %= 16; i < 16; i++)
-			printk("   ");
-		printk("  %s\n", bytes);
+			printk(KERN_CONT "   ");
+		printk(KERN_CONT "  %s\n", bytes);
 	}
 
 	return 0;
diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 6e4ef95..7f491b6 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -90,7 +90,7 @@
  */
 
 enum {
-	TM6000_URB_MSG_VIDEO=1,
+	TM6000_URB_MSG_VIDEO = 1,
 	TM6000_URB_MSG_AUDIO,
 	TM6000_URB_MSG_VBI,
 	TM6000_URB_MSG_PTS,
diff --git a/drivers/staging/tm6000/tm6000-usb-isoc.h b/drivers/staging/tm6000/tm6000-usb-isoc.h
index 084c2a8..99d15a5 100644
--- a/drivers/staging/tm6000/tm6000-usb-isoc.h
+++ b/drivers/staging/tm6000/tm6000-usb-isoc.h
@@ -46,5 +46,5 @@ struct usb_isoc_ctl {
 	int				tmp_buf_len;
 
 		/* Stores already requested buffers */
-	struct tm6000_buffer    	*buf;
+	struct tm6000_buffer		*buf;
 };
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 5bdce84..2777e51 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -384,7 +384,7 @@ extern int tm6000_debug;
 #define dprintk(dev, level, fmt, arg...) do {\
 	if (tm6000_debug & level) \
 		printk(KERN_INFO "(%lu) %s %s :"fmt, jiffies, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 #define V4L2_DEBUG_REG		0x0004
 #define V4L2_DEBUG_I2C		0x0008
@@ -395,4 +395,4 @@ extern int tm6000_debug;
 
 #define tm6000_err(fmt, arg...) do {\
 	printk(KERN_ERR "tm6000 %s :"fmt, \
-		__FUNCTION__ , ##arg); } while (0)
+		__func__ , ##arg); } while (0)
-- 
1.7.6.2

