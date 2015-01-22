Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19828 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbbAVQFd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:05:33 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIL00JTO618IN40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jan 2015 01:05:32 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: [RFC v2 4/7] v4l2-subdev: add cec ops.
Date: Thu, 22 Jan 2015 17:04:36 +0100
Message-id: <1421942679-23609-5-git-send-email-k.debski@samsung.com>
In-reply-to: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
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
index 5beeb87..fdf620d 100644
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
@@ -354,6 +358,10 @@ struct v4l2_subdev_video_ops {
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

