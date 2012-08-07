Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2HGQmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:53 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 02/11] dvb: nxt200x: apply levels to the printk()s
Date: Tue,  7 Aug 2012 19:43:02 +0300
Message-Id: <1344357792-18202-2-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb/frontends/nxt200x.c |   56 ++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index 49ca78d..03af52e 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -37,6 +37,8 @@
  * /usr/lib/hotplug/firmware/ or /lib/firmware/
  * (depending on configuration of firmware hotplug).
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
 #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"
 #define CRC_CCIT_MASK 0x1021
@@ -62,10 +64,7 @@ struct nxt200x_state {
 };
 
 static int debug;
-#define dprintk(args...) \
-	do { \
-		if (debug) printk(KERN_DEBUG "nxt200x: " args); \
-	} while (0)
+#define dprintk(args...)	do { if (debug) pr_debug(args); } while (0)
 
 static int i2c_writebytes (struct nxt200x_state* state, u8 addr, u8 *buf, u8 len)
 {
@@ -73,7 +72,7 @@ static int i2c_writebytes (struct nxt200x_state* state, u8 addr, u8 *buf, u8 len
 	struct i2c_msg msg = { .addr = addr, .flags = 0, .buf = buf, .len = len };
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
+		pr_warn("%s: i2c write error (addr 0x%02x, err == %i)\n",
 			__func__, addr, err);
 		return -EREMOTEIO;
 	}
@@ -86,7 +85,7 @@ static int i2c_readbytes(struct nxt200x_state *state, u8 addr, u8 *buf, u8 len)
 	struct i2c_msg msg = { .addr = addr, .flags = I2C_M_RD, .buf = buf, .len = len };
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
+		pr_warn("%s: i2c read error (addr 0x%02x, err == %i)\n",
 			__func__, addr, err);
 		return -EREMOTEIO;
 	}
@@ -104,7 +103,7 @@ static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg,
 	memcpy(&buf2[1], buf, len);
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
+		pr_warn("%s: i2c write error (addr 0x%02x, err == %i)\n",
 			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
@@ -121,7 +120,7 @@ static int nxt200x_readbytes(struct nxt200x_state *state, u8 reg, u8 *buf, u8 le
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, msg, 2)) != 2) {
-		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
+		pr_warn("%s: i2c read error (addr 0x%02x, err == %i)\n",
 			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
@@ -199,7 +198,7 @@ static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8*
 			break;
 	}
 
-	printk(KERN_WARNING "nxt200x: Error writing multireg register 0x%02X\n",reg);
+	pr_warn("Error writing multireg register 0x%02X\n", reg);
 
 	return 0;
 }
@@ -281,7 +280,8 @@ static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 		counter++;
 	}
 
-	printk(KERN_WARNING "nxt200x: Timeout waiting for nxt200x to stop. This is ok after firmware upload.\n");
+	pr_warn("Timeout waiting for nxt200x to stop. This is ok after "
+		"firmware upload.\n");
 	return;
 }
 
@@ -320,7 +320,7 @@ static void nxt2004_microcontroller_init (struct nxt200x_state* state)
 		counter++;
 	}
 
-	printk(KERN_WARNING "nxt200x: Timeout waiting for nxt2004 to init.\n");
+	pr_warn("Timeout waiting for nxt2004 to init.\n");
 
 	return;
 }
@@ -338,7 +338,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 	switch (state->demod_chip) {
 		case NXT2004:
 			if (i2c_writebytes(state, data[0], data+1, 4))
-				printk(KERN_WARNING "nxt200x: error writing to tuner\n");
+				pr_warn("error writing to tuner\n");
 			/* wait until we have a lock */
 			while (count < 20) {
 				i2c_readbytes(state, data[0], &buf, 1);
@@ -347,7 +347,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 				msleep(100);
 				count++;
 			}
-			printk("nxt2004: timeout waiting for tuner lock\n");
+			pr_warn("timeout waiting for tuner lock\n");
 			break;
 		case NXT2002:
 			/* set the i2c transfer speed to the tuner */
@@ -376,7 +376,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 				msleep(100);
 				count++;
 			}
-			printk("nxt2002: timeout error writing tuner\n");
+			pr_warn("timeout error writing to tuner\n");
 			break;
 		default:
 			return -EINVAL;
@@ -878,22 +878,24 @@ static int nxt2002_init(struct dvb_frontend* fe)
 	u8 buf[2];
 
 	/* request the firmware, this will block until someone uploads it */
-	printk("nxt2002: Waiting for firmware upload (%s)...\n", NXT2002_DEFAULT_FIRMWARE);
+	pr_debug("%s: Waiting for firmware upload (%s)...\n",
+		 __func__, NXT2002_DEFAULT_FIRMWARE);
 	ret = request_firmware(&fw, NXT2002_DEFAULT_FIRMWARE,
 			       state->i2c->dev.parent);
-	printk("nxt2002: Waiting for firmware upload(2)...\n");
+	pr_debug("%s: Waiting for firmware upload(2)...\n", __func__);
 	if (ret) {
-		printk("nxt2002: No firmware uploaded (timeout or file not found?)\n");
+		pr_err("%s: No firmware uploaded (timeout or file not found?)"
+		       "\n", __func__);
 		return ret;
 	}
 
 	ret = nxt2002_load_firmware(fe, fw);
 	release_firmware(fw);
 	if (ret) {
-		printk("nxt2002: Writing firmware to device failed\n");
+		pr_err("%s: Writing firmware to device failed\n", __func__);
 		return ret;
 	}
-	printk("nxt2002: Firmware upload complete\n");
+	pr_info("%s: Firmware upload complete\n", __func__);
 
 	/* Put the micro into reset */
 	nxt200x_microcontroller_stop(state);
@@ -943,22 +945,24 @@ static int nxt2004_init(struct dvb_frontend* fe)
 	nxt200x_writebytes(state, 0x1E, buf, 1);
 
 	/* request the firmware, this will block until someone uploads it */
-	printk("nxt2004: Waiting for firmware upload (%s)...\n", NXT2004_DEFAULT_FIRMWARE);
+	pr_debug("%s: Waiting for firmware upload (%s)...\n",
+		 __func__, NXT2004_DEFAULT_FIRMWARE);
 	ret = request_firmware(&fw, NXT2004_DEFAULT_FIRMWARE,
 			       state->i2c->dev.parent);
-	printk("nxt2004: Waiting for firmware upload(2)...\n");
+	pr_debug("%s: Waiting for firmware upload(2)...\n", __func__);
 	if (ret) {
-		printk("nxt2004: No firmware uploaded (timeout or file not found?)\n");
+		pr_err("%s: No firmware uploaded (timeout or file not found?)"
+		       "\n", __func__);
 		return ret;
 	}
 
 	ret = nxt2004_load_firmware(fe, fw);
 	release_firmware(fw);
 	if (ret) {
-		printk("nxt2004: Writing firmware to device failed\n");
+		pr_err("%s: Writing firmware to device failed\n", __func__);
 		return ret;
 	}
-	printk("nxt2004: Firmware upload complete\n");
+	pr_info("%s: Firmware upload complete\n", __func__);
 
 	/* ensure transfer is complete */
 	buf[0] = 0x01;
@@ -1164,11 +1168,11 @@ struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 	switch (buf[0]) {
 		case 0x04:
 			state->demod_chip = NXT2002;
-			printk("nxt200x: NXT2002 Detected\n");
+			pr_info("NXT2002 Detected\n");
 			break;
 		case 0x05:
 			state->demod_chip = NXT2004;
-			printk("nxt200x: NXT2004 Detected\n");
+			pr_info("NXT2004 Detected\n");
 			break;
 		default:
 			goto error;
-- 
1.7.10.4

