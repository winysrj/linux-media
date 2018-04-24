Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:53485 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756637AbeDXIYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:24:34 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/13] media: imx274: remove unused data from struct imx274_frmfmt
Date: Tue, 24 Apr 2018 10:24:09 +0200
Message-Id: <1524558258-530-5-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
References: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

struct imx274_frmfmt is instantiated only in the imx274_formats[]
array, where imx274_formats[N].mode always equals N (via enum
imx274_mode).  So .mode carries no information, and unsurprisingly it
is never used.

mbus_code is never used because the 12 bit modes are not implemented.

The colorspace member is also never used, which is normal since the
imx274 sensor can output only one colorspace.

Let's get rid of all of them.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

---
Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index c5d00ade4d64..9203d377cfe2 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -156,10 +156,7 @@ enum imx274_mode {
  * imx274 format related structure
  */
 struct imx274_frmfmt {
-	u32 mbus_code;
-	enum v4l2_colorspace colorspace;
 	struct v4l2_frmsize_discrete size;
-	enum imx274_mode mode;
 };
 
 /*
@@ -501,12 +498,9 @@ static const struct reg_8 *mode_table[] = {
  * imx274 format related structure
  */
 static const struct imx274_frmfmt imx274_formats[] = {
-	{MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_COLORSPACE_SRGB, {3840, 2160},
-		IMX274_MODE_3840X2160},
-	{MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_COLORSPACE_SRGB, {1920, 1080},
-		IMX274_MODE_1920X1080},
-	{MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_COLORSPACE_SRGB, {1280, 720},
-		IMX274_MODE_1280X720},
+	{ {3840, 2160} },
+	{ {1920, 1080} },
+	{ {1280,  720} },
 };
 
 /*
@@ -890,9 +884,8 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
 	int index;
 
 	dev_dbg(&client->dev,
-		"%s: width = %d height = %d code = %d mbus_code = %d\n",
-		__func__, fmt->width, fmt->height, fmt->code,
-		imx274_formats[imx274->mode_index].mbus_code);
+		"%s: width = %d height = %d code = %d\n",
+		__func__, fmt->width, fmt->height, fmt->code);
 
 	mutex_lock(&imx274->lock);
 
-- 
2.7.4
