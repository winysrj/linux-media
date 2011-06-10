Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4158 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1FJIkL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:40:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/3] s5p-tv: add drivers for TV on Samsung S5P platform
Date: Fri, 10 Jun 2011 10:39:52 +0200
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com> <201106091219.26272.hansverk@cisco.com> <4DF0F267.4010001@samsung.com>
In-Reply-To: <4DF0F267.4010001@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101039.52431.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, June 09, 2011 18:18:47 Tomasz Stanislawski wrote:
> Hans Verkuil wrote:
> > On Wednesday, June 08, 2011 14:03:31 Tomasz Stanislawski wrote:
> >
> > And now the mixer review...
> >   
> I'll separate patches. What is the proposed order of drivers?

HDMI+HDMIPHY, SDO, MIXER. That's easiest to review.

> >   
> >> Add drivers for TV outputs on Samsung platforms from S5P family.
> >> - HDMIPHY - auxiliary I2C driver need by TV driver
> >> - HDMI    - generation and control of streaming by HDMI output
> >> - SDO     - streaming analog TV by Composite connector
> >> - MIXER   - merging images from three layers and passing result to the output
> >>
> >> Interface:
> >> - 3 video nodes with output queues
> >> - support for multi plane API
> >> - each nodes has up to 2 outputs (HDMI and SDO)
> >> - outputs are controlled by S_STD and S_DV_PRESET ioctls
> >>
> >> Drivers are using:
> >> - v4l2 framework
> >> - videobuf2
> >> - videobuf2-dma-contig as memory allocator
> >> - runtime PM
> >>
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> ---
> >> diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
> >> new file mode 100644
> >> index 0000000..6176b0a
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer.h
> >> @@ -0,0 +1,368 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#ifndef SAMSUNG_MIXER_H
> >> +#define SAMSUNG_MIXER_H
> >> +
> >> +#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 7
> >> +	#define DEBUG
> >> +#endif
> >> +
> >> +#include <linux/fb.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/spinlock.h>
> >> +#include <linux/wait.h>
> >> +#include <media/v4l2-device.h>
> >> +#include <media/videobuf2-core.h>
> >> +
> >> +#include "regs-mixer.h"
> >> +
> >> +/** maximum number of output interfaces */
> >> +#define MXR_MAX_OUTPUTS 2
> >> +/** maximum number of input interfaces (layers) */
> >> +#define MXR_MAX_LAYERS 3
> >> +#define MXR_DRIVER_NAME "s5p-mixer"
> >> +/** maximal number of planes for every layer */
> >> +#define MXR_MAX_PLANES	2
> >> +
> >> +#define MXR_ENABLE 1
> >> +#define MXR_DISABLE 0
> >> +
> >> +/** description of a macroblock for packed formats */
> >> +struct mxr_block {
> >> +	/** vertical number of pixels in macroblock */
> >> +	unsigned int width;
> >> +	/** horizontal number of pixels in macroblock */
> >> +	unsigned int height;
> >> +	/** size of block in bytes */
> >> +	unsigned int size;
> >> +};
> >> +
> >> +/** description of supported format */
> >> +struct mxr_format {
> >> +	/** format name/mnemonic */
> >> +	char *name;
> >>     
> >
> > const?
> >
> >   
> >> +	/** fourcc identifier */
> >> +	u32 fourcc;
> >> +	/** number of planes in image data */
> >> +	int num_planes;
> >> +	/** description of block for each plane */
> >> +	struct mxr_block plane[MXR_MAX_PLANES];
> >> +	/** number of subframes in image data */
> >> +	int num_subframes;
> >> +	/** specifies to which subframe belong given plane */
> >> +	int plane2subframe[MXR_MAX_PLANES];
> >> +	/** internal code, driver dependant */
> >> +	unsigned long cookie;
> >> +};
> >> +
> >> +/** description of crop configuration for image */
> >> +struct mxr_crop {
> >> +	/** width of layer in pixels */
> >> +	unsigned int full_width;
> >> +	/** height of layer in pixels */
> >> +	unsigned int full_height;
> >> +	/** horizontal offset of first pixel to be displayed */
> >> +	unsigned int x_offset;
> >> +	/** vertical offset of first pixel to be displayed */
> >> +	unsigned int y_offset;
> >> +	/** width of displayed data in pixels */
> >> +	unsigned int width;
> >> +	/** height of displayed data in pixels */
> >> +	unsigned int height;
> >> +	/** indicate which fields are present in buffer */
> >> +	unsigned int field;
> >> +};
> >> +
> >> +/** description of transformation from source to destination image */
> >> +struct mxr_geometry {
> >> +	/** cropping for source image */
> >> +	struct mxr_crop src;
> >> +	/** cropping for destination image */
> >> +	struct mxr_crop dst;
> >> +	/** layer-dependant description of horizontal scaling */
> >> +	unsigned int x_ratio;
> >> +	/** layer-dependant description of vertical scaling */
> >> +	unsigned int y_ratio;
> >> +};
> >> +
> >> +/** instance of a buffer */
> >> +struct mxr_buffer {
> >> +	/** common v4l buffer stuff -- must be first */
> >> +	struct vb2_buffer	vb;
> >> +	/** node for layer's lists */
> >> +	struct list_head	list;
> >> +};
> >> +
> >> +
> >> +/** internal states of layer */
> >> +enum mxr_layer_state {
> >> +	/** layers is not shown */
> >> +	MXR_LAYER_IDLE = 0,
> >> +	/** state between STREAMON and hardware start */
> >> +	MXR_LAYER_STREAMING_START,
> >> +	/** layer is shown */
> >> +	MXR_LAYER_STREAMING,
> >> +	/** state before STREAMOFF is finished */
> >> +	MXR_LAYER_STREAMING_FINISH,
> >> +};
> >> +
> >> +/** forward declarations */
> >> +struct mxr_device;
> >> +struct mxr_layer;
> >> +
> >> +/** callback for layers operation */
> >> +struct mxr_layer_ops {
> >> +	/* TODO: try to port it to subdev API */
> >> +	/** handler for resource release function */
> >> +	void (*release)(struct mxr_layer *);
> >> +	/** setting buffer to HW */
> >> +	void (*buffer_set)(struct mxr_layer *, struct mxr_buffer *);
> >> +	/** setting format and geometry in HW */
> >> +	void (*format_set)(struct mxr_layer *);
> >> +	/** streaming stop/start */
> >> +	void (*stream_set)(struct mxr_layer *, int);
> >> +	/** adjusting geometry */
> >> +	void (*fix_geometry)(struct mxr_layer *);
> >> +};
> >> +
> >> +/** layer instance, a single window and content displayed on output */
> >> +struct mxr_layer {
> >> +	/** parent mixer device */
> >> +	struct mxr_device *mdev;
> >> +	/** layer index (unique identifier) */
> >> +	int idx;
> >> +	/** callbacks for layer methods */
> >> +	struct mxr_layer_ops ops;
> >> +	/** format array */
> >> +	const struct mxr_format **fmt_array;
> >> +	/** size of format array */
> >> +	unsigned long fmt_array_size;
> >> +
> >> +	/** lock for protection of list and state fields */
> >> +	spinlock_t enq_slock;
> >> +	/** list for enqueued buffers */
> >> +	struct list_head enq_list;
> >> +	/** buffer currently owned by hardware in temporary registers */
> >> +	struct mxr_buffer *update_buf;
> >> +	/** buffer currently owned by hardware in shadow registers */
> >> +	struct mxr_buffer *shadow_buf;
> >> +	/** state of layer IDLE/STREAMING */
> >> +	enum mxr_layer_state state;
> >> +
> >> +	/** mutex for protection of fields below */
> >> +	struct mutex mutex;
> >> +	/** use count */
> >> +	int n_user;
> >> +	/** handler for video node */
> >> +	struct video_device vfd;
> >> +	/** queue for output buffers */
> >> +	struct vb2_queue vb_queue;
> >> +	/** current image format */
> >> +	const struct mxr_format *fmt;
> >> +	/** current geometry of image */
> >> +	struct mxr_geometry geo;
> >> +};
> >> +
> >> +/** description of mixers output interface */
> >> +struct mxr_output {
> >> +	/** name of output */
> >> +	char name[32];
> >> +	/** output subdev */
> >> +	struct v4l2_subdev *sd;
> >> +	/** cookie used for configuration of registers */
> >> +	int cookie;
> >> +};
> >> +
> >> +/** specify source of output subdevs */
> >> +struct mxr_output_conf {
> >> +	/** name of output (connector) */
> >> +	char *output_name;
> >> +	/** name of module that generates output subdev */
> >> +	char *module_name;
> >> +	/** cookie need for mixer HW */
> >> +	int cookie;
> >> +};
> >> +
> >> +struct clk;
> >> +struct regulator;
> >> +
> >> +/** auxiliary resources used my mixer */
> >> +struct mxr_resources {
> >> +	/** interrupt index */
> >> +	int irq;
> >> +	/** pointer to Mixer registers */
> >> +	void __iomem *mxr_regs;
> >> +	/** pointer to Video Processor registers */
> >> +	void __iomem *vp_regs;
> >> +	/** other resources, should used under mxr_device.mutex */
> >> +	struct clk *mixer;
> >> +	struct clk *vp;
> >> +	struct clk *sclk_mixer;
> >> +	struct clk *sclk_hdmi;
> >> +	struct clk *sclk_dac;
> >> +};
> >> +
> >> +/* event flags used  */
> >> +enum mxr_devide_flags {
> >> +	MXR_EVENT_VSYNC = 0,
> >> +};
> >> +
> >> +/** drivers instance */
> >> +struct mxr_device {
> >> +	/** master device */
> >> +	struct device *dev;
> >> +	/** state of each layer */
> >> +	struct mxr_layer *layer[MXR_MAX_LAYERS];
> >> +	/** state of each output */
> >> +	struct mxr_output *output[MXR_MAX_OUTPUTS];
> >> +	/** number of registered outputs */
> >> +	int output_cnt;
> >> +
> >> +	/* video resources */
> >> +
> >> +	/** V4L2 device */
> >> +	struct v4l2_device v4l2_dev;
> >> +	/** context of allocator */
> >> +	void *alloc_ctx;
> >> +	/** event wait queue */
> >> +	wait_queue_head_t event_queue;
> >> +	/** state flags */
> >> +	unsigned long event_flags;
> >> +
> >> +	/** spinlock for protection of registers */
> >> +	spinlock_t reg_slock;
> >> +
> >> +	/** mutex for protection of fields below */
> >> +	struct mutex mutex;
> >> +	/** number of entities depndant on output configuration */
> >> +	int n_output;
> >> +	/** number of users that do streaming */
> >> +	int n_streamer;
> >> +	/** index of current output */
> >> +	int current_output;
> >> +	/** auxiliary resources used my mixer */
> >> +	struct mxr_resources res;
> >> +};
> >> +
> >> +/** transform device structure into mixer device */
> >> +static inline struct mxr_device *to_mdev(struct device *dev)
> >> +{
> >> +	struct v4l2_device *vdev = dev_get_drvdata(dev);
> >> +	return container_of(vdev, struct mxr_device, v4l2_dev);
> >> +}
> >> +
> >> +/** get current output data, should be called under mdev's mutex */
> >> +static inline struct mxr_output *to_output(struct mxr_device *mdev)
> >> +{
> >> +	return mdev->output[mdev->current_output];
> >> +}
> >> +
> >> +/** get current output subdev, should be called under mdev's mutex */
> >> +static inline struct v4l2_subdev *to_outsd(struct mxr_device *mdev)
> >> +{
> >> +	struct mxr_output *out = to_output(mdev);
> >> +	return out ? out->sd : NULL;
> >> +}
> >> +
> >> +/** forward declaration for mixer platform data */
> >> +struct mxr_platform_data;
> >> +
> >> +/** acquiring common video resources */
> >> +int __devinit mxr_acquire_video(struct mxr_device *mdev,
> >> +	struct mxr_output_conf *output_cont, int output_count);
> >> +
> >> +/** releasing common video resources */
> >> +void __devexit mxr_release_video(struct mxr_device *mdev);
> >> +
> >> +struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx);
> >> +struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx);
> >> +struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
> >> +	int idx, char *name, struct mxr_layer_ops *ops);
> >> +
> >> +void mxr_base_layer_release(struct mxr_layer *layer);
> >> +void mxr_layer_release(struct mxr_layer *layer);
> >> +
> >> +int mxr_base_layer_register(struct mxr_layer *layer);
> >> +void mxr_base_layer_unregister(struct mxr_layer *layer);
> >> +
> >> +unsigned long mxr_get_plane_size(const struct mxr_block *blk,
> >> +	unsigned int width, unsigned int height);
> >> +
> >> +/** adds new consumer for mixer's power */
> >> +int __must_check mxr_power_get(struct mxr_device *mdev);
> >> +/** removes consumer for mixer's power */
> >> +void mxr_power_put(struct mxr_device *mdev);
> >> +/** add new client for output configuration */
> >> +void mxr_output_get(struct mxr_device *mdev);
> >> +/** removes new client for output configuration */
> >> +void mxr_output_put(struct mxr_device *mdev);
> >> +/** add new client for streaming */
> >> +void mxr_streamer_get(struct mxr_device *mdev);
> >> +/** removes new client for streaming */
> >> +void mxr_streamer_put(struct mxr_device *mdev);
> >> +/** returns format of data delivared to current output */
> >> +void mxr_get_mbus_fmt(struct mxr_device *mdev,
> >> +	struct v4l2_mbus_framefmt *mbus_fmt);
> >> +
> >> +/* Debug */
> >> +
> >> +#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 3
> >> +	#define mxr_err(mdev, fmt, ...)  dev_err(mdev->dev, fmt, ##__VA_ARGS__)
> >> +#else
> >> +	#define mxr_err(mdev, fmt, ...)  do { (void) mdev; } while (0)
> >> +#endif
> >> +
> >> +#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 4
> >> +	#define mxr_warn(mdev, fmt, ...) dev_warn(mdev->dev, fmt, ##__VA_ARGS__)
> >> +#else
> >> +	#define mxr_warn(mdev, fmt, ...)  do { (void) mdev; } while (0)
> >> +#endif
> >> +
> >> +#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 6
> >> +	#define mxr_info(mdev, fmt, ...) dev_info(mdev->dev, fmt, ##__VA_ARGS__)
> >> +#else
> >> +	#define mxr_info(mdev, fmt, ...)  do {(void) mdev; } while (0)
> >> +#endif
> >> +
> >> +#if CONFIG_VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL >= 7
> >> +	#define mxr_dbg(mdev, fmt, ...)  dev_dbg(mdev->dev, fmt, ##__VA_ARGS__)
> >> +#else
> >> +	#define mxr_dbg(mdev, fmt, ...)  do { (void) mdev; } while (0)
> >> +#endif
> >> +
> >> +/* accessing Mixer's and Video Processor's registers */
> >> +
> >> +void mxr_vsync_set_update(struct mxr_device *mdev, int en);
> >> +void mxr_reg_reset(struct mxr_device *mdev);
> >> +irqreturn_t mxr_irq_handler(int irq, void *dev_data);
> >> +void mxr_reg_s_output(struct mxr_device *mdev, int cookie);
> >> +void mxr_reg_streamon(struct mxr_device *mdev);
> >> +void mxr_reg_streamoff(struct mxr_device *mdev);
> >> +int mxr_reg_wait4vsync(struct mxr_device *mdev);
> >> +void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
> >> +	struct v4l2_mbus_framefmt *fmt);
> >> +void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en);
> >> +void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr);
> >> +void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
> >> +	const struct mxr_format *fmt, const struct mxr_geometry *geo);
> >> +
> >> +void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en);
> >> +void mxr_reg_vp_buffer(struct mxr_device *mdev,
> >> +	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2]);
> >> +void mxr_reg_vp_format(struct mxr_device *mdev,
> >> +	const struct mxr_format *fmt, const struct mxr_geometry *geo);
> >> +void mxr_reg_dump(struct mxr_device *mdev);
> >> +
> >> +#endif /* SAMSUNG_MIXER_H */
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
> >> new file mode 100644
> >> index 0000000..5dca57b
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer_drv.c
> >> @@ -0,0 +1,494 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "mixer.h"
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/io.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/fb.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/pm_runtime.h>
> >> +#include <linux/clk.h>
> >> +
> >> +MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> >> +MODULE_DESCRIPTION("Samsung MIXER");
> >> +MODULE_LICENSE("GPL");
> >> +
> >> +/* --------- DRIVER PARAMETERS ---------- */
> >> +
> >> +static struct mxr_output_conf mxr_output_conf[] = {
> >> +	{
> >> +		.output_name = "S5P HDMI connector",
> >> +		.module_name = "s5p-hdmi",
> >> +		.cookie = 1,
> >> +	},
> >> +	{
> >> +		.output_name = "S5P SDO connector",
> >> +		.module_name = "s5p-sdo",
> >> +		.cookie = 0,
> >> +	},
> >> +};
> >> +
> >> +/* --------- DRIVER INITIALIZATION ---------- */
> >> +
> >> +static struct platform_driver mxr_driver __refdata;
> >> +
> >> +static int __init mxr_init(void)
> >> +{
> >> +	int i, ret;
> >> +	static const char banner[] __initdata = KERN_INFO
> >> +		"Samsung TV Mixer driver, "
> >> +		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
> >> +	printk(banner);
> >> +
> >> +	/* Loading auxiliary modules */
> >> +	for (i = 0; i < ARRAY_SIZE(mxr_output_conf); ++i)
> >> +		request_module(mxr_output_conf[i].module_name);
> >> +
> >> +	ret = platform_driver_register(&mxr_driver);
> >> +	if (ret != 0) {
> >> +		printk(KERN_ERR "registration of MIXER driver failed\n");
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +module_init(mxr_init);
> >> +
> >> +static void __exit mxr_exit(void)
> >> +{
> >> +	platform_driver_unregister(&mxr_driver);
> >> +}
> >> +module_exit(mxr_exit);
> >> +
> >> +static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
> >> +	struct platform_device *pdev);
> >> +
> >> +static void mxr_release_resources(struct mxr_device *mdev);
> >> +
> >> +static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
> >> +	struct mxr_platform_data *pdata);
> >> +
> >> +static void mxr_release_layers(struct mxr_device *mxr_dev);
> >> +
> >> +static int __devinit mxr_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct mxr_platform_data *pdata = dev->platform_data;
> >> +	struct mxr_device *mdev;
> >> +	int ret;
> >> +
> >> +	/* mdev does not exist yet so no mxr_dbg is used */
> >> +	dev_info(dev, "probe start\n");
> >> +
> >> +	mdev = kzalloc(sizeof *mdev, GFP_KERNEL);
> >> +	if (!mdev) {
> >> +		mxr_err(mdev, "not enough memory.\n");
> >> +		ret = -ENOMEM;
> >> +		goto fail;
> >> +	}
> >> +
> >> +	/* setup pointer to master device */
> >> +	mdev->dev = dev;
> >> +
> >> +	mutex_init(&mdev->mutex);
> >> +	spin_lock_init(&mdev->reg_slock);
> >> +	init_waitqueue_head(&mdev->event_queue);
> >> +
> >> +	/* acquire resources: regs, irqs, clocks, regulators */
> >> +	ret = mxr_acquire_resources(mdev, pdev);
> >> +	if (ret)
> >> +		goto fail_mem;
> >> +
> >> +	/* configure resources for video output */
> >> +	ret = mxr_acquire_video(mdev, mxr_output_conf,
> >> +		ARRAY_SIZE(mxr_output_conf));
> >> +	if (ret)
> >> +		goto fail_resources;
> >> +
> >> +	/* configure layers */
> >> +	ret = mxr_acquire_layers(mdev, pdata);
> >> +	if (ret)
> >> +		goto fail_video;
> >> +
> >> +	pm_runtime_enable(dev);
> >> +
> >> +	mxr_info(mdev, "probe successful\n");
> >> +	return 0;
> >> +
> >> +fail_video:
> >> +	mxr_release_video(mdev);
> >> +
> >> +fail_resources:
> >> +	mxr_release_resources(mdev);
> >> +
> >> +fail_mem:
> >> +	kfree(mdev);
> >> +
> >> +fail:
> >> +	dev_info(dev, "probe failed\n");
> >> +	return ret;
> >> +}
> >> +
> >> +static int __devexit mxr_remove(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct mxr_device *mdev = to_mdev(dev);
> >> +
> >> +	pm_runtime_disable(dev);
> >> +
> >> +	mxr_release_layers(mdev);
> >> +	mxr_release_video(mdev);
> >> +	mxr_release_resources(mdev);
> >> +
> >> +	kfree(mdev);
> >> +
> >> +	dev_info(dev, "remove sucessful\n");
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_runtime_resume(struct device *dev)
> >> +{
> >> +	struct mxr_device *mdev = to_mdev(dev);
> >> +	struct mxr_resources *res = &mdev->res;
> >> +
> >> +	mxr_dbg(mdev, "resume - start\n");
> >> +	mutex_lock(&mdev->mutex);
> >> +	/* turn clocks on */
> >> +	clk_enable(res->mixer);
> >> +	clk_enable(res->vp);
> >> +	clk_enable(res->sclk_mixer);
> >> +	mxr_dbg(mdev, "resume - finished\n");
> >> +
> >> +	mutex_unlock(&mdev->mutex);
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_runtime_suspend(struct device *dev)
> >> +{
> >> +	struct mxr_device *mdev = to_mdev(dev);
> >> +	struct mxr_resources *res = &mdev->res;
> >> +	mxr_dbg(mdev, "suspend - start\n");
> >> +	mutex_lock(&mdev->mutex);
> >> +	/* turn clocks off */
> >> +	clk_disable(res->sclk_mixer);
> >> +	clk_disable(res->vp);
> >> +	clk_disable(res->mixer);
> >> +	mutex_unlock(&mdev->mutex);
> >> +	mxr_dbg(mdev, "suspend - finished\n");
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct dev_pm_ops mxr_pm_ops = {
> >> +	.runtime_suspend = mxr_runtime_suspend,
> >> +	.runtime_resume	 = mxr_runtime_resume,
> >> +};
> >> +
> >> +static struct platform_driver mxr_driver __refdata = {
> >> +	.probe = mxr_probe,
> >> +	.remove = __devexit_p(mxr_remove),
> >> +	.driver = {
> >> +		.name = MXR_DRIVER_NAME,
> >> +		.owner = THIS_MODULE,
> >> +		.pm = &mxr_pm_ops,
> >> +	}
> >> +};
> >> +
> >> +static int __devinit mxr_acquire_plat_resources(struct mxr_device *mdev,
> >> +	struct platform_device *pdev)
> >> +{
> >> +	struct resource *res;
> >> +	int ret;
> >> +
> >> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mxr");
> >> +	if (res == NULL) {
> >> +		mxr_err(mdev, "get memory resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail;
> >> +	}
> >> +
> >> +	mdev->res.mxr_regs = ioremap(res->start, resource_size(res));
> >> +	if (mdev->res.mxr_regs == NULL) {
> >> +		mxr_err(mdev, "register mapping failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail;
> >> +	}
> >> +
> >> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vp");
> >> +	if (res == NULL) {
> >> +		mxr_err(mdev, "get memory resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_mxr_regs;
> >> +	}
> >> +
> >> +	mdev->res.vp_regs = ioremap(res->start, resource_size(res));
> >> +	if (mdev->res.vp_regs == NULL) {
> >> +		mxr_err(mdev, "register mapping failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_mxr_regs;
> >> +	}
> >> +
> >> +	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "irq");
> >> +	if (res == NULL) {
> >> +		mxr_err(mdev, "get interrupt resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_vp_regs;
> >> +	}
> >> +
> >> +	ret = request_irq(res->start, mxr_irq_handler, 0, "s5p-mixer", mdev);
> >> +	if (ret) {
> >> +		mxr_err(mdev, "request interrupt failed.\n");
> >> +		goto fail_vp_regs;
> >> +	}
> >> +	mdev->res.irq = res->start;
> >> +
> >> +	return 0;
> >> +
> >> +fail_vp_regs:
> >> +	iounmap(mdev->res.vp_regs);
> >> +
> >> +fail_mxr_regs:
> >> +	iounmap(mdev->res.mxr_regs);
> >> +
> >> +fail:
> >> +	return ret;
> >> +}
> >> +
> >> +static void mxr_release_plat_resources(struct mxr_device *mdev)
> >> +{
> >> +	free_irq(mdev->res.irq, mdev);
> >> +	iounmap(mdev->res.vp_regs);
> >> +	iounmap(mdev->res.mxr_regs);
> >> +}
> >> +
> >> +static void mxr_release_clocks(struct mxr_device *mdev)
> >> +{
> >> +	struct mxr_resources *res = &mdev->res;
> >> +
> >> +	if (!IS_ERR_OR_NULL(res->sclk_dac))
> >> +		clk_put(res->sclk_dac);
> >> +	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
> >> +		clk_put(res->sclk_hdmi);
> >> +	if (!IS_ERR_OR_NULL(res->sclk_mixer))
> >> +		clk_put(res->sclk_mixer);
> >> +	if (!IS_ERR_OR_NULL(res->vp))
> >> +		clk_put(res->vp);
> >> +	if (!IS_ERR_OR_NULL(res->mixer))
> >> +		clk_put(res->mixer);
> >> +}
> >> +
> >> +static int mxr_acquire_clocks(struct mxr_device *mdev)
> >> +{
> >> +	struct mxr_resources *res = &mdev->res;
> >> +	struct device *dev = mdev->dev;
> >> +
> >> +	res->mixer = clk_get(dev, "mixer");
> >> +	if (IS_ERR_OR_NULL(res->mixer)) {
> >> +		mxr_err(mdev, "failed to get clock 'mixer'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->vp = clk_get(dev, "vp");
> >> +	if (IS_ERR_OR_NULL(res->vp)) {
> >> +		mxr_err(mdev, "failed to get clock 'vp'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_mixer = clk_get(dev, "sclk_mixer");
> >> +	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
> >> +		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
> >> +	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
> >> +		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_dac = clk_get(dev, "sclk_dac");
> >> +	if (IS_ERR_OR_NULL(res->sclk_dac)) {
> >> +		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
> >> +		goto fail;
> >> +	}
> >> +
> >> +	return 0;
> >> +fail:
> >> +	mxr_release_clocks(mdev);
> >> +	return -ENODEV;
> >> +}
> >> +
> >> +static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
> >> +	struct platform_device *pdev)
> >> +{
> >> +	int ret;
> >> +	ret = mxr_acquire_plat_resources(mdev, pdev);
> >> +
> >> +	if (ret)
> >> +		goto fail;
> >> +
> >> +	ret = mxr_acquire_clocks(mdev);
> >> +	if (ret)
> >> +		goto fail_plat;
> >> +
> >> +	mxr_info(mdev, "resources acquired\n");
> >> +	return 0;
> >> +
> >> +fail_plat:
> >> +	mxr_release_plat_resources(mdev);
> >> +fail:
> >> +	mxr_err(mdev, "resources acquire failed\n");
> >> +	return ret;
> >> +}
> >> +
> >> +static void mxr_release_resources(struct mxr_device *mdev)
> >> +{
> >> +	mxr_release_clocks(mdev);
> >> +	mxr_release_plat_resources(mdev);
> >> +	memset(&mdev->res, 0, sizeof mdev->res);
> >> +}
> >> +
> >> +static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
> >> +	struct mxr_platform_data *pdata)
> >> +{
> >> +	mdev->layer[0] = mxr_graph_layer_create(mdev, 0);
> >> +	mdev->layer[1] = mxr_graph_layer_create(mdev, 1);
> >> +	mdev->layer[2] = mxr_vp_layer_create(mdev, 0);
> >> +
> >> +	if (!mdev->layer[0] || !mdev->layer[1] || !mdev->layer[2]) {
> >> +		mxr_err(mdev, "failed to acquire layers\n");
> >> +		goto fail;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +fail:
> >> +	mxr_release_layers(mdev);
> >> +	return -ENODEV;
> >> +}
> >> +
> >> +static void mxr_release_layers(struct mxr_device *mdev)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(mdev->layer); ++i)
> >> +		if (mdev->layer[i])
> >> +			mxr_layer_release(mdev->layer[i]);
> >> +}
> >> +
> >> +int mxr_power_get(struct mxr_device *mdev)
> >> +{
> >> +	int ret = pm_runtime_get_sync(mdev->dev);
> >> +
> >> +	/* returning 1 means that power is already enabled,
> >> +	 * so zero success be returned */
> >> +	if (IS_ERR_VALUE(ret))
> >> +		return ret;
> >> +	return 0;
> >> +}
> >> +
> >> +void mxr_power_put(struct mxr_device *mdev)
> >> +{
> >> +	pm_runtime_put_sync(mdev->dev);
> >> +}
> >> +
> >> +void mxr_get_mbus_fmt(struct mxr_device *mdev,
> >> +	struct v4l2_mbus_framefmt *mbus_fmt)
> >> +{
> >> +	struct v4l2_subdev *sd;
> >> +	int ret;
> >> +
> >> +	mutex_lock(&mdev->mutex);
> >> +	sd = to_outsd(mdev);
> >> +	ret = v4l2_subdev_call(sd, video, g_mbus_fmt, mbus_fmt);
> >> +	WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
> >> +	mutex_unlock(&mdev->mutex);
> >> +}
> >> +
> >> +void mxr_streamer_get(struct mxr_device *mdev)
> >> +{
> >> +	mutex_lock(&mdev->mutex);
> >> +	++mdev->n_streamer;
> >> +	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> >> +	if (mdev->n_streamer == 1) {
> >> +		struct v4l2_subdev *sd = to_outsd(mdev);
> >> +		struct v4l2_mbus_framefmt mbus_fmt;
> >> +		struct mxr_resources *res = &mdev->res;
> >> +		int ret;
> >> +
> >> +		ret = v4l2_subdev_call(sd, video, g_mbus_fmt, &mbus_fmt);
> >> +		WARN(ret, "failed to get mbus_fmt for output %s\n", sd->name);
> >> +		ret = v4l2_subdev_call(sd, video, s_stream, 1);
> >> +		WARN(ret, "starting stream failed for output %s\n", sd->name);
> >> +		if (to_output(mdev)->cookie == 0)
> >> +			clk_set_parent(res->sclk_mixer, res->sclk_dac);
> >> +		else
> >> +			clk_set_parent(res->sclk_mixer, res->sclk_hdmi);
> >> +		/* apply default configuration */
> >> +		mxr_reg_reset(mdev);
> >> +		mxr_reg_set_mbus_fmt(mdev, &mbus_fmt);
> >> +		mxr_reg_s_output(mdev, to_output(mdev)->cookie);
> >> +		mxr_reg_streamon(mdev);
> >> +		ret = mxr_reg_wait4vsync(mdev);
> >> +		WARN(ret, "failed to get vsync (%d) from output\n", ret);
> >> +	}
> >> +	mutex_unlock(&mdev->mutex);
> >> +	mxr_reg_dump(mdev);
> >> +	/* FIXME: what to do when streaming fails? */
> >> +}
> >> +
> >> +void mxr_streamer_put(struct mxr_device *mdev)
> >> +{
> >> +	mutex_lock(&mdev->mutex);
> >> +	--mdev->n_streamer;
> >> +	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_streamer);
> >> +	if (mdev->n_streamer == 0) {
> >> +		int ret;
> >> +		struct v4l2_subdev *sd = to_outsd(mdev);
> >> +
> >> +		mxr_reg_streamoff(mdev);
> >> +		/* vsync applies Mixer setup */
> >> +		ret = mxr_reg_wait4vsync(mdev);
> >> +		WARN(ret, "failed to get vsync (%d) from output\n", ret);
> >> +		ret = v4l2_subdev_call(sd, video, s_stream, 0);
> >> +		WARN(ret, "stopping stream failed for output %s\n", sd->name);
> >> +	}
> >> +	WARN(mdev->n_streamer < 0, "negative number of streamers (%d)\n",
> >> +		mdev->n_streamer);
> >> +	mutex_unlock(&mdev->mutex);
> >> +	mxr_reg_dump(mdev);
> >> +}
> >> +
> >> +void mxr_output_get(struct mxr_device *mdev)
> >> +{
> >> +	mutex_lock(&mdev->mutex);
> >> +	++mdev->n_output;
> >> +	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
> >> +	/* turn on auxliary driver */
> >>     
> >
> > typo: auxiliary
> >
> >   
> >> +	if (mdev->n_output == 1)
> >> +		v4l2_subdev_call(to_outsd(mdev), core, s_power, 1);
> >> +	mutex_unlock(&mdev->mutex);
> >> +}
> >> +
> >> +void mxr_output_put(struct mxr_device *mdev)
> >> +{
> >> +	mutex_lock(&mdev->mutex);
> >> +	--mdev->n_output;
> >> +	mxr_dbg(mdev, "%s(%d)\n", __func__, mdev->n_output);
> >> +	/* turn on auxliary driver */
> >>     
> >
> > same typo.
> >
> >   
> >> +	if (mdev->n_output == 0)
> >> +		v4l2_subdev_call(to_outsd(mdev), core, s_power, 0);
> >> +	WARN(mdev->n_output < 0, "negative number of output users (%d)\n",
> >> +		mdev->n_output);
> >> +	mutex_unlock(&mdev->mutex);
> >> +}
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
> >> new file mode 100644
> >> index 0000000..8c14531
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
> >> @@ -0,0 +1,181 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "mixer.h"
> >> +
> >> +#include <media/videobuf2-dma-contig.h>
> >> +
> >> +/* FORMAT DEFINITIONS */
> >> +
> >> +static const struct mxr_format mxr_fb_fmt_rgb565 = {
> >> +	.name = "RGB565",
> >> +	.fourcc = V4L2_PIX_FMT_RGB565,
> >> +	.num_planes = 1,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 2 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = 4,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fb_fmt_argb1555 = {
> >> +	.name = "ARGB1555",
> >> +	.num_planes = 1,
> >> +	.fourcc = V4L2_PIX_FMT_RGB555,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 2 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = 5,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fb_fmt_argb4444 = {
> >> +	.name = "ARGB4444",
> >> +	.num_planes = 1,
> >> +	.fourcc = V4L2_PIX_FMT_RGB444,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 2 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = 6,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fb_fmt_argb8888 = {
> >> +	.name = "ARGB8888",
> >> +	.fourcc = V4L2_PIX_FMT_BGR32,
> >> +	.num_planes = 1,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 4 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = 7,
> >> +};
> >> +
> >> +static const struct mxr_format *mxr_graph_format[] = {
> >> +	&mxr_fb_fmt_rgb565,
> >> +	&mxr_fb_fmt_argb1555,
> >> +	&mxr_fb_fmt_argb4444,
> >> +	&mxr_fb_fmt_argb8888,
> >> +};
> >> +
> >> +/* AUXILIARY CALLBACKS */
> >> +
> >> +static void mxr_graph_layer_release(struct mxr_layer *layer)
> >> +{
> >> +	mxr_base_layer_unregister(layer);
> >> +	mxr_base_layer_release(layer);
> >> +}
> >> +
> >> +static void mxr_graph_buffer_set(struct mxr_layer *layer,
> >> +	struct mxr_buffer *buf)
> >> +{
> >> +	dma_addr_t addr = 0;
> >> +
> >> +	if (buf)
> >> +		addr = vb2_dma_contig_plane_paddr(&buf->vb, 0);
> >> +	mxr_reg_graph_buffer(layer->mdev, layer->idx, addr);
> >> +}
> >> +
> >> +static void mxr_graph_stream_set(struct mxr_layer *layer, int en)
> >> +{
> >> +	mxr_reg_graph_layer_stream(layer->mdev, layer->idx, en);
> >> +}
> >> +
> >> +static void mxr_graph_format_set(struct mxr_layer *layer)
> >> +{
> >> +	mxr_reg_graph_format(layer->mdev, layer->idx,
> >> +		layer->fmt, &layer->geo);
> >> +}
> >> +
> >> +static void mxr_graph_fix_geometry(struct mxr_layer *layer)
> >> +{
> >> +	struct mxr_geometry *geo = &layer->geo;
> >> +
> >> +	/* limit to boundary size */
> >> +	geo->src.full_width = clamp_val(geo->src.full_width, 1, 32767);
> >> +	geo->src.full_height = clamp_val(geo->src.full_height, 1, 2047);
> >> +	geo->src.width = clamp_val(geo->src.width, 1, geo->src.full_width);
> >> +	geo->src.width = min(geo->src.width, 2047U);
> >> +	/* not possible to crop of Y axis */
> >> +	geo->src.y_offset = min(geo->src.y_offset, geo->src.full_height - 1);
> >> +	geo->src.height = geo->src.full_height - geo->src.y_offset;
> >> +	/* limitting offset */
> >> +	geo->src.x_offset = min(geo->src.x_offset,
> >> +		geo->src.full_width - geo->src.width);
> >> +
> >> +	/* setting position in output */
> >> +	geo->dst.width = min(geo->dst.width, geo->dst.full_width);
> >> +	geo->dst.height = min(geo->dst.height, geo->dst.full_height);
> >> +
> >> +	/* Mixer supports only 1x and 2x scaling */
> >> +	if (geo->dst.width >= 2 * geo->src.width) {
> >> +		geo->x_ratio = 1;
> >> +		geo->dst.width = 2 * geo->src.width;
> >> +	} else {
> >> +		geo->x_ratio = 0;
> >> +		geo->dst.width = geo->src.width;
> >> +	}
> >> +
> >> +	if (geo->dst.height >= 2 * geo->src.height) {
> >> +		geo->y_ratio = 1;
> >> +		geo->dst.height = 2 * geo->src.height;
> >> +	} else {
> >> +		geo->y_ratio = 0;
> >> +		geo->dst.height = geo->src.height;
> >> +	}
> >> +
> >> +	geo->dst.x_offset = min(geo->dst.x_offset,
> >> +		geo->dst.full_width - geo->dst.width);
> >> +	geo->dst.y_offset = min(geo->dst.y_offset,
> >> +		geo->dst.full_height - geo->dst.height);
> >> +}
> >> +
> >> +/* PUBLIC API */
> >> +
> >> +struct mxr_layer *mxr_graph_layer_create(struct mxr_device *mdev, int idx)
> >> +{
> >> +	struct mxr_layer *layer;
> >> +	int ret;
> >> +	struct mxr_layer_ops ops = {
> >> +		.release = mxr_graph_layer_release,
> >> +		.buffer_set = mxr_graph_buffer_set,
> >> +		.stream_set = mxr_graph_stream_set,
> >> +		.format_set = mxr_graph_format_set,
> >> +		.fix_geometry = mxr_graph_fix_geometry,
> >> +	};
> >> +	char name[32];
> >> +
> >> +	sprintf(name, "graph%d", idx);
> >> +
> >> +	layer = mxr_base_layer_create(mdev, idx, name, &ops);
> >> +	if (layer == NULL) {
> >> +		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	layer->fmt_array = mxr_graph_format;
> >> +	layer->fmt_array_size = ARRAY_SIZE(mxr_graph_format);
> >> +
> >> +	ret = mxr_base_layer_register(layer);
> >> +	if (ret)
> >> +		goto fail_layer;
> >> +
> >> +	return layer;
> >> +
> >> +fail_layer:
> >> +	mxr_base_layer_release(layer);
> >> +
> >> +fail:
> >> +	return NULL;
> >> +}
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/video/s5p-tv/mixer_reg.c
> >> new file mode 100644
> >> index 0000000..c60f85f8
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer_reg.c
> >> @@ -0,0 +1,540 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "mixer.h"
> >> +#include "regs-mixer.h"
> >> +#include "regs-vp.h"
> >> +
> >> +#include <linux/delay.h>
> >> +
> >> +/* Register access subroutines */
> >> +
> >> +static inline u32 vp_read(struct mxr_device *mdev, u32 reg_id)
> >> +{
> >> +	return readl(mdev->res.vp_regs + reg_id);
> >> +}
> >> +
> >> +static inline void vp_write(struct mxr_device *mdev, u32 reg_id, u32 val)
> >> +{
> >> +	writel(val, mdev->res.vp_regs + reg_id);
> >> +}
> >> +
> >> +static inline void vp_write_mask(struct mxr_device *mdev, u32 reg_id,
> >> +	u32 val, u32 mask)
> >> +{
> >> +	u32 old = vp_read(mdev, reg_id);
> >> +
> >> +	val = (val & mask) | (old & ~mask);
> >> +	writel(val, mdev->res.vp_regs + reg_id);
> >> +}
> >> +
> >> +static inline u32 mxr_read(struct mxr_device *mdev, u32 reg_id)
> >> +{
> >> +	return readl(mdev->res.mxr_regs + reg_id);
> >> +}
> >> +
> >> +static inline void mxr_write(struct mxr_device *mdev, u32 reg_id, u32 val)
> >> +{
> >> +	writel(val, mdev->res.mxr_regs + reg_id);
> >> +}
> >> +
> >> +static inline void mxr_write_mask(struct mxr_device *mdev, u32 reg_id,
> >> +	u32 val, u32 mask)
> >> +{
> >> +	u32 old = mxr_read(mdev, reg_id);
> >> +
> >> +	val = (val & mask) | (old & ~mask);
> >> +	writel(val, mdev->res.mxr_regs + reg_id);
> >> +}
> >> +
> >> +void mxr_vsync_set_update(struct mxr_device *mdev, int en)
> >> +{
> >> +	/* block update on vsync */
> >> +	mxr_write_mask(mdev, MXR_STATUS, en ? MXR_STATUS_SYNC_ENABLE : 0,
> >> +		MXR_STATUS_SYNC_ENABLE);
> >> +	vp_write(mdev, VP_SHADOW_UPDATE, en ? VP_SHADOW_UPDATE_ENABLE : 0);
> >> +}
> >> +
> >> +static void __mxr_reg_vp_reset(struct mxr_device *mdev)
> >> +{
> >> +	int tries = 100;
> >> +
> >> +	vp_write(mdev, VP_SRESET, VP_SRESET_PROCESSING);
> >> +	for (tries = 100; tries; --tries) {
> >> +		/* waiting until VP_SRESET_PROCESSING is 0 */
> >> +		if (~vp_read(mdev, VP_SRESET) & VP_SRESET_PROCESSING)
> >> +			break;
> >> +		mdelay(10);
> >> +	}
> >> +	WARN(tries == 0, "failed to reset Video Processor\n");
> >> +}
> >> +
> >> +static void mxr_reg_vp_default_filter(struct mxr_device *mdev);
> >> +
> >> +void mxr_reg_reset(struct mxr_device *mdev)
> >> +{
> >> +	unsigned long flags;
> >> +	u32 val; /* value stored to register */
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	/* set output in RGB888 mode */
> >> +	mxr_write(mdev, MXR_CFG, MXR_CFG_OUT_YUV444);
> >> +
> >> +	/* 16 beat burst in DMA */
> >> +	mxr_write_mask(mdev, MXR_STATUS, MXR_STATUS_16_BURST,
> >> +		MXR_STATUS_BURST_MASK);
> >> +
> >> +	/* setting default layer priority: layer1 > video > layer0
> >> +	 * because typical usage scenario would be
> >> +	 * layer0 - framebuffer
> >> +	 * video - video overlay
> >> +	 * layer1 - OSD
> >> +	 */
> >> +	val  = MXR_LAYER_CFG_GRP0_VAL(1);
> >> +	val |= MXR_LAYER_CFG_VP_VAL(2);
> >> +	val |= MXR_LAYER_CFG_GRP1_VAL(3);
> >> +	mxr_write(mdev, MXR_LAYER_CFG, val);
> >> +
> >> +	/* use dark gray background color */
> >> +	mxr_write(mdev, MXR_BG_COLOR0, 0x808080);
> >> +	mxr_write(mdev, MXR_BG_COLOR1, 0x808080);
> >> +	mxr_write(mdev, MXR_BG_COLOR2, 0x808080);
> >> +
> >> +	/* setting graphical layers */
> >> +
> >> +	val  = MXR_GRP_CFG_COLOR_KEY_DISABLE; /* no blank key */
> >> +	val |= MXR_GRP_CFG_BLEND_PRE_MUL; /* premul mode */
> >> +	val |= MXR_GRP_CFG_ALPHA_VAL(0xff); /* non-transparent alpha */
> >> +
> >> +	/* the same configuration for both layers */
> >> +	mxr_write(mdev, MXR_GRAPHIC_CFG(0), val);
> >> +	mxr_write(mdev, MXR_GRAPHIC_CFG(1), val);
> >> +
> >> +	/* configuration of Video Processor Registers */
> >> +	__mxr_reg_vp_reset(mdev);
> >> +	mxr_reg_vp_default_filter(mdev);
> >> +
> >> +	/* enable all interrupts */
> >> +	mxr_write_mask(mdev, MXR_INT_EN, ~0, MXR_INT_EN_ALL);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +void mxr_reg_graph_format(struct mxr_device *mdev, int idx,
> >> +	const struct mxr_format *fmt, const struct mxr_geometry *geo)
> >> +{
> >> +	u32 val;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	/* setup format */
> >> +	mxr_write_mask(mdev, MXR_GRAPHIC_CFG(idx),
> >> +		MXR_GRP_CFG_FORMAT_VAL(fmt->cookie), MXR_GRP_CFG_FORMAT_MASK);
> >> +
> >> +	/* setup geometry */
> >> +	mxr_write(mdev, MXR_GRAPHIC_SPAN(idx), geo->src.full_width);
> >> +	val  = MXR_GRP_WH_WIDTH(geo->src.width);
> >> +	val |= MXR_GRP_WH_HEIGHT(geo->src.height);
> >> +	val |= MXR_GRP_WH_H_SCALE(geo->x_ratio);
> >> +	val |= MXR_GRP_WH_V_SCALE(geo->y_ratio);
> >> +	mxr_write(mdev, MXR_GRAPHIC_WH(idx), val);
> >> +
> >> +	/* setup offsets in source image */
> >> +	val  = MXR_GRP_SXY_SX(geo->src.x_offset);
> >> +	val |= MXR_GRP_SXY_SY(geo->src.y_offset);
> >> +	mxr_write(mdev, MXR_GRAPHIC_SXY(idx), val);
> >> +
> >> +	/* setup offsets in display image */
> >> +	val  = MXR_GRP_DXY_DX(geo->dst.x_offset);
> >> +	val |= MXR_GRP_DXY_DY(geo->dst.y_offset);
> >> +	mxr_write(mdev, MXR_GRAPHIC_DXY(idx), val);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +void mxr_reg_vp_format(struct mxr_device *mdev,
> >> +	const struct mxr_format *fmt, const struct mxr_geometry *geo)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	vp_write_mask(mdev, VP_MODE, fmt->cookie, VP_MODE_FMT_MASK);
> >> +
> >> +	/* setting size of input image */
> >> +	vp_write(mdev, VP_IMG_SIZE_Y, VP_IMG_HSIZE(geo->src.full_width) |
> >> +		VP_IMG_VSIZE(geo->src.full_height));
> >> +	/* chroma height has to reduced by 2 to avoid chroma distorions */
> >> +	vp_write(mdev, VP_IMG_SIZE_C, VP_IMG_HSIZE(geo->src.full_width) |
> >> +		VP_IMG_VSIZE(geo->src.full_height / 2));
> >> +
> >> +	vp_write(mdev, VP_SRC_WIDTH, geo->src.width);
> >> +	vp_write(mdev, VP_SRC_HEIGHT, geo->src.height);
> >> +	vp_write(mdev, VP_SRC_H_POSITION,
> >> +		VP_SRC_H_POSITION_VAL(geo->src.x_offset));
> >> +	vp_write(mdev, VP_SRC_V_POSITION, geo->src.y_offset);
> >> +
> >> +	vp_write(mdev, VP_DST_WIDTH, geo->dst.width);
> >> +	vp_write(mdev, VP_DST_H_POSITION, geo->dst.x_offset);
> >> +	if (geo->dst.field == V4L2_FIELD_INTERLACED) {
> >> +		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height / 2);
> >> +		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset / 2);
> >> +	} else {
> >> +		vp_write(mdev, VP_DST_HEIGHT, geo->dst.height);
> >> +		vp_write(mdev, VP_DST_V_POSITION, geo->dst.y_offset);
> >> +	}
> >> +
> >> +	vp_write(mdev, VP_H_RATIO, geo->x_ratio);
> >> +	vp_write(mdev, VP_V_RATIO, geo->y_ratio);
> >> +
> >> +	vp_write(mdev, VP_ENDIAN_MODE, VP_ENDIAN_MODE_LITTLE);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +
> >> +}
> >> +
> >> +void mxr_reg_graph_buffer(struct mxr_device *mdev, int idx, dma_addr_t addr)
> >> +{
> >> +	u32 val = addr ? ~0 : 0;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	if (idx == 0)
> >> +		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP0_ENABLE);
> >> +	else
> >> +		mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_GRP1_ENABLE);
> >> +	mxr_write(mdev, MXR_GRAPHIC_BASE(idx), addr);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +void mxr_reg_vp_buffer(struct mxr_device *mdev,
> >> +	dma_addr_t luma_addr[2], dma_addr_t chroma_addr[2])
> >> +{
> >> +	u32 val = luma_addr[0] ? ~0 : 0;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_VP_ENABLE);
> >> +	vp_write_mask(mdev, VP_ENABLE, val, VP_ENABLE_ON);
> >> +	/* TODO: fix tiled mode */
> >> +	vp_write(mdev, VP_TOP_Y_PTR, luma_addr[0]);
> >> +	vp_write(mdev, VP_TOP_C_PTR, chroma_addr[0]);
> >> +	vp_write(mdev, VP_BOT_Y_PTR, luma_addr[1]);
> >> +	vp_write(mdev, VP_BOT_C_PTR, chroma_addr[1]);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +static void mxr_irq_layer_handle(struct mxr_layer *layer)
> >> +{
> >> +	struct list_head *head = &layer->enq_list;
> >> +	struct mxr_buffer *done;
> >> +
> >> +	/* skip non-existing layer */
> >> +	if (layer == NULL)
> >> +		return;
> >> +
> >> +	spin_lock(&layer->enq_slock);
> >> +	if (layer->state == MXR_LAYER_IDLE)
> >> +		goto done;
> >> +
> >> +	done = layer->shadow_buf;
> >> +	layer->shadow_buf = layer->update_buf;
> >> +
> >> +	if (list_empty(head)) {
> >> +		if (layer->state != MXR_LAYER_STREAMING)
> >> +			layer->update_buf = NULL;
> >> +	} else {
> >> +		struct mxr_buffer *next;
> >> +		next = list_first_entry(head, struct mxr_buffer, list);
> >> +		list_del(&next->list);
> >> +		layer->update_buf = next;
> >> +	}
> >> +
> >> +	layer->ops.buffer_set(layer, layer->update_buf);
> >> +
> >> +	if (done && done != layer->shadow_buf)
> >> +		vb2_buffer_done(&done->vb, VB2_BUF_STATE_DONE);
> >> +
> >> +done:
> >> +	spin_unlock(&layer->enq_slock);
> >> +}
> >> +
> >> +irqreturn_t mxr_irq_handler(int irq, void *dev_data)
> >> +{
> >> +	struct mxr_device *mdev = dev_data;
> >> +	u32 i, val;
> >> +
> >> +	spin_lock(&mdev->reg_slock);
> >> +	val = mxr_read(mdev, MXR_INT_STATUS);
> >> +
> >> +	/* wake up process waiting for VSYNC */
> >> +	if (val & MXR_INT_STATUS_VSYNC) {
> >> +		set_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
> >> +		wake_up(&mdev->event_queue);
> >> +	}
> >> +
> >> +	/* clear interrupts */
> >> +	if (~val & MXR_INT_EN_VSYNC) {
> >> +		/* vsync interrupt use different bit for read and clear */
> >> +		val &= ~MXR_INT_EN_VSYNC;
> >> +		val |= MXR_INT_CLEAR_VSYNC;
> >> +	}
> >> +	mxr_write(mdev, MXR_INT_STATUS, val);
> >> +
> >> +	spin_unlock(&mdev->reg_slock);
> >> +	/* leave on non-vsync event */
> >> +	if (~val & MXR_INT_CLEAR_VSYNC)
> >> +		return IRQ_HANDLED;
> >> +	for (i = 0; i < MXR_MAX_LAYERS; ++i)
> >> +		mxr_irq_layer_handle(mdev->layer[i]);
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +void mxr_reg_s_output(struct mxr_device *mdev, int cookie)
> >> +{
> >> +	u32 val;
> >> +
> >> +	val = cookie == 0 ? MXR_CFG_DST_SDO : MXR_CFG_DST_HDMI;
> >> +	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_DST_MASK);
> >> +}
> >> +
> >> +void mxr_reg_streamon(struct mxr_device *mdev)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	/* single write -> no need to block vsync update */
> >> +
> >> +	/* start MIXER */
> >> +	mxr_write_mask(mdev, MXR_STATUS, ~0, MXR_STATUS_REG_RUN);
> >> +
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +void mxr_reg_streamoff(struct mxr_device *mdev)
> >> +{
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	/* single write -> no need to block vsync update */
> >> +
> >> +	/* stop MIXER */
> >> +	mxr_write_mask(mdev, MXR_STATUS, 0, MXR_STATUS_REG_RUN);
> >> +
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +int mxr_reg_wait4vsync(struct mxr_device *mdev)
> >> +{
> >> +	int ret;
> >> +
> >> +	clear_bit(MXR_EVENT_VSYNC, &mdev->event_flags);
> >> +	/* TODO: consider adding interruptible */
> >> +	ret = wait_event_timeout(mdev->event_queue,
> >> +		test_bit(MXR_EVENT_VSYNC, &mdev->event_flags),
> >> +		msecs_to_jiffies(1000));
> >> +	if (ret > 0)
> >> +		return 0;
> >> +	if (ret < 0)
> >> +		return ret;
> >> +	return -ETIME;
> >> +}
> >> +
> >> +void mxr_reg_set_mbus_fmt(struct mxr_device *mdev,
> >> +	struct v4l2_mbus_framefmt *fmt)
> >> +{
> >> +	u32 val = 0;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&mdev->reg_slock, flags);
> >> +	mxr_vsync_set_update(mdev, MXR_DISABLE);
> >> +
> >> +	/* choosing between interlace and progressive mode */
> >> +	if (fmt->field == V4L2_FIELD_INTERLACED)
> >> +		val |= MXR_CFG_SCAN_INTERLACE;
> >> +	else
> >> +		val |= MXR_CFG_SCAN_PROGRASSIVE;
> >> +
> >> +	/* choosing between porper HD and SD mode */
> >> +	if (fmt->height == 480)
> >> +		val |= MXR_CFG_SCAN_NTSC | MXR_CFG_SCAN_SD;
> >> +	else if (fmt->height == 576)
> >> +		val |= MXR_CFG_SCAN_PAL | MXR_CFG_SCAN_SD;
> >> +	else if (fmt->height == 720)
> >> +		val |= MXR_CFG_SCAN_HD_720 | MXR_CFG_SCAN_HD;
> >> +	else if (fmt->height == 1080)
> >> +		val |= MXR_CFG_SCAN_HD_1080 | MXR_CFG_SCAN_HD;
> >> +	else
> >> +		WARN(1, "unrecognized mbus height %u!\n", fmt->height);
> >> +
> >> +	mxr_write_mask(mdev, MXR_CFG, val, MXR_CFG_SCAN_MASK);
> >> +
> >> +	val = (fmt->field == V4L2_FIELD_INTERLACED) ? ~0 : 0;
> >> +	vp_write_mask(mdev, VP_MODE, val,
> >> +		VP_MODE_LINE_SKIP | VP_MODE_FIELD_ID_AUTO_TOGGLING);
> >> +
> >> +	mxr_vsync_set_update(mdev, MXR_ENABLE);
> >> +	spin_unlock_irqrestore(&mdev->reg_slock, flags);
> >> +}
> >> +
> >> +void mxr_reg_graph_layer_stream(struct mxr_device *mdev, int idx, int en)
> >> +{
> >> +	/* no extra actions need to be done */
> >> +}
> >> +
> >> +void mxr_reg_vp_layer_stream(struct mxr_device *mdev, int en)
> >> +{
> >> +	/* no extra actions need to be done */
> >> +}
> >> +
> >> +static const u8 filter_y_horiz_tap8[] = {
> >> +	0,	-1,	-1,	-1,	-1,	-1,	-1,	-1,
> >> +	-1,	-1,	-1,	-1,	-1,	0,	0,	0,
> >> +	0,	2,	4,	5,	6,	6,	6,	6,
> >> +	6,	5,	5,	4,	3,	2,	1,	1,
> >> +	0,	-6,	-12,	-16,	-18,	-20,	-21,	-20,
> >> +	-20,	-18,	-16,	-13,	-10,	-8,	-5,	-2,
> >> +	127,	126,	125,	121,	114,	107,	99,	89,
> >> +	79,	68,	57,	46,	35,	25,	16,	8,
> >> +};
> >> +
> >> +static const u8 filter_y_vert_tap4[] = {
> >> +	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
> >> +	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
> >> +	127,	126,	124,	118,	111,	102,	92,	81,
> >> +	70,	59,	48,	37,	27,	19,	11,	5,
> >> +	0,	5,	11,	19,	27,	37,	48,	59,
> >> +	70,	81,	92,	102,	111,	118,	124,	126,
> >> +	0,	0,	-1,	-1,	-2,	-3,	-4,	-5,
> >> +	-6,	-7,	-8,	-8,	-8,	-8,	-6,	-3,
> >> +};
> >> +
> >> +static const u8 filter_cr_horiz_tap4[] = {
> >> +	0,	-3,	-6,	-8,	-8,	-8,	-8,	-7,
> >> +	-6,	-5,	-4,	-3,	-2,	-1,	-1,	0,
> >> +	127,	126,	124,	118,	111,	102,	92,	81,
> >> +	70,	59,	48,	37,	27,	19,	11,	5,
> >> +};
> >> +
> >> +static inline void mxr_reg_vp_filter_set(struct mxr_device *mdev,
> >> +	int reg_id, const u8 *data, unsigned int size)
> >> +{
> >> +	/* assure 4-byte align */
> >> +	BUG_ON(size & 3);
> >> +	for (; size; size -= 4, reg_id += 4, data += 4) {
> >> +		u32 val = (data[0] << 24) |  (data[1] << 16) |
> >> +			(data[2] << 8) | data[3];
> >> +		vp_write(mdev, reg_id, val);
> >> +	}
> >> +}
> >> +
> >> +static void mxr_reg_vp_default_filter(struct mxr_device *mdev)
> >> +{
> >> +	mxr_reg_vp_filter_set(mdev, VP_POLY8_Y0_LL,
> >> +		filter_y_horiz_tap8, sizeof filter_y_horiz_tap8);
> >> +	mxr_reg_vp_filter_set(mdev, VP_POLY4_Y0_LL,
> >> +		filter_y_vert_tap4, sizeof filter_y_vert_tap4);
> >> +	mxr_reg_vp_filter_set(mdev, VP_POLY4_C0_LL,
> >> +		filter_cr_horiz_tap4, sizeof filter_cr_horiz_tap4);
> >> +}
> >> +
> >> +static void mxr_reg_mxr_dump(struct mxr_device *mdev)
> >> +{
> >> +#define DUMPREG(reg_id) \
> >> +do { \
> >> +	mxr_dbg(mdev, #reg_id " = %08x\n", \
> >> +		(u32)readl(mdev->res.mxr_regs + reg_id)); \
> >> +} while (0)
> >> +
> >> +	DUMPREG(MXR_STATUS);
> >> +	DUMPREG(MXR_CFG);
> >> +	DUMPREG(MXR_INT_EN);
> >> +	DUMPREG(MXR_INT_STATUS);
> >> +
> >> +	DUMPREG(MXR_LAYER_CFG);
> >> +	DUMPREG(MXR_VIDEO_CFG);
> >> +
> >> +	DUMPREG(MXR_GRAPHIC0_CFG);
> >> +	DUMPREG(MXR_GRAPHIC0_BASE);
> >> +	DUMPREG(MXR_GRAPHIC0_SPAN);
> >> +	DUMPREG(MXR_GRAPHIC0_WH);
> >> +	DUMPREG(MXR_GRAPHIC0_SXY);
> >> +	DUMPREG(MXR_GRAPHIC0_DXY);
> >> +
> >> +	DUMPREG(MXR_GRAPHIC1_CFG);
> >> +	DUMPREG(MXR_GRAPHIC1_BASE);
> >> +	DUMPREG(MXR_GRAPHIC1_SPAN);
> >> +	DUMPREG(MXR_GRAPHIC1_WH);
> >> +	DUMPREG(MXR_GRAPHIC1_SXY);
> >> +	DUMPREG(MXR_GRAPHIC1_DXY);
> >> +#undef DUMPREG
> >> +}
> >> +
> >> +static void mxr_reg_vp_dump(struct mxr_device *mdev)
> >> +{
> >> +#define DUMPREG(reg_id) \
> >> +do { \
> >> +	mxr_dbg(mdev, #reg_id " = %08x\n", \
> >> +		(u32) readl(mdev->res.vp_regs + reg_id)); \
> >> +} while (0)
> >> +
> >> +
> >> +	DUMPREG(VP_ENABLE);
> >> +	DUMPREG(VP_SRESET);
> >> +	DUMPREG(VP_SHADOW_UPDATE);
> >> +	DUMPREG(VP_FIELD_ID);
> >> +	DUMPREG(VP_MODE);
> >> +	DUMPREG(VP_IMG_SIZE_Y);
> >> +	DUMPREG(VP_IMG_SIZE_C);
> >> +	DUMPREG(VP_PER_RATE_CTRL);
> >> +	DUMPREG(VP_TOP_Y_PTR);
> >> +	DUMPREG(VP_BOT_Y_PTR);
> >> +	DUMPREG(VP_TOP_C_PTR);
> >> +	DUMPREG(VP_BOT_C_PTR);
> >> +	DUMPREG(VP_ENDIAN_MODE);
> >> +	DUMPREG(VP_SRC_H_POSITION);
> >> +	DUMPREG(VP_SRC_V_POSITION);
> >> +	DUMPREG(VP_SRC_WIDTH);
> >> +	DUMPREG(VP_SRC_HEIGHT);
> >> +	DUMPREG(VP_DST_H_POSITION);
> >> +	DUMPREG(VP_DST_V_POSITION);
> >> +	DUMPREG(VP_DST_WIDTH);
> >> +	DUMPREG(VP_DST_HEIGHT);
> >> +	DUMPREG(VP_H_RATIO);
> >> +	DUMPREG(VP_V_RATIO);
> >> +
> >> +#undef DUMPREG
> >> +}
> >> +
> >> +void mxr_reg_dump(struct mxr_device *mdev)
> >> +{
> >> +	mxr_reg_mxr_dump(mdev);
> >> +	mxr_reg_vp_dump(mdev);
> >> +}
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
> >> new file mode 100644
> >> index 0000000..f4fc3e1
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer_video.c
> >> @@ -0,0 +1,956 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "mixer.h"
> >> +
> >> +#include <media/v4l2-ioctl.h>
> >> +#include <linux/videodev2.h>
> >> +#include <linux/mm.h>
> >> +#include <linux/version.h>
> >> +#include <linux/timer.h>
> >> +#include <media/videobuf2-dma-contig.h>
> >> +
> >> +static int find_reg_callback(struct device *dev, void *p)
> >> +{
> >> +	struct v4l2_subdev **sd = p;
> >> +
> >> +	*sd = dev_get_drvdata(dev);
> >>     
> >
> > Now I understand why the hdmi driver sets drvdata.
> >
> > I think that in the hdmi driver you should just pass a NULL pointer as struct
> > device to v4l2_device_register. The only think you need to do is to initialize
> > the 'name' field of v4l2_device before calling v4l2_device_register. Normally
> > v4l2_device_register will derive the name from struct device, but when you
> > pass a NULL pointer that no longer works.
> >   
> How to solve passing subdev to other driver? Any code example?
> >   
> >> +	/* non-zero value stops iteration */
> >> +	return 1;
> >> +}
> >> +
> >> +static struct v4l2_subdev *find_and_register_subdev(
> >> +	struct mxr_device *mdev, char *module_name)
> >> +{
> >> +	struct device_driver *drv;
> >> +	struct v4l2_subdev *sd = NULL;
> >> +	int ret;
> >> +
> >> +	/* TODO: add waiting until probe is finished */
> >> +	drv = driver_find(module_name, &platform_bus_type);
> >> +	if (!drv) {
> >> +		mxr_warn(mdev, "module %s is missing\n", module_name);
> >> +		return NULL;
> >> +	}
> >> +	/* driver refcnt is increased, it is safe to iterate over devices */
> >> +	ret = driver_for_each_device(drv, NULL, &sd, find_reg_callback);
> >> +	/* ret == 0 means that find_reg_callback was never executed */
> >> +	if (sd == NULL) {
> >> +		mxr_warn(mdev, "module %s provides no subdev!\n", module_name);
> >> +		goto done;
> >> +	}
> >> +	/* v4l2_device_register_subdev detects if sd is NULL */
> >> +	ret = v4l2_device_register_subdev(&mdev->v4l2_dev, sd);
> >> +	if (ret) {
> >> +		mxr_warn(mdev, "failed to register subdev %s\n", sd->name);
> >> +		sd = NULL;
> >> +	}
> >> +
> >> +done:
> >> +	put_driver(drv);
> >> +	return sd;
> >> +}
> >> +
> >> +int __devinit mxr_acquire_video(struct mxr_device *mdev,
> >> +	struct mxr_output_conf *output_conf, int output_count)
> >> +{
> >> +	struct device *dev = mdev->dev;
> >> +	struct v4l2_device *vdev = &mdev->v4l2_dev;
> >>     
> >
> > Don't use 'vdev' for v4l2_device, it's confusing. I always use 'v4l2_dev'.
> >
> >   
> >> +	int i;
> >> +	int ret = 0;
> >> +	struct v4l2_subdev *sd;
> >> +
> >> +	strlcpy(vdev->name, "s5p-tv", sizeof(vdev->name));
> >> +	/* prepare context for V4L2 device */
> >> +	ret = v4l2_device_register(dev, vdev);
> >> +	if (ret) {
> >> +		mxr_err(mdev, "could not register v4l2 device.\n");
> >> +		goto fail;
> >> +	}
> >> +
> >> +	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
> >> +	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
> >> +		mxr_err(mdev, "could not acquire vb2 allocator\n");
> >> +		goto fail_v4l2_dev;
> >> +	}
> >> +
> >> +	/* registering outputs */
> >> +	mdev->output_cnt = 0;
> >> +	for (i = 0; i < output_count; ++i) {
> >> +		struct mxr_output_conf *conf = &output_conf[i];
> >> +		struct mxr_output *out;
> >>     
> >
> > Add empty line between the declarations and the code.
> >
> >   
> >> +		sd = find_and_register_subdev(mdev, conf->module_name);
> >> +		/* trying to register next output */
> >> +		if (sd == NULL)
> >> +			continue;
> >> +		out = kzalloc(sizeof *out, GFP_KERNEL);
> >> +		if (out == NULL) {
> >> +			mxr_err(mdev, "no memory for '%s'\n",
> >> +				conf->output_name);
> >> +			ret = -ENOMEM;
> >> +			/* registered subdevs are removed in fail_v4l2_dev */
> >> +			goto fail_output;
> >> +		}
> >> +		strlcpy(out->name, conf->output_name, sizeof(out->name));
> >> +		out->sd = sd;
> >> +		out->cookie = conf->cookie;
> >> +		mdev->output[mdev->output_cnt++] = out;
> >> +		mxr_info(mdev, "added output '%s' from module '%s'\n",
> >> +			conf->output_name, conf->module_name);
> >> +		/* checking if maximal number of outputs is reached */
> >> +		if (mdev->output_cnt >= MXR_MAX_OUTPUTS)
> >> +			break;
> >> +	}
> >> +
> >> +	if (mdev->output_cnt == 0) {
> >> +		mxr_err(mdev, "failed to register any output\n");
> >> +		ret = -ENODEV;
> >> +		/* skipping fail_output because there is nothing to free */
> >> +		goto fail_vb2_allocator;
> >> +	}
> >> +
> >> +	return 0;
> >> +
> >> +fail_output:
> >> +	/* kfree is NULL-safe */
> >> +	for (i = 0; i < mdev->output_cnt; ++i)
> >> +		kfree(mdev->output[i]);
> >> +	memset(mdev->output, 0, sizeof mdev->output);
> >> +
> >> +fail_vb2_allocator:
> >> +	/* freeing allocator context */
> >> +	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
> >> +
> >> +fail_v4l2_dev:
> >> +	/* NOTE: automatically unregisteres all subdevs */
> >> +	v4l2_device_unregister(vdev);
> >> +
> >> +fail:
> >> +	return ret;
> >> +}
> >> +
> >> +void __devexit mxr_release_video(struct mxr_device *mdev)
> >> +{
> >> +	int i;
> >> +
> >> +	/* kfree is NULL-safe */
> >> +	for (i = 0; i < mdev->output_cnt; ++i)
> >> +		kfree(mdev->output[i]);
> >> +
> >> +	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
> >> +	v4l2_device_unregister(&mdev->v4l2_dev);
> >> +}
> >> +
> >> +static int mxr_querycap(struct file *file, void *priv,
> >> +	struct v4l2_capability *cap)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +
> >> +	strlcpy(cap->driver, MXR_DRIVER_NAME, sizeof cap->driver);
> >> +	strlcpy(cap->card, layer->vfd.name, sizeof cap->card);
> >> +	sprintf(cap->bus_info, "%d", layer->idx);
> >> +	cap->version = KERNEL_VERSION(0, 1, 0);
> >> +	cap->capabilities = V4L2_CAP_STREAMING |
> >> +		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +/* Geometry handling */
> >> +static void mxr_layer_geo_fix(struct mxr_layer *layer)
> >> +{
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	struct v4l2_mbus_framefmt mbus_fmt;
> >> +
> >> +	/* TODO: add some dirty flag to avoid unneccessary adjustments */
> >> +	mxr_get_mbus_fmt(mdev, &mbus_fmt);
> >> +	layer->geo.dst.full_width = mbus_fmt.width;
> >> +	layer->geo.dst.full_height = mbus_fmt.height;
> >> +	layer->geo.dst.field = mbus_fmt.field;
> >> +	layer->ops.fix_geometry(layer);
> >> +}
> >> +
> >> +static void mxr_layer_default_geo(struct mxr_layer *layer)
> >> +{
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	struct v4l2_mbus_framefmt mbus_fmt;
> >> +
> >> +	memset(&layer->geo, 0, sizeof layer->geo);
> >> +
> >> +	mxr_get_mbus_fmt(mdev, &mbus_fmt);
> >> +
> >> +	layer->geo.dst.full_width = mbus_fmt.width;
> >> +	layer->geo.dst.full_height = mbus_fmt.height;
> >> +	layer->geo.dst.width = layer->geo.dst.full_width;
> >> +	layer->geo.dst.height = layer->geo.dst.full_height;
> >> +	layer->geo.dst.field = mbus_fmt.field;
> >> +
> >> +	layer->geo.src.full_width = mbus_fmt.width;
> >> +	layer->geo.src.full_height = mbus_fmt.height;
> >> +	layer->geo.src.width = layer->geo.src.full_width;
> >> +	layer->geo.src.height = layer->geo.src.full_height;
> >> +
> >> +	layer->ops.fix_geometry(layer);
> >> +}
> >> +
> >> +static void mxr_geometry_dump(struct mxr_device *mdev, struct mxr_geometry *geo)
> >> +{
> >> +	mxr_dbg(mdev, "src.full_size = (%u, %u)\n",
> >> +		geo->src.full_width, geo->src.full_height);
> >> +	mxr_dbg(mdev, "src.size = (%u, %u)\n",
> >> +		geo->src.width, geo->src.height);
> >> +	mxr_dbg(mdev, "src.offset = (%u, %u)\n",
> >> +		geo->src.x_offset, geo->src.y_offset);
> >> +	mxr_dbg(mdev, "dst.full_size = (%u, %u)\n",
> >> +		geo->dst.full_width, geo->dst.full_height);
> >> +	mxr_dbg(mdev, "dst.size = (%u, %u)\n",
> >> +		geo->dst.width, geo->dst.height);
> >> +	mxr_dbg(mdev, "dst.offset = (%u, %u)\n",
> >> +		geo->dst.x_offset, geo->dst.y_offset);
> >> +	mxr_dbg(mdev, "ratio = (%u, %u)\n",
> >> +		geo->x_ratio, geo->y_ratio);
> >> +}
> >> +
> >> +
> >> +static const struct mxr_format *find_format_by_fourcc(
> >> +	struct mxr_layer *layer, unsigned long fourcc);
> >> +static const struct mxr_format *find_format_by_index(
> >> +	struct mxr_layer *layer, unsigned long index);
> >> +
> >> +static int mxr_enum_fmt(struct file *file, void  *priv,
> >> +	struct v4l2_fmtdesc *f)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	const struct mxr_format *fmt;
> >> +
> >> +	mxr_dbg(mdev, "%s\n", __func__);
> >> +	fmt = find_format_by_index(layer, f->index);
> >> +	if (fmt == NULL)
> >> +		return -EINVAL;
> >> +
> >> +	strlcpy(f->description, fmt->name, sizeof(f->description));
> >> +	f->pixelformat = fmt->fourcc;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_s_fmt(struct file *file, void *priv,
> >> +	struct v4l2_format *f)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	const struct mxr_format *fmt;
> >> +	struct v4l2_pix_format_mplane *pix;
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	struct mxr_geometry *geo = &layer->geo;
> >> +	int i;
> >> +
> >> +	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
> >> +
> >> +	pix = &f->fmt.pix_mp;
> >> +	fmt = find_format_by_fourcc(layer, pix->pixelformat);
> >> +	if (fmt == NULL) {
> >> +		mxr_warn(mdev, "not recognized fourcc: %08x\n",
> >> +			pix->pixelformat);
> >> +		return -EINVAL;
> >> +	}
> >> +	layer->fmt = fmt;
> >> +	geo->src.full_width = pix->width;
> >> +	geo->src.width = pix->width;
> >> +	geo->src.full_height = pix->height;
> >> +	geo->src.height = pix->height;
> >> +	/* assure consistency of geometry */
> >> +	mxr_layer_geo_fix(layer);
> >> +
> >> +	for (i = 0; i < fmt->num_subframes; ++i) {
> >> +		unsigned int n_pixel = fmt->plane[i].height *
> >> +			fmt->plane[i].width;
> >> +		pix->plane_fmt[i].bytesperline = geo->src.full_width *
> >> +			fmt->plane[i].size / n_pixel;
> >> +	}
> >> +	mxr_dbg(mdev, "width=%u height=%u bpp=%u span=%u\n",
> >> +		geo->src.width, geo->src.height,
> >> +		pix->plane_fmt[0].bytesperline, geo->src.full_width);
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_g_fmt(struct file *file, void *priv,
> >> +			     struct v4l2_format *f)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +
> >> +	f->fmt.pix.width	= layer->geo.src.full_width;
> >> +	f->fmt.pix.height	= layer->geo.src.full_height;
> >> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> >> +	f->fmt.pix.pixelformat	= layer->fmt->fourcc;
> >>     
> >
> > Colorspace is not set. The subdev drivers should set the colorspace and that
> > should be passed in here.
> >
> >   
> Which one should be used for formats in vp_layer and grp_layer?
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static inline struct mxr_crop *choose_crop_by_type(struct mxr_geometry *geo,
> >> +	enum v4l2_buf_type type)
> >> +{
> >> +	switch (type) {
> >> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> >> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >> +		return &geo->dst;
> >> +	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
> >> +		return &geo->src;
> >>     
> >
> > Hmm, this is the only place where I see overlay. It's not set in QUERYCAP either.
> > And I suspect this is supposed to be OUTPUT_OVERLAY anyway since OVERLAY is for
> > capture.
> >
> >   
> Usage of OVERLAY is workaround for a lack of S_COMPOSE. This is 
> described in RFC.

Ah, now I understand.

I don't like this hack to be honest. Can't this be done differently? I understand
from the RFC that the reason is that widths have to be a multiple of 64. So why
not use the bytesperline field in v4l2_pix_format(_mplane)? So you can set the
width to e.g. 1440 and bytesperline to 1472. That does very simple cropping, but
it seems that this is sufficient for your immediate needs.

> >> +	default:
> >> +		return NULL;
> >> +	}
> >> +}
> >> +
> >> +static int mxr_g_crop(struct file *file, void *fh, struct v4l2_crop *a)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_crop *crop;
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	crop = choose_crop_by_type(&layer->geo, a->type);
> >> +	if (crop == NULL)
> >> +		return -EINVAL;
> >> +	mxr_layer_geo_fix(layer);
> >> +	a->c.left = crop->x_offset;
> >> +	a->c.top = crop->y_offset;
> >> +	a->c.width = crop->width;
> >> +	a->c.height = crop->height;
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_crop *crop;
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	crop = choose_crop_by_type(&layer->geo, a->type);
> >> +	if (crop == NULL)
> >> +		return -EINVAL;
> >> +	crop->x_offset = a->c.left;
> >> +	crop->y_offset = a->c.top;
> >> +	crop->width = a->c.width;
> >> +	crop->height = a->c.height;
> >> +	mxr_layer_geo_fix(layer);
> >>     
> >
> > No check for out-of-bounds rectangle.
> >   
> Fix geometry will bound it.
> >   
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_cropcap(struct file *file, void *fh, struct v4l2_cropcap *a)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_crop *crop;
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	crop = choose_crop_by_type(&layer->geo, a->type);
> >> +	if (crop == NULL)
> >> +		return -EINVAL;
> >> +	mxr_layer_geo_fix(layer);
> >> +	a->bounds.left = 0;
> >> +	a->bounds.top = 0;
> >> +	a->bounds.width = crop->full_width;
> >> +	a->bounds.top = crop->full_height;
> >> +	a->defrect = a->bounds;
> >>     
> >
> > Please set pixelaspect to 1x1.
> >   
> ok
> >   
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_enum_dv_presets(struct file *file, void *fh,
> >> +	struct v4l2_dv_enum_preset *preset)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret;
> >> +
> >> +	/* lock protects from changing sd_out */
> >> +	mutex_lock(&mdev->mutex);
> >> +	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_presets, preset);
> >> +	mutex_unlock(&mdev->mutex);
> >> +
> >> +	return ret ? -EINVAL : 0;
> >> +}
> >> +
> >> +static int mxr_s_dv_preset(struct file *file, void *fh,
> >> +	struct v4l2_dv_preset *preset)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret;
> >> +
> >> +	/* lock protects from changing sd_out */
> >> +	mutex_lock(&mdev->mutex);
> >> +
> >> +	/* preset change cannot be done while there is an entity
> >> +	 * dependant on output configuration
> >> +	 */
> >> +	if (mdev->n_output == 0)
> >> +		ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_preset,
> >> +			preset);
> >> +	else
> >> +		ret = -EBUSY;
> >>     
> >
> > EBUSY or EINVAL? I think EINVAL is better as this ioctl is simply not supported
> > for that input. EBUSY means that you can change it, but not now since streaming
> > is in progress.
> >
> >   
> EBUSY in this case means that there is a layer that depends on current 
> setting of output. Therefore configuration of output cannot change.

Ah, I confused n_output with current_output.

Disregard my remark above. Instead what is missing is that if the current_output
is set to the SDO (TV) output, then this function should return -EINVAL since that
output does not support DV_PRESET.

> >> +
> >> +	mutex_unlock(&mdev->mutex);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int mxr_g_dv_preset(struct file *file, void *fh,
> >> +	struct v4l2_dv_preset *preset)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret;
> >> +
> >> +	/* lock protects from changing sd_out */
> >>     
> >
> > Needs a check against n_output as well.
> >   
> Probably I use query_dv_preset wrong.

You mean g_dv_preset, right?

> Output is always somehow 
> configured no matter is some layer is using it or not.
> Therefore there is no reference checking.

I had the same confusion here. But what is true for s_dv_preset is also true
here: if the current output == SDO, then return -EINVAL.

> >   
> >> +	mutex_lock(&mdev->mutex);
> >> +	ret = v4l2_subdev_call(to_outsd(mdev), video, query_dv_preset, preset);
> >> +	mutex_unlock(&mdev->mutex);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret;
> >> +
> >> +	/* lock protects from changing sd_out */
> >> +	mutex_lock(&mdev->mutex);
> >> +
> >> +	/* standard change cannot be done while there is an entity
> >> +	 * dependant on output configuration
> >> +	 */
> >> +	if (mdev->n_output == 0)
> >> +		ret = v4l2_subdev_call(to_outsd(mdev), video, s_std_output,
> >> +			*norm);
> >> +	else
> >> +		ret = -EBUSY;
> >>     
> >
> > -EINVAL

Same confusion :-) But same problem: if the current input is set to HDMI, then
return -EINVAL here since HDMI doesn't support s_std.

For the same reason you should implement g_std as well. While the core can
handle g_std (something I've always disapproved of BTW), it isn't smart enough
to know that one output supports it but not the other.

> >
> >   
> >> +
> >> +	mutex_unlock(&mdev->mutex);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	struct mxr_output *out;
> >> +	struct v4l2_subdev *sd;
> >> +
> >> +	if (a->index >= mdev->output_cnt)
> >> +		return -EINVAL;
> >> +	out = mdev->output[a->index];
> >> +	BUG_ON(out == NULL);
> >> +	sd = out->sd;
> >> +	strlcpy(a->name, out->name, sizeof(a->name));
> >>     
> >
> > The names for the outputs are currently hardcoded in mxr_output_conf if I
> > understand it correctly.
> >
> > I think that you should consider obtaining this from board code via platform data.
> >
> > These names should refer to labels on the final product. You don't know those
> > names in this driver (or for that matter whether any of the outputs are actually
> > hooked up to a physical connector!). Let the board designer decide which, if any,
> > outputs are used and how they are labeled.
> >
> >   
> Ok.. I tried to avoid using platform data. I prefer driver variants.
> >> +
> >> +	/* try to obtain supported tv norms */
> >> +	v4l2_subdev_call(sd, video, g_tvnorms, &a->std);
> >> +	a->capabilities = 0;
> >> +	if (sd->ops->video && sd->ops->video->s_dv_preset)
> >> +		a->capabilities |= V4L2_OUT_CAP_PRESETS;
> >> +	if (sd->ops->video && sd->ops->video->s_std_output)
> >> +		a->capabilities |= V4L2_OUT_CAP_STD;
> >>     
> >
> > Hmm, what to use for a->type? V4L2_OUTPUT_TYPE_ANALOG is the only reasonable
> > option today. I think we should introduce an alias for this: V4L2_OUTPUT_TYPE_DISPLAY
> > or something like that that is less 'analog' minded. I don't think that a
> > TYPE_DIGITAL makes much sense in practice.
> >   
> Oops.. my mistake. I forgot to set this field.
> >   
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int mxr_s_output(struct file *file, void *fh, unsigned int i)
> >> +{
> >> +	struct video_device *vfd = video_devdata(file);
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret = 0;
> >> +
> >> +	if (i >= mdev->output_cnt || mdev->output[i] == NULL)
> >> +		return -EINVAL;
> >> +
> >> +	mutex_lock(&mdev->mutex);
> >> +	if (mdev->n_output > 0) {
> >> +		ret = -EBUSY;
> >> +		goto done;
> >> +	}
> >> +	mdev->current_output = i;
> >> +	mxr_info(mdev, "tvnorms = %08llx\n", vfd->tvnorms);
> >> +	vfd->tvnorms = 0;
> >> +	v4l2_subdev_call(to_outsd(mdev), video, g_tvnorms, &vfd->tvnorms);
> >> +	mxr_info(mdev, "new tvnorms = %08llx\n", vfd->tvnorms);
> >>     
> >
> > Why mxr_info? I'd use mxr_dbg.
> >
> > Normal usage should not result in kernel messages unless explicitly enabled.
> >
> >   
> ok
> >> +
> >> +done:
> >> +	mutex_unlock(&mdev->mutex);
> >> +	return ret;
> >> +}
> >> +
> >> +static int mxr_reqbufs(struct file *file, void *priv,
> >> +			  struct v4l2_requestbuffers *p)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	return vb2_reqbufs(&layer->vb_queue, p);
> >> +}
> >> +
> >> +static int mxr_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	return vb2_querybuf(&layer->vb_queue, p);
> >> +}
> >> +
> >> +static int mxr_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d(%d)\n", __func__, __LINE__, p->index);
> >> +	return vb2_qbuf(&layer->vb_queue, p);
> >> +}
> >> +
> >> +static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
> >> +}
> >> +
> >> +static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	return vb2_streamon(&layer->vb_queue, i);
> >> +}
> >> +
> >> +static int mxr_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	return vb2_streamoff(&layer->vb_queue, i);
> >> +}
> >> +
> >> +static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
> >> +	.vidioc_querycap = mxr_querycap,
> >> +	/* format handling */
> >> +	.vidioc_enum_fmt_vid_out = mxr_enum_fmt,
> >> +	.vidioc_s_fmt_vid_out_mplane = mxr_s_fmt,
> >> +	.vidioc_g_fmt_vid_out_mplane = mxr_g_fmt,
> >> +	/* buffer control */
> >> +	.vidioc_reqbufs = mxr_reqbufs,
> >> +	.vidioc_querybuf = mxr_querybuf,
> >> +	.vidioc_qbuf = mxr_qbuf,
> >> +	.vidioc_dqbuf = mxr_dqbuf,
> >> +	/* Streaming control */
> >> +	.vidioc_streamon = mxr_streamon,
> >> +	.vidioc_streamoff = mxr_streamoff,
> >> +	/* Preset functions */
> >> +	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
> >> +	.vidioc_s_dv_preset = mxr_s_dv_preset,
> >> +	.vidioc_g_dv_preset = mxr_g_dv_preset,
> >> +	/* analog TV standard functions */
> >> +	.vidioc_s_std = mxr_s_std,
> >> +	/* Output handling */
> >> +	.vidioc_enum_output = mxr_enum_output,
> >> +	.vidioc_s_output = mxr_s_output,
> >> +	/* Crop ioctls */
> >> +	.vidioc_g_crop = mxr_g_crop,
> >> +	.vidioc_s_crop = mxr_s_crop,
> >> +	.vidioc_cropcap = mxr_cropcap,
> >> +};
> >> +
> >> +static int mxr_video_open(struct file *file)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret = 0;
> >> +
> >> +	mxr_dbg(mdev, "%s:%d\n", __func__, __LINE__);
> >> +	/* assure device probe is finished */
> >> +	wait_for_device_probe();
> >> +	/* lock layer->mutex is already taken by video_device */
> >> +	/* leaving if layer is already initialized */
> >> +	if (++layer->n_user > 1)
> >> +		return 0;
> >> +
> >> +	/* FIXME: should power be enabled on open? */
> >> +	ret = mxr_power_get(mdev);
> >> +	if (ret) {
> >> +		mxr_err(mdev, "power on failed\n");
> >> +		goto fail_n_user;
> >> +	}
> >> +
> >> +	ret = vb2_queue_init(&layer->vb_queue);
> >> +	if (ret != 0) {
> >> +		mxr_err(mdev, "failed to initialize vb2 queue\n");
> >> +		goto fail_power;
> >> +	}
> >> +	/* set default format, first on the list */
> >> +	layer->fmt = layer->fmt_array[0];
> >> +	/* setup default geometry */
> >> +	mxr_layer_default_geo(layer);
> >> +
> >> +	return 0;
> >> +
> >> +fail_power:
> >> +	mxr_power_put(mdev);
> >> +
> >> +fail_n_user:
> >> +	--layer->n_user;
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static unsigned int
> >> +mxr_video_poll(struct file *file, struct poll_table_struct *wait)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +
> >> +	return vb2_poll(&layer->vb_queue, file, wait);
> >> +}
> >> +
> >> +static int mxr_video_mmap(struct file *file, struct vm_area_struct *vma)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +
> >> +	return vb2_mmap(&layer->vb_queue, vma);
> >> +}
> >> +
> >> +static int mxr_video_release(struct file *file)
> >> +{
> >> +	struct mxr_layer *layer = video_drvdata(file);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
> >> +	if (--layer->n_user == 0) {
> >> +		vb2_queue_release(&layer->vb_queue);
> >> +		mxr_power_put(layer->mdev);
> >> +	}
> >> +	return 0;
> >> +}
> >>     
> >
> > I recommend that you start using v4l2_fh_open and v4l2_fh_release together with
> > v4l2_fh_is_singular. The first two functions will allow you to easily implement
> > G/S_PRIORITY and be ready for control and HDMI events. The v4l2_fh_is_singular()
> > call allows you to get rid of n_user. You can take a look at vivi.c to see how
> > this is done.
> >
> > I also recommend you run the v4l2-compliance test app from v4l-utils against
> > this driver. It's not a full coverage, but what it tests it does test well.
> >
> >   
> ok
> >> +
> >> +static const struct v4l2_file_operations mxr_fops = {
> >> +	.owner = THIS_MODULE,
> >> +	.open = mxr_video_open,
> >> +	.poll = mxr_video_poll,
> >> +	.mmap = mxr_video_mmap,
> >> +	.release = mxr_video_release,
> >> +	.unlocked_ioctl = video_ioctl2,
> >> +};
> >> +
> >> +static unsigned int divup(unsigned int divident, unsigned int divisor)
> >> +{
> >> +	return (divident + divisor - 1) / divisor;
> >> +}
> >> +
> >> +unsigned long mxr_get_plane_size(const struct mxr_block *blk,
> >> +	unsigned int width, unsigned int height)
> >> +{
> >> +	unsigned int bl_width = divup(width, blk->width);
> >> +	unsigned int bl_height = divup(height, blk->height);
> >> +
> >> +	return bl_width * bl_height * blk->size;
> >> +}
> >> +
> >> +static int queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> >> +	unsigned int *nplanes, unsigned long sizes[],
> >> +	void *alloc_ctxs[])
> >> +{
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> >> +	const struct mxr_format *fmt = layer->fmt;
> >> +	int i;
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +
> >> +	mxr_dbg(mdev, "%s\n", __func__);
> >> +	/* checking if format was configured */
> >> +	if (fmt == NULL)
> >> +		return -EINVAL;
> >> +	mxr_dbg(mdev, "fmt = %s\n", fmt->name);
> >> +
> >> +	*nplanes = fmt->num_subframes;
> >> +	for (i = 0; i < fmt->num_subframes; ++i) {
> >> +		alloc_ctxs[i] = layer->mdev->alloc_ctx;
> >> +		sizes[i] = 0;
> >> +	}
> >> +
> >> +	for (i = 0; i < fmt->num_planes; ++i) {
> >> +		int frame_idx = fmt->plane2subframe[i];
> >> +		const struct mxr_block *blk = &fmt->plane[i];
> >> +		unsigned long plane_size;
> >>     
> >
> > Add empty line.
> >
> >   
> >> +		plane_size = mxr_get_plane_size(blk, layer->geo.src.full_width,
> >> +			layer->geo.src.full_height);
> >> +		sizes[frame_idx] += plane_size;
> >> +		mxr_dbg(mdev, "plane_size[%d] = %08lx\n", i, plane_size);
> >> +	}
> >> +	for (i = 0; i < fmt->num_subframes; ++i) {
> >> +		sizes[i] = PAGE_ALIGN(sizes[i]);
> >> +		mxr_dbg(mdev, "size[%d] = %08lx\n", i, sizes[i]);
> >> +	}
> >> +
> >> +	if (*nbuffers == 0)
> >> +		*nbuffers = 1;
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void buf_queue(struct vb2_buffer *vb)
> >> +{
> >> +	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	unsigned long flags;
> >> +	int must_start = 0;
> >> +
> >> +	spin_lock_irqsave(&layer->enq_slock, flags);
> >> +	if (layer->state == MXR_LAYER_STREAMING_START) {
> >> +		layer->state = MXR_LAYER_STREAMING;
> >> +		must_start = 1;
> >> +	}
> >> +	list_add_tail(&buffer->list, &layer->enq_list);
> >> +	spin_unlock_irqrestore(&layer->enq_slock, flags);
> >> +	if (must_start) {
> >> +		layer->ops.stream_set(layer, MXR_ENABLE);
> >> +		mxr_streamer_get(mdev);
> >> +	}
> >> +
> >> +	mxr_dbg(mdev, "queuing buffer\n");
> >> +}
> >> +
> >> +static void wait_lock(struct vb2_queue *vq)
> >> +{
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s\n", __func__);
> >> +	mutex_lock(&layer->mutex);
> >> +}
> >> +
> >> +static void wait_unlock(struct vb2_queue *vq)
> >> +{
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> >> +
> >> +	mxr_dbg(layer->mdev, "%s\n", __func__);
> >> +	mutex_unlock(&layer->mutex);
> >> +}
> >> +
> >> +static int start_streaming(struct vb2_queue *vq)
> >> +{
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	unsigned long flags;
> >> +
> >> +	mxr_dbg(mdev, "%s\n", __func__);
> >> +	/* block any changes in output configuration */
> >> +	mxr_output_get(mdev);
> >> +
> >> +	/* update layers geometry */
> >> +	mxr_layer_geo_fix(layer);
> >> +	mxr_geometry_dump(mdev, &layer->geo);
> >> +
> >> +	layer->ops.format_set(layer);
> >> +	/* enabling layer in hardware */
> >> +	spin_lock_irqsave(&layer->enq_slock, flags);
> >> +	layer->state = MXR_LAYER_STREAMING_START;
> >> +	spin_unlock_irqrestore(&layer->enq_slock, flags);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void mxr_watchdog(unsigned long arg)
> >> +{
> >> +	struct mxr_layer *layer = (struct mxr_layer *) arg;
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	unsigned long flags;
> >> +
> >> +	mxr_err(mdev, "watchdog fired for layer %s\n", layer->vfd.name);
> >> +
> >> +	spin_lock_irqsave(&layer->enq_slock, flags);
> >> +
> >> +	if (layer->update_buf == layer->shadow_buf)
> >> +		layer->update_buf = NULL;
> >> +	if (layer->update_buf) {
> >> +		vb2_buffer_done(&layer->update_buf->vb, VB2_BUF_STATE_ERROR);
> >> +		layer->update_buf = NULL;
> >> +	}
> >> +	if (layer->shadow_buf) {
> >> +		vb2_buffer_done(&layer->shadow_buf->vb, VB2_BUF_STATE_ERROR);
> >> +		layer->shadow_buf = NULL;
> >> +	}
> >> +	spin_unlock_irqrestore(&layer->enq_slock, flags);
> >> +}
> >> +
> >> +static int stop_streaming(struct vb2_queue *vq)
> >> +{
> >> +	struct mxr_layer *layer = vb2_get_drv_priv(vq);
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	unsigned long flags;
> >> +	struct timer_list watchdog;
> >> +	struct mxr_buffer *buf, *buf_tmp;
> >> +
> >> +	mxr_dbg(mdev, "%s\n", __func__);
> >> +
> >> +	spin_lock_irqsave(&layer->enq_slock, flags);
> >> +
> >> +	/* reset list */
> >> +	layer->state = MXR_LAYER_STREAMING_FINISH;
> >> +
> >> +	/* set all buffer to be done */
> >> +	list_for_each_entry_safe(buf, buf_tmp, &layer->enq_list, list) {
> >> +		list_del(&buf->list);
> >> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> >> +	}
> >> +
> >> +	spin_unlock_irqrestore(&layer->enq_slock, flags);
> >> +
> >> +	/* give 1 seconds to complete to complete last buffers */
> >> +	setup_timer_on_stack(&watchdog, mxr_watchdog,
> >> +		(unsigned long)layer);
> >> +	mod_timer(&watchdog, jiffies + msecs_to_jiffies(1000));
> >> +
> >> +	/* wait until all buffers are goes to done state */
> >> +	vb2_wait_for_all_buffers(vq);
> >> +
> >> +	/* stop timer if all synchronization is done */
> >> +	del_timer_sync(&watchdog);
> >> +	destroy_timer_on_stack(&watchdog);
> >> +
> >> +	/* stopping hardware */
> >> +	spin_lock_irqsave(&layer->enq_slock, flags);
> >> +	layer->state = MXR_LAYER_IDLE;
> >> +	spin_unlock_irqrestore(&layer->enq_slock, flags);
> >> +
> >> +	/* disabling layer in hardware */
> >> +	layer->ops.stream_set(layer, MXR_DISABLE);
> >> +	/* remove one streamer */
> >> +	mxr_streamer_put(mdev);
> >> +	/* allow changes in output configuration */
> >> +	mxr_output_put(mdev);
> >> +	return 0;
> >> +}
> >> +
> >> +static struct vb2_ops mxr_video_qops = {
> >> +	.queue_setup = queue_setup,
> >> +	.buf_queue = buf_queue,
> >> +	.wait_prepare = wait_unlock,
> >> +	.wait_finish = wait_lock,
> >> +	.start_streaming = start_streaming,
> >> +	.stop_streaming = stop_streaming,
> >> +};
> >> +
> >> +/* FIXME: itry to put this functions to mxr_base_layer_create */
> >> +int mxr_base_layer_register(struct mxr_layer *layer)
> >> +{
> >> +	struct mxr_device *mdev = layer->mdev;
> >> +	int ret;
> >> +
> >> +	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
> >> +	if (ret)
> >> +		mxr_err(mdev, "failed to register video device\n");
> >> +	else
> >> +		mxr_info(mdev, "registered layer %s as /dev/video%d\n",
> >> +			layer->vfd.name, layer->vfd.num);
> >> +	return ret;
> >> +}
> >> +
> >> +void mxr_base_layer_unregister(struct mxr_layer *layer)
> >> +{
> >> +	video_unregister_device(&layer->vfd);
> >> +}
> >> +
> >> +void mxr_layer_release(struct mxr_layer *layer)
> >> +{
> >> +	if (layer->ops.release)
> >> +		layer->ops.release(layer);
> >> +}
> >> +
> >> +void mxr_base_layer_release(struct mxr_layer *layer)
> >> +{
> >> +	kfree(layer);
> >> +}
> >> +
> >> +static void mxr_vfd_release(struct video_device *vdev)
> >> +{
> >> +	printk(KERN_INFO "video device release\n");
> >> +}
> >> +
> >> +struct mxr_layer *mxr_base_layer_create(struct mxr_device *mdev,
> >> +	int idx, char *name, struct mxr_layer_ops *ops)
> >> +{
> >> +	struct mxr_layer *layer;
> >> +
> >> +	layer = kzalloc(sizeof *layer, GFP_KERNEL);
> >> +	if (layer == NULL) {
> >> +		mxr_err(mdev, "not enough memory for layer.\n");
> >> +		goto fail;
> >> +	}
> >> +
> >> +	layer->mdev = mdev;
> >> +	layer->idx = idx;
> >> +	layer->ops = *ops;
> >> +
> >> +	spin_lock_init(&layer->enq_slock);
> >> +	INIT_LIST_HEAD(&layer->enq_list);
> >> +	mutex_init(&layer->mutex);
> >> +
> >> +	layer->vfd = (struct video_device) {
> >> +		.minor = -1,
> >> +		.release = mxr_vfd_release,
> >> +		.fops = &mxr_fops,
> >> +		.ioctl_ops = &mxr_ioctl_ops,
> >> +	};
> >> +	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
> >> +
> >> +	video_set_drvdata(&layer->vfd, layer);
> >> +	layer->vfd.lock = &layer->mutex;
> >> +	layer->vfd.v4l2_dev = &mdev->v4l2_dev;
> >> +
> >> +	layer->vb_queue = (struct vb2_queue) {
> >> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
> >> +		.io_modes = VB2_MMAP | VB2_USERPTR,
> >> +		.drv_priv = layer,
> >> +		.buf_struct_size = sizeof(struct mxr_buffer),
> >> +		.ops = &mxr_video_qops,
> >> +		.mem_ops = &vb2_dma_contig_memops,
> >> +	};
> >> +
> >> +	return layer;
> >> +
> >> +fail:
> >> +	return NULL;
> >> +}
> >> +
> >> +static const struct mxr_format *find_format_by_fourcc(
> >> +	struct mxr_layer *layer, unsigned long fourcc)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < layer->fmt_array_size; ++i)
> >> +		if (layer->fmt_array[i]->fourcc == fourcc)
> >> +			return layer->fmt_array[i];
> >> +	return NULL;
> >> +}
> >> +
> >> +static const struct mxr_format *find_format_by_index(
> >> +	struct mxr_layer *layer, unsigned long index)
> >> +{
> >> +	if (index >= layer->fmt_array_size)
> >> +		return NULL;
> >> +	return layer->fmt_array[index];
> >> +}
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
> >> new file mode 100644
> >> index 0000000..88b457e
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/mixer_vp_layer.c
> >> @@ -0,0 +1,207 @@
> >> +/*
> >> + * Samsung TV Mixer driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "mixer.h"
> >> +
> >> +#include "regs-vp.h"
> >> +
> >> +#include <media/videobuf2-dma-contig.h>
> >> +
> >> +/* FORMAT DEFINITIONS */
> >> +static const struct mxr_format mxr_fmt_nv12 = {
> >> +	.name = "NV12",
> >> +	.fourcc = V4L2_PIX_FMT_NV12,
> >> +	.num_planes = 2,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 1 },
> >> +		{ .width = 2, .height = 2, .size = 2 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fmt_nv21 = {
> >> +	.name = "NV21",
> >> +	.fourcc = V4L2_PIX_FMT_NV21,
> >> +	.num_planes = 2,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 1 },
> >> +		{ .width = 2, .height = 2, .size = 2 },
> >> +	},
> >> +	.num_subframes = 1,
> >> +	.cookie = VP_MODE_NV21 | VP_MODE_MEM_LINEAR,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fmt_nv12m = {
> >> +	.name = "NV12 (mplane)",
> >> +	.fourcc = V4L2_PIX_FMT_NV12M,
> >> +	.num_planes = 2,
> >> +	.plane = {
> >> +		{ .width = 1, .height = 1, .size = 1 },
> >> +		{ .width = 2, .height = 2, .size = 2 },
> >> +	},
> >> +	.num_subframes = 2,
> >> +	.plane2subframe = {0, 1},
> >> +	.cookie = VP_MODE_NV12 | VP_MODE_MEM_LINEAR,
> >> +};
> >> +
> >> +static const struct mxr_format mxr_fmt_nv12mt = {
> >> +	.name = "NV12 tiled (mplane)",
> >> +	.fourcc = V4L2_PIX_FMT_NV12MT,
> >> +	.num_planes = 2,
> >> +	.plane = {
> >> +		{ .width = 128, .height = 32, .size = 4096 },
> >> +		{ .width = 128, .height = 32, .size = 2048 },
> >> +	},
> >> +	.num_subframes = 2,
> >> +	.plane2subframe = {0, 1},
> >> +	.cookie = VP_MODE_NV12 | VP_MODE_MEM_TILED,
> >> +};
> >> +
> >> +static const struct mxr_format *mxr_video_format[] = {
> >> +	&mxr_fmt_nv12,
> >> +	&mxr_fmt_nv21,
> >> +	&mxr_fmt_nv12m,
> >> +	&mxr_fmt_nv12mt,
> >> +};
> >> +
> >> +/* AUXILIARY CALLBACKS */
> >> +
> >> +static void mxr_vp_layer_release(struct mxr_layer *layer)
> >> +{
> >> +	mxr_base_layer_unregister(layer);
> >> +	mxr_base_layer_release(layer);
> >> +}
> >> +
> >> +static void mxr_vp_buffer_set(struct mxr_layer *layer,
> >> +	struct mxr_buffer *buf)
> >> +{
> >> +	dma_addr_t luma_addr[2] = {0, 0};
> >> +	dma_addr_t chroma_addr[2] = {0, 0};
> >> +
> >> +	if (buf == NULL) {
> >> +		mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
> >> +		return;
> >> +	}
> >> +	luma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 0);
> >> +	if (layer->fmt->num_subframes == 2) {
> >> +		chroma_addr[0] = vb2_dma_contig_plane_paddr(&buf->vb, 1);
> >> +	} else {
> >> +		/* FIXME: mxr_get_plane_size compute integer division,
> >> +		 * which is slow and should not be performed in interrupt */
> >> +		chroma_addr[0] = luma_addr[0] + mxr_get_plane_size(
> >> +			&layer->fmt->plane[0], layer->geo.src.full_width,
> >> +			layer->geo.src.full_height);
> >> +	}
> >> +	if (layer->fmt->cookie & VP_MODE_MEM_TILED) {
> >> +		luma_addr[1] = luma_addr[0] + 0x40;
> >> +		chroma_addr[1] = chroma_addr[0] + 0x40;
> >> +	} else {
> >> +		luma_addr[1] = luma_addr[0] + layer->geo.src.full_width;
> >> +		chroma_addr[1] = chroma_addr[0];
> >> +	}
> >> +	mxr_reg_vp_buffer(layer->mdev, luma_addr, chroma_addr);
> >> +}
> >> +
> >> +static void mxr_vp_stream_set(struct mxr_layer *layer, int en)
> >> +{
> >> +	mxr_reg_vp_layer_stream(layer->mdev, en);
> >> +}
> >> +
> >> +static void mxr_vp_format_set(struct mxr_layer *layer)
> >> +{
> >> +	mxr_reg_vp_format(layer->mdev, layer->fmt, &layer->geo);
> >> +}
> >> +
> >> +static void mxr_vp_fix_geometry(struct mxr_layer *layer)
> >> +{
> >> +	struct mxr_geometry *geo = &layer->geo;
> >> +
> >> +	/* align horizontal size to 8 pixels */
> >> +	geo->src.full_width = ALIGN(geo->src.full_width, 8);
> >> +	/* limit to boundary size */
> >> +	geo->src.full_width = clamp_val(geo->src.full_width, 8, 8192);
> >> +	geo->src.full_height = clamp_val(geo->src.full_height, 1, 8192);
> >> +	geo->src.width = clamp_val(geo->src.width, 32, geo->src.full_width);
> >> +	geo->src.width = min(geo->src.width, 2047U);
> >> +	geo->src.height = clamp_val(geo->src.height, 4, geo->src.full_height);
> >> +	geo->src.height = min(geo->src.height, 2047U);
> >> +
> >> +	/* setting size of output window */
> >> +	geo->dst.width = clamp_val(geo->dst.width, 8, geo->dst.full_width);
> >> +	geo->dst.height = clamp_val(geo->dst.height, 1, geo->dst.full_height);
> >> +
> >> +	/* ensure that scaling is in range 1/4x to 16x */
> >> +	if (geo->src.width >= 4 * geo->dst.width)
> >> +		geo->src.width = 4 * geo->dst.width;
> >> +	if (geo->dst.width >= 16 * geo->src.width)
> >> +		geo->dst.width = 16 * geo->src.width;
> >> +	if (geo->src.height >= 4 * geo->dst.height)
> >> +		geo->src.height = 4 * geo->dst.height;
> >> +	if (geo->dst.height >= 16 * geo->src.height)
> >> +		geo->dst.height = 16 * geo->src.height;
> >> +
> >> +	/* setting scaling ratio */
> >> +	geo->x_ratio = (geo->src.width << 16) / geo->dst.width;
> >> +	geo->y_ratio = (geo->src.height << 16) / geo->dst.height;
> >> +
> >> +	/* adjust offsets */
> >> +	geo->src.x_offset = min(geo->src.x_offset,
> >> +		geo->src.full_width - geo->src.width);
> >> +	geo->src.y_offset = min(geo->src.y_offset,
> >> +		geo->src.full_height - geo->src.height);
> >> +	geo->dst.x_offset = min(geo->dst.x_offset,
> >> +		geo->dst.full_width - geo->dst.width);
> >> +	geo->dst.y_offset = min(geo->dst.y_offset,
> >> +		geo->dst.full_height - geo->dst.height);
> >> +}
> >> +
> >> +/* PUBLIC API */
> >> +
> >> +struct mxr_layer *mxr_vp_layer_create(struct mxr_device *mdev, int idx)
> >> +{
> >> +	struct mxr_layer *layer;
> >> +	int ret;
> >> +	struct mxr_layer_ops ops = {
> >> +		.release = mxr_vp_layer_release,
> >> +		.buffer_set = mxr_vp_buffer_set,
> >> +		.stream_set = mxr_vp_stream_set,
> >> +		.format_set = mxr_vp_format_set,
> >> +		.fix_geometry = mxr_vp_fix_geometry,
> >> +	};
> >> +	char name[32];
> >> +
> >> +	sprintf(name, "video%d", idx);
> >> +
> >> +	layer = mxr_base_layer_create(mdev, idx, name, &ops);
> >> +	if (layer == NULL) {
> >> +		mxr_err(mdev, "failed to initialize layer(%d) base\n", idx);
> >> +		goto fail;
> >> +	}
> >> +
> >> +	layer->fmt_array = mxr_video_format;
> >> +	layer->fmt_array_size = ARRAY_SIZE(mxr_video_format);
> >> +
> >> +	ret = mxr_base_layer_register(layer);
> >> +	if (ret)
> >> +		goto fail_layer;
> >> +
> >> +	return layer;
> >> +
> >> +fail_layer:
> >> +	mxr_base_layer_release(layer);
> >> +
> >> +fail:
> >> +	return NULL;
> >> +}
> >> +
> >>     
> >
> > Regards,
> >
> > 	Hans
> >
> >   
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Regards,

	Hans
