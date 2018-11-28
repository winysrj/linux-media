Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52830 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727341AbeK1UMw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 15:12:52 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: add req_validate error injection
Message-ID: <127dd245-f07c-57ea-c430-c0fbbe1938e3@xs4all.nl>
Date: Wed, 28 Nov 2018 10:11:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new vivid button control to inject an error into the req_validate request
callback.

This will help testing with v4l2-compliance.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c1b5976af3e6..1adf7cd86f60 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -629,8 +629,19 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 }

 #ifdef CONFIG_MEDIA_CONTROLLER
+static int vivid_req_validate(struct media_request *req)
+{
+	struct vivid_dev *dev = container_of(req->mdev, struct vivid_dev, mdev);
+
+	if (dev->req_validate_error) {
+		dev->req_validate_error = false;
+		return -EINVAL;
+	}
+	return vb2_request_validate(req);
+}
+
 static const struct media_device_ops vivid_media_ops = {
-	.req_validate = vb2_request_validate,
+	.req_validate = vivid_req_validate,
 	.req_queue = vb2_request_queue,
 };
 #endif
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 1891254c8f0b..a6b8d8625ec4 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -294,6 +294,7 @@ struct vivid_dev {
 	bool				buf_prepare_error;
 	bool				start_streaming_error;
 	bool				dqbuf_error;
+	bool				req_validate_error;
 	bool				seq_wrap;
 	bool				time_wrap;
 	u64				time_wrap_offset;
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index bfffeda12f14..4cd526ff248b 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -81,6 +81,7 @@
 #define VIVID_CID_START_STR_ERROR	(VIVID_CID_VIVID_BASE + 69)
 #define VIVID_CID_QUEUE_ERROR		(VIVID_CID_VIVID_BASE + 70)
 #define VIVID_CID_CLEAR_FB		(VIVID_CID_VIVID_BASE + 71)
+#define VIVID_CID_REQ_VALIDATE_ERROR	(VIVID_CID_VIVID_BASE + 72)

 #define VIVID_CID_RADIO_SEEK_MODE	(VIVID_CID_VIVID_BASE + 90)
 #define VIVID_CID_RADIO_SEEK_PROG_LIM	(VIVID_CID_VIVID_BASE + 91)
@@ -1002,6 +1003,9 @@ static int vivid_streaming_s_ctrl(struct v4l2_ctrl *ctrl)
 	case VIVID_CID_START_STR_ERROR:
 		dev->start_streaming_error = true;
 		break;
+	case VIVID_CID_REQ_VALIDATE_ERROR:
+		dev->req_validate_error = true;
+		break;
 	case VIVID_CID_QUEUE_ERROR:
 		if (vb2_start_streaming_called(&dev->vb_vid_cap_q))
 			vb2_queue_error(&dev->vb_vid_cap_q);
@@ -1087,6 +1091,15 @@ static const struct v4l2_ctrl_config vivid_ctrl_queue_error = {
 	.type = V4L2_CTRL_TYPE_BUTTON,
 };

+#ifdef CONFIG_MEDIA_CONTROLLER
+static const struct v4l2_ctrl_config vivid_ctrl_req_validate_error = {
+	.ops = &vivid_streaming_ctrl_ops,
+	.id = VIVID_CID_REQ_VALIDATE_ERROR,
+	.name = "Inject req_validate() Error",
+	.type = V4L2_CTRL_TYPE_BUTTON,
+};
+#endif
+
 static const struct v4l2_ctrl_config vivid_ctrl_seq_wrap = {
 	.ops = &vivid_streaming_ctrl_ops,
 	.id = VIVID_CID_SEQ_WRAP,
@@ -1516,6 +1529,9 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_buf_prepare_error, NULL);
 		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_start_streaming_error, NULL);
 		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_queue_error, NULL);
+#ifdef CONFIG_MEDIA_CONTROLLER
+		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_req_validate_error, NULL);
+#endif
 		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_seq_wrap, NULL);
 		v4l2_ctrl_new_custom(hdl_streaming, &vivid_ctrl_time_wrap, NULL);
 	}
