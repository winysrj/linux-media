Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35337 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3DLW20 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 18:28:26 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so1484775ead.0
        for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 15:28:25 -0700 (PDT)
Message-ID: <51688A85.8080206@gmail.com>
Date: Sat, 13 Apr 2013 00:28:21 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Scott Jiang <scott.jiang.linux@gmail.com>
CC: linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH RFC] [media] blackfin: add video display driver
References: <1365810779-24335-1-git-send-email-scott.jiang.linux@gmail.com> <1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1365810779-24335-2-git-send-email-scott.jiang.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 04/13/2013 01:52 AM, Scott Jiang wrote:
> This is a bridge driver for blackfin diplay device.
> It can work with ppi or eppi interface. DV timings
> are supported.
>
> Signed-off-by: Scott Jiang<scott.jiang.linux@gmail.com>
> ---
>   drivers/media/platform/blackfin/Kconfig        |   15 +-
>   drivers/media/platform/blackfin/Makefile       |    1 +
>   drivers/media/platform/blackfin/bfin_display.c | 1151 ++++++++++++++++++++++++
>   include/media/blackfin/bfin_display.h          |   38 +
>   4 files changed, 1203 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/media/platform/blackfin/bfin_display.c
>   create mode 100644 include/media/blackfin/bfin_display.h
>
> diff --git a/drivers/media/platform/blackfin/Kconfig b/drivers/media/platform/blackfin/Kconfig
> index cc23997..8a8fd75 100644
> --- a/drivers/media/platform/blackfin/Kconfig
> +++ b/drivers/media/platform/blackfin/Kconfig
> @@ -9,7 +9,18 @@ config VIDEO_BLACKFIN_CAPTURE
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called bfin_capture.
>
> +config VIDEO_BLACKFIN_DISPLAY
> +	tristate "Blackfin Video Display Driver"
> +	depends on VIDEO_V4L2&&  BLACKFIN&&  I2C
> +	select VIDEOBUF2_DMA_CONTIG
> +	help
> +	  V4L2 bridge driver for Blackfin video display device.

Shouldn't it just be "V4L2 output driver", why are you calling it "bridge" ?

> +	  Choose PPI or EPPI as its interface.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called bfin_display.
> +
>   config VIDEO_BLACKFIN_PPI
>   	tristate
> -	depends on VIDEO_BLACKFIN_CAPTURE
> -	default VIDEO_BLACKFIN_CAPTURE
> +	depends on VIDEO_BLACKFIN_CAPTURE || VIDEO_BLACKFIN_DISPLAY
> +	default VIDEO_BLACKFIN_CAPTURE || VIDEO_BLACKFIN_DISPLAY
> diff --git a/drivers/media/platform/blackfin/Makefile b/drivers/media/platform/blackfin/Makefile
> index 30421bc..015c8f0 100644
> --- a/drivers/media/platform/blackfin/Makefile
> +++ b/drivers/media/platform/blackfin/Makefile
> @@ -1,2 +1,3 @@
>   obj-$(CONFIG_VIDEO_BLACKFIN_CAPTURE) += bfin_capture.o
> +obj-$(CONFIG_VIDEO_BLACKFIN_DISPLAY) += bfin_display.o
>   obj-$(CONFIG_VIDEO_BLACKFIN_PPI)     += ppi.o
> diff --git a/drivers/media/platform/blackfin/bfin_display.c b/drivers/media/platform/blackfin/bfin_display.c
> new file mode 100644
> index 0000000..d971d7b
> --- /dev/null
> +++ b/drivers/media/platform/blackfin/bfin_display.c
> @@ -0,0 +1,1151 @@
> +/*
> + * Analog Devices video display driver

Sounds a bit too generic.

> + *
> + * Copyright (c) 2011 Analog Devices Inc.

2011 - 2013 ?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include<linux/completion.h>
> +#include<linux/delay.h>
> +#include<linux/errno.h>
> +#include<linux/fs.h>
> +#include<linux/i2c.h>
> +#include<linux/init.h>
> +#include<linux/interrupt.h>
> +#include<linux/io.h>
> +#include<linux/mm.h>
> +#include<linux/module.h>
> +#include<linux/platform_device.h>
> +#include<linux/slab.h>
> +#include<linux/time.h>
> +#include<linux/types.h>
> +
> +#include<media/v4l2-chip-ident.h>
> +#include<media/v4l2-common.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-ioctl.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#include<asm/dma.h>
> +
> +#include<media/blackfin/bfin_display.h>
> +#include<media/blackfin/ppi.h>
> +
> +#define DISPLAY_DRV_NAME        "bfin_display"
> +#define DISP_MIN_NUM_BUF        2
> +
> +struct disp_format {
> +	char *desc;
> +	u32 pixelformat;
> +	enum v4l2_mbus_pixelcode mbus_code;
> +	int bpp; /* bits per pixel */
> +	int dlen; /* data length for ppi in bits */
> +};
> +
> +struct disp_buffer {
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +};
> +
> +struct disp_device {
> +	/* capture device instance */

Shouldn't it be "output device..." ?

> +	struct v4l2_device v4l2_dev;
> +	/* v4l2 control handler */
> +	struct v4l2_ctrl_handler ctrl_handler;

This handler seems to be unused, I couldn't find any code adding controls
to it. Any initialization of this handler is a dead code now. You probably
want to move that bits to a patch actually adding any controls.

> +	/* device node data */
> +	struct video_device *video_dev;
> +	/* sub device instance */
> +	struct v4l2_subdev *sd;
> +	/* capture config */
> +	struct bfin_display_config *cfg;
> +	/* ppi interface */
> +	struct ppi_if *ppi;
> +	/* current output */
> +	unsigned int cur_output;
> +	/* current selected standard */
> +	v4l2_std_id std;
> +	/* current selected dv_timings */
> +	struct v4l2_dv_timings dv_timings;
> +	/* used to store pixel format */
> +	struct v4l2_pix_format fmt;
> +	/* bits per pixel*/
> +	int bpp;
> +	/* data length for ppi in bits */
> +	int dlen;
> +	/* used to store encoder supported format */
> +	struct disp_format *enc_formats;
> +	/* number of encoder formats array */
> +	int num_enc_formats;
> +	/* pointing to current video buffer */
> +	struct disp_buffer *cur_frm;
> +	/* buffer queue used in videobuf2 */
> +	struct vb2_queue buffer_queue;
> +	/* allocator-specific contexts for each plane */
> +	struct vb2_alloc_ctx *alloc_ctx;
> +	/* queue of filled frames */
> +	struct list_head dma_queue;
> +	/* used in videobuf2 callback */
> +	spinlock_t lock;
> +	/* used to access display device */
> +	struct mutex mutex;
> +};
> +
> +struct disp_fh {
> +	struct v4l2_fh fh;
> +	/* indicates whether this file handle is doing IO */
> +	bool io_allowed;
> +};

This structure should not be needed when you use the vb2 helpers. Please 
see
below for more details.

> +static const struct disp_format disp_formats[] = {
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved UYVY 8bits",
> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.mbus_code   = V4L2_MBUS_FMT_UYVY8_2X8,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved YUYV 8bits",
> +		.pixelformat = V4L2_PIX_FMT_YUYV,
> +		.mbus_code   = V4L2_MBUS_FMT_YUYV8_2X8,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +	{
> +		.desc        = "YCbCr 4:2:2 Interleaved UYVY 16bits",
> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.mbus_code   = V4L2_MBUS_FMT_UYVY8_1X16,
> +		.bpp         = 16,
> +		.dlen        = 16,
> +	},
> +	{
> +		.desc        = "RGB 565",
> +		.pixelformat = V4L2_PIX_FMT_RGB565,
> +		.mbus_code   = V4L2_MBUS_FMT_RGB565_2X8_LE,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +	{
> +		.desc        = "RGB 444",
> +		.pixelformat = V4L2_PIX_FMT_RGB444,
> +		.mbus_code   = V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
> +		.bpp         = 16,
> +		.dlen        = 8,
> +	},
> +
> +};
> +#define DISP_MAX_FMTS ARRAY_SIZE(disp_formats)
> +
> +static irqreturn_t disp_isr(int irq, void *dev_id);

Couldn't the functions be reordered so this declaration can be avoided ?

> +static int disp_open(struct file *file)
> +{
> +	struct disp_device *disp = video_drvdata(file);
> +	struct video_device *vfd = disp->video_dev;
> +	struct disp_fh *disp_fh;
> +
> +	if (!disp->sd) {
> +		v4l2_err(&disp->v4l2_dev, "No sub device registered\n");
> +		return -ENODEV;
> +	}
> +
> +	disp_fh = kzalloc(sizeof(*disp_fh), GFP_KERNEL);
> +	if (!disp_fh) {
> +		v4l2_err(&disp->v4l2_dev,
> +			 "unable to allocate memory for file handle object\n");

k*alloc functions already log any errors, you could just return -ENOMEM,
without printing anything. There is similar occurrence in disp_probe.

Also it might be a good idea to make your function and data structure names
more specific to this device, e.g. s/disp_*/bfin_disp_*.

> +		return -ENOMEM;
> +	}
> +
> +	v4l2_fh_init(&disp_fh->fh, vfd);
> +
> +	/* store pointer to v4l2_fh in private_data member of file */
> +	file->private_data =&disp_fh->fh;
> +	v4l2_fh_add(&disp_fh->fh);
> +	disp_fh->io_allowed = false;
> +	return 0;
> +}

> +static int disp_reqbufs(struct file *file, void *priv,
> +			struct v4l2_requestbuffers *req_buf)
> +{
> +	struct disp_device *disp = video_drvdata(file);
> +	struct vb2_queue *vq =&disp->buffer_queue;
> +	struct v4l2_fh *fh = file->private_data;
> +	struct disp_fh *disp_fh = container_of(fh, struct disp_fh, fh);
> +
> +	if (vb2_is_busy(vq))
> +		return -EBUSY;
> +
> +	disp_fh->io_allowed = true;
> +
> +	return vb2_reqbufs(vq, req_buf);
> +}
> +
> +static int disp_querybuf(struct file *file, void *priv,
> +				struct v4l2_buffer *buf)
> +{
> +	struct disp_device *disp = video_drvdata(file);
> +
> +	return vb2_querybuf(&disp->buffer_queue, buf);
> +}
> +
> +static int disp_qbuf(struct file *file, void *priv,
> +			struct v4l2_buffer *buf)
> +{
> +	struct disp_device *disp = video_drvdata(file);
> +	struct v4l2_fh *fh = file->private_data;
> +	struct disp_fh *disp_fh = container_of(fh, struct disp_fh, fh);
> +
> +	if (!disp_fh->io_allowed)
> +		return -EBUSY;
> +
> +	return vb2_qbuf(&disp->buffer_queue, buf);
> +}
> +
> +static int disp_dqbuf(struct file *file, void *priv,
> +			struct v4l2_buffer *buf)
> +{
> +	struct disp_device *disp = video_drvdata(file);
> +	struct v4l2_fh *fh = file->private_data;
> +	struct disp_fh *disp_fh = container_of(fh, struct disp_fh, fh);
> +
> +	if (!disp_fh->io_allowed)
> +		return -EBUSY;
> +
> +	return vb2_dqbuf(&disp->buffer_queue,
> +				buf, file->f_flags&  O_NONBLOCK);
> +}

I would suggest you have a look at the videobuf2 ioctl/fop helpers. Lots of
boilerplate code can be removed when you use them. For an example see:

http://git.linuxtv.org/snawrocki/samsung.git/commitdiff/38b7d67224965bf09eaa3ce147bbebc7fa089411

> +static int disp_probe(struct platform_device *pdev)
> +{
> +	struct disp_device *disp;
> +	struct video_device *vfd;
> +	struct i2c_adapter *i2c_adap;
> +	struct bfin_display_config *config;
> +	struct vb2_queue *q;
> +	struct disp_route *route;
> +	int ret;
> +
> +	config = pdev->dev.platform_data;
> +	if (!config) {
> +		v4l2_err(pdev->dev.driver, "Unable to get board config\n");
> +		return -ENODEV;
> +	}
> +
> +	disp = kzalloc(sizeof(*disp), GFP_KERNEL);
> +	if (!disp) {
> +		v4l2_err(pdev->dev.driver, "Unable to alloc disp\n");
> +		return -ENOMEM;
> +	}
> +
> +	disp->cfg = config;
> +
> +	disp->ppi = ppi_create_instance(config->ppi_info);
> +	if (!disp->ppi) {
> +		v4l2_err(pdev->dev.driver, "Unable to create ppi\n");
> +		ret = -ENODEV;
> +		goto err_free_dev;
> +	}
> +	disp->ppi->priv = disp;
> +
> +	disp->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(disp->alloc_ctx)) {
> +		ret = PTR_ERR(disp->alloc_ctx);
> +		goto err_free_ppi;
> +	}
> +
> +	vfd = video_device_alloc();

Instead of this allocation you could embed struct video_device instance
in struct disp_device...

> +	if (!vfd) {
> +		ret = -ENOMEM;
> +		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
> +		goto err_cleanup_ctx;
> +	}
> +
> +	/* initialize field of video device */
> +	vfd->release    = video_device_release;

..and make this
	vfd->release    = video_device_release_empty;

> +	vfd->fops       =&disp_fops;
> +	vfd->ioctl_ops  =&disp_ioctl_ops;
> +	vfd->tvnorms    = 0;
> +	vfd->v4l2_dev   =&disp->v4l2_dev;
> +	vfd->vfl_dir    = VFL_DIR_TX;
> +	set_bit(V4L2_FL_USE_FH_PRIO,&vfd->flags);
> +	strncpy(vfd->name, DISPLAY_DRV_NAME, sizeof(vfd->name));
> +	disp->video_dev = vfd;
> +
> +	ret = v4l2_device_register(&pdev->dev,&disp->v4l2_dev);
> +	if (ret) {
> +		v4l2_err(pdev->dev.driver,
> +				"Unable to register v4l2 device\n");
> +		goto err_release_vdev;
> +	}
> +	v4l2_info(&disp->v4l2_dev, "v4l2 device registered\n");
> +
> +	disp->v4l2_dev.ctrl_handler =&disp->ctrl_handler;
> +	ret = v4l2_ctrl_handler_init(&disp->ctrl_handler, 0);
> +	if (ret) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to init control handler\n");
> +		goto err_unreg_v4l2;
> +	}
> +
> +	spin_lock_init(&disp->lock);
> +	/* initialize queue */
> +	q =&disp->buffer_queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	q->io_modes = VB2_MMAP;
> +	q->drv_priv = disp;
> +	q->buf_struct_size = sizeof(struct disp_buffer);
> +	q->ops =&disp_video_qops;
> +	q->mem_ops =&vb2_dma_contig_memops;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to init videobuf2 queue\n");
> +		goto err_free_handler;
> +	}
> +
> +	mutex_init(&disp->mutex);
> +
> +	/* init video dma queues */
> +	INIT_LIST_HEAD(&disp->dma_queue);
> +
> +	vfd->lock =&disp->mutex;
> +
> +	/* register video device */
> +	ret = video_register_device(disp->video_dev, VFL_TYPE_GRABBER, -1);

The video device should be registered as a last step, only when all
resources it uses are already initialized.

> +	if (ret) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to register video device\n");
> +		goto err_free_handler;
> +	}
> +	video_set_drvdata(disp->video_dev, disp);
> +	v4l2_info(&disp->v4l2_dev, "video device registered as: %s\n",
> +			video_device_node_name(vfd));
> +
> +	/* load up the subdevice */
> +	i2c_adap = i2c_get_adapter(config->i2c_adapter_id);
> +	if (!i2c_adap) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to find i2c adapter\n");
> +		goto err_unreg_vdev;
> +
> +	}
> +	disp->sd = v4l2_i2c_new_subdev_board(&disp->v4l2_dev,
> +						 i2c_adap,
> +						&config->board_info,
> +						 NULL);

nit: I bit strange indentation, you could probably just fit it in 2 lines.

> +	if (disp->sd) {
> +		int i;
> +		if (!config->num_outputs) {
> +			v4l2_err(&disp->v4l2_dev,
> +					"Unable to work without output\n");
> +			goto err_unreg_vdev;
> +		}
> +
> +		/* update tvnorms from the sub devices */
> +		for (i = 0; i<  config->num_outputs; i++)
> +			vfd->tvnorms |= config->outputs[i].std;
> +	} else {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to register sub device\n");
> +		goto err_unreg_vdev;
> +	}
> +
> +	v4l2_info(&disp->v4l2_dev, "v4l2 sub device registered\n");
> +
> +	/*
> +	 * explicitly set output, otherwise some boards
> +	 * may not work at the state as we expected
> +	 */
> +	route =&config->routes[0];
> +	ret = v4l2_subdev_call(disp->sd, video, s_routing,
> +				route->output, route->output, 0);
> +	if ((ret<  0)&&  (ret != -ENOIOCTLCMD)) {
> +		v4l2_err(&disp->v4l2_dev, "Failed to set output\n");
> +		goto err_unreg_vdev;
> +	}
> +	disp->cur_output = 0;
> +	/* if this route has specific config, update ppi control */
> +	if (route->ppi_control)
> +		config->ppi_control = route->ppi_control;
> +
> +	/* now we can probe the default state */
> +	if (config->outputs[0].capabilities&  V4L2_IN_CAP_STD) {
> +		v4l2_std_id std;
> +		ret = v4l2_subdev_call(disp->sd, core, g_std,&std);
> +		if (ret) {
> +			v4l2_err(&disp->v4l2_dev,
> +					"Unable to get std\n");
> +			goto err_unreg_vdev;
> +		}
> +		disp->std = std;
> +	}
> +	if (config->outputs[0].capabilities&  V4L2_IN_CAP_CUSTOM_TIMINGS) {
> +		struct v4l2_dv_timings dv_timings;
> +		ret = v4l2_subdev_call(disp->sd, video,
> +				g_dv_timings,&dv_timings);
> +		if (ret) {
> +			v4l2_err(&disp->v4l2_dev,
> +					"Unable to get dv timings\n");
> +			goto err_unreg_vdev;
> +		}
> +		disp->dv_timings = dv_timings;
> +	}
> +	ret = disp_init_encoder_formats(disp);
> +	if (ret) {
> +		v4l2_err(&disp->v4l2_dev,
> +				"Unable to create encoder formats table\n");
> +		goto err_unreg_vdev;
> +	}
> +	return 0;
> +err_unreg_vdev:
> +	video_unregister_device(disp->video_dev);
> +	disp->video_dev = NULL;
> +err_free_handler:
> +	v4l2_ctrl_handler_free(&disp->ctrl_handler);
> +err_unreg_v4l2:
> +	v4l2_device_unregister(&disp->v4l2_dev);
> +err_release_vdev:
> +	if (disp->video_dev)
> +		video_device_release(disp->video_dev);
> +err_cleanup_ctx:
> +	vb2_dma_contig_cleanup_ctx(disp->alloc_ctx);
> +err_free_ppi:
> +	ppi_delete_instance(disp->ppi);
> +err_free_dev:
> +	kfree(disp);
> +	return ret;
> +}


Regards,
Sylwester
