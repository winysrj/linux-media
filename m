Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60036 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbcFYNHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2016 09:07:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv19 14/14] vivid: add CEC emulation
Date: Sat, 25 Jun 2016 15:06:38 +0200
Message-Id: <1466859998-17640-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
References: <1466859998-17640-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vivid driver has been extended to provide CEC adapters for the HDMI
input and HDMI outputs in order to test CEC applications.

This CEC emulation is faithful to the CEC timings (i.e., it all at a
snail's pace).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt              |  36 +++-
 drivers/media/platform/vivid/Kconfig             |   8 +
 drivers/media/platform/vivid/Makefile            |   4 +
 drivers/media/platform/vivid/vivid-cec.c         | 255 +++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-cec.h         |  33 +++
 drivers/media/platform/vivid/vivid-core.c        | 118 ++++++++++-
 drivers/media/platform/vivid/vivid-core.h        |  27 +++
 drivers/media/platform/vivid/vivid-kthread-cap.c |  13 ++
 drivers/media/platform/vivid/vivid-vid-cap.c     |  23 +-
 drivers/media/platform/vivid/vivid-vid-common.c  |   7 +
 10 files changed, 509 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/platform/vivid/vivid-cec.c
 create mode 100644 drivers/media/platform/vivid/vivid-cec.h

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index 8da5d2a..1b26519 100644
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
index f535f57..8e6918c 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -6,6 +6,7 @@ config VIDEO_VIVID
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select MEDIA_CEC_EDID
 	select VIDEOBUF2_VMALLOC
 	select VIDEO_V4L2_TPG
 	default n
@@ -22,6 +23,13 @@ config VIDEO_VIVID
 	  Say Y here if you want to test video apps or debug V4L devices.
 	  When in doubt, say N.
 
+config VIDEO_VIVID_CEC
+	bool "Enable CEC emulation support"
+	depends on VIDEO_VIVID && MEDIA_CEC
+	---help---
+	  When selected the vivid module will emulate the optional
+	  HDMI CEC feature.
+
 config VIDEO_VIVID_MAX_DEVS
 	int "Maximum number of devices"
 	depends on VIDEO_VIVID
diff --git a/drivers/media/platform/vivid/Makefile b/drivers/media/platform/vivid/Makefile
index 633c8a1b..2973881 100644
--- a/drivers/media/platform/vivid/Makefile
+++ b/drivers/media/platform/vivid/Makefile
@@ -3,4 +3,8 @@ vivid-objs := vivid-core.o vivid-ctrls.o vivid-vid-common.o vivid-vbi-gen.o \
 		vivid-radio-rx.o vivid-radio-tx.o vivid-radio-common.o \
 		vivid-rds-gen.o vivid-sdr-cap.o vivid-vbi-cap.o vivid-vbi-out.o \
 		vivid-osd.o
+ifeq ($(CONFIG_VIDEO_VIVID_CEC),y)
+  vivid-objs += vivid-cec.o
+endif
+
 obj-$(CONFIG_VIDEO_VIVID) += vivid.o
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
new file mode 100644
index 0000000..b5714fa
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -0,0 +1,255 @@
+/*
+ * vivid-cec.c - A Virtual Video Test Driver, cec emulation
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <media/cec.h>
+
+#include "vivid-core.h"
+#include "vivid-cec.h"
+
+void vivid_cec_bus_free_work(struct vivid_dev *dev)
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
+	unsigned int i;
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
+	unsigned int i;
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
+		if (adap != dev->cec_rx_adap &&
+		    dev->cec_rx_adap->log_addrs.log_addr_mask)
+			cec_received_msg(dev->cec_rx_adap, &cw->msg);
+		for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++) {
+			if (adap == dev->cec_tx_adap[i] ||
+			    !dev->cec_tx_adap[i]->log_addrs.log_addr_mask)
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
+		dev->cec_xfer_time_jiffies = usecs_to_jiffies(cw->usecs);
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
+ * One data bit takes 2400 us, each byte needs 10 bits so that's 24000 us
+ * per byte.
+ */
+#define USECS_PER_BYTE 24000
+
+static int vivid_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time, struct cec_msg *msg)
+{
+	struct vivid_dev *dev = adap->priv;
+	struct vivid_cec_work *cw = kzalloc(sizeof(*cw), GFP_KERNEL);
+	long delta_jiffies = 0;
+
+	if (cw == NULL)
+		return -ENOMEM;
+	cw->dev = dev;
+	cw->adap = adap;
+	cw->usecs = CEC_FREE_TIME_TO_USEC(signal_free_time) +
+		    msg->len * USECS_PER_BYTE;
+	cw->msg = *msg;
+
+	spin_lock(&dev->cec_slock);
+	list_add(&cw->list, &dev->cec_work_list);
+	if (dev->cec_xfer_time_jiffies == 0) {
+		INIT_DELAYED_WORK(&cw->work, vivid_cec_xfer_done_worker);
+		dev->cec_xfer_start_jiffies = jiffies;
+		dev->cec_xfer_time_jiffies = usecs_to_jiffies(cw->usecs);
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
+	struct vivid_dev *dev = adap->priv;
+	struct cec_msg reply;
+	u8 dest = cec_msg_destination(msg);
+	u16 pa;
+	u8 disp_ctl;
+	char osd[14];
+
+	if (cec_msg_is_broadcast(msg))
+		dest = adap->log_addrs.log_addr[0];
+	cec_msg_init(&reply, dest, cec_msg_initiator(msg));
+
+	switch (cec_msg_opcode(msg)) {
+	case CEC_MSG_SET_STREAM_PATH:
+		if (cec_is_sink(adap))
+			return -ENOMSG;
+		cec_ops_set_stream_path(msg, &pa);
+		if (pa != adap->phys_addr)
+			return -ENOMSG;
+		cec_msg_active_source(&reply, adap->phys_addr);
+		cec_transmit_msg(adap, &reply, false);
+		break;
+	case CEC_MSG_SET_OSD_STRING:
+		if (!cec_is_sink(adap))
+			return -ENOMSG;
+		cec_ops_set_osd_string(msg, &disp_ctl, osd);
+		switch (disp_ctl) {
+		case CEC_OP_DISP_CTL_DEFAULT:
+			strcpy(dev->osd, osd);
+			dev->osd_jiffies = jiffies;
+			break;
+		case CEC_OP_DISP_CTL_UNTIL_CLEARED:
+			strcpy(dev->osd, osd);
+			dev->osd_jiffies = 0;
+			break;
+		case CEC_OP_DISP_CTL_CLEAR:
+			dev->osd[0] = 0;
+			dev->osd_jiffies = 0;
+			break;
+		default:
+			cec_msg_feature_abort(&reply, cec_msg_opcode(msg),
+					      CEC_OP_ABORT_INVALID_OP);
+			cec_transmit_msg(adap, &reply, false);
+			break;
+		}
+		break;
+	default:
+		return -ENOMSG;
+	}
+	return 0;
+}
+
+static const struct cec_adap_ops vivid_cec_adap_ops = {
+	.adap_enable = vivid_cec_adap_enable,
+	.adap_log_addr = vivid_cec_adap_log_addr,
+	.adap_transmit = vivid_cec_adap_transmit,
+	.received = vivid_received,
+};
+
+struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
+					 unsigned int idx,
+					 struct device *parent,
+					 bool is_source)
+{
+	char name[sizeof(dev->vid_out_dev.name) + 2];
+	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC;
+
+	snprintf(name, sizeof(name), "%s%d",
+		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
+		 idx);
+	return cec_allocate_adapter(&vivid_cec_adap_ops, dev,
+		name, caps, 1, parent);
+}
diff --git a/drivers/media/platform/vivid/vivid-cec.h b/drivers/media/platform/vivid/vivid-cec.h
new file mode 100644
index 0000000..97892af
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-cec.h
@@ -0,0 +1,33 @@
+/*
+ * vivid-cec.h - A Virtual Video Test Driver, cec emulation
+ *
+ * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifdef CONFIG_VIDEO_VIVID_CEC
+struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
+					 unsigned int idx,
+					 struct device *parent,
+					 bool is_source);
+void vivid_cec_bus_free_work(struct vivid_dev *dev);
+
+#else
+
+static inline void vivid_cec_bus_free_work(struct vivid_dev *dev)
+{
+}
+
+#endif
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c14da84..9966828 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -46,6 +46,7 @@
 #include "vivid-vbi-cap.h"
 #include "vivid-vbi-out.h"
 #include "vivid-osd.h"
+#include "vivid-cec.h"
 #include "vivid-ctrls.h"
 
 #define VIVID_MODULE_NAME "vivid"
@@ -684,6 +685,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
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
@@ -696,6 +702,15 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
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
@@ -1010,6 +1025,17 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	INIT_LIST_HEAD(&dev->vbi_out_active);
 	INIT_LIST_HEAD(&dev->sdr_cap_active);
 
+	INIT_LIST_HEAD(&dev->cec_work_list);
+	spin_lock_init(&dev->cec_slock);
+	/*
+	 * Same as create_singlethread_workqueue, but now I can use the
+	 * string formatting of alloc_ordered_workqueue.
+	 */
+	dev->cec_workqueue =
+		alloc_ordered_workqueue("vivid-%03d-cec", WQ_MEM_RECLAIM, inst);
+	if (!dev->cec_workqueue)
+		goto unreg_dev;
+
 	/* start creating the vb2 queues */
 	if (dev->has_vid_cap) {
 		/* initialize vid_cap queue */
@@ -1117,7 +1143,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	/* finally start creating the device nodes */
 	if (dev->has_vid_cap) {
 		vfd = &dev->vid_cap_dev;
-		strlcpy(vfd->name, "vivid-vid-cap", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-vid-cap", inst);
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
 		vfd->device_caps = dev->vid_cap_caps;
@@ -1133,6 +1160,27 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_VIDEO_VIVID_CEC
+		if (in_type_counter[HDMI]) {
+			struct cec_adapter *adap;
+
+			adap = vivid_cec_alloc_adap(dev, 0, &pdev->dev, false);
+			ret = PTR_ERR_OR_ZERO(adap);
+			if (ret < 0)
+				goto unreg_dev;
+			dev->cec_rx_adap = adap;
+			ret = cec_register_adapter(adap);
+			if (ret < 0) {
+				cec_delete_adapter(adap);
+				dev->cec_rx_adap = NULL;
+				goto unreg_dev;
+			}
+			cec_s_phys_addr(adap, 0, false);
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI input %d\n",
+				  dev_name(&adap->devnode.dev), i);
+		}
+#endif
+
 		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_cap_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1141,8 +1189,13 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	}
 
 	if (dev->has_vid_out) {
+#ifdef CONFIG_VIDEO_VIVID_CEC
+		unsigned int bus_cnt = 0;
+#endif
+
 		vfd = &dev->vid_out_dev;
-		strlcpy(vfd->name, "vivid-vid-out", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-vid-out", inst);
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
@@ -1159,6 +1212,35 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		vfd->lock = &dev->mutex;
 		video_set_drvdata(vfd, dev);
 
+#ifdef CONFIG_VIDEO_VIVID_CEC
+		for (i = 0; i < dev->num_outputs; i++) {
+			struct cec_adapter *adap;
+
+			if (dev->output_type[i] != HDMI)
+				continue;
+			dev->cec_output2bus_map[i] = bus_cnt;
+			adap = vivid_cec_alloc_adap(dev, bus_cnt,
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
+			if (bus_cnt <= in_type_counter[HDMI])
+				cec_s_phys_addr(adap, bus_cnt << 12, false);
+			else
+				cec_s_phys_addr(adap, 0x1000, false);
+			v4l2_info(&dev->v4l2_dev, "CEC adapter %s registered for HDMI output %d\n",
+				  dev_name(&adap->devnode.dev), i);
+		}
+#endif
+
 		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_out_nr[inst]);
 		if (ret < 0)
 			goto unreg_dev;
@@ -1168,7 +1250,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_vbi_cap) {
 		vfd = &dev->vbi_cap_dev;
-		strlcpy(vfd->name, "vivid-vbi-cap", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-vbi-cap", inst);
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
 		vfd->device_caps = dev->vbi_cap_caps;
@@ -1191,7 +1274,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_vbi_out) {
 		vfd = &dev->vbi_out_dev;
-		strlcpy(vfd->name, "vivid-vbi-out", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-vbi-out", inst);
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
@@ -1215,7 +1299,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_sdr_cap) {
 		vfd = &dev->sdr_cap_dev;
-		strlcpy(vfd->name, "vivid-sdr-cap", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-sdr-cap", inst);
 		vfd->fops = &vivid_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
 		vfd->device_caps = dev->sdr_cap_caps;
@@ -1234,7 +1319,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_radio_rx) {
 		vfd = &dev->radio_rx_dev;
-		strlcpy(vfd->name, "vivid-rad-rx", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-rad-rx", inst);
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
 		vfd->device_caps = dev->radio_rx_caps;
@@ -1252,7 +1338,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 
 	if (dev->has_radio_tx) {
 		vfd = &dev->radio_tx_dev;
-		strlcpy(vfd->name, "vivid-rad-tx", sizeof(vfd->name));
+		snprintf(vfd->name, sizeof(vfd->name),
+			 "vivid-%03d-rad-tx", inst);
 		vfd->vfl_dir = VFL_DIR_TX;
 		vfd->fops = &vivid_radio_fops;
 		vfd->ioctl_ops = &vivid_ioctl_ops;
@@ -1282,6 +1369,13 @@ unreg_dev:
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
@@ -1331,8 +1425,7 @@ static int vivid_probe(struct platform_device *pdev)
 static int vivid_remove(struct platform_device *pdev)
 {
 	struct vivid_dev *dev;
-	unsigned i;
-
+	unsigned int i, j;
 
 	for (i = 0; i < n_devs; i++) {
 		dev = vivid_devs[i];
@@ -1380,6 +1473,13 @@ static int vivid_remove(struct platform_device *pdev)
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
index 776783b..a7daa40 100644
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
+	unsigned int		usecs;
+	unsigned int		timeout_ms;
+	u8			tx_status;
+	struct cec_msg		msg;
+};
+
 struct vivid_dev {
 	unsigned			inst;
 	struct v4l2_device		v4l2_dev;
@@ -497,6 +510,20 @@ struct vivid_dev {
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
+	unsigned int			cec_xfer_time_jiffies;
+	unsigned long			cec_xfer_start_jiffies;
+	u8				cec_output2bus_map[MAX_OUTPUTS];
+
+	/* CEC OSD String */
+	char				osd[14];
+	unsigned long			osd_jiffies;
 };
 
 static inline bool vivid_is_webcam(const struct vivid_dev *dev)
diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index 3b8c101..6ca71aa 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -552,6 +552,19 @@ static void vivid_fillbuff(struct vivid_dev *dev, struct vivid_buffer *buf)
 			snprintf(str, sizeof(str), " button pressed!");
 			tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
 		}
+		if (dev->osd[0]) {
+			if (vivid_is_hdmi_cap(dev)) {
+				snprintf(str, sizeof(str),
+					 " OSD \"%s\"", dev->osd);
+				tpg_gen_text(tpg, basep, line++ * line_height,
+					     16, str);
+			}
+			if (dev->osd_jiffies &&
+			    time_is_before_jiffies(dev->osd_jiffies + 5 * HZ)) {
+				dev->osd[0] = 0;
+				dev->osd_jiffies = 0;
+			}
+		}
 	}
 
 	/*
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 4f730f3..16fcac1 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1701,6 +1701,9 @@ int vidioc_s_edid(struct file *file, void *_fh,
 			 struct v4l2_edid *edid)
 {
 	struct vivid_dev *dev = video_drvdata(file);
+	u16 phys_addr;
+	unsigned int i;
+	int ret;
 
 	memset(edid->reserved, 0, sizeof(edid->reserved));
 	if (edid->pad >= dev->num_inputs)
@@ -1709,14 +1712,32 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		return -EINVAL;
 	if (edid->blocks == 0) {
 		dev->edid_blocks = 0;
-		return 0;
+		phys_addr = CEC_PHYS_ADDR_INVALID;
+		goto set_phys_addr;
 	}
 	if (edid->blocks > dev->edid_max_blocks) {
 		edid->blocks = dev->edid_max_blocks;
 		return -E2BIG;
 	}
+	phys_addr = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, NULL);
+	ret = cec_phys_addr_validate(phys_addr, &phys_addr, NULL);
+	if (ret)
+		return ret;
+
+	if (vb2_is_busy(&dev->vb_vid_cap_q))
+		return -EBUSY;
+
 	dev->edid_blocks = edid->blocks;
 	memcpy(dev->edid, edid->edid, edid->blocks * 128);
+
+set_phys_addr:
+	/* TODO: a proper hotplug detect cycle should be emulated here */
+	cec_s_phys_addr(dev->cec_rx_adap, phys_addr, false);
+
+	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++)
+		cec_s_phys_addr(dev->cec_tx_adap[i],
+				cec_phys_addr_for_input(phys_addr, i + 1),
+				false);
 	return 0;
 }
 
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 39ea228..fcda3ae 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -811,6 +811,7 @@ int vidioc_g_edid(struct file *file, void *_fh,
 {
 	struct vivid_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
+	struct cec_adapter *adap;
 
 	memset(edid->reserved, 0, sizeof(edid->reserved));
 	if (vdev->vfl_dir == VFL_DIR_RX) {
@@ -818,11 +819,16 @@ int vidioc_g_edid(struct file *file, void *_fh,
 			return -EINVAL;
 		if (dev->input_type[edid->pad] != HDMI)
 			return -EINVAL;
+		adap = dev->cec_rx_adap;
 	} else {
+		unsigned int bus_idx;
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
@@ -835,5 +841,6 @@ int vidioc_g_edid(struct file *file, void *_fh,
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	memcpy(edid->edid, dev->edid, edid->blocks * 128);
+	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
 	return 0;
 }
-- 
2.8.1

