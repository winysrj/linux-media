Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:41987 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbbKLMWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 07:22:13 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>
Subject: [PATCHv10 11/16] v4l2-subdev: add HDMI CEC ops
Date: Thu, 12 Nov 2015 13:21:40 +0100
Message-Id: <91c527c94e22662d154c80a916e64892fe7da54a.1447329279.git.hansverk@cisco.com>
In-Reply-To: <cover.1447329279.git.hansverk@cisco.com>
References: <cover.1447329279.git.hansverk@cisco.com>
In-Reply-To: <cover.1447329279.git.hansverk@cisco.com>
References: <cover.1447329279.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC callbacks to the new v4l2_subdev_cec_ops struct. These are the
low-level CEC ops that subdevs that support CEC have to implement.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
---
 include/media/v4l2-subdev.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b273cf9..e55031e 100644
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
@@ -642,6 +647,14 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 };
 
+struct v4l2_subdev_cec_ops {
+	unsigned (*available_log_addrs)(struct v4l2_subdev *sd);
+	int (*enable)(struct v4l2_subdev *sd, bool enable);
+	int (*log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*transmit)(struct v4l2_subdev *sd, u32 timeout_ms,
+			u8 retries, struct cec_msg *msg);
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -651,6 +664,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
 	const struct v4l2_subdev_pad_ops	*pad;
+	const struct v4l2_subdev_cec_ops	*cec;
 };
 
 /*
-- 
2.6.2

