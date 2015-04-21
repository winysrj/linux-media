Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59768 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951AbbDUNRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:17:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/15] vivid: add request support for video capture.
Date: Tue, 21 Apr 2015 14:58:56 +0200
Message-Id: <1429621138-17213-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In order to test the request API in applications we add request support to
vivid. The brightness, contrast, saturation and hue controls now can be used
in requests. Those were chosen because the test pattern generator supports
those controls and will adjust the TPG colors accordingly, so this gives a
good visual feedback.

Just before a buffer with a specific request is ready to be filled, any
controls set for that request are applied and the TPG will use the new
values for filling in the buffer, so this matches what a well-written driver
will do in actual hardware.

Finally, support for req_queue is added using the new v4l2_device_req_queue
helper function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c        | 2 ++
 drivers/media/platform/vivid/vivid-ctrls.c       | 4 ++++
 drivers/media/platform/vivid/vivid-kthread-cap.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index d33f164..23c5bc0 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -669,6 +669,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		return ret;
 	}
 	dev->v4l2_dev.release = vivid_dev_release;
+	dev->v4l2_dev.req_queue = v4l2_device_req_queue;
 
 	/* start detecting feature set */
 
@@ -1044,6 +1045,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
+		q->allow_requests = 1;
 
 		ret = vb2_queue_init(q);
 		if (ret)
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 2b90700..bb66608 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1301,12 +1301,16 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
 		for (i = 0; i < MAX_INPUTS; i++)
 			dev->input_brightness[i] = 128;
+		v4l2_ctrl_s_max_reqs(dev->brightness, VIDEO_MAX_FRAME);
 		dev->contrast = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_CONTRAST, 0, 255, 1, 128);
+		v4l2_ctrl_s_max_reqs(dev->contrast, VIDEO_MAX_FRAME);
 		dev->saturation = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_SATURATION, 0, 255, 1, 128);
+		v4l2_ctrl_s_max_reqs(dev->saturation, VIDEO_MAX_FRAME);
 		dev->hue = v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_HUE, -128, 128, 1, 0);
+		v4l2_ctrl_s_max_reqs(dev->hue, VIDEO_MAX_FRAME);
 		v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
 			V4L2_CID_HFLIP, 0, 1, 1, 0);
 		v4l2_ctrl_new_std(hdl_user_vid, &vivid_user_vid_ctrl_ops,
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 1727f54..6b4d3b7 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -681,6 +681,8 @@ static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
 	if (!list_empty(&dev->vid_cap_active)) {
 		vid_cap_buf = list_entry(dev->vid_cap_active.next, struct vivid_buffer, list);
 		list_del(&vid_cap_buf->list);
+		v4l2_ctrl_apply_request(dev->vid_cap_dev.ctrl_handler,
+					vid_cap_buf->vb.v4l2_buf.request);
 	}
 	if (!list_empty(&dev->vbi_cap_active)) {
 		if (dev->field_cap != V4L2_FIELD_ALTERNATE ||
-- 
2.1.4

