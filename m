Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:29892 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752111AbdHHLYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 07:24:03 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] [media] media: mt9m111: constify video_subdev structures
Date: Tue,  8 Aug 2017 12:58:30 +0200
Message-Id: <1502189912-28794-5-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1502189912-28794-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_subdev_ops structure is only passed as the third argument
of v4l2_i2c_subdev_init, which is const, so the v4l2_subdev_ops
structure can be const as well.  The other structures are only
stored in the v4l2_subdev_ops structure, all the fields of which are
const, so these structures can also be const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/i2c/mt9m111.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 72e71b7..99b992e 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -835,7 +835,7 @@ static int mt9m111_s_power(struct v4l2_subdev *sd, int on)
 	.s_ctrl = mt9m111_s_ctrl,
 };
 
-static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
 	.s_power	= mt9m111_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= mt9m111_g_register,
@@ -865,7 +865,7 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_mbus_config	= mt9m111_g_mbus_config,
 };
 
@@ -877,7 +877,7 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= mt9m111_set_fmt,
 };
 
-static struct v4l2_subdev_ops mt9m111_subdev_ops = {
+static const struct v4l2_subdev_ops mt9m111_subdev_ops = {
 	.core	= &mt9m111_subdev_core_ops,
 	.video	= &mt9m111_subdev_video_ops,
 	.pad	= &mt9m111_subdev_pad_ops,
