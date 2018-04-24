Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:38543 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756669AbeDXIYh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 04:24:37 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/13] media: imx274: get rid of mode_index
Date: Tue, 24 Apr 2018 10:24:14 +0200
Message-Id: <1524558258-530-10-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
References: <1524558258-530-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After restructuring struct imx274_frmfmt, the mode_index field is
still in use only for two dev_dbg() calls in imx274_s_stream(). Let's
remove it and avoid duplicated information.

Replacing the first usage requires a some rather annoying but trivial
pointer math. The other one can be removed entirely since it would
print the same value anyway.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>

---
Changed v1 -> v2:
 - add "media: " prefix to commit message
 - fix dev_dbg() format mismatch warning
   ("warning: format ‘%ld’ expects argument of type ‘long int’, but argument 6 has type ‘int’")
 - slightly improve commit message
---
 drivers/media/i2c/imx274.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 2ec31ae4e60d..69fdc82d4214 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -553,8 +553,6 @@ struct imx274_ctrls {
  * @reset_gpio: Pointer to reset gpio
  * @lock: Mutex structure
  * @mode: Parameters for the selected readout mode
- *        (points to imx274_formats[mode_index])
- * @mode_index: Resolution mode index
  */
 struct stimx274 {
 	struct v4l2_subdev sd;
@@ -567,7 +565,6 @@ struct stimx274 {
 	struct gpio_desc *reset_gpio;
 	struct mutex lock; /* mutex lock for operations */
 	const struct imx274_frmfmt *mode;
-	u32 mode_index;
 };
 
 /*
@@ -880,7 +877,6 @@ static int imx274_set_fmt(struct v4l2_subdev *sd,
 		index = 0;
 	}
 
-	imx274->mode_index = index;
 	imx274->mode = &imx274_formats[index];
 
 	if (fmt->width > IMX274_MAX_WIDTH)
@@ -1029,7 +1025,8 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 	int ret = 0;
 
 	dev_dbg(&imx274->client->dev, "%s : %s, mode index = %d\n", __func__,
-		on ? "Stream Start" : "Stream Stop", imx274->mode_index);
+		on ? "Stream Start" : "Stream Stop",
+		imx274->mode - &imx274_formats[0]);
 
 	mutex_lock(&imx274->lock);
 
@@ -1068,8 +1065,7 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 	}
 
 	mutex_unlock(&imx274->lock);
-	dev_dbg(&imx274->client->dev,
-		"%s : Done: mode = %d\n", __func__, imx274->mode_index);
+	dev_dbg(&imx274->client->dev, "%s : Done\n", __func__);
 	return 0;
 
 fail:
@@ -1625,8 +1621,7 @@ static int imx274_probe(struct i2c_client *client,
 	mutex_init(&imx274->lock);
 
 	/* initialize format */
-	imx274->mode_index = IMX274_MODE_3840X2160;
-	imx274->mode = &imx274_formats[imx274->mode_index];
+	imx274->mode = &imx274_formats[IMX274_MODE_3840X2160];
 	imx274->format.width = imx274->mode->size.width;
 	imx274->format.height = imx274->mode->size.height;
 	imx274->format.field = V4L2_FIELD_NONE;
-- 
2.7.4
