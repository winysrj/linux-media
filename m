Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3I3NfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:35:00 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 05/10] [media] coda: move coda_product_name above vidioc_querycap
Date: Mon, 30 Sep 2013 15:34:48 +0200
Message-Id: <1380548093-22313-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
References: <1380548093-22313-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the product name (currently CodaDx6 or CODA7541)
to fill the v4l2_capabilities.name field.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 5fe947c..e70a272 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -394,14 +394,32 @@ static struct coda_codec *coda_find_codec(struct coda_dev *dev, int src_fourcc,
 	return &codecs[k];
 }
 
+static char *coda_product_name(int product)
+{
+	static char buf[9];
+
+	switch (product) {
+	case CODA_DX6:
+		return "CodaDx6";
+	case CODA_7541:
+		return "CODA7541";
+	default:
+		snprintf(buf, sizeof(buf), "(0x%04x)", product);
+		return buf;
+	}
+}
+
 /*
  * V4L2 ioctl() operations.
  */
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
+	struct coda_ctx *ctx = fh_to_ctx(priv);
+
 	strlcpy(cap->driver, CODA_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, CODA_NAME, sizeof(cap->card));
+	strlcpy(cap->card, coda_product_name(ctx->dev->devtype->product),
+		sizeof(cap->card));
 	strlcpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
@@ -2868,21 +2886,6 @@ static bool coda_firmware_supported(u32 vernum)
 	return false;
 }
 
-static char *coda_product_name(int product)
-{
-	static char buf[9];
-
-	switch (product) {
-	case CODA_DX6:
-		return "CodaDx6";
-	case CODA_7541:
-		return "CODA7541";
-	default:
-		snprintf(buf, sizeof(buf), "(0x%04x)", product);
-		return buf;
-	}
-}
-
 static int coda_hw_init(struct coda_dev *dev)
 {
 	u16 product, major, minor, release;
-- 
1.8.4.rc3

