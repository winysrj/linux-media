Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36152 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdCQVF4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 17:05:56 -0400
Received: by mail-lf0-f43.google.com with SMTP id y193so37797741lfd.3
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 14:05:42 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-Id: <20170317205915.388401869@cogentembedded.com>
Date: Fri, 17 Mar 2017 23:59:00 +0300
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH] media: platform: rcar_imr: add IMR-LX3 support
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=media-platform-rcar_imr-add-IMR-LX3-support.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the image renderer light extended 3 (IMR-LX3) found only in
the R-Car V2H (R8A7792) SoC. It's mostly the same as IMR-LSX3 but doesn't
support video capture data as a source of 2D textures.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch  is against the 'media_tree.git' repo's 'master' branch plus the
latest version of  the Renesas IMR driver and the patch adding IMR-LSX3 support.

 Documentation/devicetree/bindings/media/rcar_imr.txt |    4 ++
 drivers/media/platform/rcar_imr.c                    |   27 ++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

Index: media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
===================================================================
--- media_tree.orig/Documentation/devicetree/bindings/media/rcar_imr.txt
+++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
@@ -9,6 +9,10 @@ and drawing with respect to any shape th
 Required properties:
 
 - compatible:
+  "renesas,<soctype>-imr-lx3", "renesas,imr-lx3" as a fallback for the image
+  renderer light extended 3 (IMR-LX3) found in the R-Car gen2 SoCs, where the
+  examples with <soctype> are:
+  - "renesas,r8a7792-imr-lx3" for R-Car V2H;
   "renesas,<soctype>-imr-lsx3", "renesas,imr-lsx3" as a fallback for the image
   renderer light SRAM extended 3 (IMR-LSX3) found in the R-Car gen2 SoCs, where
   the examples with <soctype> are:
Index: media_tree/drivers/media/platform/rcar_imr.c
===================================================================
--- media_tree.orig/drivers/media/platform/rcar_imr.c
+++ media_tree/drivers/media/platform/rcar_imr.c
@@ -1,5 +1,5 @@
 /*
- * rcar_imr.c -- R-Car IMR-LSX3/LX4 Driver
+ * rcar_imr.c -- R-Car IMR-LX3/LSX3/LX4 Driver
  *
  * Copyright (C) 2015-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
  *
@@ -82,6 +82,7 @@ struct imr_format_info {
 };
 
 enum imr_type {
+	IMR_LX3,
 	IMR_LSX3,
 	IMR_LX4,
 };
@@ -153,7 +154,7 @@ struct imr_ctx {
 #define IMR_SSAR		0x38
 #define IMR_DSTR		0x3C
 #define IMR_SSTR		0x40
-#define IMR_DSOR		0x50
+#define IMR_DSOR		0x50		/* IMR-LSX3/LX4 only */
 #define IMR_CMRCR		0x54
 #define IMR_CMRCSR		0x58
 #define IMR_CMRCCR		0x5C
@@ -200,7 +201,7 @@ struct imr_ctx {
 #define IMR_CMRCR_DUV		GENMASK(4, 3)
 #define IMR_CMRCR_SUV_SHIFT	5
 #define IMR_CMRCR_SUV		GENMASK(6, 5)
-#define IMR_CMRCR_YISM		BIT(7)
+#define IMR_CMRCR_YISM		BIT(7)		/* IMR-LSX3/LX4 only */
 #define IMR_CMRCR_Y10		BIT(8)
 #define IMR_CMRCR_Y12		BIT(9)
 #define IMR_CMRCR_SY10		BIT(11)
@@ -214,7 +215,7 @@ struct imr_ctx {
 #define IMR_TRIMR_AUTOSG	BIT(3)
 #define IMR_TRIMR_TCM		BIT(6)
 
-#define IMR_TRICR_YCFORM	BIT(31)
+#define IMR_TRICR_YCFORM	BIT(31)		/* IMR-LSX3/LX4 only */
 
 #define IMR_UVDPOR_UVDPO_SHIFT	0
 #define IMR_UVDPOR_UVDPO	GENMASK(2, 0)
@@ -296,7 +297,7 @@ static u32 __imr_flags_common(u32 iflags
 	return iflags & oflags & IMR_F_PLANES_MASK;
 }
 
-static const struct imr_format_info imr_lsx3_formats[] = {
+static const struct imr_format_info imr_lx3_formats[] = {
 	{
 		.name	= "YUV 4:2:2 semiplanar (NV16)",
 		.fourcc	= V4L2_PIX_FMT_NV16,
@@ -377,10 +378,16 @@ static const struct imr_format_info imr_
 	},
 };
 
+static const struct imr_info imr_lx3 = {
+	.type		= IMR_LX3,
+	.formats	= imr_lx3_formats,
+	.num_formats	= ARRAY_SIZE(imr_lx3_formats),
+};
+
 static const struct imr_info imr_lsx3 = {
 	.type		= IMR_LSX3,
-	.formats	= imr_lsx3_formats,
-	.num_formats	= ARRAY_SIZE(imr_lsx3_formats),
+	.formats	= imr_lx3_formats,
+	.num_formats	= ARRAY_SIZE(imr_lx3_formats),
 };
 
 static const struct imr_info imr_lx4 = {
@@ -835,7 +842,8 @@ static void imr_dl_program_setup(struct
 	*dl++ = IMR_OP_WTS(IMR_CPDPOR, __imr_cpdp(type));
 
 	/* reset rendering mode registers */
-	*dl++ = IMR_OP_WTS(IMR_CMRCCR,  0xDBFE);
+	*dl++ = IMR_OP_WTS(IMR_CMRCCR, ctx->imr->info->type >= IMR_LSX3 ?
+			   0xDBFE : 0xDB7E);
 	*dl++ = IMR_OP_WTS(IMR_CMRCCR2, ctx->imr->info->type == IMR_LX4 ?
 			   0x9065 : IMR_CMRCR2_LUTE);
 
@@ -1990,6 +1998,7 @@ static const struct dev_pm_ops imr_pm_op
 
 /* device table */
 static const struct of_device_id imr_of_match[] = {
+	{ .compatible = "renesas,imr-lx3",  .data = &imr_lx3, },
 	{ .compatible = "renesas,imr-lsx3", .data = &imr_lsx3, },
 	{ .compatible = "renesas,imr-lx4",  .data = &imr_lx4,  },
 	{ },
@@ -2011,5 +2020,5 @@ module_platform_driver(imr_platform_driv
 
 MODULE_ALIAS("imr");
 MODULE_AUTHOR("Cogent Embedded Inc. <sources@cogentembedded.com>");
-MODULE_DESCRIPTION("Renesas IMR-LSX3/LX4 Driver");
+MODULE_DESCRIPTION("Renesas IMR-LX3/LSX3/LX4 Driver");
 MODULE_LICENSE("GPL");
