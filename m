Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2KZEzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 23:55:40 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7718146pbc.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 20:55:39 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/9] [media] s5p-tv: Add missing braces around sizeof in mixer_video.c
Date: Mon, 26 Nov 2012 10:19:01 +0530
Message-Id: <1353905348-15475-3-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
References: <1353905348-15475-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Silences several checkpatch warnings of the type:
WARNING: sizeof *out should be sizeof(*out)
FILE: media/platform/s5p-tv/mixer_video.c:98:
		out = kzalloc(sizeof *out, GFP_KERNEL);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-tv/mixer_video.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 9b52f3a..155c092 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -95,7 +95,7 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
 		/* trying to register next output */
 		if (sd == NULL)
 			continue;
-		out = kzalloc(sizeof *out, GFP_KERNEL);
+		out = kzalloc(sizeof(*out), GFP_KERNEL);
 		if (out == NULL) {
 			mxr_err(mdev, "no memory for '%s'\n",
 				conf->output_name);
@@ -127,7 +127,7 @@ fail_output:
 	/* kfree is NULL-safe */
 	for (i = 0; i < mdev->output_cnt; ++i)
 		kfree(mdev->output[i]);
-	memset(mdev->output, 0, sizeof mdev->output);
+	memset(mdev->output, 0, sizeof(mdev->output));
 
 fail_vb2_allocator:
 	/* freeing allocator context */
@@ -160,8 +160,8 @@ static int mxr_querycap(struct file *file, void *priv,
 
 	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
 
-	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof cap->driver);
-	strlcpy(cap->card, layer->vfd.name, sizeof cap->card);
+	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof(cap->driver));
+	strlcpy(cap->card, layer->vfd.name, sizeof(cap->card));
 	sprintf(cap->bus_info, "%d", layer->idx);
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -192,7 +192,7 @@ static void mxr_layer_default_geo(struct mxr_layer *layer)
 	struct mxr_device *mdev = layer->mdev;
 	struct v4l2_mbus_framefmt mbus_fmt;
 
-	memset(&layer->geo, 0, sizeof layer->geo);
+	memset(&layer->geo, 0, sizeof(layer->geo));
 
 	mxr_get_mbus_fmt(mdev, &mbus_fmt);
 
@@ -425,7 +425,7 @@ static int mxr_s_selection(struct file *file, void *fh,
 	struct mxr_geometry tmp;
 	struct v4l2_rect res;
 
-	memset(&res, 0, sizeof res);
+	memset(&res, 0, sizeof(res));
 
 	mxr_dbg(layer->mdev, "%s: rect: %dx%d@%d,%d\n", __func__,
 		s->r.width, s->r.height, s->r.left, s->r.top);
@@ -464,7 +464,7 @@ static int mxr_s_selection(struct file *file, void *fh,
 	/* apply change and update geometry if needed */
 	if (target) {
 		/* backup current geometry if setup fails */
-		memcpy(&tmp, geo, sizeof tmp);
+		memcpy(&tmp, geo, sizeof(tmp));
 
 		/* apply requested selection */
 		target->x_offset = s->r.left;
@@ -496,7 +496,7 @@ static int mxr_s_selection(struct file *file, void *fh,
 fail:
 	/* restore old geometry, which is not touched if target is NULL */
 	if (target)
-		memcpy(geo, &tmp, sizeof tmp);
+		memcpy(geo, &tmp, sizeof(tmp));
 	return -ERANGE;
 }
 
@@ -1061,7 +1061,7 @@ struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
 {
 	struct mxr_layer *layer;
 
-	layer = kzalloc(sizeof *layer, GFP_KERNEL);
+	layer = kzalloc(sizeof(*layer), GFP_KERNEL);
 	if (layer == NULL) {
 		mxr_err(mdev, "not enough memory for layer.\n");
 		goto fail;
-- 
1.7.4.1

