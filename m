Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33097 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZELBPt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 21:15:49 -0400
Received: by bwz22 with SMTP id 22so2994552bwz.37
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 18:15:49 -0700 (PDT)
Date: Mon, 11 May 2009 21:16:06 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH] Start support Philips MK5 tuner
Message-ID: <20090511211606.315ae629@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/meO3VsjpZAVKP8Fod374hSx"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/meO3VsjpZAVKP8Fod374hSx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

I start support Philips MK5 tuner

diff -r 19b8f124911c linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Thu May 07 12:30:01 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue May 12 06:14:24 2009 +1000
@@ -567,6 +567,31 @@
 		.type   = TUNER_PARAM_TYPE_PAL,
 		.ranges = tuner_fm1216me_mk3_pal_ranges,
 		.count  = ARRAY_SIZE(tuner_fm1216me_mk3_pal_ranges),
+		.cb_first_if_lower_freq = 1,
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.port1_fm_high_sensitivity = 1,
+		.default_top_mid = -2,
+		.default_top_secam_mid = -2,
+		.default_top_secam_high = -2,
+	},
+};
+
+/* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------ */
+
+static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
+	{ 16 * 158.00 /*MHz*/, 0xce, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xce, 0x02, },
+	{ 16 * 864.00        , 0xce, 0x04, },
+};
+
+static struct tuner_params tuner_fm1216mk5_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_fm1216mk5_pal_ranges,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
 		.cb_first_if_lower_freq = 1,
 		.has_tda9887 = 1,
 		.port1_active = 1,
@@ -1695,6 +1720,11 @@
 		.initdata = tua603x_agc112,
 		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 	},
+		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
+		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
+		.params = tuner_fm1216mk5_params,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r 19b8f124911c linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Thu May 07 12:30:01 2009 +0000
+++ b/linux/include/media/tuner.h	Tue May 12 06:14:24 2009 +1000
@@ -124,6 +124,7 @@
 #define TUNER_XC5000			76	/* Xceive Silicon Tuner */
 #define TUNER_TCL_MF02GIP_5N		77	/* TCL MF02GIP_5N */
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
+#define TUNER_PHILIPS_FM1216MK5		79
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/meO3VsjpZAVKP8Fod374hSx
Content-Type: text/x-patch; name=behold_mk5.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk5.patch

diff -r 19b8f124911c linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Thu May 07 12:30:01 2009 +0000
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue May 12 06:14:24 2009 +1000
@@ -567,6 +567,31 @@
 		.type   = TUNER_PARAM_TYPE_PAL,
 		.ranges = tuner_fm1216me_mk3_pal_ranges,
 		.count  = ARRAY_SIZE(tuner_fm1216me_mk3_pal_ranges),
+		.cb_first_if_lower_freq = 1,
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_active = 1,
+		.port2_invert_for_secam_lc = 1,
+		.port1_fm_high_sensitivity = 1,
+		.default_top_mid = -2,
+		.default_top_secam_mid = -2,
+		.default_top_secam_high = -2,
+	},
+};
+
+/* ------------ TUNER_PHILIPS_FM1216MK5 - Philips PAL ------------ */
+
+static struct tuner_range tuner_fm1216mk5_pal_ranges[] = {
+	{ 16 * 158.00 /*MHz*/, 0xce, 0x01, },
+	{ 16 * 441.00 /*MHz*/, 0xce, 0x02, },
+	{ 16 * 864.00        , 0xce, 0x04, },
+};
+
+static struct tuner_params tuner_fm1216mk5_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_fm1216mk5_pal_ranges,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_pal_ranges),
 		.cb_first_if_lower_freq = 1,
 		.has_tda9887 = 1,
 		.port1_active = 1,
@@ -1695,6 +1720,11 @@
 		.initdata = tua603x_agc112,
 		.sleepdata = (u8[]){ 4, 0x9c, 0x60, 0x85, 0x54 },
 	},
+		[TUNER_PHILIPS_FM1216MK5] = { /* Philips PAL */
+		.name   = "Philips PAL/SECAM multi (FM1216 MK5)",
+		.params = tuner_fm1216mk5_params,
+		.count  = ARRAY_SIZE(tuner_fm1216mk5_params),
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff -r 19b8f124911c linux/include/media/tuner.h
--- a/linux/include/media/tuner.h	Thu May 07 12:30:01 2009 +0000
+++ b/linux/include/media/tuner.h	Tue May 12 06:14:24 2009 +1000
@@ -124,6 +124,7 @@
 #define TUNER_XC5000			76	/* Xceive Silicon Tuner */
 #define TUNER_TCL_MF02GIP_5N		77	/* TCL MF02GIP_5N */
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
+#define TUNER_PHILIPS_FM1216MK5		79
 
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/meO3VsjpZAVKP8Fod374hSx--
