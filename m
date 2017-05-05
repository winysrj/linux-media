Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35559 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdEEQ7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 May 2017 12:59:53 -0400
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rvarsha016@gmail.com, julia.lawall@lip6.fr,
        dan.carpenter@oracle.com, colin.king@canonical.com,
        alan@linux.intel.com
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
From: Avraham Shukron <avraham.shukron@gmail.com>
Subject: [PATCH] staging: media: atomisp: fixed sparse warnings
Message-ID: <b1a538e0-03aa-a562-f5c2-c23532ea426d@gmail.com>
Date: Fri, 5 May 2017 19:59:53 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added "static" storage class to 4 not-declared functions

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c     | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a..15409e9 100644
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
2.7.4
