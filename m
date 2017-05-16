Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback.mail.elte.hu ([157.181.151.13]:45753 "EHLO
        fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752791AbdEPVis (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 17:38:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9])
        by fallback.mail.elte.hu with esmtp (Exim)
        id 1dAjRM-0005zI-9p
        from <melko@frugalware.org>
        for <linux-media@vger.kernel.org>; Tue, 16 May 2017 22:51:32 +0200
From: Paolo Cretaro <melko@frugalware.org>
To: linux-media@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mchehab@kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: media: atomisp: declare not-exported functions as static
Date: Tue, 16 May 2017 22:51:01 +0200
Message-Id: <20170516205101.21109-1-melko@frugalware.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix warnings issued by sparse:
symbol 'gmin_v1p2_ctrl' was not declared. Should it be static?
symbol 'gmin_v1p8_ctrl' was not declared. Should it be static?
symbol 'gmin_v2p8_ctrl' was not declared. Should it be static?
symbol 'gmin_flisclk_ctrl' was not declared. Should it be static?

Signed-off-by: Paolo Cretaro <melko@frugalware.org>
---
 .../media/atomisp/platform/intel-mid/atomisp_gmin_platform.c      | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index 5b4506a71126..2f0b23630f2a 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -436,7 +436,7 @@ static int gmin_gpio1_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 
@@ -455,7 +455,7 @@ int gmin_v1p2_ctrl(struct v4l2_subdev *subdev, int on)
 
 	return -EINVAL;
 }
-int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 	int ret;
@@ -491,7 +491,7 @@ int gmin_v1p8_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
 	int ret;
@@ -527,7 +527,7 @@ int gmin_v2p8_ctrl(struct v4l2_subdev *subdev, int on)
 	return -EINVAL;
 }
 
-int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
+static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	int ret = 0;
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
-- 
2.13.0
