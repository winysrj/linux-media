Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:42776 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752810AbeDLQvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] imx274: remove non-indexed pointers from mode_table
Date: Thu, 12 Apr 2018 18:51:11 +0200
Message-Id: <1523551878-15754-7-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
References: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

mode_table[] has 3 members that are accessed based on their index, which
makes worth using an array.

The other members are always accessed with a constant index. This added
indirection gives no improvement and only makes code more verbose.

Remove these pointers from the array and access them directly.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 62a0d7af0e51..63fb94e7da37 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -144,12 +144,6 @@ enum imx274_mode {
 	IMX274_MODE_3840X2160,
 	IMX274_MODE_1920X1080,
 	IMX274_MODE_1280X720,
-
-	IMX274_MODE_START_STREAM_1,
-	IMX274_MODE_START_STREAM_2,
-	IMX274_MODE_START_STREAM_3,
-	IMX274_MODE_START_STREAM_4,
-	IMX274_MODE_STOP_STREAM
 };
 
 /*
@@ -486,12 +480,6 @@ static const struct reg_8 *mode_table[] = {
 	[IMX274_MODE_3840X2160]		= imx274_mode1_3840x2160_raw10,
 	[IMX274_MODE_1920X1080]		= imx274_mode3_1920x1080_raw10,
 	[IMX274_MODE_1280X720]		= imx274_mode5_1280x720_raw10,
-
-	[IMX274_MODE_START_STREAM_1]	= imx274_start_1,
-	[IMX274_MODE_START_STREAM_2]	= imx274_start_2,
-	[IMX274_MODE_START_STREAM_3]	= imx274_start_3,
-	[IMX274_MODE_START_STREAM_4]	= imx274_start_4,
-	[IMX274_MODE_STOP_STREAM]	= imx274_stop,
 };
 
 /*
@@ -731,11 +719,11 @@ static int imx274_mode_regs(struct stimx274 *priv, int mode)
 {
 	int err = 0;
 
-	err = imx274_write_table(priv, mode_table[IMX274_MODE_START_STREAM_1]);
+	err = imx274_write_table(priv, imx274_start_1);
 	if (err)
 		return err;
 
-	err = imx274_write_table(priv, mode_table[IMX274_MODE_START_STREAM_2]);
+	err = imx274_write_table(priv, imx274_start_2);
 	if (err)
 		return err;
 
@@ -760,7 +748,7 @@ static int imx274_start_stream(struct stimx274 *priv)
 	 * give it 1 extra ms for margin
 	 */
 	msleep_range(11);
-	err = imx274_write_table(priv, mode_table[IMX274_MODE_START_STREAM_3]);
+	err = imx274_write_table(priv, imx274_start_3);
 	if (err)
 		return err;
 
@@ -770,7 +758,7 @@ static int imx274_start_stream(struct stimx274 *priv)
 	 * give it 1 extra ms for margin
 	 */
 	msleep_range(8);
-	err = imx274_write_table(priv, mode_table[IMX274_MODE_START_STREAM_4]);
+	err = imx274_write_table(priv, imx274_start_4);
 	if (err)
 		return err;
 
@@ -1081,8 +1069,7 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 			goto fail;
 	} else {
 		/* stop stream */
-		ret = imx274_write_table(imx274,
-					 mode_table[IMX274_MODE_STOP_STREAM]);
+		ret = imx274_write_table(imx274, imx274_stop);
 		if (ret)
 			goto fail;
 	}
@@ -1779,7 +1766,7 @@ static int imx274_remove(struct i2c_client *client)
 	struct stimx274 *imx274 = to_imx274(sd);
 
 	/* stop stream */
-	imx274_write_table(imx274, mode_table[IMX274_MODE_STOP_STREAM]);
+	imx274_write_table(imx274, imx274_stop);
 
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&imx274->ctrls.handler);
-- 
2.7.4
