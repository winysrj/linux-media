Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36103 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935046AbcLMR0b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 12:26:31 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] drivers: media: i2c: ak881x: constify v4l2_subdev_* structures
Date: Tue, 13 Dec 2016 22:56:13 +0530
Message-Id: <1481649973-12062-1-git-send-email-bhumirks@gmail.com>
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
   1809	    872	      0	   2681	    a79	drivers/media/i2c/ak881x.o

File size after:
  text	   data	    bss	    dec	    hex	filename
   2185	    496	      0	   2681	    a79	drivers/media/i2c/ak881x.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/i2c/ak881x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index 3a795dc..16682c84 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -205,14 +205,14 @@ static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops ak881x_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register	= ak881x_g_register,
 	.s_register	= ak881x_s_register,
 #endif
 };
 
-static struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops ak881x_subdev_video_ops = {
 	.s_std_output	= ak881x_s_std_output,
 	.s_stream	= ak881x_s_stream,
 };
@@ -224,7 +224,7 @@ static int ak881x_s_stream(struct v4l2_subdev *sd, int enable)
 	.get_fmt	= ak881x_fill_fmt,
 };
 
-static struct v4l2_subdev_ops ak881x_subdev_ops = {
+static const struct v4l2_subdev_ops ak881x_subdev_ops = {
 	.core	= &ak881x_subdev_core_ops,
 	.video	= &ak881x_subdev_video_ops,
 	.pad	= &ak881x_subdev_pad_ops,
-- 
1.9.1

