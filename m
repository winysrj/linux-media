Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2790 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab0A0QWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:22:18 -0500
Message-ID: <4B606830.90005@pelagicore.com>
Date: Wed, 27 Jan 2010 17:22:08 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/2] radio: Add radio-timb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add supports for the radio system on the Intel Russellville board.

It's a In-Vehicle Infotainment board with a radio tuner and DSP.

This umbrella driver has the DSP and tuner as V4L2 subdevs and calls them
when needed.

The RDS support is done by I/O memory accesses.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
new file mode 100644
index 0000000..276b105
--- /dev/null
+++ b/drivers/media/radio/radio-timb.c
@@ -0,0 +1,469 @@
+/*
+ * radio-timb.c Timberdale FPGA Radio driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/version.h>
+#include <linux/io.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <media/timb_radio.h>
+
+#define DRIVER_NAME "timb-radio"
+
+#define RDS_BLOCK_SIZE 4
+#define RDS_BUFFER_SIZE (RDS_BLOCK_SIZE * 100)
+
+struct timbradio {
+	struct mutex		lock; /* for mutual exclusion */
+	void __iomem		*membase;
+	struct timb_radio_platform_data	pdata;
+	struct v4l2_subdev	*sd_tuner;
+	struct v4l2_subdev	*sd_dsp;
+	struct video_device	*video_dev;
+	struct v4l2_device	v4l2_dev;
+	/* RDS related */
+	int open_count;
+	int rds_irq;
+	wait_queue_head_t read_queue;
+	unsigned char buffer[RDS_BUFFER_SIZE];
+	unsigned int rd_index;
+	unsigned int wr_index;
+};
+
+
+static int timbradio_vidioc_querycap(struct file *file, void  *priv,
+	struct v4l2_capability *v)
+{
+	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
+	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
+	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
+	v->version = KERNEL_VERSION(0, 0, 1);
+	v->capabilities =
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
+	return 0;
+}
+
+static int timbradio_vidioc_g_tuner(struct file *file, void *priv,
+	struct v4l2_tuner *v)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, g_tuner, v);
+}
+
+static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
+	struct v4l2_tuner *v)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
+}
+
+static int timbradio_vidioc_g_input(struct file *filp, void *priv,
+	unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int timbradio_vidioc_s_input(struct file *filp, void *priv,
+	unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int timbradio_vidioc_g_audio(struct file *file, void *priv,
+	struct v4l2_audio *a)
+{
+	a->index = 0;
+	strlcpy(a->name, "Radio", sizeof(a->name));
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
+
+static int timbradio_vidioc_s_audio(struct file *file, void *priv,
+	struct v4l2_audio *a)
+{
+	return a->index ? -EINVAL : 0;
+}
+
+static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
+	struct v4l2_frequency *f)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, s_frequency, f);
+}
+
+static int timbradio_vidioc_g_frequency(struct file *file, void *priv,
+	struct v4l2_frequency *f)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_tuner, tuner, g_frequency, f);
+}
+
+static int timbradio_vidioc_queryctrl(struct file *file, void *priv,
+	struct v4l2_queryctrl *qc)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, queryctrl, qc);
+}
+
+static int timbradio_vidioc_g_ctrl(struct file *file, void *priv,
+	struct v4l2_control *ctrl)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, g_ctrl, ctrl);
+}
+
+static int timbradio_vidioc_s_ctrl(struct file *file, void *priv,
+	struct v4l2_control *ctrl)
+{
+	struct timbradio *tr = video_drvdata(file);
+	return v4l2_subdev_call(tr->sd_dsp, core, s_ctrl, ctrl);
+}
+
+static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
+	.vidioc_querycap	= timbradio_vidioc_querycap,
+	.vidioc_g_tuner		= timbradio_vidioc_g_tuner,
+	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
+	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
+	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
+	.vidioc_g_input		= timbradio_vidioc_g_input,
+	.vidioc_s_input		= timbradio_vidioc_s_input,
+	.vidioc_g_audio		= timbradio_vidioc_g_audio,
+	.vidioc_s_audio		= timbradio_vidioc_s_audio,
+	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
+	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
+};
+
+static irqreturn_t timbradio_irq(int irq, void *devid)
+{
+	struct timbradio *tr = devid;
+	u32 data = ioread32(tr->membase);
+
+	tr->buffer[tr->wr_index++] = data >> 24;
+	tr->buffer[tr->wr_index++] = data >> 16;
+	tr->buffer[tr->wr_index++] = data >> 8;
+	tr->buffer[tr->wr_index++] = data;
+	tr->wr_index %= RDS_BUFFER_SIZE;
+
+	wake_up(&tr->read_queue);
+
+	/* new RDS data received, read it */
+	return IRQ_HANDLED;
+}
+
+/**************************************************************************
+ * File Operations Interface
+ **************************************************************************/
+
+static ssize_t timbradio_rds_fops_read(struct file *file, char __user *buf,
+	size_t count, loff_t *ppos)
+{
+	struct timbradio *tr = video_drvdata(file);
+	unsigned int outblocks = 0;
+
+	if (count < sizeof(struct v4l2_rds_data))
+		return -EINVAL;
+
+	/* block if no new data available */
+	while (tr->wr_index == tr->rd_index) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EWOULDBLOCK;
+
+		if (wait_event_interruptible(tr->read_queue,
+			tr->wr_index != tr->rd_index))
+			return -EINTR;
+	}
+
+	mutex_lock(&tr->lock);
+	count /= sizeof(struct v4l2_rds_data);
+
+	while (outblocks < count) {
+		struct v4l2_rds_data rds_data;
+
+		rds_data.msb = tr->buffer[tr->rd_index++];
+		rds_data.lsb = tr->buffer[tr->rd_index++];
+		tr->rd_index %= RDS_BUFFER_SIZE;
+
+		rds_data.block = V4L2_RDS_BLOCK_A;
+
+		if (copy_to_user(buf + outblocks * sizeof(rds_data), &rds_data,
+			sizeof(rds_data))) {
+			mutex_unlock(&tr->lock);
+			return -EFAULT;
+		}
+
+		outblocks++;
+
+		if (tr->rd_index == tr->wr_index)
+			break;
+	}
+	mutex_unlock(&tr->lock);
+
+	return outblocks * sizeof(struct v4l2_rds_data);
+}
+
+static unsigned int timbradio_rds_fops_poll(struct file *file,
+	struct poll_table_struct *pts)
+{
+	struct timbradio *tr = video_drvdata(file);
+
+	poll_wait(file, &tr->read_queue, pts);
+
+	if (tr->rd_index != tr->wr_index)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+struct find_addr_arg {
+	char const *name;
+	struct i2c_client *client;
+};
+
+static int timbradio_rds_fops_open(struct file *file)
+{
+	struct timbradio *tr = video_drvdata(file);
+	struct i2c_adapter *adapt;
+	int err = 0;
+
+	mutex_lock(&tr->lock);
+	if (tr->open_count)
+		goto out;
+
+	/* device currently not open, check if the DSP and tuner is not
+	 * yet found, in that case find them
+	 */
+
+	/* find the I2C bus */
+	adapt = i2c_get_adapter(tr->pdata.i2c_adapter);
+	if (!adapt) {
+		printk(KERN_ERR DRIVER_NAME": No I2C bus\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* now find the tuner and dsp */
+	if (!tr->sd_dsp)
+		tr->sd_dsp = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
+			tr->pdata.dsp.module_name, tr->pdata.dsp.info, NULL);
+
+	if (!tr->sd_tuner)
+		tr->sd_tuner = v4l2_i2c_new_subdev_board(&tr->v4l2_dev, adapt,
+			tr->pdata.tuner.module_name, tr->pdata.tuner.info,
+			NULL);
+
+	i2c_put_adapter(adapt);
+
+	if (!tr->sd_tuner || !tr->sd_dsp) {
+		printk(KERN_ERR DRIVER_NAME
+			": Failed to get tuner or DSP\n");
+		err = -ENODEV;
+		goto out;
+	}
+
+	/* enable the IRQ for receiving RDS data */
+	err = request_irq(tr->rds_irq, timbradio_irq, 0, DRIVER_NAME, tr);
+out:
+	if (!err)
+		tr->open_count++;
+	mutex_unlock(&tr->lock);
+	return err;
+}
+
+static int timbradio_rds_fops_release(struct file *file)
+{
+	struct timbradio *tr = video_drvdata(file);
+
+	mutex_lock(&tr->lock);
+	tr->open_count--;
+	if (!tr->open_count) {
+		free_irq(tr->rds_irq, tr);
+
+		tr->wr_index = 0;
+		tr->rd_index = 0;
+
+		/* cancel read processes */
+		wake_up_interruptible(&tr->read_queue);
+	}
+	mutex_unlock(&tr->lock);
+
+	return 0;
+}
+
+
+static const struct v4l2_file_operations timbradio_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= video_ioctl2,
+	.read		= timbradio_rds_fops_read,
+	.poll		= timbradio_rds_fops_poll,
+	.open		= timbradio_rds_fops_open,
+	.release	= timbradio_rds_fops_release,
+};
+
+static const struct video_device timbradio_template = {
+	.name		= "Timberdale Radio",
+	.fops		= &timbradio_fops,
+	.ioctl_ops 	= &timbradio_ioctl_ops,
+	.release	= video_device_release_empty,
+	.minor		= -1
+};
+
+
+static int __devinit timbradio_probe(struct platform_device *pdev)
+{
+	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
+	struct timbradio *tr;
+	struct resource *iomem;
+	int irq;
+	int err;
+
+	if (!pdata) {
+		printk(KERN_ERR DRIVER_NAME": Platform data missing\n");
+		err = -EINVAL;
+		goto err;
+	}
+
+	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		err = -ENODEV;
+		goto err;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		err = -ENODEV;
+		goto err;
+	}
+
+	if (!request_mem_region(iomem->start, resource_size(iomem),
+		DRIVER_NAME)) {
+		err = -EBUSY;
+		goto err;
+	}
+
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+	mutex_init(&tr->lock);
+
+	tr->membase = ioremap(iomem->start, resource_size(iomem));
+	if (!tr->membase) {
+		err = -ENOMEM;
+		goto err_ioremap;
+	}
+
+	memcpy(&tr->pdata, pdata, sizeof(tr->pdata));
+
+	tr->video_dev = video_device_alloc();
+	if (!tr->video_dev) {
+		err = -ENOMEM;
+		goto err_video_req;
+	}
+	*tr->video_dev = timbradio_template;
+	tr->rds_irq = irq;
+	init_waitqueue_head(&tr->read_queue);
+
+	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
+	err = v4l2_device_register(NULL, &tr->v4l2_dev);
+	if (err)
+		goto err_v4l2_dev;
+
+	tr->video_dev->v4l2_dev = &tr->v4l2_dev;
+
+	err = video_register_device(tr->video_dev, VFL_TYPE_RADIO, -1);
+	if (err) {
+		printk(KERN_ALERT DRIVER_NAME": Error reg video\n");
+		goto err_video_req;
+	}
+
+	video_set_drvdata(tr->video_dev, tr);
+
+	platform_set_drvdata(pdev, tr);
+	return 0;
+
+err_video_req:
+	v4l2_device_unregister(&tr->v4l2_dev);
+err_v4l2_dev:
+	if (tr->video_dev->minor != -1)
+		video_unregister_device(tr->video_dev);
+	else
+		video_device_release(tr->video_dev);
+	iounmap(tr->membase);
+err_ioremap:
+	kfree(tr);
+err_alloc:
+	release_mem_region(iomem->start, resource_size(iomem));
+err:
+	printk(KERN_ERR DRIVER_NAME ": Failed to register: %d\n", err);
+
+	return err;
+}
+
+static int __devexit timbradio_remove(struct platform_device *pdev)
+{
+	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct timbradio *tr = platform_get_drvdata(pdev);
+
+	if (tr->video_dev->minor != -1)
+		video_unregister_device(tr->video_dev);
+	else
+		video_device_release(tr->video_dev);
+
+	v4l2_device_unregister(&tr->v4l2_dev);
+
+	iounmap(tr->membase);
+	release_mem_region(iomem->start, resource_size(iomem));
+	kfree(tr);
+
+	return 0;
+}
+
+static struct platform_driver timbradio_platform_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= timbradio_probe,
+	.remove		= timbradio_remove,
+};
+
+/*--------------------------------------------------------------------------*/
+
+static int __init timbradio_init(void)
+{
+	return platform_driver_register(&timbradio_platform_driver);
+}
+
+static void __exit timbradio_exit(void)
+{
+	platform_driver_unregister(&timbradio_platform_driver);
+}
+
+module_init(timbradio_init);
+module_exit(timbradio_exit);
+
+MODULE_DESCRIPTION("Timberdale Radio driver");
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:"DRIVER_NAME);
diff --git a/include/media/timb_radio.h b/include/media/timb_radio.h
new file mode 100644
index 0000000..fcd32a3
--- /dev/null
+++ b/include/media/timb_radio.h
@@ -0,0 +1,36 @@
+/*
+ * timb_radio.h Platform struct for the Timberdale radio driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _TIMB_RADIO_
+#define _TIMB_RADIO_ 1
+
+#include <linux/i2c.h>
+
+struct timb_radio_platform_data {
+	int i2c_adapter; /* I2C adapter where the tuner and dsp are attached */
+	struct {
+		const char *module_name;
+		struct i2c_board_info *info;
+	} tuner;
+	struct {
+		const char *module_name;
+		struct i2c_board_info *info;
+	} dsp;
+};
+
+#endif

