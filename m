Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36331 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752116AbeCCTAf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 14:00:35 -0500
Date: Sat, 3 Mar 2018 16:00:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 5/8] media: em28xx: adjust I2C timeout according with
 I2C speed
Message-ID: <20180303160029.495f99aa@vento.lan>
In-Reply-To: <9321c59f039f6020df057110eaab7b123ae67851.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
        <9321c59f039f6020df057110eaab7b123ae67851.1520018558.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  2 Mar 2018 16:34:46 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> +	switch (dev->i2c_speed & 0x03) {
> +	case EM28XX_I2C_FREQ_25_KHZ:
> +		return time += 4;		/* Assume 4 ms for transfers */
> +		break;

This is obviously wrong. The right patch is enclosed.

Regards,
Mauro


[PATCH v2] media: em28xx: adjust I2C timeout according with I2C speed

If the I2C speed is too slow, it should wait more for an
answer.

While here, change disconnected type from char to unsigned
int, just like all other bitmask fields there at em28xx
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 8648426d3448..4f08e35eddee 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2688,6 +2688,8 @@ static inline void em28xx_set_xclk_i2c_speed(struct em28xx *dev)
 		i2c_speed = EM28XX_I2C_CLK_WAIT_ENABLE |
 			    EM28XX_I2C_FREQ_100_KHZ;
 
+	dev->i2c_speed = i2c_speed & 0x03;
+
 	if (!dev->board.is_em2800)
 		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, i2c_speed);
 	msleep(50);
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9bf49d666e5a..e9892a98eb6e 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -51,13 +51,43 @@ MODULE_PARM_DESC(i2c_debug, "i2c debug message level (1: normal debug, 2: show I
 } while (0)
 
 
+/*
+ * Time in msecs to wait for i2c xfers to finish.
+ * 35ms is the maximum time a SMBUS device could wait when
+ * clock stretching is used. As the transfer itself will take
+ * some time to happen, set it to 35 ms.
+ *
+ * Ok, I2C doesn't specify any limit. So, eventually, we may need
+ * to increase this timeout.
+ */
+#define EM28XX_I2C_XFER_TIMEOUT         35 /* ms */
+
+static int em28xx_i2c_timeout(struct em28xx *dev)
+{
+	int time = EM28XX_I2C_XFER_TIMEOUT;
+
+	switch (dev->i2c_speed & 0x03) {
+	case EM28XX_I2C_FREQ_25_KHZ:
+		time += 4;		/* Assume 4 ms for transfers */
+		break;
+	case EM28XX_I2C_FREQ_100_KHZ:
+	case EM28XX_I2C_FREQ_400_KHZ:
+		time += 1;		/* Assume 1 ms for transfers */
+		break;
+	default: /* EM28XX_I2C_FREQ_1_5_MHZ */
+		break;
+	}
+
+	return msecs_to_jiffies(time);
+}
+
 /*
  * em2800_i2c_send_bytes()
  * send up to 4 bytes to the em2800 i2c device
  */
 static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + em28xx_i2c_timeout(dev);
 	int ret;
 	u8 b2[6];
 
@@ -110,7 +140,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
  */
 static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + em28xx_i2c_timeout(dev);
 	u8 buf2[4];
 	int ret;
 	int i;
@@ -186,7 +216,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 				 u16 len, int stop)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(EM28XX_I2C_XFER_TIMEOUT);
+	unsigned long timeout = jiffies + em28xx_i2c_timeout(dev);
 	int ret;
 
 	if (len < 1 || len > 64)
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index b23f323b5c99..220e7a7a6124 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -195,22 +195,6 @@
 
 #define EM28XX_INTERLACED_DEFAULT 1
 
-/*
- * Time in msecs to wait for i2c xfers to finish.
- * 35ms is the maximum time a SMBUS device could wait when
- * clock stretching is used. As the transfer itself will take
- * some time to happen, set it to 35 ms.
- *
- * Ok, I2C doesn't specify any limit. So, eventually, we may need
- * to increase this timeout.
- *
- * FIXME: this assumes that an I2C message is not longer than 1ms.
- * This is actually dependent on the I2C bus speed, although most
- * devices use a 100kHz clock. So, this assumtion is true most of
- * the time.
- */
-#define EM28XX_I2C_XFER_TIMEOUT		36
-
 /* time in msecs to wait for AC97 xfers to finish */
 #define EM28XX_AC97_XFER_TIMEOUT	100
 
@@ -616,11 +600,12 @@ struct em28xx {
 	enum em28xx_chip_id chip_id;
 
 	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
-	unsigned char disconnected:1;	/* device has been diconnected */
+	unsigned int disconnected:1;	/* device has been diconnected */
 	unsigned int has_video:1;
 	unsigned int is_audio_only:1;
 	unsigned int is_webcam:1;
 	unsigned int has_msp34xx:1;
+	unsigned int i2c_speed:2;
 	enum em28xx_int_audio_type int_audio_type;
 	enum em28xx_usb_audio_type usb_audio_type;
 
