Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr750095.outbound.protection.outlook.com ([40.107.75.95]:17888
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726094AbeKUHOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 02:14:25 -0500
From: Ken Sloat <KSloat@aampglobal.com>
To: "eugen.hristev@microchip.com" <eugen.hristev@microchip.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "ludovic.desroches@microchip.com" <ludovic.desroches@microchip.com>
Subject: [PATCH v1 1/1] media: atmel-isc: Add safety checks for NULL
 isc->raw_fmt struct
Date: Tue, 20 Nov 2018 20:43:20 +0000
Message-ID: <20181120204309.42339-1-ksloat@aampglobal.com>
References: <6d1f98c0-31be-9b89-db2e-c1813ed2975d@microchip.com>
In-Reply-To: <6d1f98c0-31be-9b89-db2e-c1813ed2975d@microchip.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ken Sloat <ksloat@aampglobal.com>

In some usages isc->raw_fmt will not be initialized. If this
is the case, it is very possible that a NULL struct de-reference
will occur, as this member is referenced many times.

To prevent this, add safety checks for this member and handle
situations accordingly.

Signed-off-by: Ken Sloat <ksloat@aampglobal.com>
---
 drivers/media/platform/atmel/atmel-isc.c | 64 ++++++++++++++++--------
 1 file changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platf=
orm/atmel/atmel-isc.c
index 50178968b8a6..4cccaa4f2ce9 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -902,6 +902,15 @@ static inline bool sensor_is_preferred(const struct is=
c_format *isc_fmt)
 		!isc_fmt->isc_support;
 }
=20
+static inline u32 get_preferred_mbus_code(const struct isc_device *isc,
+		const struct isc_format *isc_fmt)
+{
+	if (sensor_is_preferred(isc_fmt) || !isc->raw_fmt)
+		return isc_fmt->mbus_code;
+	else
+		return isc->raw_fmt->mbus_code;
+}
+
 static struct fmt_config *get_fmt_config(u32 fourcc)
 {
 	struct fmt_config *config;
@@ -955,7 +964,7 @@ static void isc_set_pipeline(struct isc_device *isc, u3=
2 pipeline)
 {
 	struct regmap *regmap =3D isc->regmap;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
+	struct fmt_config *config;
 	u32 val, bay_cfg;
 	const u32 *gamma;
 	unsigned int i;
@@ -969,7 +978,12 @@ static void isc_set_pipeline(struct isc_device *isc, u=
32 pipeline)
 	if (!pipeline)
 		return;
=20
-	bay_cfg =3D config->cfa_baycfg;
+	if (isc->raw_fmt) {
+		config =3D get_fmt_config(isc->raw_fmt->fourcc);
+		bay_cfg =3D config->cfa_baycfg;
+	} else {
+		bay_cfg =3D 0;
+	}
=20
 	regmap_write(regmap, ISC_WB_CFG, bay_cfg);
 	regmap_write(regmap, ISC_WB_O_RGR, 0x0);
@@ -1022,12 +1036,20 @@ static void isc_set_histogram(struct isc_device *is=
c)
 {
 	struct regmap *regmap =3D isc->regmap;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
+	struct fmt_config *config;
+	u32	cfa_baycfg;
+
+	if (isc->raw_fmt) {
+		config =3D get_fmt_config(isc->raw_fmt->fourcc);
+		cfa_baycfg =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
+	} else {
+		cfa_baycfg =3D 0;
+	}
=20
 	if (ctrls->awb && (ctrls->hist_stat !=3D HIST_ENABLED)) {
 		regmap_write(regmap, ISC_HIS_CFG,
 			     ISC_HIS_CFG_MODE_R |
-			     (config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT) |
+				 cfa_baycfg |
 			     ISC_HIS_CFG_RAR);
 		regmap_write(regmap, ISC_HIS_CTRL, ISC_HIS_CTRL_EN);
 		regmap_write(regmap, ISC_INTEN, ISC_INT_HISDONE);
@@ -1075,7 +1097,7 @@ static int isc_configure(struct isc_device *isc)
 	struct regmap *regmap =3D isc->regmap;
 	const struct isc_format *current_fmt =3D isc->current_fmt;
 	struct fmt_config *curfmt_config =3D get_fmt_config(current_fmt->fourcc);
-	struct fmt_config *rawfmt_config =3D get_fmt_config(isc->raw_fmt->fourcc)=
;
+	struct fmt_config *rawfmt_config;
 	struct isc_subdev_entity *subdev =3D isc->current_subdev;
 	u32 pfe_cfg0, rlp_mode, dcfg, mask, pipeline;
=20
@@ -1085,7 +1107,12 @@ static int isc_configure(struct isc_device *isc)
 		isc_get_param(current_fmt, &rlp_mode, &dcfg);
 		isc->ctrls.hist_stat =3D HIST_INIT;
 	} else {
-		pfe_cfg0 =3D rawfmt_config->pfe_cfg0_bps;
+		if (isc->raw_fmt) {
+			rawfmt_config =3D get_fmt_config(isc->raw_fmt->fourcc);
+			pfe_cfg0 =3D rawfmt_config->pfe_cfg0_bps;
+		} else {
+			pfe_cfg0 =3D curfmt_config->pfe_cfg0_bps;
+		}
 		pipeline =3D curfmt_config->bits_pipeline;
 		rlp_mode =3D curfmt_config->rlp_cfg_mode;
 		dcfg =3D curfmt_config->dcfg_imode |
@@ -1315,10 +1342,7 @@ static int isc_try_fmt(struct isc_device *isc, struc=
t v4l2_format *f,
 	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
 		pixfmt->height =3D ISC_MAX_SUPPORT_HEIGHT;
=20
-	if (sensor_is_preferred(isc_fmt))
-		mbus_code =3D isc_fmt->mbus_code;
-	else
-		mbus_code =3D isc->raw_fmt->mbus_code;
+	mbus_code =3D get_preferred_mbus_code(isc, isc_fmt);
=20
 	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
@@ -1442,10 +1466,7 @@ static int isc_enum_framesizes(struct file *file, vo=
id *fh,
 	if (!isc_fmt)
 		return -EINVAL;
=20
-	if (sensor_is_preferred(isc_fmt))
-		fse.code =3D isc_fmt->mbus_code;
-	else
-		fse.code =3D isc->raw_fmt->mbus_code;
+	fse.code =3D get_preferred_mbus_code(isc, isc_fmt);
=20
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad, enum_frame_size,
 			       NULL, &fse);
@@ -1476,10 +1497,7 @@ static int isc_enum_frameintervals(struct file *file=
, void *fh,
 	if (!isc_fmt)
 		return -EINVAL;
=20
-	if (sensor_is_preferred(isc_fmt))
-		fie.code =3D isc_fmt->mbus_code;
-	else
-		fie.code =3D isc->raw_fmt->mbus_code;
+	fie.code =3D get_preferred_mbus_code(isc, isc_fmt);
=20
 	ret =3D v4l2_subdev_call(isc->current_subdev->sd, pad,
 			       enum_frame_interval, NULL, &fie);
@@ -1668,7 +1686,7 @@ static void isc_awb_work(struct work_struct *w)
 	struct isc_device *isc =3D
 		container_of(w, struct isc_device, awb_work);
 	struct regmap *regmap =3D isc->regmap;
-	struct fmt_config *config =3D get_fmt_config(isc->raw_fmt->fourcc);
+	struct fmt_config *config;
 	struct isc_ctrls *ctrls =3D &isc->ctrls;
 	u32 hist_id =3D ctrls->hist_id;
 	u32 baysel;
@@ -1686,7 +1704,13 @@ static void isc_awb_work(struct work_struct *w)
 	}
=20
 	ctrls->hist_id =3D hist_id;
-	baysel =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
+
+	if (isc->raw_fmt) {
+		config =3D get_fmt_config(isc->raw_fmt->fourcc);
+		baysel =3D config->cfa_baycfg << ISC_HIS_CFG_BAYSEL_SHIFT;
+	} else {
+		baysel =3D 0;
+	}
=20
 	pm_runtime_get_sync(isc->dev);
=20
--=20
2.17.1
