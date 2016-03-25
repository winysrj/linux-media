Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50975 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbcCYNKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 09:10:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hansverk@cisco.com>,
	Kamil Debski <kamil@wypas.org>
Subject: [PATCHv14 11/18] v4l2-subdev: add HDMI CEC ops
Date: Fri, 25 Mar 2016 14:10:09 +0100
Message-Id: <1458911416-47981-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC callbacks to the new v4l2_subdev_cec_ops struct. These are the
low-level CEC ops that subdevs that support CEC have to implement.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
---
 include/media/v4l2-subdev.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 11e2dfe..8fa660e 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,17 @@
 
 #define	V4L2_DEVICE_NOTIFY_EVENT		_IOW('v', 2, struct v4l2_event)
 
+struct v4l2_subdev_cec_tx_done {
+	u8 status;
+	u8 arb_lost_cnt;
+	u8 nack_cnt;
+	u8 low_drive_cnt;
+	u8 error_cnt;
+};
+
+#define V4L2_SUBDEV_CEC_TX_DONE			_IOW('v', 3, struct v4l2_subdev_cec_tx_done)
+#define V4L2_SUBDEV_CEC_RX_MSG			_IOW('v', 4, struct cec_msg)
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event;
@@ -51,6 +62,7 @@ struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
 struct v4l2_mbus_frame_desc;
+struct cec_msg;
 
 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -645,6 +657,14 @@ struct v4l2_subdev_pad_ops {
 			      struct v4l2_mbus_frame_desc *fd);
 };
 
+struct v4l2_subdev_cec_ops {
+	unsigned (*adap_available_log_addrs)(struct v4l2_subdev *sd);
+	int (*adap_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*adap_log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*adap_transmit)(struct v4l2_subdev *sd, u8 attempts,
+			     u32 signal_free_time, struct cec_msg *msg);
+};
+
 struct v4l2_subdev_ops {
 	const struct v4l2_subdev_core_ops	*core;
 	const struct v4l2_subdev_tuner_ops	*tuner;
@@ -654,6 +674,7 @@ struct v4l2_subdev_ops {
 	const struct v4l2_subdev_ir_ops		*ir;
 	const struct v4l2_subdev_sensor_ops	*sensor;
 	const struct v4l2_subdev_pad_ops	*pad;
+	const struct v4l2_subdev_cec_ops	*cec;
 };
 
 /*
-- 
2.7.0

