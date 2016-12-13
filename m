Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34871 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932754AbcLMRgJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 12:36:09 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr,
        0001-drivers-media-i2c-mt9m111-constify-v4l2_subdev_-stru.patch@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] drivers: media: i2c: mt9m111: constify v4l2_subdev_* structures
Date: Tue, 13 Dec 2016 23:05:50 +0530
Message-Id: <1481650550-12786-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_{core/video}_ops structures are stored in the
fields of the v4l2_subdev_ops structure which are of type const.
Also, v4l2_subdev_ops structure is passed to a function
having its argument of type const. As these structures are never
modified, so declare them as const.
Done using Coccinelle: (One of the scripts used)

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_video_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct v4l2_subdev_ops obj;
@@
obj.video=&i@p;

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_video_ops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
   6082	   1010	     16	   7108	   1bc4	drivers/media/i2c/mt9m111.o

File size after:
 text	   data	    bss	    dec	    hex	filename
   6466	    642	     16	   7124	   1bd4	drivers/media/i2c/mt9m111.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/i2c/mt9m111.c | 6 +++---
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
-- 
1.9.1

