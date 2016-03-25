Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:46697 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbcCYNUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 09:20:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv14 15/18] cobalt: add cec support
Date: Fri, 25 Mar 2016 14:10:13 +0100
Message-Id: <1458911416-47981-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
References: <1458911416-47981-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add CEC support to the cobalt driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/Kconfig         |   1 +
 drivers/media/pci/cobalt/cobalt-driver.c | 102 +++++++++++++++++++++++++------
 drivers/media/pci/cobalt/cobalt-driver.h |   2 +
 drivers/media/pci/cobalt/cobalt-irq.c    |   3 +
 drivers/media/pci/cobalt/cobalt-v4l2.c   |  96 ++++++++++++++++++++++++++---
 drivers/media/pci/cobalt/cobalt-v4l2.h   |   2 +
 6 files changed, 180 insertions(+), 26 deletions(-)

diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index a01f0cc..9125747 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_COBALT
 	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
 	depends on GPIOLIB || COMPILE_TEST
 	depends on SND
+	select MEDIA_CEC
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index 8d6f04f..dff92ef 100644
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
@@ -149,17 +150,42 @@ static void cobalt_notify(struct v4l2_subdev *sd,
 	struct cobalt *cobalt = to_cobalt(sd->v4l2_dev);
 	unsigned sd_nr = cobalt_get_sd_nr(sd);
 	struct cobalt_stream *s = &cobalt->streams[sd_nr];
-	bool hotplug = arg ? *((int *)arg) : false;
+	struct v4l2_subdev_cec_tx_done *tx_done = arg;
 
-	if (s->is_output)
+	switch (notification) {
+	case V4L2_SUBDEV_CEC_TX_DONE:
+		cec_transmit_done(s->cec_adap, tx_done->status,
+				  tx_done->arb_lost_cnt, tx_done->nack_cnt,
+				  tx_done->low_drive_cnt, tx_done->error_cnt);
+		return;
+	case V4L2_SUBDEV_CEC_RX_MSG:
+		cec_received_msg(s->cec_adap, arg);
 		return;
+	default:
+		break;
+	}
+
+	if (s->is_output) {
+		switch (notification) {
+		case ADV7511_EDID_DETECT: {
+			struct adv7511_edid_detect *ed = arg;
+
+			cec_s_phys_addr(s->cec_adap, ed->phys_addr, false);
+			break;
+		}
+		}
+		return;
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
@@ -438,12 +464,15 @@ static void cobalt_stream_struct_init(struct cobalt *cobalt)
 
 	for (i = 0; i < COBALT_NUM_STREAMS; i++) {
 		struct cobalt_stream *s = &cobalt->streams[i];
+		struct video_device *vdev = &s->vdev;
 
 		s->cobalt = cobalt;
 		s->flags = 0;
 		s->is_audio = false;
 		s->is_output = false;
 		s->is_dummy = true;
+		snprintf(vdev->name, sizeof(vdev->name),
+			 "%s-%d", cobalt->v4l2_dev.name, i);
 
 		/* The Memory DMA channels will always get a lower channel
 		 * number than the FIFO DMA. Video input should map to the
@@ -485,6 +514,19 @@ static void cobalt_stream_struct_init(struct cobalt *cobalt)
 	}
 }
 
+static int cobalt_create_cec_adap(struct cobalt_stream *s)
+{
+	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC;
+
+	if (s->is_output)
+		caps |= CEC_CAP_IS_SOURCE;
+	s->cec_adap = cec_create_adapter(&cobalt_cec_adap_ops,
+				 s, s->vdev.name, caps, 1,
+				 &s->cobalt->pci_dev->dev);
+	return PTR_ERR_OR_ZERO(s->cec_adap);
+}
+
 static int cobalt_subdevs_init(struct cobalt *cobalt)
 {
 	static struct adv76xx_platform_data adv7604_pdata = {
@@ -508,10 +550,10 @@ static int cobalt_subdevs_init(struct cobalt *cobalt)
 		.platform_data = &adv7604_pdata,
 	};
 
-	struct cobalt_stream *s = cobalt->streams;
 	int i;
 
 	for (i = 0; i < COBALT_NUM_INPUTS; i++) {
+		struct cobalt_stream *s = cobalt->streams + i;
 		struct v4l2_subdev_format sd_fmt = {
 			.pad = ADV7604_PAD_SOURCE,
 			.which = V4L2_SUBDEV_FORMAT_ACTIVE,
@@ -525,28 +567,37 @@ static int cobalt_subdevs_init(struct cobalt *cobalt)
 		};
 		int err;
 
-		s[i].pad_source = ADV7604_PAD_SOURCE;
-		s[i].i2c_adap = &cobalt->i2c_adap[i];
-		if (s[i].i2c_adap->dev.parent == NULL)
+		s->pad_source = ADV7604_PAD_SOURCE;
+		s->i2c_adap = &cobalt->i2c_adap[i];
+		if (s->i2c_adap->dev.parent == NULL)
+			continue;
+		err = cobalt_create_cec_adap(s);
+		if (err && !cobalt_ignore_err)
 			continue;
+		if (err)
+			return err;
 		cobalt_s_bit_sysctrl(cobalt,
 				COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(i), 1);
-		s[i].sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
-			s[i].i2c_adap, &adv7604_info, NULL);
-		if (!s[i].sd) {
+		s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
+			s->i2c_adap, &adv7604_info, NULL);
+		if (!s->sd) {
+			cec_delete_adapter(s->cec_adap);
+			s->cec_adap = NULL;
 			if (cobalt_ignore_err)
 				continue;
 			return -ENODEV;
 		}
-		err = v4l2_subdev_call(s[i].sd, video, s_routing,
+		cec_s_available_log_addrs(s->cec_adap,
+			v4l2_subdev_call(s->sd, cec, adap_available_log_addrs));
+		err = v4l2_subdev_call(s->sd, video, s_routing,
 				ADV76XX_PAD_HDMI_PORT_A, 0, 0);
 		if (err)
 			return err;
-		err = v4l2_subdev_call(s[i].sd, pad, set_edid,
+		err = v4l2_subdev_call(s->sd, pad, set_edid,
 				&cobalt_edid);
 		if (err)
 			return err;
-		err = v4l2_subdev_call(s[i].sd, pad, set_fmt, NULL,
+		err = v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
 				&sd_fmt);
 		if (err)
 			return err;
@@ -557,7 +608,7 @@ static int cobalt_subdevs_init(struct cobalt *cobalt)
 		cobalt_s_bit_sysctrl(cobalt,
 				COBALT_SYS_CTRL_VIDEO_RX_RESETN_BIT(i), 1);
 		mdelay(1);
-		s[i].is_dummy = false;
+		s->is_dummy = false;
 		cobalt->streams[i + COBALT_AUDIO_IN_STREAM].is_dummy = false;
 	}
 	return 0;
@@ -618,17 +669,24 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 		.edid = edid,
 	};
 	struct cobalt_stream *s = &cobalt->streams[COBALT_HSMA_IN_NODE];
+	int err;
 
 	s->i2c_adap = &cobalt->i2c_adap[COBALT_NUM_ADAPTERS - 1];
 	if (s->i2c_adap->dev.parent == NULL)
 		return 0;
+	err = cobalt_create_cec_adap(s);
+	if (err)
+		return err;
 	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(4), 1);
 
 	s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
 			s->i2c_adap, &adv7842_info, NULL);
 	if (s->sd) {
-		int err = v4l2_subdev_call(s->sd, pad, set_edid, &cobalt_edid);
+		int err;
 
+		cec_s_available_log_addrs(s->cec_adap,
+			v4l2_subdev_call(s->sd, cec, adap_available_log_addrs));
+		err = v4l2_subdev_call(s->sd, pad, set_edid, &cobalt_edid);
 		if (err)
 			return err;
 		err = v4l2_subdev_call(s->sd, pad, set_fmt, NULL,
@@ -650,8 +708,13 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 	}
 	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_NRESET_TO_HDMI_BIT(4), 0);
 	cobalt_s_bit_sysctrl(cobalt, COBALT_SYS_CTRL_PWRDN0_TO_HSMA_TX_BIT, 0);
+	cec_delete_adapter(s->cec_adap);
+	s->cec_adap = NULL;
 	s++;
 	s->i2c_adap = &cobalt->i2c_adap[COBALT_NUM_ADAPTERS - 1];
+	err = cobalt_create_cec_adap(s);
+	if (err)
+		return err;
 	s->sd = v4l2_i2c_new_subdev_board(&cobalt->v4l2_dev,
 			s->i2c_adap, &adv7511_info, NULL);
 	if (s->sd) {
@@ -663,6 +726,8 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 		cobalt_s_bit_sysctrl(cobalt,
 				COBALT_SYS_CTRL_VIDEO_TX_RESETN_BIT, 1);
 		cobalt->have_hsma_tx = true;
+		cec_s_available_log_addrs(s->cec_adap,
+			v4l2_subdev_call(s->sd, cec, adap_available_log_addrs));
 		v4l2_subdev_call(s->sd, core, s_power, 1);
 		v4l2_subdev_call(s->sd, video, s_stream, 1);
 		v4l2_subdev_call(s->sd, audio, s_stream, 1);
@@ -672,6 +737,8 @@ static int cobalt_subdevs_hsma_init(struct cobalt *cobalt)
 		cobalt->streams[COBALT_AUDIO_OUT_STREAM].is_dummy = false;
 		return 0;
 	}
+	cec_delete_adapter(s->cec_adap);
+	s->cec_adap = NULL;
 	return -ENODEV;
 }
 
@@ -797,8 +864,9 @@ static void cobalt_remove(struct pci_dev *pci_dev)
 	cobalt_set_interrupt(cobalt, false);
 	flush_workqueue(cobalt->irq_work_queues);
 	cobalt_nodes_unregister(cobalt);
-	for (i = 0; i < COBALT_NUM_ADAPTERS; i++) {
-		struct v4l2_subdev *sd = cobalt->streams[i].sd;
+	for (i = 0; i < COBALT_NUM_STREAMS; i++) {
+		struct cobalt_stream *s = &cobalt->streams[i];
+		struct v4l2_subdev *sd = s->sd;
 		struct i2c_client *client;
 
 		if (sd == NULL)
diff --git a/drivers/media/pci/cobalt/cobalt-driver.h b/drivers/media/pci/cobalt/cobalt-driver.h
index b2f08e4..66211f8 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.h
+++ b/drivers/media/pci/cobalt/cobalt-driver.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
+#include <media/cec.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
@@ -223,6 +224,7 @@ struct cobalt_stream {
 	struct list_head bufs;
 	struct i2c_adapter *i2c_adap;
 	struct v4l2_subdev *sd;
+	struct cec_adapter *cec_adap;
 	struct mutex lock;
 	spinlock_t irqlock;
 	struct v4l2_dv_timings timings;
diff --git a/drivers/media/pci/cobalt/cobalt-irq.c b/drivers/media/pci/cobalt/cobalt-irq.c
index b190d4f..9cd1596 100644
--- a/drivers/media/pci/cobalt/cobalt-irq.c
+++ b/drivers/media/pci/cobalt/cobalt-irq.c
@@ -234,6 +234,9 @@ void cobalt_irq_log_status(struct cobalt *cobalt)
 	u32 mask;
 	int i;
 
+	cobalt_info("irq: edge=%08x mask=%08x\n",
+		    cobalt_read_bar1(cobalt, COBALT_SYS_STAT_EDGE),
+		    cobalt_read_bar1(cobalt, COBALT_SYS_STAT_MASK));
 	cobalt_info("irq: adv1=%u adv2=%u advout=%u none=%u full=%u\n",
 		    cobalt->irq_adv1, cobalt->irq_adv2, cobalt->irq_advout,
 		    cobalt->irq_none, cobalt->irq_full_fifo);
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index c0ba458..1c00748 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -600,6 +600,7 @@ static int cobalt_log_status(struct file *file, void *priv_fh)
 	cobalt_pcie_status_show(cobalt);
 	cobalt_cpld_status(cobalt);
 	cobalt_irq_log_status(cobalt);
+	cec_log_status(s->cec_adap, NULL);
 	v4l2_subdev_call(s->sd, core, log_status);
 	if (!s->is_output) {
 		cobalt_video_input_status_show(s);
@@ -1059,6 +1060,16 @@ static int cobalt_s_edid(struct file *file, void *fh, struct v4l2_edid *edid)
 	edid->pad = 0;
 	ret = v4l2_subdev_call(s->sd, pad, set_edid, edid);
 	edid->pad = pad;
+	if (!ret) {
+		u16 pa = CEC_PHYS_ADDR_INVALID;
+
+		if (edid->blocks) {
+			pa = cec_get_edid_phys_addr(edid->edid,
+						    edid->blocks * 128, NULL);
+			pa = cec_phys_addr_parent(pa);
+		}
+		cec_s_phys_addr(s->cec_adap, pa, false);
+	}
 	return ret;
 }
 
@@ -1159,6 +1170,62 @@ static const struct v4l2_file_operations cobalt_empty_fops = {
 	.release = v4l2_fh_release,
 };
 
+static inline struct v4l2_subdev *adap_to_sd(struct cec_adapter *adap)
+{
+	struct cobalt_stream *s = adap->priv;
+
+	return s->sd;
+}
+
+static int cobalt_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), cec, adap_enable, enable);
+}
+
+static int cobalt_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), cec, adap_log_addr,
+				log_addr);
+}
+
+static int cobalt_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				    u32 signal_free_time, struct cec_msg *msg)
+{
+	return v4l2_subdev_call(adap_to_sd(adap), cec, adap_transmit,
+				attempts, signal_free_time, msg);
+}
+
+static int cobalt_received(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_msg reply;
+	u16 pa;
+
+	cec_msg_init(&reply, adap->log_addrs.log_addr[0],
+		     cec_msg_initiator(msg));
+
+	switch (msg->msg[1]) {
+	case CEC_MSG_SET_STREAM_PATH:
+		if (!adap->is_source)
+			return -ENOMSG;
+		cec_ops_set_stream_path(msg, &pa);
+		if (pa != adap->phys_addr)
+			return -ENOMSG;
+		cec_msg_active_source(&reply, adap->phys_addr);
+		cec_transmit_msg(adap, &reply, false);
+		break;
+	default:
+		return -ENOMSG;
+	}
+	return 0;
+}
+
+const struct cec_adap_ops cobalt_cec_adap_ops = {
+	.adap_enable = cobalt_cec_adap_enable,
+	.adap_log_addr = cobalt_cec_adap_log_addr,
+	.adap_transmit = cobalt_cec_adap_transmit,
+	.received = cobalt_received,
+};
+
 static int cobalt_node_register(struct cobalt *cobalt, int node)
 {
 	static const struct v4l2_dv_timings dv1080p60 =
@@ -1166,13 +1233,11 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	struct cobalt_stream *s = cobalt->streams + node;
 	struct video_device *vdev = &s->vdev;
 	struct vb2_queue *q = &s->q;
-	int ret;
+	int ret = 0;
 
 	mutex_init(&s->lock);
 	spin_lock_init(&s->irqlock);
 
-	snprintf(vdev->name, sizeof(vdev->name),
-			"%s-%d", cobalt->v4l2_dev.name, node);
 	s->width = 1920;
 	/* Audio frames are just 4 lines of 1920 bytes */
 	s->height = s->is_audio ? 4 : 1080;
@@ -1193,6 +1258,11 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 	if (!s->is_audio) {
 		if (s->is_dummy)
 			cobalt_warn("Setting up dummy video node %d\n", node);
+		if (s->sd) {
+			ret = cec_register_adapter(s->cec_adap);
+			if (ret)
+				return ret;
+		}
 		vdev->v4l2_dev = &cobalt->v4l2_dev;
 		if (s->is_dummy)
 			vdev->fops = &cobalt_empty_fops;
@@ -1206,8 +1276,10 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
 			vdev->ctrl_handler = s->sd->ctrl_handler;
 		s->timings = dv1080p60;
 		v4l2_subdev_call(s->sd, video, s_dv_timings, &s->timings);
-		if (!s->is_output && s->sd)
+		if (!s->is_output && s->sd) {
 			cobalt_enable_input(s);
+			cec_s_phys_addr(s->cec_adap, 0, false);
+		}
 		vdev->ioctl_ops = s->is_dummy ? &cobalt_ioctl_empty_ops :
 				  &cobalt_ioctl_ops;
 	}
@@ -1227,16 +1299,20 @@ static int cobalt_node_register(struct cobalt *cobalt, int node)
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
+				cec_unregister_adapter(s->cec_adap);
 			cobalt_err("couldn't register v4l2 device node %d\n",
 					node);
+		}
 		return ret;
 	}
 	cobalt_info("registered node %d\n", node);
@@ -1267,9 +1343,11 @@ void cobalt_nodes_unregister(struct cobalt *cobalt)
 		struct cobalt_stream *s = cobalt->streams + node;
 		struct video_device *vdev = &s->vdev;
 
-		if (!s->is_audio)
+		if (!s->is_audio) {
 			video_unregister_device(vdev);
-		else if (!s->is_dummy)
+			cec_unregister_adapter(s->cec_adap);
+		} else if (!s->is_dummy) {
 			cobalt_alsa_exit(s);
+		}
 	}
 }
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.h b/drivers/media/pci/cobalt/cobalt-v4l2.h
index 62be553..5be36cc 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.h
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.h
@@ -18,5 +18,7 @@
  *  SOFTWARE.
  */
 
+extern const struct cec_adap_ops cobalt_cec_adap_ops;
+
 int cobalt_nodes_register(struct cobalt *cobalt);
 void cobalt_nodes_unregister(struct cobalt *cobalt);
-- 
2.7.0

