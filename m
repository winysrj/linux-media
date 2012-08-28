Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2H1KyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 02/14] media: coda: add i.MX53 / CODA7541 platform support
Date: Tue, 28 Aug 2012 12:53:49 +0200
Message-Id: <1346151241-10449-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Removed JPEG from the coda7_formats.
---
 drivers/media/video/coda.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 86dae17..6ae5f0f 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -84,6 +84,7 @@ enum coda_inst_type {
 
 enum coda_product {
 	CODA_DX6 = 0xf001,
+	CODA_7541 = 0xf012,
 };
 
 struct coda_fmt {
@@ -261,6 +262,24 @@ static struct coda_fmt codadx6_formats[] = {
 	},
 };
 
+static struct coda_fmt coda7_formats[] = {
+	{
+		.name = "YUV 4:2:0 Planar",
+		.fourcc = V4L2_PIX_FMT_YUV420,
+		.type = CODA_FMT_RAW,
+	},
+	{
+		.name = "H264 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_H264,
+		.type = CODA_FMT_ENC,
+	},
+	{
+		.name = "MPEG4 Encoded Stream",
+		.fourcc = V4L2_PIX_FMT_MPEG4,
+		.type = CODA_FMT_ENC,
+	},
+};
+
 static struct coda_fmt *find_format(struct coda_dev *dev, struct v4l2_format *f)
 {
 	struct coda_fmt *formats = dev->devtype->formats;
@@ -1485,6 +1504,7 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
+	CODA_FIRMWARE_VERNUM(CODA_7541, 13, 4, 29),
 };
 
 static bool coda_firmware_supported(u32 vernum)
@@ -1504,6 +1524,8 @@ static char *coda_product_name(int product)
 	switch (product) {
 	case CODA_DX6:
 		return "CodaDx6";
+	case CODA_7541:
+		return "CODA7541";
 	default:
 		snprintf(buf, sizeof(buf), "(0x%04x)", product);
 		return buf;
@@ -1695,6 +1717,7 @@ static int coda_firmware_request(struct coda_dev *dev)
 
 enum coda_platform {
 	CODA_IMX27,
+	CODA_IMX53,
 };
 
 static struct coda_devtype coda_devdata[] = {
@@ -1704,10 +1727,17 @@ static struct coda_devtype coda_devdata[] = {
 		.formats     = codadx6_formats,
 		.num_formats = ARRAY_SIZE(codadx6_formats),
 	},
+	[CODA_IMX53] = {
+		.firmware    = "v4l-coda7541-imx53.bin",
+		.product     = CODA_7541,
+		.formats     = coda7_formats,
+		.num_formats = ARRAY_SIZE(coda7_formats),
+	},
 };
 
 static struct platform_device_id coda_platform_ids[] = {
 	{ .name = "coda-imx27", .driver_data = CODA_IMX27 },
+	{ .name = "coda-imx53", .driver_data = CODA_7541 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(platform, coda_platform_ids);
@@ -1715,6 +1745,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
 #ifdef CONFIG_OF
 static const struct of_device_id coda_dt_ids[] = {
 	{ .compatible = "fsl,imx27-vpu", .data = &coda_platform_ids[CODA_IMX27] },
+	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, coda_dt_ids);
-- 
1.7.10.4

