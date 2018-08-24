Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:33085 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728006AbeHXULc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:32 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] media: imx274: rename IMX274_DEFAULT_MODE to IMX274_DEFAULT_BINNING
Date: Fri, 24 Aug 2018 18:35:19 +0200
Message-Id: <20180824163525.12694-2-luca@lucaceresoli.net>
In-Reply-To: <20180824163525.12694-1-luca@lucaceresoli.net>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "mode" has been renamed to "binning" in commit 39dd23dc9d4c
("media: imx274: add cropping support via SELECTION API"), but this
define has not been updated.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index f8c70f1a34fe..4f629e4e53fd 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -76,7 +76,7 @@
  */
 #define IMX274_MIN_EXPOSURE_TIME		(4 * 260 / 72)
 
-#define IMX274_DEFAULT_MODE			IMX274_BINNING_OFF
+#define IMX274_DEFAULT_BINNING			IMX274_BINNING_OFF
 #define IMX274_MAX_WIDTH			(3840)
 #define IMX274_MAX_HEIGHT			(2160)
 #define IMX274_MAX_FRAME_RATE			(120)
@@ -1871,7 +1871,7 @@ static int imx274_probe(struct i2c_client *client,
 	mutex_init(&imx274->lock);
 
 	/* initialize format */
-	imx274->mode = &imx274_formats[IMX274_DEFAULT_MODE];
+	imx274->mode = &imx274_formats[IMX274_DEFAULT_BINNING];
 	imx274->crop.width = IMX274_MAX_WIDTH;
 	imx274->crop.height = IMX274_MAX_HEIGHT;
 	imx274->format.width = imx274->crop.width / imx274->mode->bin_ratio;
-- 
2.17.1
