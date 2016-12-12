Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34171 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbcLLIKL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 03:10:11 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, g.liakhovetski@gmx.de, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: platform: soc_camera_platform : constify v4l2_subdev_* structures
Date: Mon, 12 Dec 2016 13:39:53 +0530
Message-Id: <1481530193-18158-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_{core/video}_ops structures are stored in the
fields of the v4l2_subdev_ops structure which are of type const.
Also, v4l2_subdev_ops structure is passed to a function
having its argument of type const. As these structures are never
modified, so declare them as const.
Done using Coccinelle:(One of the scripts)

@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct v4l2_subdev_core_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct v4l2_subdev_ops obj;
@@
obj.core=&i@p;

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct v4l2_subdev_core_ops i;

File size before:
    text   data	    bss	    dec	    hex	filename
    858	    576	      0	   1434	    59a soc_camera/soc_camera_platform.o

File size after:
  text	   data	    bss	    dec	    hex	filename
   1234	    192	      0	   1426	    592 soc_camera/soc_camera_platform.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/soc_camera/soc_camera_platform.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 534d6c3..cb4986b 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -59,7 +59,7 @@ static int soc_camera_platform_s_power(struct v4l2_subdev *sd, int on)
 	return soc_camera_set_power(p->icd->control, &p->icd->sdesc->subdev_desc, NULL, on);
 }
 
-static struct v4l2_subdev_core_ops platform_subdev_core_ops = {
+static const struct v4l2_subdev_core_ops platform_subdev_core_ops = {
 	.s_power = soc_camera_platform_s_power,
 };
 
@@ -110,7 +110,7 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
+static const struct v4l2_subdev_video_ops platform_subdev_video_ops = {
 	.s_stream	= soc_camera_platform_s_stream,
 	.g_mbus_config	= soc_camera_platform_g_mbus_config,
 };
@@ -122,7 +122,7 @@ static int soc_camera_platform_g_mbus_config(struct v4l2_subdev *sd,
 	.set_fmt	= soc_camera_platform_fill_fmt,
 };
 
-static struct v4l2_subdev_ops platform_subdev_ops = {
+static const struct v4l2_subdev_ops platform_subdev_ops = {
 	.core	= &platform_subdev_core_ops,
 	.video	= &platform_subdev_video_ops,
 	.pad	= &platform_subdev_pad_ops,
-- 
1.9.1

