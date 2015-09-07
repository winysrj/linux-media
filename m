Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:61895 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbIGNpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2015 09:45:13 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv9 10/15] v4l2-subdev: add HDMI CEC ops
Date: Mon,  7 Sep 2015 15:44:39 +0200
Message-Id: <bbcb7730b7f6f3978adef029b075be6bc9342ff9.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC callbacks to the v4l2_subdev_video_ops. These are the low-level CEC
ops that subdevs that support CEC have to implement.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
[k.debski@samsung.com: Merged changes from CEC Updates commit by Hans Verkuil]
Signed-off-by: Kamil Debski <kamil@wypas.org>
---
 include/media/v4l2-subdev.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b273cf9..3adddc7 100644
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
@@ -421,6 +426,11 @@ struct v4l2_subdev_video_ops {
 			     const struct v4l2_mbus_config *cfg);
 	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
 			   unsigned int *size);
+	void (*cec_ready)(struct v4l2_subdev *sd);
+	unsigned (*cec_available_log_addrs)(struct v4l2_subdev *sd);
+	int (*cec_enable)(struct v4l2_subdev *sd, bool enable);
+	int (*cec_log_addr)(struct v4l2_subdev *sd, u8 logical_addr);
+	int (*cec_transmit)(struct v4l2_subdev *sd, u32 timeout_ms, struct cec_msg *msg);
 };
 
 /**
-- 
2.1.4

