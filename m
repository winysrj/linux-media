Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3779 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2APNKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/10] radio-isa: add framework for ISA radio drivers.
Date: Mon, 16 Jan 2012 14:09:57 +0100
Message-Id: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

We have quite a few ISA radio drivers, which are all very similar.

This framework makes it possible to reduce the code size of those drivers
and makes it much easier to keep them up to date with the latest V4L2 API
developments.

Drivers rewritten to use this framework fully pass the v4l2-compliance tests
and are properly using the ISA bus (so they can be found under /sys/bus/isa).

It is now also possible to support multiple cards using the same driver
(tested with two radio-gemtek cards).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig     |    4 +
 drivers/media/radio/Makefile    |    1 +
 drivers/media/radio/radio-isa.c |  353 +++++++++++++++++++++++++++++++++++++++
 drivers/media/radio/radio-isa.h |  105 ++++++++++++
 4 files changed, 463 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-isa.c
 create mode 100644 drivers/media/radio/radio-isa.h

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index e954781..2ad446f 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -167,6 +167,10 @@ menuconfig V4L_RADIO_ISA_DRIVERS
 
 if V4L_RADIO_ISA_DRIVERS
 
+config RADIO_ISA
+	depends on ISA
+	tristate
+
 config RADIO_CADET
 	tristate "ADS Cadet AM/FM Tuner"
 	depends on ISA && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 390daf9..bb1911e 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the kernel character device drivers.
 #
 
+obj-$(CONFIG_RADIO_ISA) += radio-isa.o
 obj-$(CONFIG_RADIO_AZTECH) += radio-aztech.o
 obj-$(CONFIG_RADIO_RTRACK2) += radio-rtrack2.o
 obj-$(CONFIG_RADIO_SF16FMI) += radio-sf16fmi.o
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
new file mode 100644
index 0000000..b9ccb5d
--- /dev/null
+++ b/drivers/media/radio/radio-isa.c
@@ -0,0 +1,353 @@
+/*
+ * Framework for ISA radio drivers.
+ * This takes care of all the V4L2 scaffolding, allowing the ISA drivers
+ * to concentrate on the actual hardware operation.
+ *
+ * Copyright (C) 2012 Hans Verkuil <hans.verkuil@cisco.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/io.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+
+#include "radio-isa.h"
+
+MODULE_AUTHOR("Hans Verkuil");
+MODULE_DESCRIPTION("A framework for ISA radio drivers.");
+MODULE_LICENSE("GPL");
+
+#define FREQ_LOW  (87U * 16000U)
+#define FREQ_HIGH (108U * 16000U)
+
+static int radio_isa_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *v)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+
+	strlcpy(v->driver, isa->drv->driver.driver.name, sizeof(v->driver));
+	strlcpy(v->card, isa->drv->card, sizeof(v->card));
+	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
+
+	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	return 0;
+}
+
+static int radio_isa_g_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *v)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+	const struct radio_isa_ops *ops = isa->drv->ops;
+
+	if (v->index > 0)
+		return -EINVAL;
+
+	strlcpy(v->name, "FM", sizeof(v->name));
+	v->type = V4L2_TUNER_RADIO;
+	v->rangelow = FREQ_LOW;
+	v->rangehigh = FREQ_HIGH;
+	v->capability = V4L2_TUNER_CAP_LOW;
+	if (isa->drv->has_stereo)
+		v->capability |= V4L2_TUNER_CAP_STEREO;
+
+	if (ops->g_rxsubchans)
+		v->rxsubchans = ops->g_rxsubchans(isa);
+	else
+		v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	v->audmode = isa->stereo ? V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
+	if (ops->g_signal)
+		v->signal = ops->g_signal(isa);
+	else
+		v->signal = (v->rxsubchans & V4L2_TUNER_SUB_STEREO) ?
+								0xffff : 0;
+	return 0;
+}
+
+static int radio_isa_s_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *v)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+	const struct radio_isa_ops *ops = isa->drv->ops;
+
+	if (v->index)
+		return -EINVAL;
+	if (ops->s_stereo) {
+		isa->stereo = (v->audmode == V4L2_TUNER_MODE_STEREO);
+		return ops->s_stereo(isa, isa->stereo);
+	}
+	return 0;
+}
+
+static int radio_isa_s_frequency(struct file *file, void *priv,
+				struct v4l2_frequency *f)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+	int res;
+
+	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
+		return -EINVAL;
+	f->frequency = clamp(f->frequency, FREQ_LOW, FREQ_HIGH);
+	res = isa->drv->ops->s_frequency(isa, f->frequency);
+	if (res == 0)
+		isa->freq = f->frequency;
+	return res;
+}
+
+static int radio_isa_g_frequency(struct file *file, void *priv,
+				struct v4l2_frequency *f)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+
+	if (f->tuner != 0)
+		return -EINVAL;
+	f->type = V4L2_TUNER_RADIO;
+	f->frequency = isa->freq;
+	return 0;
+}
+
+static int radio_isa_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct radio_isa_card *isa =
+		container_of(ctrl->handler, struct radio_isa_card, hdl);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		return isa->drv->ops->s_mute_volume(isa, ctrl->val,
+				isa->volume ? isa->volume->val : 0);
+	}
+	return -EINVAL;
+}
+
+static int radio_isa_log_status(struct file *file, void *priv)
+{
+	struct radio_isa_card *isa = video_drvdata(file);
+
+	v4l2_info(&isa->v4l2_dev,
+		"=================  START STATUS CARD =================\n");
+	v4l2_info(&isa->v4l2_dev, "I/O Port = 0x%03x\n", isa->io);
+	v4l2_ctrl_handler_log_status(&isa->hdl, isa->v4l2_dev.name);
+	v4l2_info(&isa->v4l2_dev,
+		"==================  END STATUS CARD ==================\n");
+	return 0;
+}
+
+static int radio_isa_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_CTRL)
+		return v4l2_event_subscribe(fh, sub, 0);
+	return -EINVAL;
+}
+
+static unsigned int radio_isa_poll(struct file *file,
+					struct poll_table_struct *wait)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	if (v4l2_event_pending(fh))
+		return POLLPRI;
+	poll_wait(file, &fh->wait, wait);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops radio_isa_ctrl_ops = {
+	.s_ctrl = radio_isa_s_ctrl,
+};
+
+static const struct v4l2_file_operations radio_isa_fops = {
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= radio_isa_poll,
+	.unlocked_ioctl	= video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops radio_isa_ioctl_ops = {
+	.vidioc_querycap    = radio_isa_querycap,
+	.vidioc_g_tuner     = radio_isa_g_tuner,
+	.vidioc_s_tuner     = radio_isa_s_tuner,
+	.vidioc_g_frequency = radio_isa_g_frequency,
+	.vidioc_s_frequency = radio_isa_s_frequency,
+	.vidioc_log_status  = radio_isa_log_status,
+	.vidioc_subscribe_event   = radio_isa_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
+};
+
+int radio_isa_match(struct device *pdev, unsigned int dev)
+{
+	struct radio_isa_driver *drv = pdev->platform_data;
+
+	return drv->probe || drv->io_params[dev] >= 0;
+}
+EXPORT_SYMBOL_GPL(radio_isa_match);
+
+static bool radio_isa_valid_io(const struct radio_isa_driver *drv, int io)
+{
+	int i;
+
+	for (i = 0; i < drv->num_of_io_ports; i++)
+		if (drv->io_ports[i] == io)
+			return true;
+	return false;
+}
+
+int radio_isa_probe(struct device *pdev, unsigned int dev)
+{
+	struct radio_isa_driver *drv = pdev->platform_data;
+	const struct radio_isa_ops *ops = drv->ops;
+	struct v4l2_device *v4l2_dev;
+	struct radio_isa_card *isa;
+	int res;
+
+	isa = drv->ops->alloc();
+	if (isa == NULL)
+		return -ENOMEM;
+	dev_set_drvdata(pdev, isa);
+	isa->drv = drv;
+	isa->io = drv->io_params[dev];
+	v4l2_dev = &isa->v4l2_dev;
+	strlcpy(v4l2_dev->name, dev_name(pdev), sizeof(v4l2_dev->name));
+
+	if (drv->probe && ops->probe) {
+		int i;
+
+		for (i = 0; i < drv->num_of_io_ports; ++i) {
+			int io = drv->io_ports[i];
+
+			if (request_region(io, drv->region_size, v4l2_dev->name)) {
+				bool found = ops->probe(isa, io);
+
+				release_region(io, drv->region_size);
+				if (found) {
+					isa->io = io;
+					break;
+				}
+			}
+		}
+	}
+
+	if (!radio_isa_valid_io(drv, isa->io)) {
+		int i;
+
+		if (isa->io < 0)
+			return -ENODEV;
+		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x%03x",
+				drv->io_ports[0]);
+		for (i = 1; i < drv->num_of_io_ports; i++)
+			printk(KERN_CONT "/0x%03x", drv->io_ports[i]);
+		printk(KERN_CONT ".\n");
+		kfree(isa);
+		return -EINVAL;
+	}
+
+	if (!request_region(isa->io, drv->region_size, v4l2_dev->name)) {
+		v4l2_err(v4l2_dev, "port 0x%x already in use\n", isa->io);
+		kfree(isa);
+		return -EBUSY;
+	}
+
+	res = v4l2_device_register(pdev, v4l2_dev);
+	if (res < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		goto err_dev_reg;
+	}
+
+	v4l2_ctrl_handler_init(&isa->hdl, 1);
+	isa->mute = v4l2_ctrl_new_std(&isa->hdl, &radio_isa_ctrl_ops,
+				V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	if (drv->max_volume)
+		isa->volume = v4l2_ctrl_new_std(&isa->hdl, &radio_isa_ctrl_ops,
+			V4L2_CID_AUDIO_VOLUME, 0, drv->max_volume, 1,
+			drv->max_volume);
+	v4l2_dev->ctrl_handler = &isa->hdl;
+	if (isa->hdl.error) {
+		res = isa->hdl.error;
+		v4l2_err(v4l2_dev, "Could not register controls\n");
+		goto err_hdl;
+	}
+	if (drv->max_volume)
+		v4l2_ctrl_cluster(2, &isa->mute);
+	v4l2_dev->ctrl_handler = &isa->hdl;
+
+	mutex_init(&isa->lock);
+	isa->vdev.lock = &isa->lock;
+	strlcpy(isa->vdev.name, v4l2_dev->name, sizeof(isa->vdev.name));
+	isa->vdev.v4l2_dev = v4l2_dev;
+	isa->vdev.fops = &radio_isa_fops;
+	isa->vdev.ioctl_ops = &radio_isa_ioctl_ops;
+	isa->vdev.release = video_device_release_empty;
+	set_bit(V4L2_FL_USE_FH_PRIO, &isa->vdev.flags);
+	video_set_drvdata(&isa->vdev, isa);
+	isa->freq = 87 * 16000;
+	isa->stereo = drv->has_stereo;
+
+	if (ops->init)
+		res = ops->init(isa);
+	if (!res)
+		res = v4l2_ctrl_handler_setup(&isa->hdl);
+	if (!res)
+		res = ops->s_frequency(isa, isa->freq);
+	if (!res && ops->s_stereo)
+		res = ops->s_stereo(isa, isa->stereo);
+	if (res < 0) {
+		v4l2_err(v4l2_dev, "Could not setup card\n");
+		goto err_node_reg;
+	}
+	res = video_register_device(&isa->vdev, VFL_TYPE_RADIO,
+					drv->radio_nr_params[dev]);
+	if (res < 0) {
+		v4l2_err(v4l2_dev, "Could not register device node\n");
+		goto err_node_reg;
+	}
+
+	v4l2_info(v4l2_dev, "Initialized radio card %s on port 0x%03x\n",
+			drv->card, isa->io);
+	return 0;
+
+err_node_reg:
+	v4l2_ctrl_handler_free(&isa->hdl);
+err_hdl:
+	v4l2_device_unregister(&isa->v4l2_dev);
+err_dev_reg:
+	release_region(isa->io, drv->region_size);
+	kfree(isa);
+	return res;
+}
+EXPORT_SYMBOL_GPL(radio_isa_probe);
+
+int radio_isa_remove(struct device *pdev, unsigned int dev)
+{
+	struct radio_isa_card *isa = dev_get_drvdata(pdev);
+	const struct radio_isa_ops *ops = isa->drv->ops;
+
+	ops->s_mute_volume(isa, true, isa->volume ? isa->volume->cur.val : 0);
+	video_unregister_device(&isa->vdev);
+	v4l2_ctrl_handler_free(&isa->hdl);
+	v4l2_device_unregister(&isa->v4l2_dev);
+	release_region(isa->io, isa->drv->region_size);
+	v4l2_info(&isa->v4l2_dev, "Removed radio card %s\n", isa->drv->card);
+	kfree(isa);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(radio_isa_remove);
diff --git a/drivers/media/radio/radio-isa.h b/drivers/media/radio/radio-isa.h
new file mode 100644
index 0000000..8a0ea84
--- /dev/null
+++ b/drivers/media/radio/radio-isa.h
@@ -0,0 +1,105 @@
+/*
+ * Framework for ISA radio drivers.
+ * This takes care of all the V4L2 scaffolding, allowing the ISA drivers
+ * to concentrate on the actual hardware operation.
+ *
+ * Copyright (C) 2012 Hans Verkuil <hans.verkuil@cisco.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef _RADIO_ISA_H_
+#define _RADIO_ISA_H_
+
+#include <linux/isa.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+
+struct radio_isa_driver;
+struct radio_isa_ops;
+
+/* Core structure for radio ISA cards */
+struct radio_isa_card {
+	const struct radio_isa_driver *drv;
+	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
+	struct video_device vdev;
+	struct mutex lock;
+	const struct radio_isa_ops *ops;
+	struct {	/* mute/volume cluster */
+		struct v4l2_ctrl *mute;
+		struct v4l2_ctrl *volume;
+	};
+	/* I/O port */
+	int io;
+
+	/* Card is in stereo audio mode */
+	bool stereo;
+	/* Current frequency */
+	u32 freq;
+};
+
+struct radio_isa_ops {
+	/* Allocate and initialize a radio_isa_card struct */
+	struct radio_isa_card *(*alloc)(void);
+	/* Probe whether a card is present at the given port */
+	bool (*probe)(struct radio_isa_card *isa, int io);
+	/* Special card initialization can be done here, this is called after
+	 * the standard controls are registered, but before they are setup,
+	 * thus allowing drivers to add their own controls here. */
+	int (*init)(struct radio_isa_card *isa);
+	/* Set mute and volume. */
+	int (*s_mute_volume)(struct radio_isa_card *isa, bool mute, int volume);
+	/* Set frequency */
+	int (*s_frequency)(struct radio_isa_card *isa, u32 freq);
+	/* Set stereo/mono audio mode */
+	int (*s_stereo)(struct radio_isa_card *isa, bool stereo);
+	/* Get rxsubchans value for VIDIOC_G_TUNER */
+	u32 (*g_rxsubchans)(struct radio_isa_card *isa);
+	/* Get the signal strength for VIDIOC_G_TUNER */
+	u32 (*g_signal)(struct radio_isa_card *isa);
+};
+
+/* Top level structure needed to instantiate the cards */
+struct radio_isa_driver {
+	struct isa_driver driver;
+	const struct radio_isa_ops *ops;
+	/* The module_param_array with the specified I/O ports */
+	int *io_params;
+	/* The module_param_array with the radio_nr values */
+	int *radio_nr_params;
+	/* Whether we should probe for possible cards */
+	bool probe;
+	/* The list of possible I/O ports */
+	const int *io_ports;
+	/* The size of that list */
+	int num_of_io_ports;
+	/* The region size to request */
+	unsigned region_size;
+	/* The name of the card */
+	const char *card;
+	/* Card can capture stereo audio */
+	bool has_stereo;
+	/* The maximum volume for the volume control. If 0, then there
+	   is no volume control possible. */
+	int max_volume;
+};
+
+int radio_isa_match(struct device *pdev, unsigned int dev);
+int radio_isa_probe(struct device *pdev, unsigned int dev);
+int radio_isa_remove(struct device *pdev, unsigned int dev);
+
+#endif
-- 
1.7.7.3

