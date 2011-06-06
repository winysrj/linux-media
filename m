Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab1FFTxW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 15:53:22 -0400
Message-ID: <4DED302D.1090707@redhat.com>
Date: Mon, 06 Jun 2011 16:53:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Subject: PATCH] [media] xc4000: make checkpatch.pl happy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

While here, remove a few printk noise by converting some msgs
into debug ones.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
index 479c198..634f4d9 100644
--- a/drivers/media/common/tuners/xc4000.c
+++ b/drivers/media/common/tuners/xc4000.c
@@ -244,8 +244,8 @@ static struct XC_TV_STANDARD xc4000_standard[MAX_TV_STANDARD] = {
 	{"DTV8",		0x00C0, 0x800B,    0},
 	{"DTV7/8",		0x00C0, 0x801B,    0},
 	{"DTV7",		0x00C0, 0x8007,    0},
-	{"FM Radio-INPUT2",	0x0008, 0x9800,10700},
-	{"FM Radio-INPUT1",	0x0008, 0x9000,10700}
+	{"FM Radio-INPUT2",	0x0008, 0x9800, 10700},
+	{"FM Radio-INPUT1",	0x0008, 0x9000, 10700}
 };
 
 static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val);
@@ -261,7 +261,7 @@ static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
 			printk(KERN_ERR "xc4000: I2C write failed (len=%i)\n",
 			       len);
 			if (len == 4) {
-				printk("bytes %02x %02x %02x %02x\n", buf[0],
+				printk(KERN_ERR "bytes %02x %02x %02x %02x\n", buf[0],
 				       buf[1], buf[2], buf[3]);
 			}
 			return -EREMOTEIO;
@@ -546,7 +546,7 @@ static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val)
 	};
 
 	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
-		printk(KERN_WARNING "xc4000: I2C read failed\n");
+		printk(KERN_ERR "xc4000: I2C read failed\n");
 		return -EREMOTEIO;
 	}
 
@@ -558,67 +558,67 @@ static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val)
 static void dump_firm_type_and_int_freq(unsigned int type, u16 int_freq)
 {
 	 if (type & BASE)
-		printk("BASE ");
+		printk(KERN_CONT "BASE ");
 	 if (type & INIT1)
-		printk("INIT1 ");
+		printk(KERN_CONT "INIT1 ");
 	 if (type & F8MHZ)
-		printk("F8MHZ ");
+		printk(KERN_CONT "F8MHZ ");
 	 if (type & MTS)
-		printk("MTS ");
+		printk(KERN_CONT "MTS ");
 	 if (type & D2620)
-		printk("D2620 ");
+		printk(KERN_CONT "D2620 ");
 	 if (type & D2633)
-		printk("D2633 ");
+		printk(KERN_CONT "D2633 ");
 	 if (type & DTV6)
-		printk("DTV6 ");
+		printk(KERN_CONT "DTV6 ");
 	 if (type & QAM)
-		printk("QAM ");
+		printk(KERN_CONT "QAM ");
 	 if (type & DTV7)
-		printk("DTV7 ");
+		printk(KERN_CONT "DTV7 ");
 	 if (type & DTV78)
-		printk("DTV78 ");
+		printk(KERN_CONT "DTV78 ");
 	 if (type & DTV8)
-		printk("DTV8 ");
+		printk(KERN_CONT "DTV8 ");
 	 if (type & FM)
-		printk("FM ");
+		printk(KERN_CONT "FM ");
 	 if (type & INPUT1)
-		printk("INPUT1 ");
+		printk(KERN_CONT "INPUT1 ");
 	 if (type & LCD)
-		printk("LCD ");
+		printk(KERN_CONT "LCD ");
 	 if (type & NOGD)
-		printk("NOGD ");
+		printk(KERN_CONT "NOGD ");
 	 if (type & MONO)
-		printk("MONO ");
+		printk(KERN_CONT "MONO ");
 	 if (type & ATSC)
-		printk("ATSC ");
+		printk(KERN_CONT "ATSC ");
 	 if (type & IF)
-		printk("IF ");
+		printk(KERN_CONT "IF ");
 	 if (type & LG60)
-		printk("LG60 ");
+		printk(KERN_CONT "LG60 ");
 	 if (type & ATI638)
-		printk("ATI638 ");
+		printk(KERN_CONT "ATI638 ");
 	 if (type & OREN538)
-		printk("OREN538 ");
+		printk(KERN_CONT "OREN538 ");
 	 if (type & OREN36)
-		printk("OREN36 ");
+		printk(KERN_CONT "OREN36 ");
 	 if (type & TOYOTA388)
-		printk("TOYOTA388 ");
+		printk(KERN_CONT "TOYOTA388 ");
 	 if (type & TOYOTA794)
-		printk("TOYOTA794 ");
+		printk(KERN_CONT "TOYOTA794 ");
 	 if (type & DIBCOM52)
-		printk("DIBCOM52 ");
+		printk(KERN_CONT "DIBCOM52 ");
 	 if (type & ZARLINK456)
-		printk("ZARLINK456 ");
+		printk(KERN_CONT "ZARLINK456 ");
 	 if (type & CHINA)
-		printk("CHINA ");
+		printk(KERN_CONT "CHINA ");
 	 if (type & F6MHZ)
-		printk("F6MHZ ");
+		printk(KERN_CONT "F6MHZ ");
 	 if (type & INPUT2)
-		printk("INPUT2 ");
+		printk(KERN_CONT "INPUT2 ");
 	 if (type & SCODE)
-		printk("SCODE ");
+		printk(KERN_CONT "SCODE ");
 	 if (type & HAS_IF)
-		printk("HAS_IF_%d ", int_freq);
+		printk(KERN_CONT "HAS_IF_%d ", int_freq);
 }
 
 static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
@@ -666,7 +666,8 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 	}
 
 	if (best_nr_diffs > 0U) {
-		printk("Selecting best matching firmware (%u bits differ) for "
+		printk(KERN_WARNING
+		       "Selecting best matching firmware (%u bits differ) for "
 		       "type=(%x), id %016llx:\n",
 		       best_nr_diffs, type, (unsigned long long)*id);
 		i = best_i;
@@ -677,10 +678,10 @@ found:
 
 ret:
 	if (debug) {
-		printk("%s firmware for type=",
+		printk(KERN_DEBUG "%s firmware for type=",
 		       (i < 0) ? "Can't find" : "Found");
 		dump_firm_type(type);
-		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
+		printk(KERN_DEBUG "(%x), id %016llx.\n", type, (unsigned long long)*id);
 	}
 	return i;
 }
@@ -723,13 +724,13 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 	else
 		fname = XC4000_DEFAULT_FIRMWARE;
 
-	printk("Reading firmware %s\n",  fname);
+	dprintk(1, "Reading firmware %s\n", fname);
 	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);
 	if (rc < 0) {
 		if (rc == -ENOENT)
-			printk("Error: firmware %s not found.\n", fname);
+			printk(KERN_ERR "Error: firmware %s not found.\n", fname);
 		else
-			printk("Error %d while requesting firmware %s \n",
+			printk(KERN_ERR "Error %d while requesting firmware %s\n",
 			       rc, fname);
 
 		return rc;
@@ -738,7 +739,8 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 	endp = p + fw->size;
 
 	if (fw->size < sizeof(name) - 1 + 2 + 2) {
-		printk("Error: firmware file %s has invalid size!\n", fname);
+		printk(KERN_ERR "Error: firmware file %s has invalid size!\n",
+		       fname);
 		goto corrupt;
 	}
 
@@ -758,9 +760,9 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 
 	priv->firm = kzalloc(sizeof(*priv->firm) * n_array, GFP_KERNEL);
 	if (priv->firm == NULL) {
-		printk("Not enough memory to load firmware file.\n");
+		printk(KERN_ERR "Not enough memory to load firmware file.\n");
 		rc = -ENOMEM;
-		goto err;
+		goto done;
 	}
 	priv->firm_size = n_array;
 
@@ -772,7 +774,7 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 
 		n++;
 		if (n >= n_array) {
-			printk("More firmware images in file than "
+			printk(KERN_ERR "More firmware images in file than "
 			       "were expected!\n");
 			goto corrupt;
 		}
@@ -798,8 +800,7 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 		p += sizeof(size);
 
 		if (!size || size > endp - p) {
-			printk("Firmware type (%x), id %llx is corrupted "
-			       "(size=%d, expected %d)\n",
+			printk(KERN_ERR "Firmware type (%x), id %llx is corrupted (size=%d, expected %d)\n",
 			       type, (unsigned long long)id,
 			       (unsigned)(endp - p), size);
 			goto corrupt;
@@ -807,15 +808,15 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 
 		priv->firm[n].ptr = kzalloc(size, GFP_KERNEL);
 		if (priv->firm[n].ptr == NULL) {
-			printk("Not enough memory to load firmware file.\n");
+			printk(KERN_ERR "Not enough memory to load firmware file.\n");
 			rc = -ENOMEM;
-			goto err;
+			goto done;
 		}
 
 		if (debug) {
-			printk("Reading firmware type ");
+			printk(KERN_DEBUG "Reading firmware type ");
 			dump_firm_type_and_int_freq(type, int_freq);
-			printk("(%x), id %llx, size=%d.\n",
+			printk(KERN_DEBUG "(%x), id %llx, size=%d.\n",
 			       type, (unsigned long long)id, size);
 		}
 
@@ -829,20 +830,17 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 	}
 
 	if (n + 1 != priv->firm_size) {
-		printk("Firmware file is incomplete!\n");
+		printk(KERN_ERR "Firmware file is incomplete!\n");
 		goto corrupt;
 	}
 
 	goto done;
 
 header:
-	printk("Firmware header is incomplete!\n");
+	printk(KERN_ERR "Firmware header is incomplete!\n");
 corrupt:
 	rc = -EINVAL;
-	printk("Error: firmware file is corrupted!\n");
-
-err:
-	printk("Releasing partially loaded firmware file.\n");
+	printk(KERN_ERR "Error: firmware file is corrupted!\n");
 
 done:
 	release_firmware(fw);
@@ -883,11 +881,13 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 		return -EINVAL;
 	p += 12 * scode;
 
-	tuner_info("Loading SCODE for type=");
-	dump_firm_type_and_int_freq(priv->firm[pos].type,
-				    priv->firm[pos].int_freq);
-	printk("(%x), id %016llx.\n", priv->firm[pos].type,
-	       (unsigned long long)*id);
+	if (debug) {
+		tuner_info("Loading SCODE for type=");
+		dump_firm_type_and_int_freq(priv->firm[pos].type,
+					    priv->firm[pos].int_freq);
+		printk(KERN_CONT "(%x), id %016llx.\n", priv->firm[pos].type,
+		       (unsigned long long)*id);
+	}
 
 	scode_buf[0] = 0x00;
 	memcpy(&scode_buf[1], p, 12);
@@ -895,7 +895,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 	/* Enter direct-mode */
 	rc = xc_write_reg(priv, XREG_DIRECTSITTING_MODE, 0);
 	if (rc < 0) {
-		printk("failed to put device into direct mode!\n");
+		printk(KERN_ERR "failed to put device into direct mode!\n");
 		return -EIO;
 	}
 
@@ -903,7 +903,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 	if (rc != 0) {
 		/* Even if the send failed, make sure we set back to indirect
 		   mode */
-		printk("Failed to set scode %d\n", rc);
+		printk(KERN_ERR "Failed to set scode %d\n", rc);
 	}
 
 	/* Switch back to indirect-mode */
@@ -944,7 +944,7 @@ retry:
 	dprintk(1, "checking firmware, user requested type=");
 	if (debug) {
 		dump_firm_type(new_fw.type);
-		printk("(%x), id %016llx, ", new_fw.type,
+		printk(KERN_CONT "(%x), id %016llx, ", new_fw.type,
 		       (unsigned long long)new_fw.std_req);
 		if (!int_freq)
 			printk(KERN_CONT "scode_tbl ");
@@ -971,7 +971,7 @@ retry:
 	std0 = 0;
 	rc = load_firmware(fe, BASE, &std0);
 	if (rc < 0) {
-		printk("Error %d while loading base firmware\n", rc);
+		printk(KERN_ERR "Error %d while loading base firmware\n", rc);
 		goto fail;
 	}
 
@@ -1025,7 +1025,7 @@ check_device:
 
 	if (xc_get_version(priv, &hw_major, &hw_minor, &fw_major,
 			   &fw_minor) != 0) {
-		printk("Unable to read tuner registers.\n");
+		printk(KERN_ERR "Unable to read tuner registers.\n");
 		goto fail;
 	}
 
@@ -1340,11 +1340,10 @@ static int xc4000_set_analog_params(struct dvb_frontend *fe,
 	if (params->std & V4L2_STD_PAL_I) {
 		/* default to NICAM audio standard */
 		params->std = V4L2_STD_PAL_I | V4L2_STD_NICAM;
-		if (audio_std & XC4000_AUDIO_STD_MONO) {
+		if (audio_std & XC4000_AUDIO_STD_MONO)
 			priv->video_standard = XC4000_I_PAL_NICAM_MONO;
-		} else {
+		else
 			priv->video_standard = XC4000_I_PAL_NICAM;
-		}
 		goto tune_channel;
 	}
 
diff --git a/drivers/media/common/tuners/xc4000.h b/drivers/media/common/tuners/xc4000.h
index 442cb0f..e6a44d1 100644
--- a/drivers/media/common/tuners/xc4000.h
+++ b/drivers/media/common/tuners/xc4000.h
@@ -50,8 +50,7 @@ struct xc4000_config {
  * it's passed back to a bridge during tuner_callback().
  */
 
-#if defined(CONFIG_MEDIA_TUNER_XC4000) || \
-    (defined(CONFIG_MEDIA_TUNER_XC4000_MODULE) && defined(MODULE))
+#if defined(CONFIG_MEDIA_TUNER_XC4000) || (defined(CONFIG_MEDIA_TUNER_XC4000_MODULE) && defined(MODULE))
 extern struct dvb_frontend *xc4000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct xc4000_config *cfg);
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index ae0abc5..d0ea5b6 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2794,7 +2794,7 @@ static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
 	tun_i2c = dib7000p_get_i2c_master(adap->fe,
 					  DIBX000_I2C_INTERFACE_TUNER, 1);
 	if (tun_i2c == NULL) {
-		printk("Could not reach tuner i2c bus\n");
+		printk(KERN_ERR "Could not reach tuner i2c bus\n");
 		return 0;
 	}
 

