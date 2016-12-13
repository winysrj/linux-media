Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33996 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933460AbcLMRcC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 12:32:02 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] drivers: media: i2c: ml86v7667: constify v4l2_subdev_* structures
Date: Tue, 13 Dec 2016 23:01:45 +0530
Message-Id: <1481650305-12428-1-git-send-email-bhumirks@gmail.com>
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
static struct v4l2_subdev_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
@@
v4l2_i2c_subdev_init(...,&i@p)

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_ops i;

File size before:
  text	   data	    bss	    dec	    hex	filename
   2732	    608	      8	   3348	    d14	drivers/media/i2c/ml86v7667.o

File size after:
  text	   data	    bss	    dec	    hex	filename
   3100	    232	      8	   3340	    d0c	drivers/media/i2c/ml86v7667.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/i2c/ml86v7667.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ml86v7667.c b/drivers/media/i2c/ml86v7667.c
index 38a20fe..57ef901 100644
--- a/drivers/media/i2c/ml86v7667.c
+++ b/drivers/media/i2c/ml86v7667.c
@@ -290,7 +290,7 @@ static int ml86v7667_s_register(struct v4l2_subdev *sd,
 	.s_ctrl = ml86v7667_s_ctrl,
 };
 
-static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
 	.g_std = ml86v7667_g_std,
 	.s_std = ml86v7667_s_std,
 	.querystd = ml86v7667_querystd,
@@ -304,14 +304,14 @@ static int ml86v7667_s_register(struct v4l2_subdev *sd,
 	.set_fmt = ml86v7667_fill_fmt,
 };
 
-static struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops ml86v7667_subdev_core_ops = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ml86v7667_g_register,
 	.s_register = ml86v7667_s_register,
 #endif
 };
 
-static struct v4l2_subdev_ops ml86v7667_subdev_ops = {
+static const struct v4l2_subdev_ops ml86v7667_subdev_ops = {
 	.core = &ml86v7667_subdev_core_ops,
 	.video = &ml86v7667_subdev_video_ops,
 	.pad = &ml86v7667_subdev_pad_ops,
-- 
1.9.1

