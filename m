Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbbEHMBl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 08:01:41 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Shuah Khan <shuah.kh@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Cheolhyun Park <pch851130@gmail.com>,
	Benoit Taine <benoit.taine@lip6.fr>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: replace bellow -> below
Date: Fri,  8 May 2015 09:01:28 -0300
Message-Id: <65116e50702f631e14a8d3ded91637faaac6a319.1431086474.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bellow is yelling. Ok, sometimes the code is yells a lot, but
but this is not the case there ;)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 1d60d200d9ab..41f2a3939979 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -78,7 +78,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	dev->dev.parent = coredev->device;
 
 #if 0
-	/* TODO: properly initialize the parameters bellow */
+	/* TODO: properly initialize the parameters below */
 	dev->input_id.bustype = BUS_USB;
 	dev->input_id.version = 1;
 	dev->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 61f76038442a..52245354bf04 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -9541,7 +9541,7 @@ ctrl_get_qam_sig_quality(struct drx_demod_instance *demod)
 	/* ----------------------------------------- */
 	/* Pre Viterbi Symbol Error Rate Calculation */
 	/* ----------------------------------------- */
-	/* pre viterbi SER is good if it is bellow 0.025 */
+	/* pre viterbi SER is good if it is below 0.025 */
 
 	/* get the register value */
 	/*   no of quadrature symbol errors */
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index d46cf5f7cd2e..ad35264a3819 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -544,7 +544,7 @@ error:
 static int init_state(struct drxk_state *state)
 {
 	/*
-	 * FIXME: most (all?) of the values bellow should be moved into
+	 * FIXME: most (all?) of the values below should be moved into
 	 * struct drxk_config, as they are probably board-specific
 	 */
 	u32 ul_vsb_if_agc_mode = DRXK_AGC_CTRL_AUTO;
diff --git a/drivers/media/dvb-frontends/tda10021.c b/drivers/media/dvb-frontends/tda10021.c
index 1bff7f457e19..28d987068048 100644
--- a/drivers/media/dvb-frontends/tda10021.c
+++ b/drivers/media/dvb-frontends/tda10021.c
@@ -258,7 +258,7 @@ static int tda10021_set_parameters(struct dvb_frontend *fe)
 	}
 
 	/*
-	 * gcc optimizes the code bellow the same way as it would code:
+	 * gcc optimizes the code below the same way as it would code:
 	 *           "if (qam > 5) return -EINVAL;"
 	 * Yet, the code is clearer, as it shows what QAM standards are
 	 * supported by the driver, and avoids the usage of magic numbers on
diff --git a/drivers/media/dvb-frontends/tda10023.c b/drivers/media/dvb-frontends/tda10023.c
index ca1e0d54b69a..f92fbbbb4a71 100644
--- a/drivers/media/dvb-frontends/tda10023.c
+++ b/drivers/media/dvb-frontends/tda10023.c
@@ -331,7 +331,7 @@ static int tda10023_set_parameters(struct dvb_frontend *fe)
 	}
 
 	/*
-	 * gcc optimizes the code bellow the same way as it would code:
+	 * gcc optimizes the code below the same way as it would code:
 	 *		 "if (qam > 5) return -EINVAL;"
 	 * Yet, the code is clearer, as it shows what QAM standards are
 	 * supported by the driver, and avoids the usage of magic numbers on
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 070c152da95a..0c50e5285cf6 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -272,7 +272,7 @@ static int chip_cmd(struct CHIPSTATE *chip, char *name, audiocmd *cmd)
 		return -EINVAL;
 	}
 
-	/* FIXME: it seems that the shadow bytes are wrong bellow !*/
+	/* FIXME: it seems that the shadow bytes are wrong below !*/
 
 	/* update our shadow register set; print bytes if (debug > 0) */
 	v4l2_dbg(1, debug, sd, "chip_cmd(%s): reg=%d, data:",
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index d12f5e4ad8bf..4e941f00b600 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1094,7 +1094,7 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 		 * Still need tests for XC3028L (firmware 3.2 or upper)
 		 * So, for now, let's just comment the per-firmware
 		 * version of this change. Reports with xc3028l working
-		 * with and without the lines bellow are welcome
+		 * with and without the lines below are welcome
 		 */
 
 		if (priv->firm_version < 0x0302) {
-- 
2.1.0

