Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36518 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdF1T5Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 15:57:25 -0400
Received: by mail-lf0-f43.google.com with SMTP id h22so41132872lfk.3
        for <linux-media@vger.kernel.org>; Wed, 28 Jun 2017 12:57:25 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-Id: <20170628195719.333514117@cogentembedded.com>
Date: Wed, 28 Jun 2017 22:56:23 +0300
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v3] media: platform: rcar_imr: add IMR-LSX3 support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=media-platform-rcar_imr-add-IMR-LSX3-support-v3.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the image renderer light SRAM extended 3 (IMR-LSX3) found
only in the R-Car V2H (R8A7792) SoC.  It differs  from IMR-LX4 in that it
supports only planar video formats but can use the video capture data for
the textures.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch  is against the 'media_tree.git' repo's 'master' branch plus the
latest version of the Renesas IMR driver...

Changes in version 3:
- fixed compilation errors, resolved rejects, refreshed the patch atop of the
  IMR driver patch (version 6).

Changes in version 2:
- renamed *enum* 'imr_gen' to 'imr_type' and the *struct* field of this type
  from 'gen' to 'type';
- rename *struct* 'imr_type' to 'imr_info' and the fields/variables of this type
  from 'type' to 'info';
- added comments to IMR-LX4 only CMRCR2 bits;
- added IMR type check to the WTS instruction writing to CMRCCR2.

 Documentation/devicetree/bindings/media/rcar_imr.txt |   11 +-
 drivers/media/platform/rcar_imr.c                    |  101 +++++++++++++++----
 2 files changed, 92 insertions(+), 20 deletions(-)

Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
===================================================================
--- media_tree.orig/Documentation/devicetree/bindings/media/rcar_imr.txt
+++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
@@ -8,9 +8,14 @@ and drawing with respect to any shape th
 
 Required properties:
 
-- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for
-  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs,
-  where the examples with <soctype> are:
+- compatible:
+  "renesas,<soctype>-imr-lsx3", "renesas,imr-lsx3" as a fallback for the image
+  renderer light SRAM extended 3 (IMR-LSX3) found in the R-Car gen2 SoCs, where
+  the examples with <soctype> are:
+  - "renesas,r8a7792-imr-lsx3" for R-Car V2H;
+  "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a fallback for the image
+  renderer light extended 4 (IMR-LX4) found in the R-Car gen3 SoCs, where the
+  examples with <soctype> are:
   - "renesas,r8a7795-imr-lx4" for R-Car H3,
   - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
 - reg: offset and length of the register block;
Index: media_tree/drivers/media/platform/rcar_imr.c
===================================================================
--- media_tree.orig/drivers/media/platform/rcar_imr.c
+++ media_tree/drivers/media/platform/rcar_imr.c
@@ -1,5 +1,5 @@
 /*
- * rcar_imr.c -- R-Car IMR-LX4 Driver
+ * rcar_imr.c -- R-Car IMR-LSX3/LX4 Driver
  *
  * Copyright (C) 2015-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
  *
@@ -14,7 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
+#include <linux/of_device.h>
 #include <linux/rcar_imr.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -81,8 +81,21 @@ struct imr_format_info {
 	u32			flags;
 };
 
+enum imr_type {
+	IMR_LSX3,
+	IMR_LX4,
+};
+
+/* IMR type specific data */
+struct imr_info {
+	enum imr_type		type;
+	const struct imr_format_info *formats;
+	unsigned int		num_formats;
+};
+
 /* per-device data */
 struct imr_device {
+	const struct imr_info	*info;
 	struct device		*dev;
 	struct clk		*clock;
 	void __iomem		*mmio;
@@ -190,6 +203,7 @@ struct imr_ctx {
 #define IMR_IMR_IEM		BIT(1)
 #define IMR_IMR_INM		BIT(2)
 
+#define IMR_CMRCR_TXTM		BIT(0)		/* IMR-LSX3 only */
 #define IMR_CMRCR_LUCE		BIT(1)
 #define IMR_CMRCR_CLCE		BIT(2)
 #define IMR_CMRCR_DUV_SHIFT	3
@@ -229,11 +243,11 @@ struct imr_ctx {
 #define IMR_CPDPOR_YLDPO	GENMASK(10, 8)
 
 #define IMR_CMRCR2_LUTE		BIT(0)
-#define IMR_CMRCR2_YUV422E	BIT(2)
-#define IMR_CMRCR2_YUV422FORM	BIT(5)
-#define IMR_CMRCR2_UVFORM	BIT(6)
-#define IMR_CMRCR2_TCTE		BIT(12)
-#define IMR_CMRCR2_DCTE		BIT(15)
+#define IMR_CMRCR2_YUV422E	BIT(2)		/* IMR-LX4 only */
+#define IMR_CMRCR2_YUV422FORM	BIT(5)		/* IMR-LX4 only */
+#define IMR_CMRCR2_UVFORM	BIT(6)		/* IMR-LX4 only */
+#define IMR_CMRCR2_TCTE		BIT(12)		/* IMR-LX4 only */
+#define IMR_CMRCR2_DCTE		BIT(15)		/* IMR-LX4 only */
 
 /*******************************************************************************
  * Display list commands
@@ -292,6 +306,29 @@ static u32 __imr_flags_common(u32 iflags
 	return iflags & oflags & IMR_F_PLANES_MASK;
 }
 
+static const struct imr_format_info imr_lsx3_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_NV16,
+		.flags	= IMR_F_Y8 | IMR_F_UV8 | IMR_F_PLANAR,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_GREY,
+		.flags	= IMR_F_Y8 | IMR_F_PLANAR,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_Y10,
+		.flags	= IMR_F_Y8 | IMR_F_Y10 | IMR_F_PLANAR,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_Y12,
+		.flags	= IMR_F_Y8 | IMR_F_Y10 | IMR_F_Y12 | IMR_F_PLANAR,
+	},
+	{
+		.fourcc	= V4L2_PIX_FMT_UV8,
+		.flags	= IMR_F_UV8 | IMR_F_PLANAR,
+	},
+};
+
 static const struct imr_format_info imr_lx4_formats[] = {
 	{
 		.fourcc	= V4L2_PIX_FMT_NV16,
@@ -335,6 +372,18 @@ static const struct imr_format_info imr_
 	},
 };
 
+static const struct imr_info imr_lsx3 = {
+	.type		= IMR_LSX3,
+	.formats	= imr_lsx3_formats,
+	.num_formats	= ARRAY_SIZE(imr_lsx3_formats),
+};
+
+static const struct imr_info imr_lx4 = {
+	.type		= IMR_LX4,
+	.formats	= imr_lx4_formats,
+	.num_formats	= ARRAY_SIZE(imr_lx4_formats),
+};
+
 /* mesh configuration constructor */
 static struct imr_cfg *imr_cfg_create(struct imr_ctx *ctx,
 				      u32 dl_size, u32 dl_start)
@@ -735,7 +784,8 @@ static void imr_dl_program_setup(struct
 		 "setup %ux%u -> %ux%u mapping (type=%x)\n", w, h, W, H, type);
 
 	/* set triangle mode register from user-supplied descriptor */
-	*dl++ = IMR_OP_WTS(IMR_TRIMCR, 0x004F);
+	*dl++ = IMR_OP_WTS(IMR_TRIMCR,
+			   ctx->imr->info->type == IMR_LX4 ? 0x004F : 0x007F);
 
 	/* set automatic source/destination coordinates generation flags */
 	*dl++ = IMR_OP_WTS(IMR_TRIMSR, __imr_auto_sg_dg_tcm(type) |
@@ -749,7 +799,8 @@ static void imr_dl_program_setup(struct
 
 	/* reset rendering mode registers */
 	*dl++ = IMR_OP_WTS(IMR_CMRCCR,  0xDBFE);
-	*dl++ = IMR_OP_WTS(IMR_CMRCCR2, 0x9065);
+	*dl++ = IMR_OP_WTS(IMR_CMRCCR2, ctx->imr->info->type == IMR_LX4 ?
+			   0x9065 : IMR_CMRCR2_LUTE);
 
 	/* set source/destination addresses of Y/UV plane */
 	*dl++ = IMR_OP_WTL(IMR_DSAR, 2);
@@ -791,7 +842,7 @@ static void imr_dl_program_setup(struct
 			*dl++ = IMR_OP_WTS(IMR_SSTR,
 					   w << (iflags & IMR_F_UV10 ? 1 : 0));
 		}
-	} else {
+	} else if (ctx->imr->info->type == IMR_LX4) {
 		u16 src_fmt = (iflags & IMR_F_UV_SWAP ? IMR_CMRCR2_UVFORM : 0) |
 			      (iflags & IMR_F_YUV_SWAP ?
 			       IMR_CMRCR2_YUV422FORM : 0);
@@ -832,6 +883,9 @@ static void imr_dl_program_setup(struct
 			*dl++ = IMR_OP_WTS(IMR_DSTR,
 					   W << (cflags & IMR_F_Y10 ? 2 : 1));
 		}
+	} else	{
+		/* this shouldn't happen! */
+		BUG();
 	}
 
 	/*
@@ -1071,6 +1125,7 @@ out:
 /* test if a format is supported */
 static int __imr_try_fmt(struct imr_ctx *ctx, struct v4l2_format *f)
 {
+	const struct imr_info	*info = ctx->imr->info;
 	struct v4l2_pix_format	*pix = &f->fmt.pix;
 	u32			fourcc = pix->pixelformat;
 	int			i;
@@ -1079,8 +1134,8 @@ static int __imr_try_fmt(struct imr_ctx
 	 * both output and capture interface have the same set of
 	 * supported formats
 	 */
-	for (i = 0; i < ARRAY_SIZE(imr_lx4_formats); i++) {
-		if (fourcc == imr_lx4_formats[i].fourcc) {
+	for (i = 0; i < info->num_formats; i++) {
+		if (fourcc == info->formats[i].fourcc) {
 			/* fix up format specification as needed */
 			pix->field = V4L2_FIELD_NONE;
 
@@ -1126,9 +1181,12 @@ static int imr_querycap(struct file *fil
 /* enumerate supported formats */
 static int imr_enum_fmt(struct file *file, void *priv, struct v4l2_fmtdesc *f)
 {
+	struct imr_ctx		*ctx = fh_to_ctx(priv);
+	const struct imr_info	*info = ctx->imr->info;
+
 	/* no distinction between output/capture formats */
-	if (f->index < ARRAY_SIZE(imr_lx4_formats)) {
-		f->pixelformat = imr_lx4_formats[f->index].fourcc;
+	if (f->index < info->num_formats) {
+		f->pixelformat = info->formats[f->index].fourcc;
 		return 0;
 	}
 
@@ -1195,7 +1253,7 @@ static int imr_s_fmt(struct file *file,
 
 	/* processing is locked? TBD */
 	q_data->fmt = f->fmt.pix;
-	q_data->flags = imr_lx4_formats[i].flags;
+	q_data->flags = ctx->imr->info->formats[i].flags;
 
 	/* set default compose factors */
 	if (!V4L2_TYPE_IS_OUTPUT(f->type)) {
@@ -1553,6 +1611,8 @@ static void imr_device_run(void *priv)
 	wmb();
 
 	/* start rendering operation */
+	if (imr->info->type != IMR_LX4)
+		iowrite32(IMR_CMRCR_TXTM, imr->mmio + IMR_CMRCSR);
 	iowrite32(IMR_CR_RS, imr->mmio + IMR_CR);
 
 	/* timestamp input buffer */
@@ -1707,16 +1767,22 @@ handled:
 
 static int imr_probe(struct platform_device *pdev)
 {
+	const struct imr_info	*info;
 	struct imr_device	*imr;
 	struct resource		*res;
 	int			ret;
 
+	info = of_device_get_match_data(&pdev->dev);
+	if (!info)
+		return -ENODEV;
+
 	imr = devm_kzalloc(&pdev->dev, sizeof(*imr), GFP_KERNEL);
 	if (!imr)
 		return -ENOMEM;
 
 	mutex_init(&imr->mutex);
 	spin_lock_init(&imr->lock);
+	imr->info = info;
 	imr->dev = &pdev->dev;
 
 	/* memory-mapped registers */
@@ -1853,7 +1919,8 @@ static const struct dev_pm_ops imr_pm_op
 
 /* device table */
 static const struct of_device_id imr_of_match[] = {
-	{ .compatible = "renesas,imr-lx4" },
+	{ .compatible = "renesas,imr-lsx3", .data = &imr_lsx3, },
+	{ .compatible = "renesas,imr-lx4",  .data = &imr_lx4,  },
 	{ },
 };
 
@@ -1873,5 +1940,5 @@ module_platform_driver(imr_platform_driv
 
 MODULE_ALIAS("imr");
 MODULE_AUTHOR("Cogent Embedded Inc. <sources@cogentembedded.com>");
-MODULE_DESCRIPTION("Renesas IMR-LX4 Driver");
+MODULE_DESCRIPTION("Renesas IMR-LSX3/LX4 Driver");
 MODULE_LICENSE("GPL");
