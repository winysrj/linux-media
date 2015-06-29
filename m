Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:49555 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbbF2K0T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:26:19 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: [PATCHv7 15/15] cobalt: add cec support
Date: Mon, 29 Jun 2015 12:15:00 +0200
Message-Id: <1435572900-56998-16-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC support to the cobalt driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-driver.c |  37 +++++++++--
 drivers/media/pci/cobalt/cobalt-driver.h |   2 +
 drivers/media/pci/cobalt/cobalt-v4l2.c   | 110 +++++++++++++++++++++++++++++--
 3 files changed, 138 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index b994b8e..a6d3644 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -76,6 +76,7 @@ static u8 edid[256] = {
 	0x0A, 0x0A, 0x0A, 0x0A, 0x00, 0x00, 0x00, 0x10,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x68,
+
 	0x02, 0x03, 0x1a, 0xc0, 0x48, 0xa2, 0x10, 0x04,
 	0x02, 0x01, 0x21, 0x14, 0x13, 0x23, 0x09, 0x07,
 	0x07, 0x65, 0x03, 0x0c, 0x00, 0x10, 0x00, 0xe2,
@@ -149,17 +150,44 @@ static void cobalt_notify(struct v4l2_subdev *sd,
 	struct cobalt *cobalt = to_cobalt(sd->v4l2_dev);
 	unsigned sd_nr = cobalt_get_sd_nr(sd);
 	struct cobalt_stream *s = &cobalt->streams[sd_nr];
-	bool hotplug = arg ? *((int *)arg) : false;
 
-	if (s->is_output)
+	switch (notification) {
+	case V4L2_SUBDEV_CEC_TX_DONE:
+		cec_transmit_done(&s->cec_adap, (unsigned long)arg);
+		return;
+	case V4L2_SUBDEV_CEC_RX_MSG:
+		cec_received_msg(&s->cec_adap, arg);
+		return;
+	default:
+		break;
+	}
+
+	if (s->is_output) {
+		switch (notification) {
+		case ADV7511_EDID_DETECT: {
+			struct adv7511_edid_detect *ed = arg;
+
+			s->cec_adap.phys_addr = ed->phys_addr;
+			if (!ed->present) {
+				cec_enable(&s->cec_adap, false);
+				break;
+			}
+			cec_enable(&s->cec_adap, true);
+			break;
+		}
+		}
 		return;
+	}
 
 	switch (notification) {
-	case ADV76XX_HOTPLUG:
+	case ADV76XX_HOTPLUG: {
+		bool hotplug = arg ? *((int *)arg) : false;
+
 		cobalt_s_bit_sysctrl(cobalt,
 			COBALT_SYS_CTRL_HPD_TO_CONNECTOR_BIT(sd_nr), hotplug);
 		cobalt_dbg(1, "Set hotplug for adv %d to %d\n", sd_nr, hotplug);
 		break;
+	}
 	case V4L2_DEVICE_NOTIFY_EVENT:
 		cobalt_dbg(1, "Format changed for adv %d\n", sd_nr);
 		v4l2_event_queue(&s->vdev, arg);
@@ -626,8 +654,9 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 	s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
 			s->i2c_adap, &adv7842_info, NULL);
 	if (s->sd) {
-		int err = v4l2_subdev_call(s->sd, pad, set_edid, &cobalt_edid);
+		int err;
 
+		err = v4l2_subdev_call(s->sd, pad, set_edid, &cobalt_edid);
 		if (err)
 			return err;
 		err = v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index c206df9..151c80f 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
+#include <media/cec.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
@@ -221,6 +222,7 @@ struct cobalt_stream {
 	struct list_head bufs;
 	struct i2c_adapter *i2c_adap;
 	struct v4l2_subdev *sd;
+	struct cec_adapter cec_adap;
 	struct mutex lock;
 	spinlock_t irqlock;
 	struct v4l2_dv_timings timings;
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index b40c2d1..b37bfd5 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1156,6 +1156,69 @@ static const struct v4l2_file_operations cobalt_empty_fops = {
 	.release = v4l2_fh_release,
 };
 
+static inline struct v4l2_subdev *adap_to_sd(struct cec_adapter *adap)
+{
+	struct cobalt_stream *s = container_of(adap, struct cobalt_stream, cec_adap);
+
+	return s->sd;
+}
+
+static int cobalt_cec_enable(struct cec_adapter *adap, bool enable)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), video, cec_enable, enable);
+}
+
+static int cobalt_cec_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), video, cec_log_addr,
+				log_addr);
+}
+
+static int cobalt_cec_transmit(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), video, cec_transmit, msg);
+}
+
+static void cobalt_cec_transmit_timed_out(struct cec_adapter *adap)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), video, cec_transmit_timed_out);
+}
+
+static u8 cobalt_cec_cdc_hpd(struct cec_adapter *adap, u8 cdc_hpd_state)
+{
+	switch (cdc_hpd_state) {
+	case CEC_OP_HPD_STATE_EDID_DISABLE:
+	case CEC_OP_HPD_STATE_EDID_ENABLE:
+	case CEC_OP_HPD_STATE_EDID_DISABLE_ENABLE:
+		return CEC_OP_HPD_ERROR_NONE;
+	case CEC_OP_HPD_STATE_CP_EDID_DISABLE:
+	case CEC_OP_HPD_STATE_CP_EDID_ENABLE:
+	case CEC_OP_HPD_STATE_CP_EDID_DISABLE_ENABLE:
+	default:
+		return CEC_OP_HPD_ERROR_INITIATOR_WRONG_STATE;
+	}
+}
+
+static int cobalt_sink_initiate_arc(struct cec_adapter *adap)
+{
+	return 0;
+}
+
+static int cobalt_sink_terminate_arc(struct cec_adapter *adap)
+{
+	return 0;
+}
+
+static int cobalt_source_arc_initiated(struct cec_adapter *adap)
+{
+	return 0;
+}
+
+static int cobalt_source_arc_terminated(struct cec_adapter *adap)
+{
+	return 0;
+}
+
 static int cobalt_node_register(struct cobalt *cobalt, int node)
 {
 	static const struct v4l2_dv_timings dv1080p60 =
@@ -1163,7 +1226,7 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	struct cobalt_stream *s = cobalt->streams + node;
 	struct video_device *vdev = &s->vdev;
 	struct vb2_queue *q = &s->q;
-	int ret;
+	int ret = 0;
 
 	mutex_init(&s->lock);
 	spin_lock_init(&s->irqlock);
@@ -1190,6 +1253,29 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	if (!s->is_audio) {
 		if (s->is_dummy)
 			cobalt_warn("Setting up dummy video node %d\n", node);
+		if (s->sd) {
+			u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_RECEIVE |
+				CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
+				CEC_CAP_RC | CEC_CAP_ARC;
+
+			s->cec_adap.adap_enable = cobalt_cec_enable;
+			s->cec_adap.adap_log_addr = cobalt_cec_log_addr;
+			s->cec_adap.adap_transmit = cobalt_cec_transmit;
+			s->cec_adap.adap_transmit_timed_out =
+				cobalt_cec_transmit_timed_out;
+			s->cec_adap.source_cdc_hpd = cobalt_cec_cdc_hpd;
+			s->cec_adap.sink_initiate_arc = cobalt_sink_initiate_arc;
+			s->cec_adap.sink_terminate_arc = cobalt_sink_terminate_arc;
+			s->cec_adap.source_arc_initiated = cobalt_source_arc_initiated;
+			s->cec_adap.source_arc_terminated = cobalt_source_arc_terminated;
+			if (s->is_output)
+				caps |= CEC_CAP_CDC;
+			ret = cec_create_adapter(&s->cec_adap, vdev->name,
+						 caps, !s->is_output, THIS_MODULE,
+						 &cobalt->pci_dev->dev);
+			s->cec_adap.available_log_addrs =
+				v4l2_subdev_call(s->sd, video, cec_available_log_addrs);
+		}
 		vdev->v4l2_dev = &cobalt->v4l2_dev;
 		if (s->is_dummy)
 			vdev->fops = &cobalt_empty_fops;
@@ -1203,8 +1289,11 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 			vdev->ctrl_handler = s->sd->ctrl_handler;
 		s->timings = dv1080p60;
 		v4l2_subdev_call(s->sd, video, s_dv_timings, &s->timings);
-		if (!s->is_output && s->sd)
+		if (!s->is_output && s->sd) {
 			cobalt_enable_input(s);
+			s->cec_adap.phys_addr = 0;
+			ret = cec_enable(&s->cec_adap, true);
+		}
 		vdev->ioctl_ops = s->is_dummy ? &cobalt_ioctl_empty_ops :
 				  &cobalt_ioctl_ops;
 	}
@@ -1224,16 +1313,20 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	vdev->queue = q;
 
 	video_set_drvdata(vdev, s);
-	ret = vb2_queue_init(q);
+	if (ret == 0)
+		ret = vb2_queue_init(q);
 	if (!s->is_audio && ret == 0)
 		ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
-	else if (!s->is_dummy)
+	else if (!s->is_dummy && ret == 0)
 		ret = cobalt_alsa_init(s);
 
 	if (ret < 0) {
-		if (!s->is_audio)
+		if (!s->is_audio) {
+			if (s->sd)
+				cec_delete_adapter(&s->cec_adap);
 			cobalt_err("couldn't register v4l2 device node %d\n",
 					node);
+		}
 		return ret;
 	}
 	cobalt_info("registered node %d\n", node);
@@ -1264,9 +1357,12 @@ void cobalt_nodes_unregister(struct cobalt *cobalt)
 		struct cobalt_stream *s = cobalt->streams + node;
 		struct video_device *vdev = &s->vdev;
 
-		if (!s->is_audio)
+		if (!s->is_audio) {
 			video_unregister_device(vdev);
-		else if (!s->is_dummy)
+			if (s->sd)
+				cec_delete_adapter(&s->cec_adap);
+		} else if (!s->is_dummy) {
 			cobalt_alsa_exit(s);
+		}
 	}
 }
-- 
2.1.4

