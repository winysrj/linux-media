Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4063 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3CKLqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/42] tuner: add Sony BTF tuners
Date: Mon, 11 Mar 2013 12:45:46 +0100
Message-Id: <a1e6fd16a40c140c406f31862979ae2dfd4d057b.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds support for three Sony BTF tuners:

TUNER_SONY_BTF_PG472Z: PAL+SECAM
TUNER_SONY_BTF_PK467Z: NTSC-M-JP
TUNER_SONY_BTF_PB463Z: NTSC-M

These come from the go7007 staging driver where they were implemented in
the wis-sony-tuner i2c driver.

Adding support for these tuners to tuner-types.c is the first step towards
removing the wis-sony-tuner driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/CARDLIST.tuner   |    3 ++
 drivers/media/tuners/tuner-types.c         |   69 ++++++++++++++++++++++++++++
 drivers/staging/media/go7007/go7007-usb.c  |    1 +
 drivers/staging/media/go7007/go7007-v4l2.c |    1 +
 drivers/staging/media/go7007/wis-i2c.h     |    6 ---
 include/media/tuner.h                      |    4 ++
 6 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.tuner b/Documentation/video4linux/CARDLIST.tuner
index c83f6e4..5b83a3f 100644
--- a/Documentation/video4linux/CARDLIST.tuner
+++ b/Documentation/video4linux/CARDLIST.tuner
@@ -86,3 +86,6 @@ tuner=85 - Philips FQ1236 MK5
 tuner=86 - Tena TNF5337 MFD
 tuner=87 - Xceive 4000 tuner
 tuner=88 - Xceive 5000C tuner
+tuner=89 - Sony PAL+SECAM (BTF-PG472Z)
+tuner=90 - Sony NTSC-M-JP (BTF-PK467Z)
+tuner=91 - Sony NTSC-M (BTF-PB463Z)
diff --git a/drivers/media/tuners/tuner-types.c b/drivers/media/tuners/tuner-types.c
index 2da4440..98bc15a 100644
--- a/drivers/media/tuners/tuner-types.c
+++ b/drivers/media/tuners/tuner-types.c
@@ -1381,6 +1381,58 @@ static struct tuner_params tuner_philips_fq1236_mk5_params[] = {
 	},
 };
 
+/* --------- Sony BTF-PG472Z PAL/SECAM ------- */
+
+static struct tuner_range tuner_sony_btf_pg472z_ranges[] = {
+	{ 16 * 144.25 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 427.25 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 999.99        , 0xc6, 0x04, },
+};
+
+static struct tuner_params tuner_sony_btf_pg472z_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_PAL,
+		.ranges = tuner_sony_btf_pg472z_ranges,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg472z_ranges),
+		.has_tda9887 = 1,
+		.port1_active = 1,
+		.port2_invert_for_secam_lc = 1,
+	},
+};
+
+/* 90-99 */
+/* --------- Sony BTF-PG467Z NTSC-M-JP ------- */
+
+static struct tuner_range tuner_sony_btf_pg467z_ranges[] = {
+	{ 16 * 220.25 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 467.25 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 999.99        , 0xc6, 0x04, },
+};
+
+static struct tuner_params tuner_sony_btf_pg467z_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_NTSC,
+		.ranges = tuner_sony_btf_pg467z_ranges,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg467z_ranges),
+	},
+};
+
+/* --------- Sony BTF-PG463Z NTSC-M ------- */
+
+static struct tuner_range tuner_sony_btf_pg463z_ranges[] = {
+	{ 16 * 130.25 /*MHz*/, 0xc6, 0x01, },
+	{ 16 * 364.25 /*MHz*/, 0xc6, 0x02, },
+	{ 16 * 999.99        , 0xc6, 0x04, },
+};
+
+static struct tuner_params tuner_sony_btf_pg463z_params[] = {
+	{
+		.type   = TUNER_PARAM_TYPE_NTSC,
+		.ranges = tuner_sony_btf_pg463z_ranges,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg463z_ranges),
+	},
+};
+
 /* --------------------------------------------------------------------- */
 
 struct tunertype tuners[] = {
@@ -1872,6 +1924,23 @@ struct tunertype tuners[] = {
 		.name   = "Xceive 5000C tuner",
 		/* see xc5000.c for details */
 	},
+	[TUNER_SONY_BTF_PG472Z] = {
+		.name   = "Sony BTF-PG472Z PAL/SECAM",
+		.params = tuner_sony_btf_pg472z_params,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg472z_params),
+	},
+
+	/* 90-99 */
+	[TUNER_SONY_BTF_PK467Z] = {
+		.name   = "Sony BTF-PK467Z NTSC-M-JP",
+		.params = tuner_sony_btf_pg467z_params,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg467z_params),
+	},
+	[TUNER_SONY_BTF_PB463Z] = {
+		.name   = "Sony BTF-PB463Z NTSC-M",
+		.params = tuner_sony_btf_pg463z_params,
+		.count  = ARRAY_SIZE(tuner_sony_btf_pg463z_params),
+	},
 };
 EXPORT_SYMBOL(tuners);
 
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 914b247..3333a8f 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <asm/byteorder.h>
 #include <media/tvaudio.h>
+#include <media/tuner.h>
 
 #include "go7007-priv.h"
 #include "wis-i2c.h"
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index cb9fe33..e115132 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1238,6 +1238,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (!go->i2c_adapter_online)
 		return -EIO;
 
+	strlcpy(t->name, "Tuner", sizeof(t->name));
 	return call_all(&go->v4l2_dev, tuner, g_tuner, t);
 }
 
diff --git a/drivers/staging/media/go7007/wis-i2c.h b/drivers/staging/media/go7007/wis-i2c.h
index 6d09c06..97763db 100644
--- a/drivers/staging/media/go7007/wis-i2c.h
+++ b/drivers/staging/media/go7007/wis-i2c.h
@@ -34,9 +34,3 @@ struct video_decoder_resolution {
 
 #define	DECODER_SET_RESOLUTION	_IOW('d', 200, struct video_decoder_resolution)
 #define	DECODER_SET_CHANNEL	_IOW('d', 201, int)
-
-/* Sony tuner types */
-
-#define TUNER_SONY_BTF_PG472Z		200
-#define TUNER_SONY_BTF_PK467Z		201
-#define TUNER_SONY_BTF_PB463Z		202
diff --git a/include/media/tuner.h b/include/media/tuner.h
index 926aff9..24eaafe 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -138,6 +138,10 @@
 #define TUNER_XC4000			87	/* Xceive Silicon Tuner */
 #define TUNER_XC5000C			88	/* Xceive Silicon Tuner */
 
+#define TUNER_SONY_BTF_PG472Z		89	/* PAL+SECAM */
+#define TUNER_SONY_BTF_PK467Z		90	/* NTSC_JP */
+#define TUNER_SONY_BTF_PB463Z		91	/* NTSC */
+
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)
 #define TDA9887_PORT1_INACTIVE 		(1<<1)
-- 
1.7.10.4

