Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758779Ab2JZNk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 09:40:56 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] dvb: or51211: apply pr_fmt and use pr_* macros instead of printk
Date: Fri, 26 Oct 2012 16:40:46 +0300
Message-Id: <1351258846-17829-2-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1351258846-17829-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1351258846-17829-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb-frontends/or51211.c |   94 +++++++++++++++------------------
 1 file changed, 43 insertions(+), 51 deletions(-)

diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index 1af997e..9db8008 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -42,11 +42,11 @@
 #include "dvb_frontend.h"
 #include "or51211.h"
 
+#define pr_fmt(fmt)	KBUILD_MODNAME ": %s: " fmt, __func__
+
 static int debug;
 #define dprintk(args...) \
-	do { \
-		if (debug) printk(KERN_DEBUG "or51211: " args); \
-	} while (0)
+	do { if (debug) pr_debug(args); } while (0)
 
 static u8 run_buf[] = {0x7f,0x01};
 static u8 cmd_buf[] = {0x04,0x01,0x50,0x80,0x06}; // ATSC
@@ -80,8 +80,7 @@ static int i2c_writebytes (struct or51211_state* state, u8 reg, const u8 *buf,
 	msg.buf		= (u8 *)buf;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		printk(KERN_WARNING "or51211: i2c_writebytes error "
-		       "(addr %02x, err == %i)\n", reg, err);
+		pr_warn("error (addr %02x, err == %i)\n", reg, err);
 		return -EREMOTEIO;
 	}
 
@@ -98,8 +97,7 @@ static int i2c_readbytes(struct or51211_state *state, u8 reg, u8 *buf, int len)
 	msg.buf		= buf;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		printk(KERN_WARNING "or51211: i2c_readbytes error "
-		       "(addr %02x, err == %i)\n", reg, err);
+		pr_warn("error (addr %02x, err == %i)\n", reg, err);
 		return -EREMOTEIO;
 	}
 
@@ -118,11 +116,11 @@ static int or51211_load_firmware (struct dvb_frontend* fe,
 	/* Get eprom data */
 	tudata[0] = 17;
 	if (i2c_writebytes(state,0x50,tudata,1)) {
-		printk(KERN_WARNING "or51211:load_firmware error eprom addr\n");
+		pr_warn("error eprom addr\n");
 		return -1;
 	}
 	if (i2c_readbytes(state,0x50,&tudata[145],192)) {
-		printk(KERN_WARNING "or51211: load_firmware error eprom\n");
+		pr_warn("error eprom\n");
 		return -1;
 	}
 
@@ -136,32 +134,32 @@ static int or51211_load_firmware (struct dvb_frontend* fe,
 	state->config->reset(fe);
 
 	if (i2c_writebytes(state,state->config->demod_address,tudata,585)) {
-		printk(KERN_WARNING "or51211: load_firmware error 1\n");
+		pr_warn("error 1\n");
 		return -1;
 	}
 	msleep(1);
 
 	if (i2c_writebytes(state,state->config->demod_address,
 			   &fw->data[393],8125)) {
-		printk(KERN_WARNING "or51211: load_firmware error 2\n");
+		pr_warn("error 2\n");
 		return -1;
 	}
 	msleep(1);
 
 	if (i2c_writebytes(state,state->config->demod_address,run_buf,2)) {
-		printk(KERN_WARNING "or51211: load_firmware error 3\n");
+		pr_warn("error 3\n");
 		return -1;
 	}
 
 	/* Wait at least 5 msec */
 	msleep(10);
 	if (i2c_writebytes(state,state->config->demod_address,run_buf,2)) {
-		printk(KERN_WARNING "or51211: load_firmware error 4\n");
+		pr_warn("error 4\n");
 		return -1;
 	}
 	msleep(10);
 
-	printk("or51211: Done.\n");
+	pr_info("Done.\n");
 	return 0;
 };
 
@@ -173,14 +171,14 @@ static int or51211_setmode(struct dvb_frontend* fe, int mode)
 	state->config->setmode(fe, mode);
 
 	if (i2c_writebytes(state,state->config->demod_address,run_buf,2)) {
-		printk(KERN_WARNING "or51211: setmode error 1\n");
+		pr_warn("error 1\n");
 		return -1;
 	}
 
 	/* Wait at least 5 msec */
 	msleep(10);
 	if (i2c_writebytes(state,state->config->demod_address,run_buf,2)) {
-		printk(KERN_WARNING "or51211: setmode error 2\n");
+		pr_warn("error 2\n");
 		return -1;
 	}
 
@@ -196,7 +194,7 @@ static int or51211_setmode(struct dvb_frontend* fe, int mode)
 	 *             normal +/-150kHz Carrier acquisition range
 	 */
 	if (i2c_writebytes(state,state->config->demod_address,cmd_buf,3)) {
-		printk(KERN_WARNING "or51211: setmode error 3\n");
+		pr_warn("error 3\n");
 		return -1;
 	}
 
@@ -206,14 +204,14 @@ static int or51211_setmode(struct dvb_frontend* fe, int mode)
 	rec_buf[3] = 0x00;
 	msleep(20);
 	if (i2c_writebytes(state,state->config->demod_address,rec_buf,3)) {
-		printk(KERN_WARNING "or51211: setmode error 5\n");
+		pr_warn("error 5\n");
 	}
 	msleep(3);
 	if (i2c_readbytes(state,state->config->demod_address,&rec_buf[10],2)) {
-		printk(KERN_WARNING "or51211: setmode error 6");
+		pr_warn("error 6\n");
 		return -1;
 	}
-	dprintk("setmode rec status %02x %02x\n",rec_buf[10],rec_buf[11]);
+	dprintk("rec status %02x %02x\n", rec_buf[10], rec_buf[11]);
 
 	return 0;
 }
@@ -248,15 +246,15 @@ static int or51211_read_status(struct dvb_frontend* fe, fe_status_t* status)
 
 	/* Receiver Status */
 	if (i2c_writebytes(state,state->config->demod_address,snd_buf,3)) {
-		printk(KERN_WARNING "or51132: read_status write error\n");
+		pr_warn("write error\n");
 		return -1;
 	}
 	msleep(3);
 	if (i2c_readbytes(state,state->config->demod_address,rec_buf,2)) {
-		printk(KERN_WARNING "or51132: read_status read error\n");
+		pr_warn("read error\n");
 		return -1;
 	}
-	dprintk("read_status %x %x\n",rec_buf[0],rec_buf[1]);
+	dprintk("%x %x\n", rec_buf[0], rec_buf[1]);
 
 	if (rec_buf[0] &  0x01) { /* Receiver Lock */
 		*status |= FE_HAS_SIGNAL;
@@ -306,20 +304,18 @@ static int or51211_read_snr(struct dvb_frontend* fe, u16* snr)
 	snd_buf[2] = 0x04;
 
 	if (i2c_writebytes(state,state->config->demod_address,snd_buf,3)) {
-		printk(KERN_WARNING "%s: error writing snr reg\n",
-		       __func__);
+		pr_warn("error writing snr reg\n");
 		return -1;
 	}
 	if (i2c_readbytes(state,state->config->demod_address,rec_buf,2)) {
-		printk(KERN_WARNING "%s: read_status read error\n",
-		       __func__);
+		pr_warn("read_status read error\n");
 		return -1;
 	}
 
 	state->snr = calculate_snr(rec_buf[0], 89599047);
 	*snr = (state->snr) >> 16;
 
-	dprintk("%s: noise = 0x%02x, snr = %d.%02d dB\n", __func__, rec_buf[0],
+	dprintk("noise = 0x%02x, snr = %d.%02d dB\n", rec_buf[0],
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -375,25 +371,24 @@ static int or51211_init(struct dvb_frontend* fe)
 
 	if (!state->initialized) {
 		/* Request the firmware, this will block until it uploads */
-		printk(KERN_INFO "or51211: Waiting for firmware upload "
-		       "(%s)...\n", OR51211_DEFAULT_FIRMWARE);
+		pr_info("Waiting for firmware upload (%s)...\n",
+			OR51211_DEFAULT_FIRMWARE);
 		ret = config->request_firmware(fe, &fw,
 					       OR51211_DEFAULT_FIRMWARE);
-		printk(KERN_INFO "or51211:Got Hotplug firmware\n");
+		pr_info("Got Hotplug firmware\n");
 		if (ret) {
-			printk(KERN_WARNING "or51211: No firmware uploaded "
-			       "(timeout or file not found?)\n");
+			pr_warn("No firmware uploaded "
+				"(timeout or file not found?)\n");
 			return ret;
 		}
 
 		ret = or51211_load_firmware(fe, fw);
 		release_firmware(fw);
 		if (ret) {
-			printk(KERN_WARNING "or51211: Writing firmware to "
-			       "device failed!\n");
+			pr_warn("Writing firmware to device failed!\n");
 			return ret;
 		}
-		printk(KERN_INFO "or51211: Firmware upload complete.\n");
+		pr_info("Firmware upload complete.\n");
 
 		/* Set operation mode in Receiver 1 register;
 		 * type 1:
@@ -406,7 +401,7 @@ static int or51211_init(struct dvb_frontend* fe)
 		 */
 		if (i2c_writebytes(state,state->config->demod_address,
 				   cmd_buf,3)) {
-			printk(KERN_WARNING "or51211: Load DVR Error 5\n");
+			pr_warn("Load DVR Error 5\n");
 			return -1;
 		}
 
@@ -419,13 +414,13 @@ static int or51211_init(struct dvb_frontend* fe)
 		msleep(30);
 		if (i2c_writebytes(state,state->config->demod_address,
 				   rec_buf,3)) {
-			printk(KERN_WARNING "or51211: Load DVR Error A\n");
+			pr_warn("Load DVR Error A\n");
 			return -1;
 		}
 		msleep(3);
 		if (i2c_readbytes(state,state->config->demod_address,
 				  &rec_buf[10],2)) {
-			printk(KERN_WARNING "or51211: Load DVR Error B\n");
+			pr_warn("Load DVR Error B\n");
 			return -1;
 		}
 
@@ -436,13 +431,13 @@ static int or51211_init(struct dvb_frontend* fe)
 		msleep(20);
 		if (i2c_writebytes(state,state->config->demod_address,
 				   rec_buf,3)) {
-			printk(KERN_WARNING "or51211: Load DVR Error C\n");
+			pr_warn("Load DVR Error C\n");
 			return -1;
 		}
 		msleep(3);
 		if (i2c_readbytes(state,state->config->demod_address,
 				  &rec_buf[12],2)) {
-			printk(KERN_WARNING "or51211: Load DVR Error D\n");
+			pr_warn("Load DVR Error D\n");
 			return -1;
 		}
 
@@ -454,16 +449,14 @@ static int or51211_init(struct dvb_frontend* fe)
 			get_ver_buf[4] = i+1;
 			if (i2c_writebytes(state,state->config->demod_address,
 					   get_ver_buf,5)) {
-				printk(KERN_WARNING "or51211:Load DVR Error 6"
-				       " - %d\n",i);
+				pr_warn("Load DVR Error 6 - %d\n", i);
 				return -1;
 			}
 			msleep(3);
 
 			if (i2c_readbytes(state,state->config->demod_address,
 					  &rec_buf[i*2],2)) {
-				printk(KERN_WARNING "or51211:Load DVR Error 7"
-				       " - %d\n",i);
+				pr_warn("Load DVR Error 7 - %d\n", i);
 				return -1;
 			}
 			/* If we didn't receive the right index, try again */
@@ -473,10 +466,9 @@ static int or51211_init(struct dvb_frontend* fe)
 		}
 		dprintk("read_fwbits %10ph\n", rec_buf);
 
-		printk(KERN_INFO "or51211: ver TU%02x%02x%02x VSB mode %02x"
-		       " Status %02x\n",
-		       rec_buf[2], rec_buf[4],rec_buf[6],
-		       rec_buf[12],rec_buf[10]);
+		pr_info("ver TU%02x%02x%02x VSB mode %02x Status %02x\n",
+			rec_buf[2], rec_buf[4], rec_buf[6], rec_buf[12],
+			rec_buf[10]);
 
 		rec_buf[0] = 0x04;
 		rec_buf[1] = 0x00;
@@ -485,13 +477,13 @@ static int or51211_init(struct dvb_frontend* fe)
 		msleep(20);
 		if (i2c_writebytes(state,state->config->demod_address,
 				   rec_buf,3)) {
-			printk(KERN_WARNING "or51211: Load DVR Error 8\n");
+			pr_warn("Load DVR Error 8\n");
 			return -1;
 		}
 		msleep(20);
 		if (i2c_readbytes(state,state->config->demod_address,
 				  &rec_buf[8],2)) {
-			printk(KERN_WARNING "or51211: Load DVR Error 9\n");
+			pr_warn("Load DVR Error 9\n");
 			return -1;
 		}
 		state->initialized = 1;
-- 
1.7.10.4

