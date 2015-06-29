Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:37495 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbF2K0B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:26:01 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv7 10/15] v4l2-subdev: add HDMI CEC ops
Date: Mon, 29 Jun 2015 12:14:55 +0200
Message-Id: <1435572900-56998-11-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
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
index dc20102..53e220d 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -42,6 +42,9 @@
 
 #define	V4L2_DEVICE_NOTIFY_EVENT		_IOW('v', 2, struct v4l2_event)
 
+#define V4L2_SUBDEV_CEC_TX_DONE			_IOW('v', 2, u32)
+#define V4L2_SUBDEV_CEC_RX_MSG			_IOW('v', 3, struct cec_msg)
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
@@ -50,6 +53,7 @@ struct v4l2_subdev;
 struct v4l2_subdev_fh;
 struct tuner_setup;
 struct v4l2_mbus_frame_desc;
+struct cec_msg;
 
 /* decode_vbi_line */
 struct v4l2_decode_vbi_line {
@@ -338,6 +342,11 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	unsigned (*cec_available_log_addrs)(struct v4l2_subdev *sd);
+	int (*cec_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*cec_log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*cec_transmit)(struct v4l2_subdev *sd, struct cec_msg *msg);
+	void (*cec_transmit_timed_out)(struct v4l2_subdev *sd);
 };
 
 /*
-- 
2.1.4

