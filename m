Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59153 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757041AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Buesch <m@bues.ch>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 57/57] [media] tuners: don't break long lines
Date: Fri, 14 Oct 2016 17:20:45 -0300
Message-Id: <0c366cfc8e931e913f717251222abd29777721d2.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/fc0011.c          |  7 ++----
 drivers/media/tuners/mc44s803.c        |  3 +--
 drivers/media/tuners/tda18271-common.c |  3 +--
 drivers/media/tuners/tda18271-fe.c     |  3 +--
 drivers/media/tuners/tda18271-maps.c   |  6 +-----
 drivers/media/tuners/tda8290.c         |  3 +--
 drivers/media/tuners/tea5761.c         |  6 ++----
 drivers/media/tuners/tuner-simple.c    | 39 ++++++++++++----------------------
 drivers/media/tuners/xc4000.c          | 25 +++++++---------------
 9 files changed, 30 insertions(+), 65 deletions(-)

diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 3932aa81e18c..2dda8d993c14 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -262,8 +262,7 @@ static int fc0011_set_params(struct dvb_frontend *fe)
 		regs[FC11_REG_VCOSEL] |= FC11_VCOSEL_BW7M;
 		break;
 	default:
-		dev_warn(&priv->i2c->dev, "Unsupported bandwidth %u kHz. "
-			 "Using 6000 kHz.\n",
+		dev_warn(&priv->i2c->dev, "Unsupported bandwidth %u kHz. Using 6000 kHz.\n",
 			 bandwidth);
 		bandwidth = 6000;
 		/* fallthrough */
@@ -435,9 +434,7 @@ static int fc0011_set_params(struct dvb_frontend *fe)
 	if (err)
 		return err;
 
-	dev_dbg(&priv->i2c->dev, "Tuned to "
-		"fa=%02X fp=%02X xin=%02X%02X vco=%02X vcosel=%02X "
-		"vcocal=%02X(%u) bw=%u\n",
+	dev_dbg(&priv->i2c->dev, "Tuned to fa=%02X fp=%02X xin=%02X%02X vco=%02X vcosel=%02X vcocal=%02X(%u) bw=%u\n",
 		(unsigned int)regs[FC11_REG_FA],
 		(unsigned int)regs[FC11_REG_FP],
 		(unsigned int)regs[FC11_REG_XINHI],
diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
index f1b764074661..cc0d5ae11eb9 100644
--- a/drivers/media/tuners/mc44s803.c
+++ b/drivers/media/tuners/mc44s803.c
@@ -349,8 +349,7 @@ struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
 	id = MC44S803_REG_MS(reg, MC44S803_ID);
 
 	if (id != 0x14) {
-		mc_printk(KERN_ERR, "unsupported ID "
-		       "(%x should be 0x14)\n", id);
+		mc_printk(KERN_ERR, "unsupported ID (%x should be 0x14)\n", id);
 		goto error;
 	}
 
diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
index a26bb33102b8..25c0ec42a1c6 100644
--- a/drivers/media/tuners/tda18271-common.c
+++ b/drivers/media/tuners/tda18271-common.c
@@ -251,8 +251,7 @@ static int __tda18271_write_regs(struct dvb_frontend *fe, int idx, int len,
 	}
 
 	if (ret != 1)
-		tda_err("ERROR: idx = 0x%x, len = %d, "
-			"i2c_transfer returned: %d\n", idx, max, ret);
+		tda_err("ERROR: idx = 0x%x, len = %d, i2c_transfer returned: %d\n", idx, max, ret);
 
 	return (ret == 1 ? 0 : ret);
 }
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 2d50e8b1dce1..a4730610c0c6 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -26,8 +26,7 @@
 
 int tda18271_debug;
 module_param_named(debug, tda18271_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debug level "
-		 "(info=1, map=2, reg=4, adv=8, cal=16 (or-able))");
+MODULE_PARM_DESC(debug, "set debug level (info=1, map=2, reg=4, adv=8, cal=16 (or-able))");
 
 static int tda18271_cal_on_startup = -1;
 module_param_named(cal, tda18271_cal_on_startup, int, 0644);
diff --git a/drivers/media/tuners/tda18271-maps.c b/drivers/media/tuners/tda18271-maps.c
index 1e89dd93c4bb..7d114677b4ca 100644
--- a/drivers/media/tuners/tda18271-maps.c
+++ b/drivers/media/tuners/tda18271-maps.c
@@ -1024,11 +1024,7 @@ int tda18271_lookup_rf_band(struct dvb_frontend *fe, u32 *freq, u8 *rf_band)
 
 	while ((map[i].rfmax * 1000) < *freq) {
 		if (tda18271_debug & DBG_ADV)
-			tda_map("(%d) rfmax = %d < freq = %d, "
-				"rf1_def = %d, rf2_def = %d, rf3_def = %d, "
-				"rf1 = %d, rf2 = %d, rf3 = %d, "
-				"rf_a1 = %d, rf_a2 = %d, "
-				"rf_b1 = %d, rf_b2 = %d\n",
+			tda_map("(%d) rfmax = %d < freq = %d, rf1_def = %d, rf2_def = %d, rf3_def = %d, rf1 = %d, rf2 = %d, rf3 = %d, rf_a1 = %d, rf_a2 = %d, rf_b1 = %d, rf_b2 = %d\n",
 				i, map[i].rfmax * 1000, *freq,
 				map[i].rf1_def, map[i].rf2_def, map[i].rf3_def,
 				map[i].rf1, map[i].rf2, map[i].rf3,
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 998e82bba9c0..1634a9e95602 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -617,8 +617,7 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 
 	if (tuner_addrs == 0) {
 		tuner_addrs = 0x60;
-		tuner_info("could not clearly identify tuner address, "
-			   "defaulting to %x\n", tuner_addrs);
+		tuner_info("could not clearly identify tuner address, defaulting to %x\n", tuner_addrs);
 	} else {
 		tuner_addrs = tuner_addrs & 0xff;
 		tuner_info("setting tuner address to %x\n", tuner_addrs);
diff --git a/drivers/media/tuners/tea5761.c b/drivers/media/tuners/tea5761.c
index 36b0b1e1d05b..12347aa95de3 100644
--- a/drivers/media/tuners/tea5761.c
+++ b/drivers/media/tuners/tea5761.c
@@ -274,13 +274,11 @@ int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr)
 	}
 
 	if ((buffer[13] != 0x2b) || (buffer[14] != 0x57) || (buffer[15] != 0x061)) {
-		printk(KERN_WARNING "Manufacturer ID= 0x%02x, Chip ID = %02x%02x."
-				    " It is not a TEA5761\n",
+		printk(KERN_WARNING "Manufacturer ID= 0x%02x, Chip ID = %02x%02x. It is not a TEA5761\n",
 				    buffer[13], buffer[14], buffer[15]);
 		return -EINVAL;
 	}
-	printk(KERN_WARNING "tea5761: TEA%02x%02x detected. "
-			    "Manufacturer ID= 0x%02x\n",
+	printk(KERN_WARNING "tea5761: TEA%02x%02x detected. Manufacturer ID= 0x%02x\n",
 			    buffer[14], buffer[15], buffer[13]);
 
 	return 0;
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 9ba9582e7765..60586593dd98 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -275,8 +275,7 @@ static int simple_config_lookup(struct dvb_frontend *fe,
 	*config = t_params->ranges[i].config;
 	*cb     = t_params->ranges[i].cb;
 
-	tuner_dbg("freq = %d.%02d (%d), range = %d, "
-		  "config = 0x%02x, cb = 0x%02x\n",
+	tuner_dbg("freq = %d.%02d (%d), range = %d, config = 0x%02x, cb = 0x%02x\n",
 		  *frequency / 16, *frequency % 16 * 100 / 16, *frequency,
 		  i, *config, *cb);
 
@@ -404,12 +403,10 @@ static int simple_std_setup(struct dvb_frontend *fe,
 		i2c.addr = 0x0a;
 		rc = tuner_i2c_xfer_send(&i2c, &buffer[0], 2);
 		if (2 != rc)
-			tuner_warn("i2c i/o error: rc == %d "
-				   "(should be 2)\n", rc);
+			tuner_warn("i2c i/o error: rc == %d (should be 2)\n", rc);
 		rc = tuner_i2c_xfer_send(&i2c, &buffer[2], 2);
 		if (2 != rc)
-			tuner_warn("i2c i/o error: rc == %d "
-				   "(should be 2)\n", rc);
+			tuner_warn("i2c i/o error: rc == %d (should be 2)\n", rc);
 		break;
 	}
 	}
@@ -463,8 +460,7 @@ static int simple_post_tune(struct dvb_frontend *fe, u8 *buffer,
 			rc = tuner_i2c_xfer_recv(&priv->i2c_props,
 						 &status_byte, 1);
 			if (1 != rc) {
-				tuner_warn("i2c i/o read error: rc == %d "
-					   "(should be 1)\n", rc);
+				tuner_warn("i2c i/o read error: rc == %d (should be 1)\n", rc);
 				break;
 			}
 			if (status_byte & TUNER_PLL_LOCKED)
@@ -483,8 +479,7 @@ static int simple_post_tune(struct dvb_frontend *fe, u8 *buffer,
 
 		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
 		if (4 != rc)
-			tuner_warn("i2c i/o error: rc == %d "
-				   "(should be 4)\n", rc);
+			tuner_warn("i2c i/o error: rc == %d (should be 4)\n", rc);
 		break;
 	}
 	}
@@ -499,8 +494,7 @@ static int simple_radio_bandswitch(struct dvb_frontend *fe, u8 *buffer)
 	switch (priv->type) {
 	case TUNER_TENA_9533_DI:
 	case TUNER_YMEC_TVF_5533MF:
-		tuner_dbg("This tuner doesn't have FM. "
-			  "Most cards have a TEA5767 for FM\n");
+		tuner_dbg("This tuner doesn't have FM. Most cards have a TEA5767 for FM\n");
 		return 0;
 	case TUNER_PHILIPS_FM1216ME_MK3:
 	case TUNER_PHILIPS_FM1236_MK3:
@@ -586,8 +580,7 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
 
 	div = params->frequency + IFPCoff + offset;
 
-	tuner_dbg("Freq= %d.%02d MHz, V_IF=%d.%02d MHz, "
-		  "Offset=%d.%02d MHz, div=%0d\n",
+	tuner_dbg("Freq= %d.%02d MHz, V_IF=%d.%02d MHz, Offset=%d.%02d MHz, div=%0d\n",
 		  params->frequency / 16, params->frequency % 16 * 100 / 16,
 		  IFPCoff / 16, IFPCoff % 16 * 100 / 16,
 		  offset / 16, offset % 16 * 100 / 16, div);
@@ -858,8 +851,7 @@ static u32 simple_dvb_configure(struct dvb_frontend *fe, u8 *buf,
 	if (!tun->stepsize) {
 		/* tuner-core was loaded before the digital tuner was
 		 * configured and somehow picked the wrong tuner type */
-		tuner_err("attempt to treat tuner %d (%s) as digital tuner "
-			  "without stepsize defined.\n",
+		tuner_err("attempt to treat tuner %d (%s) as digital tuner without stepsize defined.\n",
 			  priv->type, priv->tun->name);
 		return 0; /* failure */
 	}
@@ -1077,8 +1069,7 @@ struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 			fe->ops.i2c_gate_ctrl(fe, 1);
 
 		if (1 != i2c_transfer(i2c_adap, &msg, 1))
-			printk(KERN_WARNING "tuner-simple %d-%04x: "
-			       "unable to probe %s, proceeding anyway.",
+			printk(KERN_WARNING "tuner-simple %d-%04x: unable to probe %s, proceeding anyway.",
 			       i2c_adapter_id(i2c_adap), i2c_addr,
 			       tuners[type].name);
 
@@ -1123,18 +1114,14 @@ struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 	if ((debug) || ((atv_input[priv->nr] > 0) ||
 			(dtv_input[priv->nr] > 0))) {
 		if (0 == atv_input[priv->nr])
-			tuner_info("tuner %d atv rf input will be "
-				   "autoselected\n", priv->nr);
+			tuner_info("tuner %d atv rf input will be autoselected\n", priv->nr);
 		else
-			tuner_info("tuner %d atv rf input will be "
-				   "set to input %d (insmod option)\n",
+			tuner_info("tuner %d atv rf input will be set to input %d (insmod option)\n",
 				   priv->nr, atv_input[priv->nr]);
 		if (0 == dtv_input[priv->nr])
-			tuner_info("tuner %d dtv rf input will be "
-				   "autoselected\n", priv->nr);
+			tuner_info("tuner %d dtv rf input will be autoselected\n", priv->nr);
 		else
-			tuner_info("tuner %d dtv rf input will be "
-				   "set to input %d (insmod option)\n",
+			tuner_info("tuner %d dtv rf input will be set to input %d (insmod option)\n",
 				   priv->nr, dtv_input[priv->nr]);
 	}
 
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index d95c7e082ccf..ac98dea985c8 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -43,14 +43,11 @@ MODULE_PARM_DESC(debug, "Debugging level (0 to 2, default: 0 (off)).");
 
 static int no_poweroff;
 module_param(no_poweroff, int, 0644);
-MODULE_PARM_DESC(no_poweroff, "Power management (1: disabled, 2: enabled, "
-	"0 (default): use device-specific default mode).");
+MODULE_PARM_DESC(no_poweroff, "Power management (1: disabled, 2: enabled, 0 (default): use device-specific default mode).");
 
 static int audio_std;
 module_param(audio_std, int, 0644);
-MODULE_PARM_DESC(audio_std, "Audio standard. XC4000 audio decoder explicitly "
-	"needs to know what audio standard is needed for some video standards "
-	"with audio A2 or NICAM. The valid settings are a sum of:\n"
+MODULE_PARM_DESC(audio_std, "Audio standard. XC4000 audio decoder explicitly needs to know what audio standard is needed for some video standards with audio A2 or NICAM. The valid settings are a sum of:\n"
 	" 1: use NICAM/B or A2/B instead of NICAM/A or A2/A\n"
 	" 2: use A2 instead of NICAM or BTSC\n"
 	" 4: use SECAM/K3 instead of K1\n"
@@ -60,8 +57,7 @@ MODULE_PARM_DESC(audio_std, "Audio standard. XC4000 audio decoder explicitly "
 
 static char firmware_name[30];
 module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
-MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the "
-	"default firmware name.");
+MODULE_PARM_DESC(firmware_name, "Firmware file name. Allows overriding the default firmware name.");
 
 static DEFINE_MUTEX(xc4000_list_mutex);
 static LIST_HEAD(hybrid_tuner_instance_list);
@@ -290,8 +286,7 @@ static int xc4000_tuner_reset(struct dvb_frontend *fe)
 			return -EREMOTEIO;
 		}
 	} else {
-		printk(KERN_ERR "xc4000: no tuner reset callback function, "
-				"fatal\n");
+		printk(KERN_ERR "xc4000: no tuner reset callback function, fatal\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -679,8 +674,7 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 
 	if (best_nr_diffs > 0U) {
 		printk(KERN_WARNING
-		       "Selecting best matching firmware (%u bits differ) for "
-		       "type=(%x), id %016llx:\n",
+		       "Selecting best matching firmware (%u bits differ) for type=(%x), id %016llx:\n",
 		       best_nr_diffs, type, (unsigned long long)*id);
 		i = best_i;
 	}
@@ -800,8 +794,7 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 
 		n++;
 		if (n >= n_array) {
-			printk(KERN_ERR "More firmware images in file than "
-			       "were expected!\n");
+			printk(KERN_ERR "More firmware images in file than were expected!\n");
 			goto corrupt;
 		}
 
@@ -1055,8 +1048,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 		goto fail;
 	}
 
-	dprintk(1, "Device is Xceive %d version %d.%d, "
-		"firmware version %d.%d\n",
+	dprintk(1, "Device is Xceive %d version %d.%d, firmware version %d.%d\n",
 		hwmodel, hw_major, hw_minor, fw_major, fw_minor);
 
 	/* Check firmware version against what we downloaded. */
@@ -1076,8 +1068,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 	} else if (priv->hwmodel == 0 || priv->hwmodel != hwmodel ||
 		   priv->hwvers != ((hw_major << 8) | hw_minor)) {
 		printk(KERN_WARNING
-		       "Read invalid device hardware information - tuner "
-		       "hung?\n");
+		       "Read invalid device hardware information - tuner hung?\n");
 		goto fail;
 	}
 
-- 
2.7.4


