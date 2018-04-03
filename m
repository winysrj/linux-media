Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0129.outbound.protection.outlook.com ([104.47.41.129]:34256
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752420AbeDCTvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 15:51:21 -0400
From: Chris Lesiak <chris.lesiak@licor.com>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Chris Lesiak <chris.lesiak@licor.com>
Subject: [PATCH] media: platform: video-mux: propagate format from sink to source
Date: Tue,  3 Apr 2018 14:50:22 -0500
Message-Id: <20180403195022.31188-1-chris.lesiak@licor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Propagate the v4l2_mbus_framefmt to the source pad when either a sink
pad is activated or when the format of the active sink pad changes.

Signed-off-by: Chris Lesiak <chris.lesiak@licor.com>
---
 drivers/media/platform/video-mux.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index ee89ad76bee2..1fb887293337 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -45,6 +45,7 @@ static int video_mux_link_setup(struct media_entity *entity,
 {
 	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
 	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
+	u16 source_pad = entity->num_pads - 1;
 	int ret = 0;
 
 	/*
@@ -74,6 +75,9 @@ static int video_mux_link_setup(struct media_entity *entity,
 		if (ret < 0)
 			goto out;
 		vmux->active = local->index;
+
+		/* Propagate the active format to the source */
+		vmux->format_mbus[source_pad] = vmux->format_mbus[vmux->active];
 	} else {
 		if (vmux->active != local->index)
 			goto out;
@@ -162,14 +166,20 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 			    struct v4l2_subdev_format *sdformat)
 {
 	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
-	struct v4l2_mbus_framefmt *mbusformat;
+	struct v4l2_mbus_framefmt *mbusformat, *source_mbusformat;
 	struct media_pad *pad = &vmux->pads[sdformat->pad];
+	u16 source_pad = sd->entity.num_pads - 1;
 
 	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
 					    sdformat->which);
 	if (!mbusformat)
 		return -EINVAL;
 
+	source_mbusformat = __video_mux_get_pad_format(sd, cfg, source_pad,
+						       sdformat->which);
+	if (!source_mbusformat)
+		return -EINVAL;
+
 	mutex_lock(&vmux->lock);
 
 	/* Source pad mirrors active sink pad, no limitations on sink pads */
@@ -178,6 +188,10 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 
 	*mbusformat = sdformat->format;
 
+	/* Propagate the format from an active sink to source */
+	if ((pad->flags & MEDIA_PAD_FL_SINK) && (pad->index == vmux->active))
+		*source_mbusformat = sdformat->format;
+
 	mutex_unlock(&vmux->lock);
 
 	return 0;
-- 
2.14.3
