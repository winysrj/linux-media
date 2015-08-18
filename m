Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:25057 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbHRIiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:38:54 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 10/15] v4l2-subdev: add HDMI CEC ops
Date: Tue, 18 Aug 2015 10:26:35 +0200
Message-Id: <ffa7f5ed1e2f16db7eb3272f87c75b06a3ada2ca.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC callbacks to the v4l2_subdev_video_ops. These are the low-level CEC
ops that subdevs that support CEC have to implement.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 370fc38..1b04d94 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,10 @@
 
 #define	V4L2_DEVICE_NOTIFY_EVENT		_IOW('v', 2, struct v4l2_event)
 
+#define V4L2_SUBDEV_CEC_TX_DONE			_IOW('v', 3, u32)
+#define V4L2_SUBDEV_CEC_RX_MSG			_IOW('v', 4, struct cec_msg)
+#define V4L2_SUBDEV_CEC_CONN_INPUTS		_IOW('v', 5, u16)
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event;
@@ -51,6 +55,7 @@ struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
 struct v4l2_mbus_frame_desc;
+struct cec_msg;
 
 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -339,6 +344,10 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	unsigned (*cec_available_log_addrs)(struct v4l2_subdev *sd);
+	int (*cec_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*cec_log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*cec_transmit)(struct v4l2_subdev *sd, u32 timeout_ms, struct cec_msg *msg);
 };
 
 /*
-- 
2.1.4

