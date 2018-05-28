Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59108 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932242AbeE1R5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 13:57:17 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: imx258: get rid of an unused var
Date: Mon, 28 May 2018 13:57:11 -0400
Message-Id: <66a1e187a88fcceb84a390e6ea0c35e9f7a7f252.1527530230.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/imx258.c: In function 'imx258_init_controls':
drivers/media/i2c/imx258.c:1117:6: warning: variable 'exposure_max' set but not used [-Wunused-but-set-variable]
  s64 exposure_max;
      ^~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/imx258.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index fad3012f4fe5..f3b124723aa0 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -1114,7 +1114,6 @@ static int imx258_init_controls(struct imx258 *imx258)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
 	struct v4l2_ctrl_handler *ctrl_hdlr;
-	s64 exposure_max;
 	s64 vblank_def;
 	s64 vblank_min;
 	s64 pixel_rate_min;
@@ -1168,7 +1167,6 @@ static int imx258_init_controls(struct imx258 *imx258)
 	if (imx258->hblank)
 		imx258->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
-	exposure_max = imx258->cur_mode->vts_def - 8;
 	imx258->exposure = v4l2_ctrl_new_std(
 				ctrl_hdlr, &imx258_ctrl_ops,
 				V4L2_CID_EXPOSURE, IMX258_EXPOSURE_MIN,
-- 
2.17.0
