Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35056 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbcBJNAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 08:00:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv12 17/17] vivid: add CEC emulation
Date: Wed, 10 Feb 2016 13:51:51 +0100
Message-Id: <1455108711-29850-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vivid driver has been extended to provide CEC adapters for the HDMI
input and HDMI outputs in order to test CEC applications.

This CEC emulation is faithful to the CEC timings (i.e., it all at a
snail's pace).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt             |  36 ++-
 drivers/media/platform/vivid/Kconfig            |   1 +
 drivers/media/platform/vivid/vivid-core.c       | 308 +++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-core.h       |  23 ++
 drivers/media/platform/vivid/vivid-vid-cap.c    |  23 ++
 drivers/media/platform/vivid/vivid-vid-common.c |  61 +++++
 drivers/media/platform/vivid/vivid-vid-common.h |   1 +
 7 files changed, 446 insertions(+), 7 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index e35d376..0d89715 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -74,7 +74,8 @@ Section 11: Cropping, Composing, Scaling
 Section 12: Formats
 Section 13: Capture Overlay
 Section 14: Output Overlay
-Section 15: Some Future Improvements
+Section 15: CEC (Consumer Electronics Control)
+Section 16: Some Future Improvements
 
 
 Section 1: Configuring the driver
@@ -364,7 +365,11 @@ For HDMI inputs it is possible to set the EDID. By default a simple EDID
 is provided. You can only set the EDID for HDMI inputs. Internally, however,
 the EDID is shared between all HDMI inputs.
 
-No interpretation is done of the EDID data.
+No interpretation is done of the EDID data with the exception of the
+physical address. See the CEC section for more details.
+
+There is a maximum of 15 HDMI inputs (if there are more, then they will be
+reduced to 15) since that's the limitation of the EDID physical address.
 
 
 Section 3: Video Output
@@ -409,6 +414,9 @@ standard, and for all others a 1:1 pixel aspect ratio is returned.
 
 An HDMI output has a valid EDID which can be obtained through VIDIOC_G_EDID.
 
+There is a maximum of 15 HDMI outputs (if there are more, then they will be
+reduced to 15) since that's the limitation of the EDID physical address. See
+also the CEC section for more details.
 
 Section 4: VBI Capture
 ----------------------
@@ -1108,7 +1116,26 @@ capabilities will slow down the video loop considerably as a lot of checks have
 to be done per pixel.
 
 
-Section 15: Some Future Improvements
+Section 15: CEC (Consumer Electronics Control)
+----------------------------------------------
+
+If there are HDMI inputs then a CEC adapter will be created that has
+the same number of input ports. This is the equivalent of e.g. a TV that
+has that number of inputs. Each HDMI output will also create a
+CEC adapter that is hooked up to the corresponding input port, or (if there
+are more outputs than inputs) is not hooked up at all. In other words,
+this is the equivalent of hooking up each output device to an input port of
+the TV. Any remaining output devices remain unconnected.
+
+The EDID that each output reads reports a unique CEC physical address that is
+based on the physical address of the EDID of the input. So if the EDID of the
+receiver has physical address A.B.0.0, then each output will see an EDID
+containing physical address A.B.C.0 where C is 1 to the number of inputs. If
+there are more outputs than inputs then the remaining outputs have a CEC adapter
+that is disabled and reports an invalid physical address.
+
+
+Section 16: Some Future Improvements
 ------------------------------------
 
 Just as a reminder and in no particular order:
@@ -1121,8 +1148,6 @@ Just as a reminder and in no particular order:
 - Fix sequence/field numbering when looping of video with alternate fields
 - Add support for V4L2_CID_BG_COLOR for video outputs
 - Add ARGB888 overlay support: better testing of the alpha channel
-- Add custom DV timings support
-- Add support for V4L2_DV_FL_REDUCED_FPS
 - Improve pixel aspect support in the tpg code by passing a real v4l2_fract
 - Use per-queue locks and/or per-device locks to improve throughput
 - Add support to loop from a specific output to a specific input across
@@ -1133,3 +1158,4 @@ Just as a reminder and in no particular order:
 - Make a thread for the RDS generation, that would help in particular for the
   "Controls" RDS Rx I/O Mode as the read-only RDS controls could be updated
   in real-time.
+- Changing the EDID should cause hotplug detect emulation to happen.
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 0885e93..8645bb6 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_VIVID
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select MEDIA_CEC
 	select VIDEOBUF2_VMALLOC
 	default n
 	---help---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ec125bec..c7bbd09 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -396,10 +396,19 @@ static int vidioc_log_status(struct file *file, void *fh)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
+	unsigned bus_idx;
 
 	v4l2_ctrl_log_status(file, fh);
 	if (vdev->vfl_dir == VFL_DIR_RX && vdev->vfl_type == VFL_TYPE_GRABBER)
 		tpg_log_status(&dev->tpg);
+	if (vdev->vfl_dir == VFL_DIR_RX && vdev->vfl_type == VFL_TYPE_GRABBER &&
+	    dev->cec_rx_adap)
+		cec_log_status(dev->cec_rx_adap);
+	if (vdev->vfl_dir == VFL_DIR_TX && vdev->vfl_type == VFL_TYPE_GRABBER &&
+	    dev->output_type[dev->output] == HDMI) {
+		bus_idx = dev->cec_output2bus_map[dev->output];
+		cec_log_status(dev->cec_tx_adap[bus_idx]);
+	}
 	return 0;
 }
 
@@ -646,6 +655,206 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	kfree(dev);
 }
 
+static void vivid_cec_bus_free_work(struct vivid_dev *dev)
+{
+	spin_lock(&dev->cec_slock);
+	while (!list_empty(&dev->cec_work_list)) {
+		struct vivid_cec_work *cw =
+			list_first_entry(&dev->cec_work_list,
+					 struct vivid_cec_work, list);
+
+		spin_unlock(&dev->cec_slock);
+		cancel_delayed_work_sync(&cw->work);
+		spin_lock(&dev->cec_slock);
+		list_del(&cw->list);
+		cec_transmit_done(cw->adap, CEC_TX_STATUS_LOW_DRIVE, 0, 0, 1, 0);
+		kfree(cw);
+	}
+	spin_unlock(&dev->cec_slock);
+}
+
+static struct cec_adapter *vivid_cec_find_dest_adap(struct vivid_dev *dev,
+						    struct cec_adapter *adap,
+						    u8 dest)
+{
+	unsigned i;
+
+	if (dest >= 0xf)
+		return NULL;
+
+	if (adap != dev->cec_rx_adap && dev->cec_rx_adap &&
+	    dev->cec_rx_adap->is_configured &&
+	    cec_has_log_addr(dev->cec_rx_adap, dest))
+		return dev->cec_rx_adap;
+
+	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++) {
+		if (adap == dev->cec_tx_adap[i])
+			continue;
+		if (!dev->cec_tx_adap[i]->is_configured)
+			continue;
+		if (cec_has_log_addr(dev->cec_tx_adap[i], dest))
+			return dev->cec_tx_adap[i];
+	}
+	return NULL;
+}
+
+static void vivid_cec_xfer_done_worker(struct work_struct *work)
+{
+	struct vivid_cec_work *cw =
+		container_of(work, struct vivid_cec_work, work.work);
+	struct vivid_dev *dev = cw->dev;
+	struct cec_adapter *adap = cw->adap;
+	bool is_poll = cw->msg.len == 1;
+	u8 dest = cec_msg_destination(&cw->msg);
+	struct cec_adapter *dest_adap = NULL;
+	bool valid_dest;
+	unsigned i;
+
+	valid_dest = cec_msg_is_broadcast(&cw->msg);
+	if (!valid_dest) {
+		dest_adap = vivid_cec_find_dest_adap(dev, adap, dest);
+		if (dest_adap)
+			valid_dest = true;
+	}
+	cw->tx_status = valid_dest ? CEC_TX_STATUS_OK : CEC_TX_STATUS_NACK;
+	spin_lock(&dev->cec_slock);
+	dev->cec_xfer_time_jiffies = 0;
+	dev->cec_xfer_start_jiffies = 0;
+	list_del(&cw->list);
+	spin_unlock(&dev->cec_slock);
+	cec_transmit_done(cw->adap, cw->tx_status, 0, valid_dest ? 0 : 1, 0, 0);
+
+	if (!is_poll && dest_adap) {
+		/* Directed message */
+		cec_received_msg(dest_adap, &cw->msg);
+	} else if (!is_poll && valid_dest) {
+		/* Broadcast message */
+		if (adap != dev->cec_rx_adap && dev->cec_rx_adap->log_addr_mask)
+			cec_received_msg(dev->cec_rx_adap, &cw->msg);
+		for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++) {
+			if (adap == dev->cec_tx_adap[i] ||
+			    !dev->cec_tx_adap[i]->log_addr_mask)
+				continue;
+			cec_received_msg(dev->cec_tx_adap[i], &cw->msg);
+		}
+	}
+	kfree(cw);
+}
+
+static void vivid_cec_xfer_try_worker(struct work_struct *work)
+{
+	struct vivid_cec_work *cw =
+		container_of(work, struct vivid_cec_work, work.work);
+	struct vivid_dev *dev = cw->dev;
+
+	spin_lock(&dev->cec_slock);
+	if (dev->cec_xfer_time_jiffies) {
+		list_del(&cw->list);
+		spin_unlock(&dev->cec_slock);
+		cec_transmit_done(cw->adap, CEC_TX_STATUS_ARB_LOST, 1, 0, 0, 0);
+		kfree(cw);
+	} else {
+		INIT_DELAYED_WORK(&cw->work, vivid_cec_xfer_done_worker);
+		dev->cec_xfer_start_jiffies = jiffies;
+		dev->cec_xfer_time_jiffies = msecs_to_jiffies(cw->msecs);
+		spin_unlock(&dev->cec_slock);
+		schedule_delayed_work(&cw->work, dev->cec_xfer_time_jiffies);
+	}
+}
+
+static int vivid_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	return 0;
+}
+
+static int vivid_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	return 0;
+}
+
+/*
+ * One data bit takes 2.4 ms, each byte needs 10 bits so that's 24 ms per byte.
+ */
+#define MSECS_PER_BYTE 24
+
+static int vivid_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time_ms, struct cec_msg *msg)
+{
+	struct vivid_dev *dev = adap->priv;
+	struct vivid_cec_work *cw = kzalloc(sizeof(*cw), GFP_KERNEL);
+	long delta_jiffies = 0;
+
+	if (cw == NULL)
+		return -ENOMEM;
+	cw->dev = dev;
+	cw->adap = adap;
+	cw->msecs = signal_free_time_ms + msg->len * MSECS_PER_BYTE;
+	cw->msg = *msg;
+
+	spin_lock(&dev->cec_slock);
+	list_add(&cw->list, &dev->cec_work_list);
+	if (dev->cec_xfer_time_jiffies == 0) {
+		INIT_DELAYED_WORK(&cw->work, vivid_cec_xfer_done_worker);
+		dev->cec_xfer_start_jiffies = jiffies;
+		dev->cec_xfer_time_jiffies = msecs_to_jiffies(cw->msecs);
+		delta_jiffies = dev->cec_xfer_time_jiffies;
+	} else {
+		INIT_DELAYED_WORK(&cw->work, vivid_cec_xfer_try_worker);
+		delta_jiffies = dev->cec_xfer_start_jiffies +
+			dev->cec_xfer_time_jiffies - jiffies;
+	}
+	spin_unlock(&dev->cec_slock);
+	schedule_delayed_work(&cw->work, delta_jiffies < 0 ? 0 : delta_jiffies);
+	return 0;
+}
+
+static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct cec_msg reply;
+	u16 pa;
+
+	cec_msg_init(&reply, adap->log_addr[0], cec_msg_initiator(msg));
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
+const struct cec_adap_ops vivid_cec_adap_ops = {
+	.adap_enable = vivid_cec_adap_enable,
+	.adap_log_addr = vivid_cec_adap_log_addr,
+	.adap_transmit = vivid_cec_adap_transmit,
+	.received = vivid_received,
+};
+
+static struct cec_adapter *vivid_create_cec_adap(struct vivid_dev *dev,
+						 unsigned idx,
+						 struct device *parent,
+						 bool is_source)
+{
+	char name[sizeof(dev->vid_out_dev.name) + 2];
+	u32 caps = CEC_CAP_IO | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC |
+		CEC_CAP_VENDOR_ID | (is_source ? CEC_CAP_IS_SOURCE : 0);
+
+	snprintf(name, sizeof(name), "%s%d",
+		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
+		 idx);
+	return cec_create_adapter(&vivid_cec_adap_ops, dev, name,
+		caps, is_source ? 0 : 1, THIS_MODULE, parent);
+}
+
 static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
@@ -699,6 +908,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		dev->input_name_counter[i] = in_type_counter[dev->input_type[i]]++;
 	}
 	dev->has_audio_inputs = in_type_counter[TV] && in_type_counter[SVID];
+	if (in_type_counter[HDMI] == 16) {
+		/* The CEC physical address only allows for max 15 inputs */
+		in_type_counter[HDMI]--;
+		dev->num_inputs--;
+	}
 
 	/* how many outputs do we have and of what type? */
 	dev->num_outputs = num_outputs[inst];
@@ -711,6 +925,15 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		dev->output_name_counter[i] = out_type_counter[dev->output_type[i]]++;
 	}
 	dev->has_audio_outputs = out_type_counter[SVID];
+	if (out_type_counter[HDMI] == 16) {
+		/*
+		 * The CEC physical address only allows for max 15 inputs,
+		 * so outputs are also limited to 15 to allow for easy
+		 * CEC output to input mapping.
+		 */
+		out_type_counter[HDMI]--;
+		dev->num_outputs--;
+	}
 
 	/* do we create a video capture device? */
 	dev->has_vid_cap = node_type & 0x0001;
@@ -1025,6 +1248,17 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	INIT_LIST_HEAD(&dev->vbi_out_active);
 	INIT_LIST_HEAD(&dev->sdr_cap_active);
 
+	INIT_LIST_HEAD(&dev->cec_work_list);
+	spin_lock_init(&dev->cec_slock);
+	/*
+	 * Same as create_singlethread_workqueue, but now I can use the
+	 * string formatting of alloc_ordered_workqueue.
+	 */
+	dev->cec_workqueue =
+		alloc_ordered_workqueue("vivid-cec%d", WQ_MEM_RECLAIM, inst);
+	if (!dev->cec_workqueue)
+		goto unreg_dev;
+
 	/* start creating the vb2 queues */
 	if (dev->has_vid_cap) {
 		/* initialize vid_cap queue */
@@ -1131,6 +1365,9 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	/* finally start creating the device nodes */
 	if (dev->has_vid_cap) {
+		unsigned cec_cnt = in_type_counter[HDMI];
+		struct cec_adapter *adap;
+
 		vfd = &dev->vid_cap_dev;
 		strlcpy(vfd->name, "vivid-vid-cap", sizeof(vfd->name));
 		vfd->fops = &vivid_fops;
@@ -1147,6 +1384,27 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+		if (cec_cnt) {
+			adap = vivid_create_cec_adap(dev, 0, &pdev->dev, false);
+			ret = PTR_ERR_OR_ZERO(adap);
+			if (ret < 0)
+				goto unreg_dev;
+			dev->cec_rx_adap = adap;
+			cec_connected_inputs(adap, cec_cnt);
+			ret = cec_register_adapter(adap);
+			if (ret < 0) {
+				cec_delete_adapter(adap);
+				dev->cec_rx_adap = NULL;
+				goto unreg_dev;
+			}
+			cec_set_phys_addr(adap, 0);
+			ret = cec_enable(adap, true);
+			if (ret < 0)
+				goto unreg_dev;
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI input %d\n",
+				  dev_name(&adap->devnode.dev), i);
+		}
+
 		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1155,6 +1413,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	}
 
 	if (dev->has_vid_out) {
+		unsigned bus_cnt = 0;
+
 		vfd = &dev->vid_out_dev;
 		strlcpy(vfd->name, "vivid-vid-out", sizeof(vfd->name));
 		vfd->vfl_dir = VFL_DIR_TX;
@@ -1172,6 +1432,37 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+		for (i = 0; i < dev->num_outputs; i++) {
+			struct cec_adapter *adap;
+
+			if (dev->output_type[i] != HDMI)
+				continue;
+			dev->cec_output2bus_map[i] = bus_cnt;
+			adap = vivid_create_cec_adap(dev, bus_cnt,
+						     &pdev->dev, true);
+			ret = PTR_ERR_OR_ZERO(adap);
+			if (ret < 0)
+				goto unreg_dev;
+			dev->cec_tx_adap[bus_cnt] = adap;
+			ret = cec_register_adapter(adap);
+			if (ret < 0) {
+				cec_delete_adapter(adap);
+				dev->cec_tx_adap[bus_cnt] = NULL;
+				goto unreg_dev;
+			}
+			bus_cnt++;
+			if (bus_cnt <= in_type_counter[HDMI]) {
+				cec_set_phys_addr(adap, bus_cnt << 12);
+				ret = cec_enable(adap, true);
+				if (ret < 0)
+					goto unreg_dev;
+			} else {
+				cec_set_phys_addr(adap, 0x1000);
+			}
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI output %d\n",
+				  dev_name(&adap->devnode.dev), i);
+		}
+
 		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_out_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1290,6 +1581,13 @@ unreg_dev:
 	video_unregister_device(&dev->vbi_cap_dev);
 	video_unregister_device(&dev->vid_out_dev);
 	video_unregister_device(&dev->vid_cap_dev);
+	cec_unregister_adapter(dev->cec_rx_adap);
+	for (i = 0; i < MAX_OUTPUTS; i++)
+		cec_unregister_adapter(dev->cec_tx_adap[i]);
+	if (dev->cec_workqueue) {
+		vivid_cec_bus_free_work(dev);
+		destroy_workqueue(dev->cec_workqueue);
+	}
 free_dev:
 	v4l2_device_put(&dev->v4l2_dev);
 	return ret;
@@ -1339,8 +1637,7 @@ static int vivid_probe(struct platform_device *pdev)
 static int vivid_remove(struct platform_device *pdev)
 {
 	struct vivid_dev *dev;
-	unsigned i;
-
+	unsigned i, j;
 
 	for (i = 0; i < n_devs; i++) {
 		dev = vivid_devs[i];
@@ -1388,6 +1685,13 @@ static int vivid_remove(struct platform_device *pdev)
 			unregister_framebuffer(&dev->fb_info);
 			vivid_fb_release_buffers(dev);
 		}
+		cec_unregister_adapter(dev->cec_rx_adap);
+		for (j = 0; j < MAX_OUTPUTS; j++)
+			cec_unregister_adapter(dev->cec_tx_adap[j]);
+		if (dev->cec_workqueue) {
+			vivid_cec_bus_free_work(dev);
+			destroy_workqueue(dev->cec_workqueue);
+		}
 		v4l2_device_put(&dev->v4l2_dev);
 		vivid_devs[i] = NULL;
 	}
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 751c1ba..f864fb9 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -21,6 +21,8 @@
 #define _VIVID_CORE_H_
 
 #include <linux/fb.h>
+#include <linux/workqueue.h>
+#include <media/cec.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
@@ -132,6 +134,17 @@ enum vivid_colorspace {
 #define VIVID_INVALID_SIGNAL(mode) \
 	((mode) == NO_SIGNAL || (mode) == NO_LOCK || (mode) == OUT_OF_RANGE)
 
+struct vivid_cec_work {
+	struct list_head	list;
+	struct delayed_work	work;
+	struct cec_adapter	*adap;
+	struct vivid_dev	*dev;
+	unsigned		msecs;
+	unsigned		timeout_ms;
+	u8			tx_status;
+	struct cec_msg		msg;
+};
+
 struct vivid_dev {
 	unsigned			inst;
 	struct v4l2_device		v4l2_dev;
@@ -497,6 +510,16 @@ struct vivid_dev {
 	/* Shared between radio receiver and transmitter */
 	bool				radio_rds_loop;
 	struct timespec			radio_rds_init_ts;
+
+	/* CEC */
+	struct cec_adapter		*cec_rx_adap;
+	struct cec_adapter		*cec_tx_adap[MAX_OUTPUTS];
+	struct workqueue_struct		*cec_workqueue;
+	spinlock_t			cec_slock;
+	struct list_head		cec_work_list;
+	unsigned			cec_xfer_time_jiffies;
+	unsigned long			cec_xfer_start_jiffies;
+	u8				cec_output2bus_map[MAX_OUTPUTS];
 };
 
 static inline bool vivid_is_webcam(const struct vivid_dev *dev)
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b84f081..7ab5fa9 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1700,6 +1700,9 @@ int vidioc_s_edid(struct file *file, void *_fh,
 			 struct v4l2_edid *edid)
 {
 	struct vivid_dev *dev = video_drvdata(file);
+	u16 phys_addr;
+	unsigned shift;
+	unsigned i;
 
 	memset(edid->reserved, 0, sizeof(edid->reserved));
 	if (edid->pad >= dev->num_inputs)
@@ -1714,8 +1717,28 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		edid->blocks = dev->edid_max_blocks;
 		return -E2BIG;
 	}
+	phys_addr = vivid_get_edid_phys_addr(edid->edid, edid->blocks * 128);
+	/*
+	 * Invalid physical address, all nibbles are used and no physical
+	 * addresses can be assigned to the inputs.
+	 */
+	if (phys_addr & 0xf)
+		return -EINVAL;
+	if (vb2_is_busy(&dev->vb_vid_cap_q))
+		return -EBUSY;
+
 	dev->edid_blocks = edid->blocks;
 	memcpy(dev->edid, edid->edid, edid->blocks * 128);
+
+	/* TODO: a proper hotplug detect cycle should be emulated here */
+	cec_set_phys_addr(dev->cec_rx_adap, phys_addr);
+	/* Note: we already checked above that the lowest nibble == 0 */
+	for (shift = 4; shift < 16; shift += 4)
+		if (phys_addr & (0xf << shift))
+			break;
+	shift -= 4;
+	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++)
+		cec_set_phys_addr(dev->cec_tx_adap[i], phys_addr | ((i + 1) << shift));
 	return 0;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 1678b73..3852c71 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -868,11 +868,66 @@ int vidioc_dv_timings_cap(struct file *file, void *_fh,
 	return 0;
 }
 
+static int get_edid_spa_location(const u8 *edid, unsigned size)
+{
+	u8 d;
+
+	if (size < 256)
+		return -1;
+
+	if (edid[0x7e] != 1 || edid[0x80] != 0x02 || edid[0x81] != 0x03)
+		return -1;
+
+	/* search Vendor Specific Data Block (tag 3) */
+	d = edid[0x82] & 0x7f;
+	if (d > 4) {
+		int i = 0x84;
+		int end = 0x80 + d;
+
+		do {
+			u8 tag = edid[i] >> 5;
+			u8 len = edid[i] & 0x1f;
+
+			if (tag == 3 && len >= 5)
+				return i + 4;
+			i += len + 1;
+		} while (i < end);
+	}
+	return -1;
+}
+
+static void set_edid_phys_addr(u8 *edid, unsigned size, u16 phys_addr)
+{
+	int loc = get_edid_spa_location(edid, size);
+	u8 sum = 0;
+	int i;
+
+	if (loc < 0)
+		return;
+	edid[loc] = phys_addr >> 8;
+	edid[loc + 1] = phys_addr & 0xff;
+	loc &= ~0x7f;
+
+	for (i = loc; i < loc + 127; i++)
+		sum += edid[i];
+	edid[i] = 256 - sum;
+}
+
+u16 vivid_get_edid_phys_addr(const u8 *edid, unsigned size)
+{
+	int loc = get_edid_spa_location(edid, size);
+
+	if (loc < 0)
+		return CEC_PHYS_ADDR_INVALID;
+	return (edid[loc] << 8) | edid[loc + 1];
+}
+
 int vidioc_g_edid(struct file *file, void *_fh,
 			 struct v4l2_edid *edid)
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
+	struct cec_adapter *adap;
 
 	memset(edid->reserved, 0, sizeof(edid->reserved));
 	if (vdev->vfl_dir == VFL_DIR_RX) {
@@ -880,11 +935,16 @@ int vidioc_g_edid(struct file *file, void *_fh,
 			return -EINVAL;
 		if (dev->input_type[edid->pad] != HDMI)
 			return -EINVAL;
+		adap = dev->cec_rx_adap;
 	} else {
+		unsigned bus_idx;
+
 		if (edid->pad >= dev->num_outputs)
 			return -EINVAL;
 		if (dev->output_type[edid->pad] != HDMI)
 			return -EINVAL;
+		bus_idx = dev->cec_output2bus_map[edid->pad];
+		adap = dev->cec_tx_adap[bus_idx];
 	}
 	if (edid->start_block == 0 && edid->blocks == 0) {
 		edid->blocks = dev->edid_blocks;
@@ -897,5 +957,6 @@ int vidioc_g_edid(struct file *file, void *_fh,
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	memcpy(edid->edid, dev->edid, edid->blocks * 128);
+	set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-common.h b/drivers/media/platform/vivid/vivid-vid-common.h
index 3ec4fa8..ea203da 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.h
+++ b/drivers/media/platform/vivid/vivid-vid-common.h
@@ -47,6 +47,7 @@ struct v4l2_rect rect_intersect(const struct v4l2_rect *a, const struct v4l2_rec
 void rect_scale(struct v4l2_rect *r, const struct v4l2_rect *from,
 				     const struct v4l2_rect *to);
 int vivid_vid_adjust_sel(unsigned flags, struct v4l2_rect *r);
+u16 vivid_get_edid_phys_addr(const u8 *edid, unsigned size);
 
 int vivid_enum_fmt_vid(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
 int vidioc_enum_fmt_vid_mplane(struct file *file, void  *priv, struct v4l2_fmtdesc *f);
-- 
2.7.0

