Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755321AbdERNva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:51:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: mchehab@s-opensource.com, alan@linux.intel.com
Cc: Avraham Shukron <avraham.shukron@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 04/13] staging: media: atomisp: fixed sparse warnings
Date: Thu, 18 May 2017 15:50:13 +0200
Message-Id: <20170518135022.6069-5-gregkh@linuxfoundation.org>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Avraham Shukron <avraham.shukron@gmail.com>

Added "static" storage class to 4 not-declared functions

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
