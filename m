Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1944 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab0AVQ1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:27:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Richard =?iso-8859-1?q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Subject: Re: [PATCH 1/2] radio: Add radio-timb
Date: Fri, 22 Jan 2010 17:26:16 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <4B599C44.4030801@pelagicore.com>
In-Reply-To: <4B599C44.4030801@pelagicore.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001221726.16522.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 22 January 2010 13:38:28 Richard Röjfors wrote:
> This patch add supports for the radio system on the Intel Russellville board.
> 
> It's a In-Vehicle Infotainment board with a radio tuner and DSP.
> 
> This umbrella driver has the DSP and tuner as V4L2 subdevs and calls them
> when needed.
> 
> The RDS support is done by I/O memory accesses.

I gather from this source that you weren't aware of the RDS interface
specification:

http://www.linuxtv.org/downloads/v4l-dvb-apis/ch04s11.html

Please use the V4L2_CAP_RDS_CAPTURE capability in querycap and use the
struct v4l2_rds_data when reading the RDS data. Let us know if you run into
problems doing this. This API was only formalized in 2.6.32 (although based
on previous implementations), so it is pretty recent.

Some more comments below.

> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
> new file mode 100644
> index 0000000..3dbe9ad
> --- /dev/null
> +++ b/drivers/media/radio/radio-timb.c
> @@ -0,0 +1,543 @@
> +/*
> + * radio-timb.c Timberdale FPGA Radio driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-device.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <media/timb_radio.h>
> +
> +#define DRIVER_NAME "timb-radio"
> +
> +#define RDS_BLOCK_SIZE 4
> +#define RDS_BUFFER_SIZE (RDS_BLOCK_SIZE * 100)
> +
> +struct timbradio {
> +	struct mutex		lock; /* for mutual exclusion */
> +	void __iomem		*membase;
> +	struct timb_radio_platform_data	pdata;
> +	struct v4l2_subdev	*sd_tuner;
> +	struct module		*tuner_owner;
> +	struct v4l2_subdev	*sd_dsp;
> +	struct module		*dsp_owner;
> +	struct video_device	*video_dev;
> +	/* RDS related */
> +	int open_count;
> +	int rds_irq;
> +	wait_queue_head_t read_queue;
> +	unsigned char buffer[RDS_BUFFER_SIZE];
> +	unsigned int rd_index;
> +	unsigned int wr_index;
> +};
> +
> +
> +static int timbradio_vidioc_querycap(struct file *file, void  *priv,
> +			    struct v4l2_capability *v)
> +{
> +	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
> +	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
> +	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
> +	v->version = KERNEL_VERSION(0, 0, 1);
> +	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> +	return 0;
> +}
> +
> +static int timbradio_vidioc_g_tuner(struct file *file, void *priv,
> +			   struct v4l2_tuner *v)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_tuner, tuner, g_tuner, v);
> +	mutex_unlock(&tr->lock);

I'm not sure whether it is appropriate (or even needed!) to do the locking here.
Perhaps it is better to do the locking in the tuner driver? This is just an
idea. I do not have the datasheets, so I don't know what is reasonable here.

> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_s_tuner(struct file *file, void *priv,
> +			   struct v4l2_tuner *v)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_tuner, tuner, s_tuner, v);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_g_input(struct file *filp, void *priv,
> +	unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int timbradio_vidioc_s_input(struct file *filp, void *priv,
> +	unsigned int i)
> +{
> +	return i ? -EINVAL : 0;
> +}
> +
> +static int timbradio_vidioc_g_audio(struct file *file, void *priv,
> +			   struct v4l2_audio *a)
> +{
> +	a->index = 0;
> +	strlcpy(a->name, "Radio", sizeof(a->name));
> +	a->capability = V4L2_AUDCAP_STEREO;
> +	return 0;
> +}
> +
> +
> +static int timbradio_vidioc_s_audio(struct file *file, void *priv,
> +			   struct v4l2_audio *a)
> +{
> +	return a->index ? -EINVAL : 0;
> +}
> +
> +static int timbradio_vidioc_s_frequency(struct file *file, void *priv,
> +			       struct v4l2_frequency *f)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_tuner, tuner, s_frequency, f);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_g_frequency(struct file *file, void *priv,
> +			       struct v4l2_frequency *f)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_tuner, tuner, g_frequency, f);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_queryctrl(struct file *file, void *priv,
> +			     struct v4l2_queryctrl *qc)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_dsp, core, queryctrl, qc);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_g_ctrl(struct file *file, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_dsp, core, g_ctrl, ctrl);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static int timbradio_vidioc_s_ctrl(struct file *file, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int ret;
> +
> +	mutex_lock(&tr->lock);
> +	ret = v4l2_subdev_call(tr->sd_dsp, core, s_ctrl, ctrl);
> +	mutex_unlock(&tr->lock);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
> +	.vidioc_querycap	= timbradio_vidioc_querycap,
> +	.vidioc_g_tuner		= timbradio_vidioc_g_tuner,
> +	.vidioc_s_tuner		= timbradio_vidioc_s_tuner,
> +	.vidioc_g_frequency	= timbradio_vidioc_g_frequency,
> +	.vidioc_s_frequency	= timbradio_vidioc_s_frequency,
> +	.vidioc_g_input		= timbradio_vidioc_g_input,
> +	.vidioc_s_input		= timbradio_vidioc_s_input,
> +	.vidioc_g_audio		= timbradio_vidioc_g_audio,
> +	.vidioc_s_audio		= timbradio_vidioc_s_audio,
> +	.vidioc_queryctrl	= timbradio_vidioc_queryctrl,
> +	.vidioc_g_ctrl		= timbradio_vidioc_g_ctrl,
> +	.vidioc_s_ctrl		= timbradio_vidioc_s_ctrl
> +};
> +
> +static irqreturn_t timbradio_irq(int irq, void *devid)
> +{
> +	struct timbradio *tr = devid;
> +	u32 data = ioread32(tr->membase);
> +
> +	tr->buffer[tr->wr_index++] = data >> 24;
> +	tr->buffer[tr->wr_index++] = data >> 16;
> +	tr->buffer[tr->wr_index++] = data >> 8;
> +	tr->buffer[tr->wr_index++] = data;
> +	tr->wr_index %= RDS_BUFFER_SIZE;
> +
> +	wake_up(&tr->read_queue);
> +
> +	/* new RDS data received, read it */
> +	return IRQ_HANDLED;
> +}
> +
> +/**************************************************************************
> + * File Operations Interface
> + **************************************************************************/
> +
> +static ssize_t timbradio_rds_fops_read(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int outblocks = 0;
> +
> +	/* block if no new data available */
> +	while (tr->wr_index == tr->rd_index) {
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EWOULDBLOCK;
> +
> +		if (wait_event_interruptible(tr->read_queue,
> +			tr->wr_index != tr->rd_index))
> +			return -EINTR;
> +	}
> +
> +	count /= RDS_BLOCK_SIZE;
> +	/* copy RDS block out of internal buffer and to user buffer */
> +	mutex_lock(&tr->lock);
> +	while (outblocks < count) {
> +		if (tr->rd_index == tr->wr_index)
> +			break;
> +
> +		if (copy_to_user(buf, tr->buffer + tr->rd_index,
> +			RDS_BLOCK_SIZE))
> +			break;
> +		tr->rd_index += RDS_BLOCK_SIZE;
> +		tr->rd_index %= RDS_BUFFER_SIZE;
> +		outblocks++;
> +	}
> +	mutex_unlock(&tr->lock);
> +
> +	return outblocks * RDS_BLOCK_SIZE;
> +}
> +
> +static unsigned int timbradio_rds_fops_poll(struct file *file,
> +		struct poll_table_struct *pts)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +
> +	poll_wait(file, &tr->read_queue, pts);
> +
> +	if (tr->rd_index != tr->wr_index)
> +		return POLLIN | POLLRDNORM;
> +
> +	return 0;
> +}
> +
> +struct find_addr_arg {
> +	char const *name;
> +	struct i2c_client *client;
> +};
> +
> +static int find_name(struct device *dev, void *argp)
> +{
> +	struct find_addr_arg	*arg = (struct find_addr_arg *)argp;
> +	struct i2c_client	*client = i2c_verify_client(dev);
> +
> +	if (client && !strcmp(arg->name, client->name) && client->driver)
> +		arg->client = client;
> +
> +	return 0;
> +}
> +
> +static struct i2c_client *find_client(struct i2c_adapter *adapt,
> +	const char *name)
> +{
> +	struct find_addr_arg find_arg;
> +	/* now find the client */
> +#ifdef MODULE
> +	request_module(name);
> +#endif
> +	/* code for finding the I2C child */
> +	find_arg.name = name;
> +	find_arg.client = NULL;
> +	device_for_each_child(&adapt->dev, &find_arg, find_name);
> +	return find_arg.client;
> +}
> +
> +static int timbradio_rds_fops_open(struct file *file)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +	int err = 0;
> +
> +	mutex_lock(&tr->lock);
> +	if (tr->open_count == 0) {
> +		/* device currently not open, check if the DSP and tuner is not
> +		 * yet found, in that case find them
> +		 */
> +		if (!tr->sd_tuner) {

Much cleaner to invert these conditions:

	if (tr->open_count)
		goto out;
	if (tr->sd_tuner)
		goto req_irq;

Or something along these lines. Then the remainder of this function has two
tabs less and is thus much more readable.

> +			struct i2c_adapter *adapt;
> +			struct i2c_client *tuner;
> +			struct i2c_client *dsp;
> +
> +			/* find the I2C bus */
> +			adapt = i2c_get_adapter(tr->pdata.i2c_adapter);
> +			if (!adapt) {
> +				printk(KERN_ERR DRIVER_NAME": No I2C bus\n");
> +				err = -ENODEV;
> +				goto out;
> +			}
> +
> +			/* now find the tuner and dsp */
> +			tuner = find_client(adapt, tr->pdata.tuner);
> +			dsp = find_client(adapt, tr->pdata.dsp);
> +
> +			i2c_put_adapter(adapt);
> +
> +			if (!tuner || !dsp) {
> +				printk(KERN_ERR DRIVER_NAME
> +					": Failed to get tuner or DSP\n");
> +				err = -ENODEV;
> +				goto out;
> +			}
> +
> +			tr->sd_tuner = i2c_get_clientdata(tuner);
> +			tr->sd_dsp = i2c_get_clientdata(dsp);

I strongly recommend using v4l2_i2c_new_subdev() or v4l2_i2c_new_subdev_board()
to load the tuner and dsp subdevs. See also the v4l2-framework.txt documentation
in Documentation/video4linux.

Is there a reason why you want to load them only on first use? It is customary
to load them when this driver is loaded. Exceptions to that may be if the i2c
device needs to load a firmware: this can be slow over i2c and so should be
postponed until the i2c driver is needed for the first time.

> +
> +			tr->tuner_owner = tr->sd_tuner->owner;
> +			tr->dsp_owner = tr->sd_dsp->owner;
> +			/* Lock the modules */
> +			if (!try_module_get(tr->tuner_owner)) {
> +				err = -ENODEV;
> +				goto err_get_tuner;
> +			}
> +
> +			if (!try_module_get(tr->dsp_owner)) {
> +				err = -ENODEV;
> +				goto err_get_dsp;
> +			}
> +		}
> +
> +		/* enable the IRQ for receiving RDS data */
> +		err = request_irq(tr->rds_irq, timbradio_irq, 0, DRIVER_NAME,
> +			tr);
> +	}
> +	goto out;
> +
> +err_get_dsp:
> +	module_put(tr->tuner_owner);
> +err_get_tuner:
> +	tr->sd_tuner = NULL;
> +	tr->sd_dsp = NULL;
> +out:
> +	if (!err)
> +		tr->open_count++;
> +	mutex_unlock(&tr->lock);
> +	return err;
> +}
> +
> +static int timbradio_rds_fops_release(struct file *file)
> +{
> +	struct timbradio *tr = video_drvdata(file);
> +
> +	mutex_lock(&tr->lock);
> +	tr->open_count--;
> +	if (!tr->open_count) {
> +		free_irq(tr->rds_irq, tr);
> +
> +		tr->wr_index = 0;
> +		tr->rd_index = 0;
> +
> +		/* cancel read processes */
> +		wake_up_interruptible(&tr->read_queue);
> +	}
> +	mutex_unlock(&tr->lock);
> +
> +	return 0;
> +}
> +
> +
> +static const struct v4l2_file_operations timbradio_fops = {
> +	.owner		= THIS_MODULE,
> +	.ioctl		= video_ioctl2,
> +	.read		= timbradio_rds_fops_read,
> +	.poll		= timbradio_rds_fops_poll,
> +	.open		= timbradio_rds_fops_open,
> +	.release	= timbradio_rds_fops_release,
> +};
> +
> +static const struct video_device timbradio_template = {
> +	.name		= "Timberdale Radio",
> +	.fops		= &timbradio_fops,
> +	.ioctl_ops 	= &timbradio_ioctl_ops,
> +	.release	= video_device_release_empty,
> +	.minor		= -1
> +};
> +
> +
> +
> +static int timbradio_probe(struct platform_device *pdev)
> +{
> +	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
> +	struct timbradio *tr;
> +	struct resource *iomem;
> +	int irq;
> +	int err;
> +
> +	if (!pdata) {
> +		printk(KERN_ERR DRIVER_NAME": Platform data missing\n");
> +		err = -EINVAL;
> +		goto err;
> +	}
> +
> +	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!iomem) {
> +		err = -ENODEV;
> +		goto err;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		err = -ENODEV;
> +		goto err;
> +	}
> +
> +	if (!request_mem_region(iomem->start, resource_size(iomem),
> +		DRIVER_NAME)) {
> +		err = -EBUSY;
> +		goto err;
> +	}
> +
> +	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
> +	if (!tr) {
> +		err = -ENOMEM;
> +		goto err_alloc;
> +	}
> +	mutex_init(&tr->lock);
> +
> +	tr->membase = ioremap(iomem->start, resource_size(iomem));
> +	if (!tr->membase) {
> +		err = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +	memcpy(&tr->pdata, pdata, sizeof(tr->pdata));
> +
> +	tr->video_dev = video_device_alloc();
> +	if (!tr->video_dev) {
> +		err = -ENOMEM;
> +		goto err_video_req;
> +	}
> +	*tr->video_dev = timbradio_template;
> +	tr->rds_irq = irq;
> +	init_waitqueue_head(&tr->read_queue);
> +
> +	err = video_register_device(tr->video_dev, VFL_TYPE_RADIO, -1);
> +	if (err) {
> +		printk(KERN_ALERT DRIVER_NAME": Error reg video\n");
> +		goto err_video_req;
> +	}
> +
> +	video_set_drvdata(tr->video_dev, tr);
> +
> +	platform_set_drvdata(pdev, tr);
> +	return 0;
> +
> +err_video_req:
> +	if (tr->video_dev->minor != -1)
> +		video_unregister_device(tr->video_dev);
> +	else
> +		video_device_release(tr->video_dev);
> +	iounmap(tr->membase);
> +err_ioremap:
> +	kfree(tr);
> +err_alloc:
> +	release_mem_region(iomem->start, resource_size(iomem));
> +err:
> +	printk(KERN_ERR DRIVER_NAME ": Failed to register: %d\n", err);
> +
> +	return err;
> +}
> +
> +static int timbradio_remove(struct platform_device *pdev)
> +{
> +	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	struct timbradio *tr = platform_get_drvdata(pdev);
> +
> +	if (tr->video_dev->minor != -1)
> +		video_unregister_device(tr->video_dev);
> +	else
> +		video_device_release(tr->video_dev);
> +
> +	if (tr->sd_tuner) {
> +		module_put(tr->tuner_owner);
> +		module_put(tr->dsp_owner);
> +	}
> +
> +	iounmap(tr->membase);
> +	release_mem_region(iomem->start, resource_size(iomem));
> +	kfree(tr);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver timbradio_platform_driver = {
> +	.driver = {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= timbradio_probe,
> +	.remove		= timbradio_remove,
> +};
> +
> +/*--------------------------------------------------------------------------*/
> +
> +static int __init timbradio_init(void)
> +{
> +	return platform_driver_register(&timbradio_platform_driver);
> +}
> +
> +static void __exit timbradio_exit(void)
> +{
> +	platform_driver_unregister(&timbradio_platform_driver);
> +}
> +
> +module_init(timbradio_init);
> +module_exit(timbradio_exit);
> +
> +MODULE_DESCRIPTION("Timberdale Radio driver");
> +MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:"DRIVER_NAME);
> diff --git a/include/media/timb_radio.h b/include/media/timb_radio.h
> new file mode 100644
> index 0000000..6bea1b9
> --- /dev/null
> +++ b/include/media/timb_radio.h
> @@ -0,0 +1,30 @@
> +/*
> + * timb_radio.h Platform struct for the Timberdale radio driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _TIMB_RADIO_
> +#define _TIMB_RADIO_
> +
> +#include <linux/i2c.h>
> +
> +struct timb_radio_platform_data {
> +	int i2c_adapter; /* I2C adapter where the tuner and dsp are attached */
> +	char tuner[32];
> +	char dsp[32];

Isn't const char * better for tuner and dsp?

Regards,

	Hans

> +};
> +
> +#endif
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
