Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:15151 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbbDWNEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 09:04:10 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH v4 07/10] v4l2-subdev: add HDMI CEC ops
Date: Thu, 23 Apr 2015 15:03:10 +0200
Message-id: <1429794192-20541-8-git-send-email-k.debski@samsung.com>
In-reply-to: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Add callbacks to the v4l2_subdev_video_ops.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 include/media/v4l2-subdev.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 2f0a345..9323e10 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -40,6 +40,9 @@
 #define V4L2_SUBDEV_IR_TX_NOTIFY		_IOW('v', 1, u32)
 #define V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ	0x00000001
 
+#define V4L2_SUBDEV_CEC_TX_DONE			_IOW('v', 2, u32)
+#define V4L2_SUBDEV_CEC_RX_MSG			_IOW('v', 3, struct cec_msg)
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
@@ -48,6 +51,7 @@ struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
 struct v4l2_mbus_frame_desc;
+struct cec_msg;
 
 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -352,6 +356,10 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	int (*cec_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*cec_log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*cec_transmit)(struct v4l2_subdev *sd, struct cec_msg *msg);
+	void (*cec_transmit_timed_out)(struct v4l2_subdev *sd);
 };
 
 /*
-- 
1.7.9.5

