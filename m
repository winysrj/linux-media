Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34777 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbdEMR0G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 May 2017 13:26:06 -0400
From: Juan Antonio Pedreira Martos <juanpm1@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Juan Antonio Pedreira Martos <juanpm1@gmail.com>
Subject: [PATCH] staging: atomisp: fix non static symbol warnings
Date: Sat, 13 May 2017 19:24:54 +0200
Message-Id: <20170513172454.27816-1-juanpm1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some unneeded exported symbols by marking them as static.
This was found with the 'sparse' tool.

Signed-off-by: Juan Antonio Pedreira Martos <juanpm1@gmail.com>
---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c     | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a71126..15409e96449d 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -436,7 +436,7 @@ static int gmin_gpio1_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 
@@ -455,7 +455,8 @@ int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
 
 	return -EINVAL;
 }
-int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
+
+static int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 	int ret;
@@ -491,7 +492,7 @@ int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 	int ret;
@@ -527,7 +528,7 @@ int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	int ret = 0;
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
-- 
2.13.0
