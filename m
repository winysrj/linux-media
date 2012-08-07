Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab2HGQmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:53 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 01/11] saa7164: use native print_hex_dump() instead of custom one
Date: Tue,  7 Aug 2012 19:43:01 +0300
Message-Id: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/saa7164/saa7164-api.c  |   15 ++++++---
 drivers/media/video/saa7164/saa7164-core.c |   46 +++-------------------------
 drivers/media/video/saa7164/saa7164.h      |    1 -
 3 files changed, 14 insertions(+), 48 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index c8799fd..eff7135 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -670,7 +670,8 @@ int saa7164_api_set_dif(struct saa7164_port *port, u8 reg, u8 val)
 	if (ret != SAA_OK)
 		printk(KERN_ERR "%s() error, ret(2) = 0x%x\n", __func__, ret);
 #if 0
-	saa7164_dumphex16(dev, buf, 16);
+	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, buf, 16,
+		       false);
 #endif
 	return ret == SAA_OK ? 0 : -EIO;
 }
@@ -1352,7 +1353,8 @@ int saa7164_api_enum_subdevs(struct saa7164_dev *dev)
 	}
 
 	if (saa_debug & DBGLVL_API)
-		saa7164_dumphex16(dev, buf, (buflen/16)*16);
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, buf,
+			       buflen & ~15, false);
 
 	saa7164_api_dump_subdevs(dev, buf, buflen);
 
@@ -1403,7 +1405,8 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 	dprintk(DBGLVL_API, "%s() len = %d bytes\n", __func__, len);
 
 	if (saa_debug & DBGLVL_I2C)
-		saa7164_dumphex16(dev, buf, 2 * 16);
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1, buf,
+			       32, false);
 
 	ret = saa7164_cmd_send(bus->dev, unitid, GET_CUR,
 		EXU_REGISTER_ACCESS_CONTROL, len, &buf);
@@ -1411,7 +1414,8 @@ int saa7164_api_i2c_read(struct saa7164_i2c *bus, u8 addr, u32 reglen, u8 *reg,
 		printk(KERN_ERR "%s() error, ret(2) = 0x%x\n", __func__, ret);
 	else {
 		if (saa_debug & DBGLVL_I2C)
-			saa7164_dumphex16(dev, buf, sizeof(buf));
+			print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+				       buf, sizeof(buf), false);
 		memcpy(data, (buf + 2 * sizeof(u32) + reglen), datalen);
 	}
 
@@ -1471,7 +1475,8 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
 	memcpy((buf + 2 * sizeof(u32)), data, datalen);
 
 	if (saa_debug & DBGLVL_I2C)
-		saa7164_dumphex16(dev, buf, sizeof(buf));
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+			       buf, sizeof(buf), false);
 
 	ret = saa7164_cmd_send(bus->dev, unitid, SET_CUR,
 		EXU_REGISTER_ACCESS_CONTROL, len, &buf);
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index 3b7d7b4..2c9ad87 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -92,28 +92,6 @@ LIST_HEAD(saa7164_devlist);
 
 #define INT_SIZE 16
 
-void saa7164_dumphex16FF(struct saa7164_dev *dev, u8 *buf, int len)
-{
-	int i;
-	u8 tmp[16];
-	memset(&tmp[0], 0xff, sizeof(tmp));
-
-	printk(KERN_INFO "--------------------> "
-		"00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
-
-	for (i = 0; i < len; i += 16) {
-		if (memcmp(&tmp, buf + i, sizeof(tmp)) != 0) {
-			printk(KERN_INFO "         [0x%08x] "
-				"%02x %02x %02x %02x %02x %02x %02x %02x "
-				"%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-			*(buf+i+0), *(buf+i+1), *(buf+i+2), *(buf+i+3),
-			*(buf+i+4), *(buf+i+5), *(buf+i+6), *(buf+i+7),
-			*(buf+i+8), *(buf+i+9), *(buf+i+10), *(buf+i+11),
-			*(buf+i+12), *(buf+i+13), *(buf+i+14), *(buf+i+15));
-		}
-	}
-}
-
 static void saa7164_pack_verifier(struct saa7164_buffer *buf)
 {
 	u8 *p = (u8 *)buf->cpu;
@@ -125,7 +103,8 @@ static void saa7164_pack_verifier(struct saa7164_buffer *buf)
 			(*(p + i + 2) != 0x01) || (*(p + i + 3) != 0xBA)) {
 			printk(KERN_ERR "No pack at 0x%x\n", i);
 #if 0
-			saa7164_dumphex16FF(buf->port->dev, (p + i), 32);
+			print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+				       p + 1, 32, false);
 #endif
 		}
 	}
@@ -316,7 +295,8 @@ static void saa7164_work_enchandler_helper(struct saa7164_port *port, int bufnr)
 						printk(KERN_ERR "%s() buf %p guard buffer breach\n",
 							__func__, buf);
 #if 0
-						saa7164_dumphex16FF(dev, (p + buf->actual_size) - 32 , 64);
+			print_hex_dump(KERN_INFO, "", DUMP_PREFIX_OFFSET, 16, 1,
+				       p + buf->actual_size - 32, 64, false);
 #endif
 				}
 			}
@@ -777,24 +757,6 @@ u32 saa7164_getcurrentfirmwareversion(struct saa7164_dev *dev)
 }
 
 /* TODO: Debugging func, remove */
-void saa7164_dumphex16(struct saa7164_dev *dev, u8 *buf, int len)
-{
-	int i;
-
-	printk(KERN_INFO "--------------------> "
-		"00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f\n");
-
-	for (i = 0; i < len; i += 16)
-		printk(KERN_INFO "         [0x%08x] "
-			"%02x %02x %02x %02x %02x %02x %02x %02x "
-			"%02x %02x %02x %02x %02x %02x %02x %02x\n", i,
-		*(buf+i+0), *(buf+i+1), *(buf+i+2), *(buf+i+3),
-		*(buf+i+4), *(buf+i+5), *(buf+i+6), *(buf+i+7),
-		*(buf+i+8), *(buf+i+9), *(buf+i+10), *(buf+i+11),
-		*(buf+i+12), *(buf+i+13), *(buf+i+14), *(buf+i+15));
-}
-
-/* TODO: Debugging func, remove */
 void saa7164_dumpregs(struct saa7164_dev *dev, u32 addr)
 {
 	int i;
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index 35219b9..437284e 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -484,7 +484,6 @@ extern unsigned int vbi_buffers;
 /* ----------------------------------------------------------- */
 /* saa7164-core.c                                              */
 void saa7164_dumpregs(struct saa7164_dev *dev, u32 addr);
-void saa7164_dumphex16(struct saa7164_dev *dev, u8 *buf, int len);
 void saa7164_getfirmwarestatus(struct saa7164_dev *dev);
 u32 saa7164_getcurrentfirmwareversion(struct saa7164_dev *dev);
 void saa7164_histogram_update(struct saa7164_histogram *hg, u32 val);
-- 
1.7.10.4

