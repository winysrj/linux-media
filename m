Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49049 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728355AbeJEOqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/11] davinci/vpbe: drop unused g_cropcap
Date: Fri,  5 Oct 2018 09:49:04 +0200
Message-Id: <20181005074911.47574-5-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function/callback is never used. Drop it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpbe.c | 23 -----------------------
 include/media/davinci/vpbe.h          |  4 ----
 2 files changed, 27 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 18c035ef84cf..e80d7806cc45 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -92,28 +92,6 @@ static int vpbe_find_encoder_sd_index(struct vpbe_config *cfg,
 	return -EINVAL;
 }
 
-/**
- * vpbe_g_cropcap - Get crop capabilities of the display
- * @vpbe_dev: vpbe device ptr
- * @cropcap: cropcap is a ptr to struct v4l2_cropcap
- *
- * Update the crop capabilities in crop cap for current
- * mode
- */
-static int vpbe_g_cropcap(struct vpbe_device *vpbe_dev,
-			  struct v4l2_cropcap *cropcap)
-{
-	if (!cropcap)
-		return -EINVAL;
-	cropcap->bounds.left = 0;
-	cropcap->bounds.top = 0;
-	cropcap->bounds.width = vpbe_dev->current_timings.xres;
-	cropcap->bounds.height = vpbe_dev->current_timings.yres;
-	cropcap->defrect = cropcap->bounds;
-
-	return 0;
-}
-
 /**
  * vpbe_enum_outputs - enumerate outputs
  * @vpbe_dev: vpbe device ptr
@@ -793,7 +771,6 @@ static void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
 }
 
 static const struct vpbe_device_ops vpbe_dev_ops = {
-	.g_cropcap = vpbe_g_cropcap,
 	.enum_outputs = vpbe_enum_outputs,
 	.set_output = vpbe_set_output,
 	.get_output = vpbe_get_output,
diff --git a/include/media/davinci/vpbe.h b/include/media/davinci/vpbe.h
index 79a566d7defd..5c31a7682492 100644
--- a/include/media/davinci/vpbe.h
+++ b/include/media/davinci/vpbe.h
@@ -100,10 +100,6 @@ struct vpbe_config {
 struct vpbe_device;
 
 struct vpbe_device_ops {
-	/* crop cap for the display */
-	int (*g_cropcap)(struct vpbe_device *vpbe_dev,
-			 struct v4l2_cropcap *cropcap);
-
 	/* Enumerate the outputs */
 	int (*enum_outputs)(struct vpbe_device *vpbe_dev,
 			    struct v4l2_output *output);
-- 
2.18.0
