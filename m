Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37505 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZFFCDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 22:03:45 -0400
Subject: [PATCH v2] tuner-simple, tveeprom: Add support for the FQ1216LME
 MK3
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Dmitri Belimov <d.belimov@gmail.com>, Ant <ant@symons.net.au>,
	Martin Dauskardt <martin.dauskardt@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Discussion list for development of the IVTV driver
	<ivtv-devel@ivtvdriver.org>
In-Reply-To: <1244238732.4440.15.camel@palomino.walls.org>
References: <200905210909.43333.martin.dauskardt@gmx.de>
	 <1243389830.4046.52.camel@palomino.walls.org>
	 <4A1CB353.7020906@symons.net.au>  <200905270809.53056.hverkuil@xs4all.nl>
	 <1243502498.3722.17.camel@pc07.localdom.local>
	 <1244238732.4440.15.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 21:59:41 -0400
Message-Id: <1244253581.3140.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is version 2 of the patch that:

1. adds explicit support for the FQ1216LME MK3

2. points the tveeprom module to the FQ1216LME MK3 entry for EEPROMs
claiming FQ1216LME MK3 and MK5.

3. refactors some code in simple_post_tune() because
I needed to set the Auxillary Byte, as did TUNER_LG_TDVS_H06XF, so I
could set the TUA6030 TOP to external AGC per the datasheet.


The patch no longer twiddles the CP bit nor polls the FL bit for the
FQ1216LME.  That will be something for another patch.


Any other comments?

Regards,
Andy

Signed-off-by: Andy Walls <awalls@radix.net>

diff -r e4b4291847b8 linux/drivers/media/common/tuners/tuner-simple.c
--- a/linux/drivers/media/common/tuners/tuner-simple.c	Tue Jun 02 19:40:03 2009 -0400
+++ b/linux/drivers/media/common/tuners/tuner-simple.c	Fri Jun 05 21:46:13 2009 -0400
@@ -423,6 +423,24 @@
 	return 0;
 }
 
+static int simple_set_aux_byte(struct dvb_frontend *fe, u8 config, u8 aux)
+{
+	struct tuner_simple_priv *priv = fe->tuner_priv;
+	int rc;
+	u8 buffer[2];
+
+	buffer[0] = (config & ~0x38) | 0x18;
+	buffer[1] = aux;
+
+	tuner_dbg("setting aux byte: 0x%02x 0x%02x\n", buffer[0], buffer[1]);
+
+	rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 2);
+	if (2 != rc)
+		tuner_warn("i2c i/o error: rc == %d (should be 2)\n", rc);
+
+	return rc == 2 ? 0 : rc;
+}
+
 static int simple_post_tune(struct dvb_frontend *fe, u8 *buffer,
 			    u16 div, u8 config, u8 cb)
 {
@@ -431,30 +449,10 @@
 
 	switch (priv->type) {
 	case TUNER_LG_TDVS_H06XF:
-		/* Set the Auxiliary Byte. */
-#if 0
-		buffer[2] &= ~0x20;
-		buffer[2] |= 0x18;
-		buffer[3] = 0x20;
-		tuner_dbg("tv 0x%02x 0x%02x 0x%02x 0x%02x\n",
-			  buffer[0], buffer[1], buffer[2], buffer[3]);
-
-		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 4);
-		if (4 != rc)
-			tuner_warn("i2c i/o error: rc == %d "
-				   "(should be 4)\n", rc);
-#else
-		buffer[0] = buffer[2];
-		buffer[0] &= ~0x20;
-		buffer[0] |= 0x18;
-		buffer[1] = 0x20;
-		tuner_dbg("tv 0x%02x 0x%02x\n", buffer[0], buffer[1]);
-
-		rc = tuner_i2c_xfer_send(&priv->i2c_props, buffer, 2);
-		if (2 != rc)
-			tuner_warn("i2c i/o error: rc == %d "
-				   "(should be 2)\n", rc);
-#endif
+		simple_set_aux_byte(fe, config, 0x20);
+		break;
+	case TUNER_PHILIPS_FQ1216LME_MK3:
+		simple_set_aux_byte(fe, config, 0x60); /* External AGC */
 		break;
 	case TUNER_MICROTUNE_4042FI5:
 	{
@@ -526,6 +524,11 @@
 	case TUNER_THOMSON_DTT761X:
 		buffer[3] = 0x39;
 		break;
+	case TUNER_PHILIPS_FQ1216LME_MK3:
+		tuner_err("This tuner doesn't have FM\n");
+		/* Set the low band for sanity, since it covers 88-108 MHz */
+		buffer[3] = 0x01;
+		break;
 	case TUNER_MICROTUNE_4049FM5:
 	default:
 		buffer[3] = 0xa4;
diff -r e4b4291847b8 linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Tue Jun 02 19:40:03 2009 -0400
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Fri Jun 05 21:46:13 2009 -0400
@@ -1280,6 +1280,28 @@
 	},
 };
 
+/* 80-89 */
+/* --------- TUNER_PHILIPS_FQ1216LME_MK3 -- active loopthrough, no FM ------- */
+
+static struct tuner_params tuner_fq1216lme_mk3_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_fm1216me_mk3_pal_ranges,
+		.count  = ARRAY_SIZE(tuner_fm1216me_mk3_pal_ranges),
+		.cb_first_if_lower_freq = 1, /* not specified, but safe to do */
+		.has_tda9887 = 1, /* TDA9886 */
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.default_top_low = 4,
+		.default_top_mid = 4,
+		.default_top_high = 4,
+		.default_top_secam_low = 4,
+		.default_top_secam_mid = 4,
+		.default_top_secam_high = 4,
+	},
+};
+
 /* --------------------------------------------------------------------- */
 
 struct tunertype tuners[] = {
@@ -1725,6 +1747,13 @@
 		.params = tuner_fm1216mk5_params,
 		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
 	},
+
+	/* 80-89 */
+	[TUNER_PHILIPS_FQ1216LME_MK3] = { /* PAL/SECAM, Loop-thru, no FM */
+		.name = "Philips FQ1216LME MK3 PAL/SECAM w/active loopthrough",
+		.params = tuner_fq1216lme_mk3_params,
+		.count  = ARRAY_SIZE(tuner_fq1216lme_mk3_params),
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r e4b4291847b8 linux/drivers/media/video/tveeprom.c
--- a/linux/drivers/media/video/tveeprom.c	Tue Jun 02 19:40:03 2009 -0400
+++ b/linux/drivers/media/video/tveeprom.c	Fri Jun 05 21:46:13 2009 -0400
@@ -185,7 +185,7 @@
 	{ TUNER_ABSENT,        		"Silicon TDA8275C1 8290 FM"},
 	{ TUNER_ABSENT,        		"Thompson DTT757"},
 	/* 80-89 */
-	{ TUNER_PHILIPS_FM1216ME_MK3, 	"Philips FQ1216LME MK3"},
+	{ TUNER_PHILIPS_FQ1216LME_MK3, 	"Philips FQ1216LME MK3"},
 	{ TUNER_LG_PAL_NEW_TAPC, 	"LG TAPC G701D"},
 	{ TUNER_LG_NTSC_NEW_TAPC, 	"LG TAPC H791F"},
 	{ TUNER_LG_PAL_NEW_TAPC, 	"TCL 2002MB 3"},
@@ -230,7 +230,7 @@
 	{ TUNER_ABSENT,        		"Samsung THPD5222FG30A"},
 	/* 120-129 */
 	{ TUNER_XC2028,        		"Xceive XC3028"},
-	{ TUNER_ABSENT,        		"Philips FQ1216LME MK5"},
+	{ TUNER_PHILIPS_FQ1216LME_MK3,	"Philips FQ1216LME MK5"},
 	{ TUNER_ABSENT,        		"Philips FQD1216LME"},
 	{ TUNER_ABSENT,        		"Conexant CX24118A"},
 	{ TUNER_ABSENT,        		"TCL DMF11WIP"},
diff -r e4b4291847b8 linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Tue Jun 02 19:40:03 2009 -0400
+++ b/linux/include/media/tuner.h	Fri Jun 05 21:46:13 2009 -0400
@@ -125,6 +125,7 @@
 #define TUNER_TCL_MF02GIP_5N		77	/* TCL MF02GIP_5N */
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
 #define TUNER_PHILIPS_FM1216MK5		79
+#define TUNER_PHILIPS_FQ1216LME_MK3	80	/* Active loopthrough, no FM */
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)


