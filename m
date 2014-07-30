Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3182 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaG3OX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jul 2014 10:23:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 03/12] vivid: add core driver code
Date: Wed, 30 Jul 2014 16:23:06 +0200
Message-Id: <1406730195-64365-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>
References: <1406730195-64365-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is the core driver code that creates all the driver instances
and all the configured devices.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 1390 +++++++++++++++++++++++++++++
 drivers/media/platform/vivid/vivid-core.h |  520 +++++++++++
 2 files changed, 1910 insertions(+)
 create mode 100644 drivers/media/platform/vivid/vivid-core.c
 create mode 100644 drivers/media/platform/vivid/vivid-core.h

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
new file mode 100644
index 0000000..708b053
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -0,0 +1,1390 @@
+/*
+ * vivid-core.c - A Virtual Video Test Driver, core initialization
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/font.h>
+#include <linux/mutex.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/videobuf2-vmalloc.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+
+#include "vivid-core.h"
+#include "vivid-vid-common.h"
+#include "vivid-vid-cap.h"
+#include "vivid-vid-out.h"
+#include "vivid-radio-common.h"
+#include "vivid-radio-rx.h"
+#include "vivid-radio-tx.h"
+#include "vivid-sdr-cap.h"
+#include "vivid-vbi-cap.h"
+#include "vivid-vbi-out.h"
+#include "vivid-osd.h"
+#include "vivid-ctrls.h"
+
+#define VIVID_MODULE_NAME "vivid"
+
+/* The maximum number of vivid devices */
+#define VIVID_MAX_DEVS 64
+
+MODULE_DESCRIPTION("Virtual Video Test Driver");
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_LICENSE("GPL");
+
+static unsigned n_devs = 1;
+module_param(n_devs, uint, 0444);
+MODULE_PARM_DESC(n_devs, " number of driver instances to create");
+
+static int vid_cap_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(vid_cap_nr, int, NULL, 0444);
+MODULE_PARM_DESC(vid_cap_nr, " videoX start number, -1 is autodetect");
+
+static int vid_out_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(vid_out_nr, int, NULL, 0444);
+MODULE_PARM_DESC(vid_out_nr, " videoX start number, -1 is autodetect");
+
+static int vbi_cap_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(vbi_cap_nr, int, NULL, 0444);
+MODULE_PARM_DESC(vbi_cap_nr, " vbiX start number, -1 is autodetect");
+
+static int vbi_out_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(vbi_out_nr, int, NULL, 0444);
+MODULE_PARM_DESC(vbi_out_nr, " vbiX start number, -1 is autodetect");
+
+static int sdr_cap_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(sdr_cap_nr, int, NULL, 0444);
+MODULE_PARM_DESC(sdr_cap_nr, " swradioX start number, -1 is autodetect");
+
+static int radio_rx_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(radio_rx_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_rx_nr, " radioX start number, -1 is autodetect");
+
+static int radio_tx_nr[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(radio_tx_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_tx_nr, " radioX start number, -1 is autodetect");
+
+static int ccs_cap_mode[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(ccs_cap_mode, int, NULL, 0444);
+MODULE_PARM_DESC(ccs_cap_mode, " capture crop/compose/scale mode:\n"
+			   "\t\t    bit 0=crop, 1=compose, 2=scale,\n"
+			   "\t\t    -1=user-controlled (default)");
+
+static int ccs_out_mode[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = -1 };
+module_param_array(ccs_out_mode, int, NULL, 0444);
+MODULE_PARM_DESC(ccs_out_mode, " output crop/compose/scale mode:\n"
+			   "\t\t    bit 0=crop, 1=compose, 2=scale,\n"
+			   "\t\t    -1=user-controlled (default)");
+
+static unsigned multiplanar[VIVID_MAX_DEVS];
+module_param_array(multiplanar, uint, NULL, 0444);
+MODULE_PARM_DESC(multiplanar, " 0 (default) is alternating single and multiplanar devices,\n"
+			      "\t\t    1 is single planar devices,\n"
+			      "\t\t    2 is multiplanar devices");
+
+/* Default: video + vbi-cap (raw and sliced) + radio rx + radio tx + sdr + vbi-out + vid-out */
+static unsigned node_types[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0x1d3d };
+module_param_array(node_types, uint, NULL, 0444);
+MODULE_PARM_DESC(node_types, " node types, default is 0x1d3d. Bitmask with the following meaning:\n"
+			     "\t\t    bit 0: Video Capture node\n"
+			     "\t\t    bit 2-3: VBI Capture node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both\n"
+			     "\t\t    bit 4: Radio Receiver node\n"
+			     "\t\t    bit 5: Software Defined Radio Receiver node\n"
+			     "\t\t    bit 8: Video Output node\n"
+			     "\t\t    bit 10-11: VBI Output node: 0 = none, 1 = raw vbi, 2 = sliced vbi, 3 = both\n"
+			     "\t\t    bit 12: Radio Transmitter node\n"
+			     "\t\t    bit 16: Framebuffer for testing overlays");
+
+/* Default: 4 inputs */
+static unsigned num_inputs[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 4 };
+module_param_array(num_inputs, uint, NULL, 0444);
+MODULE_PARM_DESC(num_inputs, " number of inputs, default is 4");
+
+/* Default: input 0 = WEBCAM, 1 = TV, 2 = SVID, 3 = HDMI */
+static unsigned input_types[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0xe4 };
+module_param_array(input_types, uint, NULL, 0444);
+MODULE_PARM_DESC(input_types, " input types, default is 0xe4. Two bits per input,\n"
+			      "\t\t    bits 0-1 == input 0, bits 31-30 == input 15.\n"
+			      "\t\t    Type 0 == webcam, 1 == TV, 2 == S-Video, 3 == HDMI");
+
+/* Default: 2 outputs */
+static unsigned num_outputs[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 2 };
+module_param_array(num_outputs, uint, NULL, 0444);
+MODULE_PARM_DESC(num_outputs, " number of outputs, default is 2");
+
+/* Default: output 0 = SVID, 1 = HDMI */
+static unsigned output_types[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 2 };
+module_param_array(output_types, uint, NULL, 0444);
+MODULE_PARM_DESC(output_types, " output types, default is 0x02. One bit per output,\n"
+			      "\t\t    bit 0 == output 0, bit 15 == output 15.\n"
+			      "\t\t    Type 0 == S-Video, 1 == HDMI");
+
+unsigned vivid_debug;
+module_param(vivid_debug, uint, 0644);
+MODULE_PARM_DESC(vivid_debug, " activates debug info");
+
+static bool no_error_inj;
+module_param(no_error_inj, bool, 0444);
+MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
+
+static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
+
+const struct v4l2_rect vivid_min_rect = {
+	0, 0, MIN_WIDTH, MIN_HEIGHT
+};
+
+const struct v4l2_rect vivid_max_rect = {
+	0, 0, MAX_WIDTH * MAX_ZOOM, MAX_HEIGHT * MAX_ZOOM
+};
+
+static const u8 vivid_hdmi_edid[256] = {
+	0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00,
+	0x63, 0x3a, 0xaa, 0x55, 0x00, 0x00, 0x00, 0x00,
+	0x0a, 0x18, 0x01, 0x03, 0x80, 0x10, 0x09, 0x78,
+	0x0e, 0x00, 0xb2, 0xa0, 0x57, 0x49, 0x9b, 0x26,
+	0x10, 0x48, 0x4f, 0x2f, 0xcf, 0x00, 0x31, 0x59,
+	0x45, 0x59, 0x81, 0x80, 0x81, 0x40, 0x90, 0x40,
+	0x95, 0x00, 0xa9, 0x40, 0xb3, 0x00, 0x02, 0x3a,
+	0x80, 0x18, 0x71, 0x38, 0x2d, 0x40, 0x58, 0x2c,
+	0x46, 0x00, 0x10, 0x09, 0x00, 0x00, 0x00, 0x1e,
+	0x00, 0x00, 0x00, 0xfd, 0x00, 0x18, 0x55, 0x18,
+	0x5e, 0x11, 0x00, 0x0a, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x00, 0x00, 0x00, 0xfc, 0x00,  'v',
+	'4',   'l',  '2',  '-',  'h',  'd',  'm',  'i',
+	0x0a, 0x0a, 0x0a, 0x0a, 0x00, 0x00, 0x00, 0x10,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xf0,
+
+	0x02, 0x03, 0x1a, 0xc0, 0x48, 0xa2, 0x10, 0x04,
+	0x02, 0x01, 0x21, 0x14, 0x13, 0x23, 0x09, 0x07,
+	0x07, 0x65, 0x03, 0x0c, 0x00, 0x10, 0x00, 0xe2,
+	0x00, 0x2a, 0x01, 0x1d, 0x00, 0x80, 0x51, 0xd0,
+	0x1c, 0x20, 0x40, 0x80, 0x35, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x1e, 0x8c, 0x0a, 0xd0, 0x8a,
+	0x20, 0xe0, 0x2d, 0x10, 0x10, 0x3e, 0x96, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd7
+};
+
+void vivid_lock(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_lock(&dev->mutex);
+}
+
+void vivid_unlock(struct vb2_queue *vq)
+{
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int vidioc_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	strcpy(cap->driver, "vivid");
+	strcpy(cap->card, "vivid");
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", dev->v4l2_dev.name);
+
+	if (vdev->vfl_type == VFL_TYPE_GRABBER && vdev->vfl_dir == VFL_DIR_RX)
+		cap->device_caps = dev->vid_cap_caps;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER && vdev->vfl_dir == VFL_DIR_TX)
+		cap->device_caps = dev->vid_out_caps;
+	else if (vdev->vfl_type == VFL_TYPE_VBI && vdev->vfl_dir == VFL_DIR_RX)
+		cap->device_caps = dev->vbi_cap_caps;
+	else if (vdev->vfl_type == VFL_TYPE_VBI && vdev->vfl_dir == VFL_DIR_TX)
+		cap->device_caps = dev->vbi_out_caps;
+	else if (vdev->vfl_type == VFL_TYPE_SDR)
+		cap->device_caps = dev->sdr_cap_caps;
+	else if (vdev->vfl_type == VFL_TYPE_RADIO && vdev->vfl_dir == VFL_DIR_RX)
+		cap->device_caps = dev->radio_rx_caps;
+	else if (vdev->vfl_type == VFL_TYPE_RADIO && vdev->vfl_dir == VFL_DIR_TX)
+		cap->device_caps = dev->radio_tx_caps;
+	cap->capabilities = dev->vid_cap_caps | dev->vid_out_caps |
+		dev->vbi_cap_caps | dev->vbi_out_caps |
+		dev->radio_rx_caps | dev->radio_tx_caps |
+		dev->sdr_cap_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int vidioc_s_hw_freq_seek(struct file *file, void *fh, const struct v4l2_hw_freq_seek *a)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_rx_s_hw_freq_seek(file, fh, a);
+	return -ENOTTY;
+}
+
+static int vidioc_enum_freq_bands(struct file *file, void *fh, struct v4l2_frequency_band *band)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_rx_enum_freq_bands(file, fh, band);
+	if (vdev->vfl_type == VFL_TYPE_SDR)
+		return vivid_sdr_enum_freq_bands(file, fh, band);
+	return -ENOTTY;
+}
+
+static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_rx_g_tuner(file, fh, vt);
+	if (vdev->vfl_type == VFL_TYPE_SDR)
+		return vivid_sdr_g_tuner(file, fh, vt);
+	return vivid_video_g_tuner(file, fh, vt);
+}
+
+static int vidioc_s_tuner(struct file *file, void *fh, const struct v4l2_tuner *vt)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_rx_s_tuner(file, fh, vt);
+	if (vdev->vfl_type == VFL_TYPE_SDR)
+		return vivid_sdr_s_tuner(file, fh, vt);
+	return vivid_video_s_tuner(file, fh, vt);
+}
+
+static int vidioc_g_frequency(struct file *file, void *fh, struct v4l2_frequency *vf)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_g_frequency(file,
+			vdev->vfl_dir == VFL_DIR_RX ?
+			&dev->radio_rx_freq : &dev->radio_tx_freq, vf);
+	if (vdev->vfl_type == VFL_TYPE_SDR)
+		return vivid_sdr_g_frequency(file, fh, vf);
+	return vivid_video_g_frequency(file, fh, vf);
+}
+
+static int vidioc_s_frequency(struct file *file, void *fh, const struct v4l2_frequency *vf)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
+		return vivid_radio_s_frequency(file,
+			vdev->vfl_dir == VFL_DIR_RX ?
+			&dev->radio_rx_freq : &dev->radio_tx_freq, vf);
+	if (vdev->vfl_type == VFL_TYPE_SDR)
+		return vivid_sdr_s_frequency(file, fh, vf);
+	return vivid_video_s_frequency(file, fh, vf);
+}
+
+static int vidioc_overlay(struct file *file, void *fh, unsigned i)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_overlay(file, fh, i);
+	return vivid_vid_out_overlay(file, fh, i);
+}
+
+static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *a)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_g_fbuf(file, fh, a);
+	return vivid_vid_out_g_fbuf(file, fh, a);
+}
+
+static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *a)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_s_fbuf(file, fh, a);
+	return vivid_vid_out_s_fbuf(file, fh, a);
+}
+
+static int vidioc_s_std(struct file *file, void *fh, v4l2_std_id id)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_s_std(file, fh, id);
+	return vivid_vid_out_s_std(file, fh, id);
+}
+
+static int vidioc_s_dv_timings(struct file *file, void *fh, struct v4l2_dv_timings *timings)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_s_dv_timings(file, fh, timings);
+	return vivid_vid_out_s_dv_timings(file, fh, timings);
+}
+
+static int vidioc_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cc)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_cropcap(file, fh, cc);
+	return vivid_vid_out_cropcap(file, fh, cc);
+}
+
+static int vidioc_g_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_g_selection(file, fh, sel);
+	return vivid_vid_out_g_selection(file, fh, sel);
+}
+
+static int vidioc_s_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_s_selection(file, fh, sel);
+	return vivid_vid_out_s_selection(file, fh, sel);
+}
+
+static int vidioc_g_parm(struct file *file, void *fh,
+			  struct v4l2_streamparm *parm)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_g_parm(file, fh, parm);
+	return vivid_vid_out_g_parm(file, fh, parm);
+}
+
+static int vidioc_s_parm(struct file *file, void *fh,
+			  struct v4l2_streamparm *parm)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_vid_cap_s_parm(file, fh, parm);
+	return vivid_vid_out_g_parm(file, fh, parm);
+}
+
+static ssize_t vivid_radio_read(struct file *file, char __user *buf,
+			 size_t size, loff_t *offset)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_TX)
+		return -EINVAL;
+	return vivid_radio_rx_read(file, buf, size, offset);
+}
+
+static ssize_t vivid_radio_write(struct file *file, const char __user *buf,
+			  size_t size, loff_t *offset)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return -EINVAL;
+	return vivid_radio_tx_write(file, buf, size, offset);
+}
+
+static unsigned int vivid_radio_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_dir == VFL_DIR_RX)
+		return vivid_radio_rx_poll(file, wait);
+	return vivid_radio_tx_poll(file, wait);
+}
+
+static bool vivid_is_in_use(struct video_device *vdev)
+{
+	unsigned long flags;
+	bool res;
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+	res = !list_empty(&vdev->fh_list);
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+	return res;
+}
+
+static bool vivid_is_last_user(struct vivid_dev *dev)
+{
+	unsigned uses = vivid_is_in_use(&dev->vid_cap_dev) +
+			vivid_is_in_use(&dev->vid_out_dev) +
+			vivid_is_in_use(&dev->vbi_cap_dev) +
+			vivid_is_in_use(&dev->vbi_out_dev) +
+			vivid_is_in_use(&dev->sdr_cap_dev) +
+			vivid_is_in_use(&dev->radio_rx_dev) +
+			vivid_is_in_use(&dev->radio_tx_dev);
+
+	return uses == 1;
+}
+
+static int vivid_fop_release(struct file *file)
+{
+	struct vivid_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
+
+	mutex_lock(&dev->mutex);
+	if (!no_error_inj && v4l2_fh_is_singular_file(file) &&
+	    !video_is_registered(vdev) && vivid_is_last_user(dev)) {
+		/*
+		 * I am the last user of this driver, and a disconnect
+		 * was forced (since this video_device is unregistered),
+		 * so re-register all video_device's again.
+		 */
+		v4l2_info(&dev->v4l2_dev, "reconnect\n");
+		set_bit(V4L2_FL_REGISTERED, &dev->vid_cap_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->vid_out_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->vbi_cap_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->vbi_out_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->sdr_cap_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->radio_rx_dev.flags);
+		set_bit(V4L2_FL_REGISTERED, &dev->radio_tx_dev.flags);
+	}
+	mutex_unlock(&dev->mutex);
+	if (file->private_data == dev->overlay_cap_owner)
+		dev->overlay_cap_owner = NULL;
+	if (file->private_data == dev->radio_rx_rds_owner) {
+		dev->radio_rx_rds_last_block = 0;
+		dev->radio_rx_rds_owner = NULL;
+	}
+	if (file->private_data == dev->radio_tx_rds_owner) {
+		dev->radio_tx_rds_last_block = 0;
+		dev->radio_tx_rds_owner = NULL;
+	}
+	if (vdev->queue)
+		return vb2_fop_release(file);
+	return v4l2_fh_release(file);
+}
+
+static const struct v4l2_file_operations vivid_fops = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vivid_fop_release,
+	.read           = vb2_fop_read,
+	.write          = vb2_fop_write,
+	.poll		= vb2_fop_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap           = vb2_fop_mmap,
+};
+
+static const struct v4l2_file_operations vivid_radio_fops = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = vivid_fop_release,
+	.read           = vivid_radio_read,
+	.write          = vivid_radio_write,
+	.poll		= vivid_radio_poll,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
+	.vidioc_querycap		= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
+	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_mplane,
+	.vidioc_g_fmt_vid_cap_mplane	= vidioc_g_fmt_vid_cap_mplane,
+	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
+	.vidioc_s_fmt_vid_cap_mplane	= vidioc_s_fmt_vid_cap_mplane,
+
+	.vidioc_enum_fmt_vid_out	= vidioc_enum_fmt_vid,
+	.vidioc_g_fmt_vid_out		= vidioc_g_fmt_vid_out,
+	.vidioc_try_fmt_vid_out		= vidioc_try_fmt_vid_out,
+	.vidioc_s_fmt_vid_out		= vidioc_s_fmt_vid_out,
+	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_mplane,
+	.vidioc_g_fmt_vid_out_mplane	= vidioc_g_fmt_vid_out_mplane,
+	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
+	.vidioc_s_fmt_vid_out_mplane	= vidioc_s_fmt_vid_out_mplane,
+
+	.vidioc_g_selection		= vidioc_g_selection,
+	.vidioc_s_selection		= vidioc_s_selection,
+	.vidioc_cropcap			= vidioc_cropcap,
+
+	.vidioc_g_fmt_vbi_cap		= vidioc_g_fmt_vbi_cap,
+	.vidioc_try_fmt_vbi_cap		= vidioc_g_fmt_vbi_cap,
+	.vidioc_s_fmt_vbi_cap		= vidioc_s_fmt_vbi_cap,
+
+	.vidioc_g_fmt_sliced_vbi_cap    = vidioc_g_fmt_sliced_vbi_cap,
+	.vidioc_try_fmt_sliced_vbi_cap  = vidioc_try_fmt_sliced_vbi_cap,
+	.vidioc_s_fmt_sliced_vbi_cap    = vidioc_s_fmt_sliced_vbi_cap,
+	.vidioc_g_sliced_vbi_cap	= vidioc_g_sliced_vbi_cap,
+
+	.vidioc_g_fmt_vbi_out		= vidioc_g_fmt_vbi_out,
+	.vidioc_try_fmt_vbi_out		= vidioc_g_fmt_vbi_out,
+	.vidioc_s_fmt_vbi_out		= vidioc_s_fmt_vbi_out,
+
+	.vidioc_g_fmt_sliced_vbi_out    = vidioc_g_fmt_sliced_vbi_out,
+	.vidioc_try_fmt_sliced_vbi_out  = vidioc_try_fmt_sliced_vbi_out,
+	.vidioc_s_fmt_sliced_vbi_out    = vidioc_s_fmt_sliced_vbi_out,
+
+	.vidioc_enum_fmt_sdr_cap	= vidioc_enum_fmt_sdr_cap,
+	.vidioc_g_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
+	.vidioc_try_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
+	.vidioc_s_fmt_sdr_cap		= vidioc_g_fmt_sdr_cap,
+
+	.vidioc_overlay			= vidioc_overlay,
+	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals	= vidioc_enum_frameintervals,
+	.vidioc_g_parm			= vidioc_g_parm,
+	.vidioc_s_parm			= vidioc_s_parm,
+
+	.vidioc_enum_fmt_vid_overlay	= vidioc_enum_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_overlay	= vidioc_g_fmt_vid_overlay,
+	.vidioc_try_fmt_vid_overlay	= vidioc_try_fmt_vid_overlay,
+	.vidioc_s_fmt_vid_overlay	= vidioc_s_fmt_vid_overlay,
+	.vidioc_g_fmt_vid_out_overlay	= vidioc_g_fmt_vid_out_overlay,
+	.vidioc_try_fmt_vid_out_overlay	= vidioc_try_fmt_vid_out_overlay,
+	.vidioc_s_fmt_vid_out_overlay	= vidioc_s_fmt_vid_out_overlay,
+	.vidioc_overlay			= vidioc_overlay,
+	.vidioc_g_fbuf			= vidioc_g_fbuf,
+	.vidioc_s_fbuf			= vidioc_s_fbuf,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+/* Not yet	.vidioc_expbuf		= vb2_ioctl_expbuf,*/
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_enum_input		= vidioc_enum_input,
+	.vidioc_g_input			= vidioc_g_input,
+	.vidioc_s_input			= vidioc_s_input,
+	.vidioc_s_audio			= vidioc_s_audio,
+	.vidioc_g_audio			= vidioc_g_audio,
+	.vidioc_enumaudio		= vidioc_enumaudio,
+	.vidioc_s_frequency		= vidioc_s_frequency,
+	.vidioc_g_frequency		= vidioc_g_frequency,
+	.vidioc_s_tuner			= vidioc_s_tuner,
+	.vidioc_g_tuner			= vidioc_g_tuner,
+	.vidioc_s_modulator		= vidioc_s_modulator,
+	.vidioc_g_modulator		= vidioc_g_modulator,
+	.vidioc_s_hw_freq_seek		= vidioc_s_hw_freq_seek,
+	.vidioc_enum_freq_bands		= vidioc_enum_freq_bands,
+
+	.vidioc_enum_output		= vidioc_enum_output,
+	.vidioc_g_output		= vidioc_g_output,
+	.vidioc_s_output		= vidioc_s_output,
+	.vidioc_s_audout		= vidioc_s_audout,
+	.vidioc_g_audout		= vidioc_g_audout,
+	.vidioc_enumaudout		= vidioc_enumaudout,
+
+	.vidioc_querystd		= vidioc_querystd,
+	.vidioc_g_std			= vidioc_g_std,
+	.vidioc_s_std			= vidioc_s_std,
+	.vidioc_s_dv_timings		= vidioc_s_dv_timings,
+	.vidioc_g_dv_timings		= vidioc_g_dv_timings,
+	.vidioc_query_dv_timings	= vidioc_query_dv_timings,
+	.vidioc_enum_dv_timings		= vidioc_enum_dv_timings,
+	.vidioc_dv_timings_cap		= vidioc_dv_timings_cap,
+	.vidioc_g_edid			= vidioc_g_edid,
+	.vidioc_s_edid			= vidioc_s_edid,
+
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= vidioc_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
+};
+
+/* -----------------------------------------------------------------
+	Initialization and module stuff
+   ------------------------------------------------------------------*/
+
+static int __init vivid_create_instance(int inst)
+{
+	static const struct v4l2_dv_timings def_dv_timings =
+					V4L2_DV_BT_CEA_1280X720P60;
+	unsigned in_type_counter[4] = { 0, 0, 0, 0 };
+	unsigned out_type_counter[4] = { 0, 0, 0, 0 };
+	int ccs_cap = ccs_cap_mode[inst];
+	int ccs_out = ccs_out_mode[inst];
+	bool has_tuner;
+	bool has_modulator;
+	struct vivid_dev *dev;
+	struct video_device *vfd;
+	struct vb2_queue *q;
+	unsigned node_type = node_types[inst];
+	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
+	int ret;
+	int i;
+
+	/* allocate main vivid state structure */
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->inst = inst;
+
+	/* register v4l2_device */
+	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
+			"%s-%03d", VIVID_MODULE_NAME, inst);
+	ret = v4l2_device_register(NULL, &dev->v4l2_dev);
+	if (ret)
+		goto free_dev;
+
+	/* start detecting feature set */
+
+	/* do we use single- or multi-planar? */
+	if (multiplanar[inst] == 0)
+		dev->multiplanar = inst & 1;
+	else
+		dev->multiplanar = multiplanar[inst] > 1;
+	v4l2_info(&dev->v4l2_dev, "using %splanar format API\n",
+			dev->multiplanar ? "multi" : "single ");
+
+	/* how many inputs do we have and of what type? */
+	dev->num_inputs = num_inputs[inst];
+	if (dev->num_inputs < 1)
+		dev->num_inputs = 1;
+	if (dev->num_inputs >= MAX_INPUTS)
+		dev->num_inputs = MAX_INPUTS;
+	for (i = 0; i < dev->num_inputs; i++) {
+		dev->input_type[i] = (input_types[inst] >> (i * 2)) & 0x3;
+		dev->input_name_counter[i] = in_type_counter[dev->input_type[i]]++;
+	}
+	dev->has_audio_inputs = in_type_counter[TV] && in_type_counter[SVID];
+
+	/* how many outputs do we have and of what type? */
+	dev->num_outputs = num_outputs[inst];
+	if (dev->num_outputs < 1)
+		dev->num_outputs = 1;
+	if (dev->num_outputs >= MAX_OUTPUTS)
+		dev->num_outputs = MAX_OUTPUTS;
+	for (i = 0; i < dev->num_outputs; i++) {
+		dev->output_type[i] = ((output_types[inst] >> i) & 1) ? HDMI : SVID;
+		dev->output_name_counter[i] = out_type_counter[dev->output_type[i]]++;
+	}
+	dev->has_audio_outputs = out_type_counter[SVID];
+
+	/* do we create a video capture device? */
+	dev->has_vid_cap = node_type & 0x0001;
+
+	/* do we create a vbi capture device? */
+	if (in_type_counter[TV] || in_type_counter[SVID]) {
+		dev->has_raw_vbi_cap = node_type & 0x0004;
+		dev->has_sliced_vbi_cap = node_type & 0x0008;
+		dev->has_vbi_cap = dev->has_raw_vbi_cap | dev->has_sliced_vbi_cap;
+	}
+
+	/* do we create a video output device? */
+	dev->has_vid_out = node_type & 0x0100;
+
+	/* do we create a vbi output device? */
+	if (out_type_counter[SVID]) {
+		dev->has_raw_vbi_out = node_type & 0x0400;
+		dev->has_sliced_vbi_out = node_type & 0x0800;
+		dev->has_vbi_out = dev->has_raw_vbi_out | dev->has_sliced_vbi_out;
+	}
+
+	/* do we create a radio receiver device? */
+	dev->has_radio_rx = node_type & 0x0010;
+
+	/* do we create a radio transmitter device? */
+	dev->has_radio_tx = node_type & 0x1000;
+
+	/* do we create a software defined radio capture device? */
+	dev->has_sdr_cap = node_type & 0x0020;
+
+	/* do we have a tuner? */
+	has_tuner = ((dev->has_vid_cap || dev->has_vbi_cap) && in_type_counter[TV]) ||
+		    dev->has_radio_rx || dev->has_sdr_cap;
+
+	/* do we have a modulator? */
+	has_modulator = dev->has_radio_tx;
+
+	if (dev->has_vid_cap)
+		/* do we have a framebuffer for overlay testing? */
+		dev->has_fb = node_type & 0x10000;
+
+	/* can we do crop/compose/scaling while capturing? */
+	if (no_error_inj && ccs_cap == -1)
+		ccs_cap = 7;
+
+	/* if ccs_cap == -1, then the use can select it using controls */
+	if (ccs_cap != -1) {
+		dev->has_crop_cap = ccs_cap & 1;
+		dev->has_compose_cap = ccs_cap & 2;
+		dev->has_scaler_cap = ccs_cap & 4;
+		v4l2_info(&dev->v4l2_dev, "Capture Crop: %c Compose: %c Scaler: %c\n",
+			dev->has_crop_cap ? 'Y' : 'N',
+			dev->has_compose_cap ? 'Y' : 'N',
+			dev->has_scaler_cap ? 'Y' : 'N');
+	}
+
+	/* can we do crop/compose/scaling with video output? */
+	if (no_error_inj && ccs_out == -1)
+		ccs_out = 7;
+
+	/* if ccs_out == -1, then the use can select it using controls */
+	if (ccs_out != -1) {
+		dev->has_crop_out = ccs_out & 1;
+		dev->has_compose_out = ccs_out & 2;
+		dev->has_scaler_out = ccs_out & 4;
+		v4l2_info(&dev->v4l2_dev, "Output Crop: %c Compose: %c Scaler: %c\n",
+			dev->has_crop_out ? 'Y' : 'N',
+			dev->has_compose_out ? 'Y' : 'N',
+			dev->has_scaler_out ? 'Y' : 'N');
+	}
+
+	/* end detecting feature set */
+
+	if (dev->has_vid_cap) {
+		/* set up the capabilities of the video capture device */
+		dev->vid_cap_caps = dev->multiplanar ?
+			V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY;
+		dev->vid_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		if (dev->has_audio_inputs)
+			dev->vid_cap_caps |= V4L2_CAP_AUDIO;
+		if (in_type_counter[TV])
+			dev->vid_cap_caps |= V4L2_CAP_TUNER;
+	}
+	if (dev->has_vid_out) {
+		/* set up the capabilities of the video output device */
+		dev->vid_out_caps = dev->multiplanar ?
+			V4L2_CAP_VIDEO_OUTPUT_MPLANE :
+			V4L2_CAP_VIDEO_OUTPUT;
+		if (dev->has_fb)
+			dev->vid_out_caps |= V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
+		dev->vid_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		if (dev->has_audio_outputs)
+			dev->vid_out_caps |= V4L2_CAP_AUDIO;
+	}
+	if (dev->has_vbi_cap) {
+		/* set up the capabilities of the vbi capture device */
+		dev->vbi_cap_caps = (dev->has_raw_vbi_cap ? V4L2_CAP_VBI_CAPTURE : 0) |
+				    (dev->has_sliced_vbi_cap ? V4L2_CAP_SLICED_VBI_CAPTURE : 0);
+		dev->vbi_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		if (dev->has_audio_inputs)
+			dev->vbi_cap_caps |= V4L2_CAP_AUDIO;
+		if (in_type_counter[TV])
+			dev->vbi_cap_caps |= V4L2_CAP_TUNER;
+	}
+	if (dev->has_vbi_out) {
+		/* set up the capabilities of the vbi output device */
+		dev->vbi_out_caps = (dev->has_raw_vbi_out ? V4L2_CAP_VBI_OUTPUT : 0) |
+				    (dev->has_sliced_vbi_out ? V4L2_CAP_SLICED_VBI_OUTPUT : 0);
+		dev->vbi_out_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+		if (dev->has_audio_outputs)
+			dev->vbi_out_caps |= V4L2_CAP_AUDIO;
+	}
+	if (dev->has_sdr_cap) {
+		/* set up the capabilities of the sdr capture device */
+		dev->sdr_cap_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER;
+		dev->sdr_cap_caps |= V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
+	}
+	/* set up the capabilities of the radio receiver device */
+	if (dev->has_radio_rx)
+		dev->radio_rx_caps = V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE |
+				     V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+				     V4L2_CAP_READWRITE;
+	/* set up the capabilities of the radio transmitter device */
+	if (dev->has_radio_tx)
+		dev->radio_tx_caps = V4L2_CAP_RDS_OUTPUT | V4L2_CAP_MODULATOR |
+				     V4L2_CAP_READWRITE;
+
+	/* initialize the test pattern generator */
+	tpg_init(&dev->tpg, 640, 360);
+	if (tpg_alloc(&dev->tpg, MAX_ZOOM * MAX_WIDTH))
+		goto free_dev;
+	dev->scaled_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
+	if (!dev->scaled_line)
+		goto free_dev;
+	dev->blended_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
+	if (!dev->blended_line)
+		goto free_dev;
+
+	/* load the edid */
+	dev->edid = vmalloc(256 * 128);
+	if (!dev->edid)
+		goto free_dev;
+
+	/* create a string array containing the names of all the preset timings */
+	while (v4l2_dv_timings_presets[dev->query_dv_timings_size].bt.width)
+		dev->query_dv_timings_size++;
+	dev->query_dv_timings_qmenu = kmalloc(dev->query_dv_timings_size *
+					   (sizeof(void *) + 32), GFP_KERNEL);
+	if (dev->query_dv_timings_qmenu == NULL)
+		goto free_dev;
+	for (i = 0; i < dev->query_dv_timings_size; i++) {
+		const struct v4l2_bt_timings *bt = &v4l2_dv_timings_presets[i].bt;
+		char *p = (char *)&dev->query_dv_timings_qmenu[dev->query_dv_timings_size];
+		u32 htot, vtot;
+
+		p += i * 32;
+		dev->query_dv_timings_qmenu[i] = p;
+
+		htot = V4L2_DV_BT_FRAME_WIDTH(bt);
+		vtot = V4L2_DV_BT_FRAME_HEIGHT(bt);
+		snprintf(p, 32, "%ux%u%s%u",
+			bt->width, bt->height, bt->interlaced ? "i" : "p",
+			(u32)bt->pixelclock / (htot * vtot));
+	}
+
+	/* disable invalid ioctls based on the feature set */
+	if (!dev->has_audio_inputs) {
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_ENUMAUDIO);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_S_AUDIO);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_G_AUDIO);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_ENUMAUDIO);
+	}
+	if (!dev->has_audio_outputs) {
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_S_AUDOUT);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_AUDOUT);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_ENUMAUDOUT);
+		v4l2_disable_ioctl(&dev->vbi_out_dev, VIDIOC_S_AUDOUT);
+		v4l2_disable_ioctl(&dev->vbi_out_dev, VIDIOC_G_AUDOUT);
+		v4l2_disable_ioctl(&dev->vbi_out_dev, VIDIOC_ENUMAUDOUT);
+	}
+	if (!in_type_counter[TV] && !in_type_counter[SVID]) {
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_ENUMSTD);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_QUERYSTD);
+	}
+	if (!out_type_counter[SVID]) {
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_ENUMSTD);
+	}
+	if (!has_tuner && !has_modulator) {
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_FREQUENCY);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_S_FREQUENCY);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_G_FREQUENCY);
+	}
+	if (!has_tuner) {
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_TUNER);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_S_TUNER);
+		v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_G_TUNER);
+	}
+	if (in_type_counter[HDMI] == 0) {
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_EDID);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_EDID);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_DV_TIMINGS_CAP);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_G_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_ENUM_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_QUERY_DV_TIMINGS);
+	}
+	if (out_type_counter[HDMI] == 0) {
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_EDID);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_DV_TIMINGS_CAP);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_S_DV_TIMINGS);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_ENUM_DV_TIMINGS);
+	}
+	if (!dev->has_fb) {
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_FBUF);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_S_FBUF);
+		v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_OVERLAY);
+	}
+	v4l2_disable_ioctl(&dev->vid_cap_dev, VIDIOC_S_HW_FREQ_SEEK);
+	v4l2_disable_ioctl(&dev->vbi_cap_dev, VIDIOC_S_HW_FREQ_SEEK);
+	v4l2_disable_ioctl(&dev->sdr_cap_dev, VIDIOC_S_HW_FREQ_SEEK);
+	v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_S_FREQUENCY);
+	v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_G_FREQUENCY);
+	v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_ENUM_FRAMESIZES);
+	v4l2_disable_ioctl(&dev->vid_out_dev, VIDIOC_ENUM_FRAMEINTERVALS);
+	v4l2_disable_ioctl(&dev->vbi_out_dev, VIDIOC_S_FREQUENCY);
+	v4l2_disable_ioctl(&dev->vbi_out_dev, VIDIOC_G_FREQUENCY);
+
+	/* configure internal data */
+	dev->fmt_cap = &vivid_formats[0];
+	dev->fmt_out = &vivid_formats[0];
+	if (!dev->multiplanar)
+		vivid_formats[0].data_offset[0] = 0;
+	dev->webcam_size_idx = 1;
+	dev->webcam_ival_idx = 3;
+	tpg_s_fourcc(&dev->tpg, dev->fmt_cap->fourcc);
+	dev->std_cap = V4L2_STD_PAL;
+	dev->std_out = V4L2_STD_PAL;
+	if (dev->input_type[0] == TV || dev->input_type[0] == SVID)
+		tvnorms_cap = V4L2_STD_ALL;
+	if (dev->output_type[0] == SVID)
+		tvnorms_out = V4L2_STD_ALL;
+	dev->dv_timings_cap = def_dv_timings;
+	dev->dv_timings_out = def_dv_timings;
+	dev->tv_freq = 2804 /* 175.25 * 16 */;
+	dev->tv_audmode = V4L2_TUNER_MODE_STEREO;
+	dev->tv_field_cap = V4L2_FIELD_INTERLACED;
+	dev->tv_field_out = V4L2_FIELD_INTERLACED;
+	dev->radio_rx_freq = 95000 * 16;
+	dev->radio_rx_audmode = V4L2_TUNER_MODE_STEREO;
+	if (dev->has_radio_tx) {
+		dev->radio_tx_freq = 95500 * 16;
+		dev->radio_rds_loop = false;
+	}
+	dev->radio_tx_subchans = V4L2_TUNER_SUB_STEREO | V4L2_TUNER_SUB_RDS;
+	dev->sdr_adc_freq = 300000;
+	dev->sdr_fm_freq = 50000000;
+	dev->edid_max_blocks = dev->edid_blocks = 2;
+	memcpy(dev->edid, vivid_hdmi_edid, sizeof(vivid_hdmi_edid));
+	ktime_get_ts(&dev->radio_rds_init_ts);
+
+	/* create all controls */
+	ret = vivid_create_controls(dev, ccs_cap == -1, ccs_out == -1, no_error_inj,
+			in_type_counter[TV] || in_type_counter[SVID] ||
+			out_type_counter[SVID],
+			in_type_counter[HDMI] || out_type_counter[HDMI]);
+	if (ret)
+		goto unreg_dev;
+
+	/*
+	 * update the capture and output formats to do a proper initial
+	 * configuration.
+	 */
+	vivid_update_format_cap(dev, false);
+	vivid_update_format_out(dev);
+
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_vid_cap);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_vid_out);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_vbi_cap);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_vbi_out);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_radio_rx);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_radio_tx);
+	v4l2_ctrl_handler_setup(&dev->ctrl_hdl_sdr_cap);
+
+	/* initialize overlay */
+	dev->fb_cap.fmt.width = dev->src_rect.width;
+	dev->fb_cap.fmt.height = dev->src_rect.height;
+	dev->fb_cap.fmt.pixelformat = dev->fmt_cap->fourcc;
+	dev->fb_cap.fmt.bytesperline = dev->src_rect.width * tpg_g_twopixelsize(&dev->tpg, 0) / 2;
+	dev->fb_cap.fmt.sizeimage = dev->src_rect.height * dev->fb_cap.fmt.bytesperline;
+
+	/* initialize locks */
+	spin_lock_init(&dev->slock);
+	mutex_init(&dev->mutex);
+
+	/* init dma queues */
+	INIT_LIST_HEAD(&dev->vid_cap_active);
+	INIT_LIST_HEAD(&dev->vid_out_active);
+	INIT_LIST_HEAD(&dev->vbi_cap_active);
+	INIT_LIST_HEAD(&dev->vbi_out_active);
+	INIT_LIST_HEAD(&dev->sdr_cap_active);
+
+	/* start creating the vb2 queues */
+	if (dev->has_vid_cap) {
+		/* initialize vid_cap queue */
+		q = &dev->vb_vid_cap_q;
+		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+			V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct vivid_buffer);
+		q->ops = &vivid_vid_cap_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 2;
+
+		ret = vb2_queue_init(q);
+		if (ret)
+			goto unreg_dev;
+	}
+
+	if (dev->has_vid_out) {
+		/* initialize vid_out queue */
+		q = &dev->vb_vid_out_q;
+		q->type = dev->multiplanar ? V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE :
+			V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct vivid_buffer);
+		q->ops = &vivid_vid_out_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 2;
+
+		ret = vb2_queue_init(q);
+		if (ret)
+			goto unreg_dev;
+	}
+
+	if (dev->has_vbi_cap) {
+		/* initialize vbi_cap queue */
+		q = &dev->vb_vbi_cap_q;
+		q->type = dev->has_raw_vbi_cap ? V4L2_BUF_TYPE_VBI_CAPTURE :
+					      V4L2_BUF_TYPE_SLICED_VBI_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct vivid_buffer);
+		q->ops = &vivid_vbi_cap_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 2;
+
+		ret = vb2_queue_init(q);
+		if (ret)
+			goto unreg_dev;
+	}
+
+	if (dev->has_vbi_out) {
+		/* initialize vbi_out queue */
+		q = &dev->vb_vbi_out_q;
+		q->type = dev->has_raw_vbi_out ? V4L2_BUF_TYPE_VBI_OUTPUT :
+					      V4L2_BUF_TYPE_SLICED_VBI_OUTPUT;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_WRITE;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct vivid_buffer);
+		q->ops = &vivid_vbi_out_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 2;
+
+		ret = vb2_queue_init(q);
+		if (ret)
+			goto unreg_dev;
+	}
+
+	if (dev->has_sdr_cap) {
+		/* initialize sdr_cap queue */
+		q = &dev->vb_sdr_cap_q;
+		q->type = V4L2_BUF_TYPE_SDR_CAPTURE;
+		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
+		q->drv_priv = dev;
+		q->buf_struct_size = sizeof(struct vivid_buffer);
+		q->ops = &vivid_sdr_cap_qops;
+		q->mem_ops = &vb2_vmalloc_memops;
+		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->min_buffers_needed = 8;
+
+		ret = vb2_queue_init(q);
+		if (ret)
+			goto unreg_dev;
+	}
+
+	if (dev->has_fb) {
+		/* Create framebuffer for testing capture/output overlay */
+		ret = vivid_fb_init(dev);
+		if (ret)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "Framebuffer device registered as fb%d\n",
+				dev->fb_info.node);
+	}
+
+	/* finally start creating the device nodes */
+	if (dev->has_vid_cap) {
+		vfd = &dev->vid_cap_dev;
+		strlcpy(vfd->name, "vivid-vid-cap", sizeof(vfd->name));
+		vfd->fops = &vivid_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->queue = &dev->vb_vid_cap_q;
+		vfd->tvnorms = tvnorms_cap;
+
+		/*
+		 * Provide a mutex to v4l2 core. It will be used to protect
+		 * all fops and v4l2 ioctls.
+		 */
+		vfd->lock = &dev->mutex;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_cap_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 capture device registered as %s\n",
+					  video_device_node_name(vfd));
+	}
+
+	if (dev->has_vid_out) {
+		vfd = &dev->vid_out_dev;
+		strlcpy(vfd->name, "vivid-vid-out", sizeof(vfd->name));
+		vfd->vfl_dir = VFL_DIR_TX;
+		vfd->fops = &vivid_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->queue = &dev->vb_vid_out_q;
+		vfd->tvnorms = tvnorms_out;
+
+		/*
+		 * Provide a mutex to v4l2 core. It will be used to protect
+		 * all fops and v4l2 ioctls.
+		 */
+		vfd->lock = &dev->mutex;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_GRABBER, vid_out_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 output device registered as %s\n",
+					  video_device_node_name(vfd));
+	}
+
+	if (dev->has_vbi_cap) {
+		vfd = &dev->vbi_cap_dev;
+		strlcpy(vfd->name, "vivid-vbi-cap", sizeof(vfd->name));
+		vfd->fops = &vivid_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->queue = &dev->vb_vbi_cap_q;
+		vfd->lock = &dev->mutex;
+		vfd->tvnorms = tvnorms_cap;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_cap_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 capture device registered as %s, supports %s VBI\n",
+					  video_device_node_name(vfd),
+					  (dev->has_raw_vbi_cap && dev->has_sliced_vbi_cap) ?
+					  "raw and sliced" :
+					  (dev->has_raw_vbi_cap ? "raw" : "sliced"));
+	}
+
+	if (dev->has_vbi_out) {
+		vfd = &dev->vbi_out_dev;
+		strlcpy(vfd->name, "vivid-vbi-out", sizeof(vfd->name));
+		vfd->vfl_dir = VFL_DIR_TX;
+		vfd->fops = &vivid_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->queue = &dev->vb_vbi_out_q;
+		vfd->lock = &dev->mutex;
+		vfd->tvnorms = tvnorms_out;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_VBI, vbi_out_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 output device registered as %s, supports %s VBI\n",
+					  video_device_node_name(vfd),
+					  (dev->has_raw_vbi_out && dev->has_sliced_vbi_out) ?
+					  "raw and sliced" :
+					  (dev->has_raw_vbi_out ? "raw" : "sliced"));
+	}
+
+	if (dev->has_sdr_cap) {
+		vfd = &dev->sdr_cap_dev;
+		strlcpy(vfd->name, "vivid-sdr-cap", sizeof(vfd->name));
+		vfd->fops = &vivid_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->queue = &dev->vb_sdr_cap_q;
+		vfd->lock = &dev->mutex;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_SDR, sdr_cap_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 capture device registered as %s\n",
+					  video_device_node_name(vfd));
+	}
+
+	if (dev->has_radio_rx) {
+		vfd = &dev->radio_rx_dev;
+		strlcpy(vfd->name, "vivid-rad-rx", sizeof(vfd->name));
+		vfd->fops = &vivid_radio_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->lock = &dev->mutex;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_RADIO, radio_rx_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 receiver device registered as %s\n",
+					  video_device_node_name(vfd));
+	}
+
+	if (dev->has_radio_tx) {
+		vfd = &dev->radio_tx_dev;
+		strlcpy(vfd->name, "vivid-rad-tx", sizeof(vfd->name));
+		vfd->vfl_dir = VFL_DIR_TX;
+		vfd->fops = &vivid_radio_fops;
+		vfd->ioctl_ops = &vivid_ioctl_ops;
+		vfd->release = video_device_release_empty;
+		vfd->v4l2_dev = &dev->v4l2_dev;
+		vfd->lock = &dev->mutex;
+		video_set_drvdata(vfd, dev);
+
+		ret = video_register_device(vfd, VFL_TYPE_RADIO, radio_tx_nr[inst]);
+		if (ret < 0)
+			goto unreg_dev;
+		v4l2_info(&dev->v4l2_dev, "V4L2 transmitter device registered as %s\n",
+					  video_device_node_name(vfd));
+	}
+
+	/* Now that everything is fine, let's add it to device list */
+	vivid_devs[inst] = dev;
+
+	return 0;
+
+unreg_dev:
+	video_unregister_device(&dev->radio_tx_dev);
+	video_unregister_device(&dev->radio_rx_dev);
+	video_unregister_device(&dev->sdr_cap_dev);
+	video_unregister_device(&dev->vbi_out_dev);
+	video_unregister_device(&dev->vbi_cap_dev);
+	video_unregister_device(&dev->vid_out_dev);
+	video_unregister_device(&dev->vid_cap_dev);
+	vivid_free_controls(dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_dev:
+	vfree(dev->scaled_line);
+	vfree(dev->blended_line);
+	vfree(dev->edid);
+	tpg_free(&dev->tpg);
+	kfree(dev->query_dv_timings_qmenu);
+	kfree(dev);
+	return ret;
+}
+
+/* This routine allocates from 1 to n_devs virtual drivers.
+
+   The real maximum number of virtual drivers will depend on how many drivers
+   will succeed. This is limited to the maximum number of devices that
+   videodev supports, which is equal to VIDEO_NUM_DEVICES.
+ */
+static int __init vivid_init(void)
+{
+	const struct font_desc *font = find_font("VGA8x16");
+	int ret = 0, i;
+
+	if (font == NULL) {
+		pr_err("vivid: could not find font\n");
+		return -ENODEV;
+	}
+
+	tpg_set_font(font->data);
+
+	n_devs = clamp_t(unsigned, n_devs, 1, VIVID_MAX_DEVS);
+
+	for (i = 0; i < n_devs; i++) {
+		ret = vivid_create_instance(i);
+		if (ret) {
+			/* If some instantiations succeeded, keep driver */
+			if (i)
+				ret = 0;
+			break;
+		}
+	}
+
+	if (ret < 0) {
+		pr_err("vivid: error %d while loading driver\n", ret);
+		return ret;
+	}
+
+	/* n_devs will reflect the actual number of allocated devices */
+	n_devs = i;
+
+	return ret;
+}
+
+static void __exit vivid_exit(void)
+{
+	struct vivid_dev *dev;
+	unsigned i;
+
+	for (i = 0; vivid_devs[i]; i++) {
+		dev = vivid_devs[i];
+
+		if (dev->has_vid_cap) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->vid_cap_dev));
+			video_unregister_device(&dev->vid_cap_dev);
+		}
+		if (dev->has_vid_out) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->vid_out_dev));
+			video_unregister_device(&dev->vid_out_dev);
+		}
+		if (dev->has_vbi_cap) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->vbi_cap_dev));
+			video_unregister_device(&dev->vbi_cap_dev);
+		}
+		if (dev->has_vbi_out) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->vbi_out_dev));
+			video_unregister_device(&dev->vbi_out_dev);
+		}
+		if (dev->has_sdr_cap) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->sdr_cap_dev));
+			video_unregister_device(&dev->sdr_cap_dev);
+		}
+		if (dev->has_radio_rx) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->radio_rx_dev));
+			video_unregister_device(&dev->radio_rx_dev);
+		}
+		if (dev->has_radio_tx) {
+			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
+				video_device_node_name(&dev->radio_tx_dev));
+			video_unregister_device(&dev->radio_tx_dev);
+		}
+		if (dev->has_fb) {
+			v4l2_info(&dev->v4l2_dev, "unregistering fb%d\n",
+				dev->fb_info.node);
+			unregister_framebuffer(&dev->fb_info);
+			vivid_fb_release_buffers(dev);
+		}
+		v4l2_device_unregister(&dev->v4l2_dev);
+		vivid_free_controls(dev);
+		vfree(dev->scaled_line);
+		vfree(dev->blended_line);
+		vfree(dev->edid);
+		vfree(dev->bitmap_cap);
+		vfree(dev->bitmap_out);
+		tpg_free(&dev->tpg);
+		kfree(dev->query_dv_timings_qmenu);
+		kfree(dev);
+		vivid_devs[i] = NULL;
+	}
+}
+
+module_init(vivid_init);
+module_exit(vivid_exit);
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
new file mode 100644
index 0000000..811c286
--- /dev/null
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -0,0 +1,520 @@
+/*
+ * vivid-core.h - core datastructures
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
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
+#ifndef _VIVID_CORE_H_
+#define _VIVID_CORE_H_
+
+#include <linux/fb.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ctrls.h>
+#include "vivid-tpg.h"
+#include "vivid-rds-gen.h"
+#include "vivid-vbi-gen.h"
+
+#define dprintk(dev, level, fmt, arg...) \
+	v4l2_dbg(level, vivid_debug, &dev->v4l2_dev, fmt, ## arg)
+
+/* Maximum allowed frame rate
+ *
+ * vivid will allow setting timeperframe in [1/FPS_MAX - FPS_MAX/1] range.
+ *
+ * Ideally FPS_MAX should be infinity, i.e. practically UINT_MAX, but that
+ * might hit application errors when they manipulate these values.
+ *
+ * Besides, for tpf < 10ms image-generation logic should be changed, to avoid
+ * producing frames with equal content.
+ */
+#define FPS_MAX 100
+
+/* The maximum number of clip rectangles */
+#define MAX_CLIPS  16
+/* The maximum number of inputs */
+#define MAX_INPUTS 16
+/* The maximum number of outputs */
+#define MAX_OUTPUTS 16
+/* The maximum up or down scaling factor is 4 */
+#define MAX_ZOOM  4
+/* The maximum image width/height are set to 4K DMT */
+#define MAX_WIDTH  4096
+#define MAX_HEIGHT 2160
+/* The minimum image width/height */
+#define MIN_WIDTH  16
+#define MIN_HEIGHT 16
+/* The data_offset of plane 0 for the multiplanar formats */
+#define PLANE0_DATA_OFFSET 128
+
+/* The supported TV frequency range in MHz */
+#define MIN_TV_FREQ (44U * 16U)
+#define MAX_TV_FREQ (958U * 16U)
+
+/* The number of samples returned in every SDR buffer */
+#define SDR_CAP_SAMPLES_PER_BUF 0x4000
+
+/* used by the threads to know when to resync internal counters */
+#define JIFFIES_PER_DAY (3600U * 24U * HZ)
+#define JIFFIES_RESYNC (JIFFIES_PER_DAY * (0xf0000000U / JIFFIES_PER_DAY))
+
+extern const struct v4l2_rect vivid_min_rect;
+extern const struct v4l2_rect vivid_max_rect;
+extern unsigned vivid_debug;
+
+struct vivid_fmt {
+	const char *name;
+	u32	fourcc;          /* v4l2 format id */
+	u8	depth;
+	bool	is_yuv;
+	bool	can_do_overlay;
+	u32	alpha_mask;
+	u8	planes;
+	u32	data_offset[2];
+};
+
+extern struct vivid_fmt vivid_formats[];
+
+/* buffer for one video frame */
+struct vivid_buffer {
+	/* common v4l buffer stuff -- must be first */
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+enum vivid_input {
+	WEBCAM,
+	TV,
+	SVID,
+	HDMI,
+};
+
+enum vivid_signal_mode {
+	CURRENT_DV_TIMINGS,
+	CURRENT_STD = CURRENT_DV_TIMINGS,
+	NO_SIGNAL,
+	NO_LOCK,
+	OUT_OF_RANGE,
+	SELECTED_DV_TIMINGS,
+	SELECTED_STD = SELECTED_DV_TIMINGS,
+	CYCLE_DV_TIMINGS,
+	CYCLE_STD = CYCLE_DV_TIMINGS,
+	CUSTOM_DV_TIMINGS,
+};
+
+#define VIVID_INVALID_SIGNAL(mode) \
+	((mode) == NO_SIGNAL || (mode) == NO_LOCK || (mode) == OUT_OF_RANGE)
+
+struct vivid_dev {
+	unsigned			inst;
+	struct v4l2_device		v4l2_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_user_gen;
+	struct v4l2_ctrl_handler	ctrl_hdl_user_vid;
+	struct v4l2_ctrl_handler	ctrl_hdl_user_aud;
+	struct v4l2_ctrl_handler	ctrl_hdl_streaming;
+	struct v4l2_ctrl_handler	ctrl_hdl_sdtv_cap;
+	struct v4l2_ctrl_handler	ctrl_hdl_loop_out;
+	struct video_device		vid_cap_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_vid_cap;
+	struct video_device		vid_out_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_vid_out;
+	struct video_device		vbi_cap_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_vbi_cap;
+	struct video_device		vbi_out_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_vbi_out;
+	struct video_device		radio_rx_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_radio_rx;
+	struct video_device		radio_tx_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_radio_tx;
+	struct video_device		sdr_cap_dev;
+	struct v4l2_ctrl_handler	ctrl_hdl_sdr_cap;
+	spinlock_t			slock;
+	struct mutex			mutex;
+
+	/* capabilities */
+	u32				vid_cap_caps;
+	u32				vid_out_caps;
+	u32				vbi_cap_caps;
+	u32				vbi_out_caps;
+	u32				sdr_cap_caps;
+	u32				radio_rx_caps;
+	u32				radio_tx_caps;
+
+	/* supported features */
+	bool				multiplanar;
+	unsigned			num_inputs;
+	u8				input_type[MAX_INPUTS];
+	u8				input_name_counter[MAX_INPUTS];
+	unsigned			num_outputs;
+	u8				output_type[MAX_OUTPUTS];
+	u8				output_name_counter[MAX_OUTPUTS];
+	bool				has_audio_inputs;
+	bool				has_audio_outputs;
+	bool				has_vid_cap;
+	bool				has_vid_out;
+	bool				has_vbi_cap;
+	bool				has_raw_vbi_cap;
+	bool				has_sliced_vbi_cap;
+	bool				has_vbi_out;
+	bool				has_raw_vbi_out;
+	bool				has_sliced_vbi_out;
+	bool				has_radio_rx;
+	bool				has_radio_tx;
+	bool				has_sdr_cap;
+	bool				has_fb;
+
+	bool				can_loop_video;
+
+	/* controls */
+	struct v4l2_ctrl		*brightness;
+	struct v4l2_ctrl		*contrast;
+	struct v4l2_ctrl		*saturation;
+	struct v4l2_ctrl		*hue;
+	struct {
+		/* autogain/gain cluster */
+		struct v4l2_ctrl	*autogain;
+		struct v4l2_ctrl	*gain;
+	};
+	struct v4l2_ctrl		*volume;
+	struct v4l2_ctrl		*mute;
+	struct v4l2_ctrl		*alpha;
+	struct v4l2_ctrl		*button;
+	struct v4l2_ctrl		*boolean;
+	struct v4l2_ctrl		*int32;
+	struct v4l2_ctrl		*int64;
+	struct v4l2_ctrl		*menu;
+	struct v4l2_ctrl		*string;
+	struct v4l2_ctrl		*bitmask;
+	struct v4l2_ctrl		*int_menu;
+	struct v4l2_ctrl		*test_pattern;
+	struct v4l2_ctrl		*colorspace;
+	struct v4l2_ctrl		*rgb_range_cap;
+	struct v4l2_ctrl		*real_rgb_range_cap;
+	struct {
+		/* std_signal_mode/standard cluster */
+		struct v4l2_ctrl	*ctrl_std_signal_mode;
+		struct v4l2_ctrl	*ctrl_standard;
+	};
+	struct {
+		/* dv_timings_signal_mode/timings cluster */
+		struct v4l2_ctrl	*ctrl_dv_timings_signal_mode;
+		struct v4l2_ctrl	*ctrl_dv_timings;
+	};
+	struct v4l2_ctrl		*ctrl_has_crop_cap;
+	struct v4l2_ctrl		*ctrl_has_compose_cap;
+	struct v4l2_ctrl		*ctrl_has_scaler_cap;
+	struct v4l2_ctrl		*ctrl_has_crop_out;
+	struct v4l2_ctrl		*ctrl_has_compose_out;
+	struct v4l2_ctrl		*ctrl_has_scaler_out;
+	struct v4l2_ctrl		*ctrl_tx_mode;
+	struct v4l2_ctrl		*ctrl_tx_rgb_range;
+
+	struct v4l2_ctrl		*radio_tx_rds_pi;
+	struct v4l2_ctrl		*radio_tx_rds_pty;
+	struct v4l2_ctrl		*radio_tx_rds_mono_stereo;
+	struct v4l2_ctrl		*radio_tx_rds_art_head;
+	struct v4l2_ctrl		*radio_tx_rds_compressed;
+	struct v4l2_ctrl		*radio_tx_rds_dyn_pty;
+	struct v4l2_ctrl		*radio_tx_rds_ta;
+	struct v4l2_ctrl		*radio_tx_rds_tp;
+	struct v4l2_ctrl		*radio_tx_rds_ms;
+	struct v4l2_ctrl		*radio_tx_rds_psname;
+	struct v4l2_ctrl		*radio_tx_rds_radiotext;
+
+	struct v4l2_ctrl		*radio_rx_rds_pty;
+	struct v4l2_ctrl		*radio_rx_rds_ta;
+	struct v4l2_ctrl		*radio_rx_rds_tp;
+	struct v4l2_ctrl		*radio_rx_rds_ms;
+	struct v4l2_ctrl		*radio_rx_rds_psname;
+	struct v4l2_ctrl		*radio_rx_rds_radiotext;
+
+	unsigned			input_brightness[MAX_INPUTS];
+	unsigned			osd_mode;
+	unsigned			button_pressed;
+	bool				sensor_hflip;
+	bool				sensor_vflip;
+	bool				hflip;
+	bool				vflip;
+	bool				vbi_cap_interlaced;
+	bool				loop_video;
+
+	/* Framebuffer */
+	unsigned long			video_pbase;
+	void				*video_vbase;
+	u32				video_buffer_size;
+	int				display_width;
+	int				display_height;
+	int				display_byte_stride;
+	int				bits_per_pixel;
+	int				bytes_per_pixel;
+	struct fb_info			fb_info;
+	struct fb_var_screeninfo	fb_defined;
+	struct fb_fix_screeninfo	fb_fix;
+
+	/* Error injection */
+	bool				queue_setup_error;
+	bool				buf_prepare_error;
+	bool				start_streaming_error;
+	bool				dqbuf_error;
+	bool				seq_wrap;
+	bool				time_wrap;
+	__kernel_time_t			time_wrap_offset;
+	unsigned			perc_dropped_buffers;
+	enum vivid_signal_mode		std_signal_mode;
+	unsigned			query_std_last;
+	v4l2_std_id			query_std;
+	enum tpg_video_aspect		std_aspect_ratio;
+
+	enum vivid_signal_mode		dv_timings_signal_mode;
+	char				**query_dv_timings_qmenu;
+	unsigned			query_dv_timings_size;
+	unsigned			query_dv_timings_last;
+	unsigned			query_dv_timings;
+	enum tpg_video_aspect		dv_timings_aspect_ratio;
+
+	/* Input */
+	unsigned			input;
+	v4l2_std_id			std_cap;
+	struct v4l2_dv_timings		dv_timings_cap;
+	u32				service_set_cap;
+	struct vivid_vbi_gen_data	vbi_gen;
+	u8				*edid;
+	unsigned			edid_blocks;
+	unsigned			edid_max_blocks;
+	unsigned			webcam_size_idx;
+	unsigned			webcam_ival_idx;
+	unsigned			tv_freq;
+	unsigned			tv_audmode;
+	unsigned			tv_field_cap;
+	unsigned			tv_audio_input;
+
+	/* Capture Overlay */
+	struct v4l2_framebuffer		fb_cap;
+	struct v4l2_fh			*overlay_cap_owner;
+	void				*fb_vbase_cap;
+	int				overlay_cap_top, overlay_cap_left;
+	enum v4l2_field			overlay_cap_field;
+	void				*bitmap_cap;
+	struct v4l2_clip		clips_cap[MAX_CLIPS];
+	struct v4l2_clip		try_clips_cap[MAX_CLIPS];
+	unsigned			clipcount_cap;
+
+	/* Output */
+	unsigned			output;
+	v4l2_std_id			std_out;
+	struct v4l2_dv_timings		dv_timings_out;
+	u32				colorspace_out;
+	u32				service_set_out;
+	u32				bytesperline_out[2];
+	unsigned			tv_field_out;
+	unsigned			tv_audio_output;
+	bool				vbi_out_have_wss;
+	u8				vbi_out_wss[2];
+	bool				vbi_out_have_cc[2];
+	u8				vbi_out_cc[2][2];
+	bool				dvi_d_out;
+	u8				*scaled_line;
+	u8				*blended_line;
+	unsigned			cur_scaled_line;
+
+	/* Output Overlay */
+	void				*fb_vbase_out;
+	bool				overlay_out_enabled;
+	int				overlay_out_top, overlay_out_left;
+	void				*bitmap_out;
+	struct v4l2_clip		clips_out[MAX_CLIPS];
+	struct v4l2_clip		try_clips_out[MAX_CLIPS];
+	unsigned			clipcount_out;
+	unsigned			fbuf_out_flags;
+	u32				chromakey_out;
+	u8				global_alpha_out;
+
+	/* video capture */
+	struct tpg_data			tpg;
+	unsigned			ms_vid_cap;
+	bool				must_blank[VIDEO_MAX_FRAME];
+
+	const struct vivid_fmt		*fmt_cap;
+	struct v4l2_fract		timeperframe_vid_cap;
+	enum v4l2_field			field_cap;
+	struct v4l2_rect		src_rect;
+	struct v4l2_rect		fmt_cap_rect;
+	struct v4l2_rect		crop_cap;
+	struct v4l2_rect		compose_cap;
+	struct v4l2_rect		crop_bounds_cap;
+	struct vb2_queue		vb_vid_cap_q;
+	struct list_head		vid_cap_active;
+	struct vb2_queue		vb_vbi_cap_q;
+	struct list_head		vbi_cap_active;
+
+	/* thread for generating video capture stream */
+	struct task_struct		*kthread_vid_cap;
+	unsigned long			jiffies_vid_cap;
+	u32				cap_seq_offset;
+	u32				cap_seq_count;
+	bool				cap_seq_resync;
+	u32				vid_cap_seq_start;
+	u32				vid_cap_seq_count;
+	bool				vid_cap_streaming;
+	u32				vbi_cap_seq_start;
+	u32				vbi_cap_seq_count;
+	bool				vbi_cap_streaming;
+	bool				stream_sliced_vbi_cap;
+
+	/* video output */
+	const struct vivid_fmt		*fmt_out;
+	struct v4l2_fract		timeperframe_vid_out;
+	enum v4l2_field			field_out;
+	struct v4l2_rect		sink_rect;
+	struct v4l2_rect		fmt_out_rect;
+	struct v4l2_rect		crop_out;
+	struct v4l2_rect		compose_out;
+	struct v4l2_rect		compose_bounds_out;
+	struct vb2_queue		vb_vid_out_q;
+	struct list_head		vid_out_active;
+	struct vb2_queue		vb_vbi_out_q;
+	struct list_head		vbi_out_active;
+
+	/* video loop precalculated rectangles */
+
+	/*
+	 * Intersection between what the output side composes and the capture side
+	 * crops. I.e., what actually needs to be copied from the output buffer to
+	 * the capture buffer.
+	 */
+	struct v4l2_rect		loop_vid_copy;
+	/* The part of the output buffer that (after scaling) corresponds to loop_vid_copy. */
+	struct v4l2_rect		loop_vid_out;
+	/* The part of the capture buffer that (after scaling) corresponds to loop_vid_copy. */
+	struct v4l2_rect		loop_vid_cap;
+	/*
+	 * The intersection of the framebuffer, the overlay output window and
+	 * loop_vid_copy. I.e., the part of the framebuffer that actually should be
+	 * blended with the compose_out rectangle. This uses the framebuffer origin.
+	 */
+	struct v4l2_rect		loop_fb_copy;
+	/* The same as loop_fb_copy but with compose_out origin. */
+	struct v4l2_rect		loop_vid_overlay;
+	/*
+	 * The part of the capture buffer that (after scaling) corresponds
+	 * to loop_vid_overlay.
+	 */
+	struct v4l2_rect		loop_vid_overlay_cap;
+
+	/* thread for generating video output stream */
+	struct task_struct		*kthread_vid_out;
+	unsigned long			jiffies_vid_out;
+	u32				out_seq_offset;
+	u32				out_seq_count;
+	bool				out_seq_resync;
+	u32				vid_out_seq_start;
+	u32				vid_out_seq_count;
+	bool				vid_out_streaming;
+	u32				vbi_out_seq_start;
+	u32				vbi_out_seq_count;
+	bool				vbi_out_streaming;
+	bool				stream_sliced_vbi_out;
+
+	/* SDR capture */
+	struct vb2_queue		vb_sdr_cap_q;
+	struct list_head		sdr_cap_active;
+	unsigned			sdr_adc_freq;
+	unsigned			sdr_fm_freq;
+	int				sdr_fixp_src_phase;
+	int				sdr_fixp_mod_phase;
+
+	bool				tstamp_src_is_soe;
+	bool				has_crop_cap;
+	bool				has_compose_cap;
+	bool				has_scaler_cap;
+	bool				has_crop_out;
+	bool				has_compose_out;
+	bool				has_scaler_out;
+
+	/* thread for generating SDR stream */
+	struct task_struct		*kthread_sdr_cap;
+	unsigned long			jiffies_sdr_cap;
+	u32				sdr_cap_seq_offset;
+	u32				sdr_cap_seq_count;
+	bool				sdr_cap_seq_resync;
+
+	/* RDS generator */
+	struct vivid_rds_gen		rds_gen;
+
+	/* Radio receiver */
+	unsigned			radio_rx_freq;
+	unsigned			radio_rx_audmode;
+	int				radio_rx_sig_qual;
+	unsigned			radio_rx_hw_seek_mode;
+	bool				radio_rx_hw_seek_prog_lim;
+	bool				radio_rx_rds_controls;
+	bool				radio_rx_rds_enabled;
+	unsigned			radio_rx_rds_use_alternates;
+	unsigned			radio_rx_rds_last_block;
+	struct v4l2_fh			*radio_rx_rds_owner;
+
+	/* Radio transmitter */
+	unsigned			radio_tx_freq;
+	unsigned			radio_tx_subchans;
+	bool				radio_tx_rds_controls;
+	unsigned			radio_tx_rds_last_block;
+	struct v4l2_fh			*radio_tx_rds_owner;
+
+	/* Shared between radio receiver and transmitter */
+	bool				radio_rds_loop;
+	struct timespec			radio_rds_init_ts;
+};
+
+static inline bool vivid_is_webcam(const struct vivid_dev *dev)
+{
+	return dev->input_type[dev->input] == WEBCAM;
+}
+
+static inline bool vivid_is_tv_cap(const struct vivid_dev *dev)
+{
+	return dev->input_type[dev->input] == TV;
+}
+
+static inline bool vivid_is_svid_cap(const struct vivid_dev *dev)
+{
+	return dev->input_type[dev->input] == SVID;
+}
+
+static inline bool vivid_is_hdmi_cap(const struct vivid_dev *dev)
+{
+	return dev->input_type[dev->input] == HDMI;
+}
+
+static inline bool vivid_is_sdtv_cap(const struct vivid_dev *dev)
+{
+	return vivid_is_tv_cap(dev) || vivid_is_svid_cap(dev);
+}
+
+static inline bool vivid_is_svid_out(const struct vivid_dev *dev)
+{
+	return dev->output_type[dev->output] == SVID;
+}
+
+static inline bool vivid_is_hdmi_out(const struct vivid_dev *dev)
+{
+	return dev->output_type[dev->output] == HDMI;
+}
+
+void vivid_lock(struct vb2_queue *vq);
+void vivid_unlock(struct vb2_queue *vq);
+
+#endif
-- 
2.0.1

