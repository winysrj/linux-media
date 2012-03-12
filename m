Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:25259 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab2CLFDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 01:03:08 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0R003TS9W3ESM0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Mar 2012 14:03:06 +0900 (KST)
Received: from DOJIUNYU01 ([12.23.119.65])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0R00J50A151W40@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Mon, 12 Mar 2012 14:03:06 +0900 (KST)
From: =?utf-8?B?7Jyg7KeA7Jq0?= <jiun.yu@samsung.com>
To: 'Tomasz Stanislawski' <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, hatim.rv@samsung.com,
	prashanth.g@samsung.com, younglak1004.kim@samsung.com,
	june.bae@samsung.com, a.sim@samsung.com
References: <014f01ccf6d1$b7340820$259c1860$%yu@samsung.com>
 <4F54EEDB.9020506@samsung.com>
In-reply-to: <4F54EEDB.9020506@samsung.com>
Subject: RE: [PATCH] media: s5p-tv: support mc framework
Date: Mon, 12 Mar 2012 14:03:05 +0900
Message-id: <000901cd000d$68b8f8a0$3a2ae9e0$%yu@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz

Thanks for detailed review.
I wrote my opinion below.
Please review again.


On 03/06/12 1:51 AM, Tomasz Stanislawski wrote:
>Hi Jiun Yu,
>Thanks for proposing this patch. I was considering moving
>V4L2 TV drivers to Media Controller framework. I am glad that this patch
>was posted.
>
>However, there are still some important issues.
>Please refer to the comments below.
>
>On 02/29/2012 12:03 PM, Jiun Yu wrote:
>> From: Jiun Yu<jiun.yu@samsung.com>
>>
>> Samsung Exynos tv subsystem is composed of video processor, mixer,
>> HDMI Tx and analog TV. Each h/w IP becomes a entity and also inputs of
>> video and graphic layers become entities in media controller framework
>like below figure.
>>
>> +-------------+-+       +-+--------------+-+       +-+----------------+-+
>> | mxr-vd-grp0 |0| ----> |0| mxr-sd-grp0  |1| ----> | |                | |
>> +-------------+-+       +-+--------------+-+       |0|                | |       +-+---------+
>>                                                    | |                | | ----> |0| hdmi-sd |
>> +-------------+-+       +-+--------------+-+       +-+                | |       +-+---------+
>> | mxr-vd-grp1 |0| ----> |0| mxr-sd-grp1  |1| ----> | |                | |
>> +-------------+-+       +-+--------------+-+       |1| mxr-sd-blender |3|
>>                                                    | |                | |
>>                         +-+--------------+-+       +-+                | |       +-+---------+
>>                         |0| mxr-sd-video |1| ----> | |                | | ----> |0| sdo-sd  |
>>                         +-+--------------+-+       |2|                | |       +-+---------+
>>                                                    | |                | |
>>                                                    +-+----------------+-+
>
>What is the purpose for separating mxr-vd-* from mxr-sd-*.
>There is no additional HW chip hidden behind mxr-sd-* subdev.
I separated logically mixer h/w as 4 parts. So, mxr-sd-grp0, mxr-sd-grp1 and
mxr-sd-video are part of mixer h/w. These represent each fetcher in mixer h/w.
And mxr-sd-blender represents Blender in mixer h/w. Because, it's easy to handle
mixer by each layer. And mixer can be set destination coordinates. How do you set
destination coordinates in case of using multiple layers at the same time?
I think mxr-sd-grp0 pad1, mxr-sd-grp1 pad1, mxr-sd-video pad1 and
mxr-sd-blender Pad 0,1,2 will be set by SUBDEV_S_FMT/SUBDEV_S_CROP and etc.

>
>Using mxr-sd-video is rational because this subdev refers to VideoProcessor.
mxr-sd-video subdev didn't represent VideoProcessor. It's just video fetcher in mixer h/w

>This chip may makes use of its controls like brightness/contrast adjustment
>or image filtering.
>But why mxr-sd-video is not connected to any video node?
I have to consider exynos4210 as well as exynos5250. The Gscaler is supported on
Exynos5250 instead of VideoProcessor. VideoProcessor is dedicated scaler of tv 
Subsystem. But Gscaler is general scaler. So, gscaler subdev entity can be
connected to mxr-sd-video subdev.


>
>What do you think about following topology:
>
>                         +-+--------------+-+       +-+----------------+-+
>                         |0| mxr-vd-grp0  |1| ----> | |                | |
>                         +-+--------------+-+       |0|                | |       +-+---------+
>                                                    | |                | | ----> |0| hdmi-sd |
>                         +-+--------------+-+       +-+                | |       +-+---------+
>                         |0| mxr-vd-grp1  |1| ----> | |                | |
>                         +-+--------------+-+       |1| mxr-sd-blender |3|
>                                                    | |                | |
> +-------------+-+       +-+--------------+-+       +-+                | |       +-+---------+
> | mxr-vd-video|0| ----> |0|   mxr-sd-vp  |1| ----> | |                | | ----> |0| sdo-sd  |
> +-------------+-+       +-+--------------+-+       |2|                | |       +-+---------+
>                                                    | |                | |
>                                                    +-+----------------+-+
>
>It is much simpler because if contains 4 subdevs instead of 6 and allows to
>use every data sink as video node.
>
>>
>> * mxr-vd-grp0
>>    video device type entity
>>    input of graphic0 layer
>>
>> * mxr-vd-grp1
>>    video device type entity
>>    input of graphic1 layer
>>
>> * mxr-sd-grp0
>>    sub-device type entity
>>    graphic0 layer part of mixer
>>
>> * mxr-sd-grp1
>>    sub-device type entity
>>    graphic1 layer part of mixer
>>
>> * mxr-sd-video
>>    sub-device type entity
>>    video layer part of mixer
>
>I prefer to call it mxr-sd-vp (Video Processor).
mxr-sd-video represents video fetcher of mixer h/w. So, I think mxr-sd-video is better.

>>
>> * mxr-sd-blender
>>    sub-device type entity
>>    blender part of mixer
>
>Would it be better to use name 'mxr-sd-mixer' instead of 'mxr-sd-blender'?
>The chip is called 'Mixer". The 'Blender' is some internal subblock of
>Mixer.
mxr-sd-blender means blender part of mixer h/w. So I think mxr-sd-blender is better.

>
>>
>> * hdmi-sd
>>    sub-device type entity
>>    hdmi tx
>
>In future we should consider adding entities like HDMIPHY and MHL to MC
>topology.
>For now let HDMI driver deal with its slave devices.
If user cannot access HDMIPHY and MHL subdev directly,
I think it's unnecessary to make entities like HDMIPHY and MHL

>
>>
>> * sdo-sd
>>    sub-device type entity
>>    analog TV-out
>>
>> Signed-off-by: Jiun Yu<jiun.yu@samsung.com>
>> ---
>>   drivers/media/video/s5p-tv/hdmi_drv.c        |   77 ++++++++-
>>   drivers/media/video/s5p-tv/mixer.h           |   52 ++++++
>>   drivers/media/video/s5p-tv/mixer_drv.c       |  224
>++++++++++++++++++++++++++
>>   drivers/media/video/s5p-tv/mixer_grp_layer.c |    2 +-
>>   drivers/media/video/s5p-tv/mixer_video.c     |  127 ++++++++-------
>>   drivers/media/video/s5p-tv/sdo_drv.c         |   75 ++++++++-
>>   6 files changed, 478 insertions(+), 79 deletions(-)
>>
>> diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c
>> b/drivers/media/video/s5p-tv/hdmi_drv.c
>> index 8b41a04..4c3cb7b 100644
>> --- a/drivers/media/video/s5p-tv/hdmi_drv.c
>> +++ b/drivers/media/video/s5p-tv/hdmi_drv.c
>> @@ -33,6 +33,8 @@
>>   #include<media/v4l2-common.h>
>>   #include<media/v4l2-dev.h>
>>   #include<media/v4l2-device.h>
>> +#include<media/v4l2-subdev.h>
>> +#include<media/exynos_mc.h>
>>
>>   #include "regs-hdmi.h"
>>
>> @@ -42,6 +44,10 @@ MODULE_LICENSE("GPL");
>>
>>   /* default preset configured on probe */
>>   #define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
>> +/* sink pad number of hdmi subdev */
>> +#define HDMI_PAD_SINK	0
>> +/* number of hdmi subdev pads */
>> +#define HDMI_PADS_NUM	1
>>
>>   struct hdmi_resources {
>>   	struct clk *hdmi;
>> @@ -62,6 +68,8 @@ struct hdmi_device {
>>   	struct device *dev;
>>   	/** subdev generated by HDMI device */
>>   	struct v4l2_subdev sd;
>> +	/** sink pad of hdmi subdev */
>> +	struct media_pad pad;
>>   	/** V4L2 device structure */
>>   	struct v4l2_device v4l2_dev;
>>   	/** subdev of HDMIPHY interface */
>> @@ -863,12 +871,68 @@ fail:
>>   	return -ENODEV;
>>   }
>>
>> +static int hdmi_link_setup(struct media_entity *entity,
>> +			      const struct media_pad *local,
>> +			      const struct media_pad *remote, u32 flags) {
>> +	return 0;
>> +}
>> +
>> +/* hdmi entity operations */
>> +static const struct media_entity_operations hdmi_entity_ops = {
>> +	.link_setup = hdmi_link_setup,
>> +};
>> +
>> +static int hdmi_register_entity(struct hdmi_device *hdev) {
>> +	struct v4l2_subdev *sd =&hdev->sd;
>> +	struct media_pad *pad =&hdev->pad;
>> +	struct media_entity *me =&sd->entity;
>> +	struct device *dev = hdev->dev;
>> +	struct exynos_md *md;
>> +	int ret;
>> +
>> +	dev_dbg(dev, "HDMI entity init\n");
>> +
>
>Why this code (till [end]) was moved from hdmi_probe?
Below code is for initialize hdmi subdev. I think it's related to
make hdmi subdev as a entity.

>
>> +	/* init hdmi subdev */
>> +	v4l2_subdev_init(sd,&hdmi_sd_ops);
>> +	sd->owner = THIS_MODULE;
>> +	strlcpy(sd->name, "hdmi-sd", sizeof(sd->name));
>> +
>> +	dev_set_drvdata(dev, sd);
>
>[end]
>
>> +
>> +	/* init hdmi subdev as entity */
>> +	pad[HDMI_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +	me->ops =&hdmi_entity_ops;
>> +	ret = media_entity_init(me, HDMI_PADS_NUM, pad, 0);
>> +	if (ret) {
>> +		dev_err(dev, "failed to initialize media entity\n");
>> +		return ret;
>> +	}
>> +
>> +	/* get output media ptr for registering hdmi's sd */
>> +	md = (struct exynos_md
>> +*)module_name_to_driver_data(MDEV_MODULE_NAME);
>
>The dependency between S5P-HDMI and EXYNOS_MD should be reflected in
>Kconfig.
Yes. It's necessary.
>
>> +	if (!md) {
>> +		dev_err(dev, "failed to get output media device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* regiser HDMI subdev as entity to v4l2_dev pointer of
>> +	 * output media device */
>> +	ret = v4l2_device_register_subdev(&md->v4l2_dev, sd);
>> +	if (ret) {
>> +		dev_err(dev, "failed to register HDMI subdev\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int __devinit hdmi_probe(struct platform_device *pdev)
>>   {
>>   	struct device *dev =&pdev->dev;
>>   	struct resource *res;
>>   	struct i2c_adapter *phy_adapter;
>> -	struct v4l2_subdev *sd;
>>   	struct hdmi_device *hdmi_dev = NULL;
>>   	struct hdmi_driver_data *drv_data;
>>   	int ret;
>> @@ -950,17 +1014,14 @@ static int __devinit hdmi_probe(struct
>> platform_device *pdev)
>>
>>   	pm_runtime_enable(dev);
>>
>> -	sd =&hdmi_dev->sd;
>> -	v4l2_subdev_init(sd,&hdmi_sd_ops);
>> -	sd->owner = THIS_MODULE;
>> -
>> -	strlcpy(sd->name, "s5p-hdmi", sizeof sd->name);
>>   	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
>>   	/* FIXME: missing fail preset is not supported */
>>   	hdmi_dev->cur_conf = hdmi_preset2conf(hdmi_dev->cur_preset);
>>
>> -	/* storing subdev for call that have only access to struct device */
>> -	dev_set_drvdata(dev, sd);
>> +	/* register hdmi subdev as entity */
>> +	ret = hdmi_register_entity(hdmi_dev);
>> +	if (ret)
>> +		goto fail_vdev;
>>
>>   	dev_info(dev, "probe sucessful\n");
>>
>> diff --git a/drivers/media/video/s5p-tv/mixer.h
>> b/drivers/media/video/s5p-tv/mixer.h
>> index 1597078..2f6b773 100644
>> --- a/drivers/media/video/s5p-tv/mixer.h
>> +++ b/drivers/media/video/s5p-tv/mixer.h
>> @@ -23,18 +23,43 @@
>>   #include<linux/spinlock.h>
>>   #include<linux/wait.h>
>>   #include<media/v4l2-device.h>
>> +#include<media/v4l2-subdev.h>
>>   #include<media/videobuf2-core.h>
>>
>>   #include "regs-mixer.h"
>>
>>   /** maximum number of output interfaces */
>>   #define MXR_MAX_OUTPUTS 2
>> +/** index of graphic0 layer */
>> +#define MXR_GRP0_LAYER	0
>> +/** index of graphic1 layer */
>> +#define MXR_GRP1_LAYER	1
>> +/** index of video layer */
>> +#define MXR_VIDEO_LAYER	2
>>   /** maximum number of input interfaces (layers) */
>>   #define MXR_MAX_LAYERS 3
>>   #define MXR_DRIVER_NAME "s5p-mixer"
>>   /** maximal number of planes for every layer */
>>   #define MXR_MAX_PLANES	2
>>
>> +/** sink pad of each layer subdev */
>> +#define MXR_PAD_SINK		0
>> +/** source pad of each layer subdev */
>> +#define MXR_PAD_SOURCE		1
>> +/** sink pad of blender connected to graphic0 layer subdev */
>> +#define MXR_PAD_SINK_GRP0	0
>> +/** sink pad of blender connected to graphic1 layer subdev */
>> +#define MXR_PAD_SINK_GRP1	1
>> +/** sink pad of blender connected to video layer subdev */
>> +#define MXR_PAD_SINK_VIDEO	2
>> +/** source pad of blender connected to hdmi subdev */
>> +#define MXR_PAD_SOURCE_OUTPUT	3
>> +
>> +/** maximum pad number of mixer subdev */
>> +#define MXR_PADS_NUM	2
>> +/** maximum pad number of blender subdev */
>> +#define MXR_BLENDER_PADS_NUM	4
>> +
>>   #define MXR_ENABLE 1
>>   #define MXR_DISABLE 0
>>
>> @@ -117,6 +142,12 @@ struct mxr_buffer {
>>   	struct list_head	list;
>>   };
>>
>> +/** TV graphic layer pipeline structure for streaming media data */
>> +struct tv_graph_pipeline {
>> +	struct media_pipeline pipe;
>> +	/** starting point on pipeline */
>> +	struct mxr_layer *layer;
>> +};
>>
>>   /** internal states of layer */
>>   enum mxr_layer_state {
>> @@ -176,12 +207,21 @@ struct mxr_layer {
>>   	struct mutex mutex;
>>   	/** handler for video node */
>>   	struct video_device vfd;
>> +	/** source pad of mixer video device */
>> +	struct media_pad vd_pad;
>>   	/** queue for output buffers */
>>   	struct vb2_queue vb_queue;
>>   	/** current image format */
>>   	const struct mxr_format *fmt;
>>   	/** current geometry of image */
>>   	struct mxr_geometry geo;
>> +
>> +	/** each layer subdev of a mixer */
>> +	struct v4l2_subdev sd;
>> +	/** pads for each layer subdev */
>> +	struct media_pad sd_pads[MXR_PADS_NUM];
>> +	/** pipeline structure for streaming TV graphic layer */
>> +	struct tv_graph_pipeline pipe;
>>   };
>>
>>   /** description of mixers output interface */ @@ -263,6 +303,11 @@
>> struct mxr_device {
>>   	int current_output;
>>   	/** auxiliary resources used my mixer */
>>   	struct mxr_resources res;
>> +
>> +	/** subdev of mixer blender */
>> +	struct v4l2_subdev sd;
>> +	/** pads of mixer blender */
>> +	struct media_pad pads[MXR_BLENDER_PADS_NUM];
>>   };
>>
>>   /** transform device structure into mixer device */ @@ -272,6
>> +317,13 @@ static inline struct mxr_device *to_mdev(struct device *dev)
>>   	return container_of(vdev, struct mxr_device, v4l2_dev);
>>   }
>>
>> +/** transform subdev structure into mixer device */ static inline
>> +struct mxr_device *sd_to_mdev(struct v4l2_subdev *sd) {
>> +	struct mxr_layer *layer = container_of(sd, struct mxr_layer, sd);
>> +	return layer->mdev;
>> +}
>> +
>>   /** get current output data, should be called under mdev's mutex */
>>   static inline struct mxr_output *to_output(struct mxr_device *mdev)
>>   {
>> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c
>> b/drivers/media/video/s5p-tv/mixer_drv.c
>> index 0064309..a07cd1e 100644
>> --- a/drivers/media/video/s5p-tv/mixer_drv.c
>> +++ b/drivers/media/video/s5p-tv/mixer_drv.c
>> @@ -23,6 +23,8 @@
>>   #include<linux/pm_runtime.h>
>>   #include<linux/clk.h>
>>
>> +#include<media/exynos_mc.h>
>> +
>>   MODULE_AUTHOR("Tomasz Stanislawski,<t.stanislaws@samsung.com>");
>>   MODULE_DESCRIPTION("Samsung MIXER");
>>   MODULE_LICENSE("GPL");
>> @@ -370,6 +372,213 @@ static const struct dev_pm_ops mxr_pm_ops = {
>>   	.runtime_resume	 = mxr_runtime_resume,
>>   };
>>
>> +/* ---------- MEDIA CONTROLLER MANAGEMENT ----------- */
>> +
>> +static int mxr_s_stream(struct v4l2_subdev *sd, int enable) {
>> +	struct mxr_device *mdev = sd_to_mdev(sd);
>> +
>> +	if (enable)
>> +		mxr_streamer_get(mdev);
>> +	else
>> +		mxr_streamer_put(mdev);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_subdev_video_ops mxr_sd_video_ops = {
>> +	.s_stream = mxr_s_stream,
>> +};
>> +
>> +static const struct v4l2_subdev_ops mxr_sd_ops = {
>> +	.video =&mxr_sd_video_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_ops blend_sd_ops = { };
>
>what is the purpose of introducing the subdev that does nothing.
>Maybe you should add at least s_stream.
Yes. But I think adding "to be implemented" comment is better.

>
>> +
>> +static int mxr_link_setup(struct media_entity *entity,
>> +			      const struct media_pad *local,
>> +			      const struct media_pad *remote, u32 flags) {
>> +	return 0;
>
>There might be a bug here.
>Returning zero indicate that mixer subdev can be connected with any other
>subdev. Is it correct?
Links are already created when probing tv driver. User just can enable or disable
Flag of link. User cannot create lilnks.

>
>> +}
>> +
>> +/* mixer entity operations */
>> +static const struct media_entity_operations mxr_entity_ops = {
>> +	.link_setup = mxr_link_setup,
>> +};
>> +
>> +static int mxr_register_entities(struct mxr_device *mdev) {
>> +	struct v4l2_subdev *sd;
>> +	struct v4l2_subdev *blend_sd;
>> +	struct media_pad *pads;
>> +	struct media_pad *blend_pads;
>> +	struct media_entity *me;
>> +	struct media_entity *blend_me;
>> +	struct exynos_md *md;
>> +	int ret, i;
>> +
>> +	mxr_dbg(mdev, "initialize and register mixer entities\n");
>> +
>> +	md = (struct exynos_md
>> +*)module_name_to_driver_data(MDEV_MODULE_NAME);
>
>no dependency in Kconfig
Yes. It's necessary.
>
>> +	if (!md) {
>> +		mxr_err(mdev, "failed to get output media device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* initialize and register each layer subdev of mixer */
>> +	for (i = 0; i<  MXR_MAX_LAYERS; ++i) {
>> +		sd =&mdev->layer[i]->sd;
>> +		pads = mdev->layer[i]->sd_pads;
>> +		me =&sd->entity;
>> +
>> +		v4l2_subdev_init(sd,&mxr_sd_ops);
>> +		sd->owner = THIS_MODULE;
>> +
>> +		if (i == MXR_VIDEO_LAYER)
>> +			sprintf(sd->name, "mxr-sd-video");
>> +		else
>> +			sprintf(sd->name, "mxr-sd-grp%d", i);
>> +
>> +		pads[MXR_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +		pads[MXR_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +		me->ops =&mxr_entity_ops;
>> +
>> +		ret = media_entity_init(me, MXR_PADS_NUM, pads, 0);
>> +		if (ret) {
>> +			mxr_err(mdev, "failed to initialize media entity\n");
>> +			return ret;
>> +		}
>> +
>> +		ret = v4l2_device_register_subdev(&md->v4l2_dev, sd);
>> +		if (ret) {
>> +			mxr_err(mdev, "failed to register mixer subdev\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>> +	/* initialize and register mixer blender */
>> +	blend_sd =&mdev->sd;
>> +	blend_pads = mdev->pads;
>> +	blend_me =&blend_sd->entity;
>> +
>> +	v4l2_subdev_init(blend_sd,&blend_sd_ops);
>> +	sd->owner = THIS_MODULE;
>> +
>> +	sprintf(blend_sd->name, "mxr-sd-blender");
>> +
>> +	blend_pads[MXR_PAD_SINK_GRP0].flags = MEDIA_PAD_FL_SINK;
>> +	blend_pads[MXR_PAD_SINK_GRP1].flags = MEDIA_PAD_FL_SINK;
>> +	blend_pads[MXR_PAD_SINK_VIDEO].flags = MEDIA_PAD_FL_SINK;
>> +	blend_pads[MXR_PAD_SOURCE_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
>> +
>> +	blend_me->ops =&mxr_entity_ops;
>> +
>> +	ret = media_entity_init(blend_me, MXR_BLENDER_PADS_NUM, blend_pads,
>0);
>> +	if (ret) {
>> +		mxr_err(mdev, "failed to initialize media entity\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = v4l2_device_register_subdev(&md->v4l2_dev, blend_sd);
>> +	if (ret) {
>> +		mxr_err(mdev, "failed to register mixer subdev\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void mxr_unregister_entities(struct mxr_device *mdev) {
>> +	int i;
>> +
>> +	/* unregister subdevs of all layers */
>> +	for (i = 0; i<  MXR_MAX_LAYERS; ++i)
>> +		v4l2_device_unregister_subdev(&mdev->layer[i]->sd);
>> +
>> +	/* unregister blender subdev */
>> +	v4l2_device_unregister_subdev(&mdev->sd);
>> +}
>> +
>> +static void mxr_entities_info_print(struct mxr_device *mdev) {
>> +	struct media_entity *me;
>> +	int i;
>> +
>> +	for (i = 0; i<  MXR_VIDEO_LAYER; ++i) {
>> +		me =&mdev->layer[i]->vfd.entity;
>> +		entity_info_print(me, mdev->dev);
>> +	}
>> +
>> +	for (i = 0; i<  MXR_MAX_LAYERS; ++i) {
>> +		me =&mdev->layer[i]->sd.entity;
>> +		entity_info_print(me, mdev->dev);
>> +	}
>> +
>> +	me =&mdev->sd.entity;
>> +	entity_info_print(me, mdev->dev);
>> +
>> +	for (i = 0; i<  mdev->output_cnt; ++i) {
>> +		me =&mdev->output[i]->sd->entity;
>> +		entity_info_print(me, mdev->dev);
>> +	}
>> +}
>> +
>> +static int mxr_create_links(struct mxr_device *mdev) {
>> +	struct media_entity *source, *sink;
>> +	char err[80];
>> +	int ret, i;
>> +
>> +	mxr_dbg(mdev, "%s start\n", __func__);
>> +
>> +	memset(err, 0, sizeof(err));
>> +
>> +	/* create link between graphic layer vd to graphic layer sd */
>> +	for (i = 0; i<  MXR_VIDEO_LAYER; ++i) {
>> +		source =&mdev->layer[i]->vfd.entity;
>> +		sink =&mdev->layer[i]->sd.entity;
>> +		ret = media_entity_create_link(source, 0, sink, MXR_PAD_SINK,
>0);
>> +		if (ret) {
>> +			sprintf(err, "%s ->  %s", source->name, sink->name);
>> +			goto fail;
>> +		}
>> +	}
>> +
>> +	/* create link between all layers sd to blender sd*/
>> +	for (i = 0; i<  MXR_MAX_LAYERS; ++i) {
>> +		source =&mdev->layer[i]->sd.entity;
>> +		sink =&mdev->sd.entity;
>> +		ret = media_entity_create_link(source, MXR_PAD_SOURCE, sink,
>i, 0);
>> +		if (ret) {
>> +			sprintf(err, "%s ->  %s", source->name, sink->name);
>> +			goto fail;
>> +		}
>> +	}
>> +
>> +	/* create link between blender to output devices */
>> +	for (i = 0; i<  mdev->output_cnt; ++i) {
>> +		source =&mdev->sd.entity;
>> +		sink =&mdev->output[i]->sd->entity;
>> +		ret = media_entity_create_link(source, MXR_PAD_SOURCE_OUTPUT,
>> +				sink, 0, 0);
>> +		if (ret) {
>> +			sprintf(err, "%s ->  %s", source->name, sink->name);
>> +			goto fail;
>> +		}
>> +	}
>> +
>> +	return 0;
>> +
>> +fail:
>> +	mxr_err(mdev, "failed to create link : %s\n", err);
>> +	return ret;
>> +}
>> +
>>   /* --------- DRIVER INITIALIZATION ---------- */
>>
>>   static int __devinit mxr_probe(struct platform_device *pdev) @@
>> -410,13 +619,28 @@ static int __devinit mxr_probe(struct platform_device
>*pdev)
>>   	/* configure layers */
>>   	ret = mxr_acquire_layers(mdev, pdata);
>>   	if (ret)
>> +		goto fail_entities;
>> +
>> +	/* register mixer subdevs as entity */
>> +	ret = mxr_register_entities(mdev);
>> +	if (ret)
>>   		goto fail_video;
>>
>> +	/* create all links related to exynos-tv driver */
>> +	ret = mxr_create_links(mdev);
>> +	if (ret)
>> +		goto fail_entities;
>> +
>>   	pm_runtime_enable(dev);
>>
>> +	mxr_entities_info_print(mdev);
>> +
>>   	mxr_info(mdev, "probe successful\n");
>>   	return 0;
>>
>> +fail_entities:
>> +	mxr_unregister_entities(mdev);
>> +
>>   fail_video:
>>   	mxr_release_video(mdev);
>>
>> diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c
>> b/drivers/media/video/s5p-tv/mixer_grp_layer.c
>> index b93a21f..eb29d38 100644
>> --- a/drivers/media/video/s5p-tv/mixer_grp_layer.c
>> +++ b/drivers/media/video/s5p-tv/mixer_grp_layer.c
>> @@ -244,7 +244,7 @@ struct mxr_layer *mxr_graph_layer_create(struct
>mxr_device *mdev, int idx)
>>   	};
>>   	char name[32];
>>
>> -	sprintf(name, "graph%d", idx);
>> +	sprintf(name, "mxr-vd-grp%d", idx);
>>
>>   	layer = mxr_base_layer_create(mdev, idx, name,&ops);
>>   	if (layer == NULL) {
>> diff --git a/drivers/media/video/s5p-tv/mixer_video.c
>> b/drivers/media/video/s5p-tv/mixer_video.c
>> index 7884bae..2ca580b 100644
>> --- a/drivers/media/video/s5p-tv/mixer_video.c
>> +++ b/drivers/media/video/s5p-tv/mixer_video.c
>> @@ -20,69 +20,19 @@
>>   #include<linux/version.h>
>>   #include<linux/timer.h>
>>   #include<media/videobuf2-dma-contig.h>
>> -
>> -static int find_reg_callback(struct device *dev, void *p) -{
>> -	struct v4l2_subdev **sd = p;
>> -
>> -	*sd = dev_get_drvdata(dev);
>> -	/* non-zero value stops iteration */
>> -	return 1;
>> -}
>> -
>> -static struct v4l2_subdev *find_and_register_subdev(
>> -	struct mxr_device *mdev, char *module_name)
>> -{
>> -	struct device_driver *drv;
>> -	struct v4l2_subdev *sd = NULL;
>> -	int ret;
>> -
>> -	/* TODO: add waiting until probe is finished */
>> -	drv = driver_find(module_name,&platform_bus_type);
>> -	if (!drv) {
>> -		mxr_warn(mdev, "module %s is missing\n", module_name);
>> -		return NULL;
>> -	}
>> -	/* driver refcnt is increased, it is safe to iterate over devices */
>> -	ret = driver_for_each_device(drv, NULL,&sd, find_reg_callback);
>> -	/* ret == 0 means that find_reg_callback was never executed */
>> -	if (sd == NULL) {
>> -		mxr_warn(mdev, "module %s provides no subdev!\n",
>module_name);
>> -		goto done;
>> -	}
>> -	/* v4l2_device_register_subdev detects if sd is NULL */
>> -	ret = v4l2_device_register_subdev(&mdev->v4l2_dev, sd);
>> -	if (ret) {
>> -		mxr_warn(mdev, "failed to register subdev %s\n", sd->name);
>> -		sd = NULL;
>> -	}
>> -
>> -done:
>> -	put_driver(drv);
>> -	return sd;
>> -}
>> +#include<media/exynos_mc.h>
>>
>>   int __devinit mxr_acquire_video(struct mxr_device *mdev,
>>   	struct mxr_output_conf *output_conf, int output_count)
>>   {
>> -	struct device *dev = mdev->dev;
>> -	struct v4l2_device *v4l2_dev =&mdev->v4l2_dev;
>>   	int i;
>>   	int ret = 0;
>>   	struct v4l2_subdev *sd;
>>
>> -	strlcpy(v4l2_dev->name, dev_name(mdev->dev), sizeof(v4l2_dev->name));
>> -	/* prepare context for V4L2 device */
>> -	ret = v4l2_device_register(dev, v4l2_dev);
>> -	if (ret) {
>> -		mxr_err(mdev, "could not register v4l2 device.\n");
>> -		goto fail;
>> -	}
>> -
>>   	mdev->alloc_ctx = vb2_dma_contig_init_ctx(mdev->dev);
>>   	if (IS_ERR_OR_NULL(mdev->alloc_ctx)) {
>>   		mxr_err(mdev, "could not acquire vb2 allocator\n");
>> -		goto fail_v4l2_dev;
>> +		goto fail;
>>   	}
>>
>>   	/* registering outputs */
>> @@ -91,7 +41,9 @@ int __devinit mxr_acquire_video(struct mxr_device *mdev,
>>   		struct mxr_output_conf *conf =&output_conf[i];
>>   		struct mxr_output *out;
>>
>> -		sd = find_and_register_subdev(mdev, conf->module_name);
>> +		/* find subdev of output devices */
>> +		sd = (struct v4l2_subdev *)
>> +			module_name_to_driver_data(conf->module_name);
>>   		/* trying to register next output */
>>   		if (sd == NULL)
>>   			continue;
>> @@ -133,10 +85,6 @@ fail_vb2_allocator:
>>   	/* freeing allocator context */
>>   	vb2_dma_contig_cleanup_ctx(mdev->alloc_ctx);
>>
>> -fail_v4l2_dev:
>> -	/* NOTE: automatically unregister all subdevs */
>> -	v4l2_device_unregister(v4l2_dev);
>> -
>>   fail:
>>   	return ret;
>>   }
>> @@ -153,6 +101,28 @@ void __devexit mxr_release_video(struct mxr_device
>*mdev)
>>   	v4l2_device_unregister(&mdev->v4l2_dev);
>>   }
>>
>> +static void tv_graph_pipeline_stream(struct tv_graph_pipeline *pipe, int
>on)
>> +{
>> +	struct mxr_device *mdev = pipe->layer->mdev;
>> +	struct media_entity *me =&pipe->layer->vfd.entity;
>> +	/* source pad of graphic layer entity */
>> +	struct media_pad *pad =&me->pads[0];
>> +	struct v4l2_subdev *sd;
>> +
>> +	mxr_dbg(mdev, "%s TV graphic layer pipeline\n", on ? "start" :
>"stop");
>> +
>> +	/* find remote pad through enabled link */
>> +	pad = media_entity_remote_source(pad);
>> +	if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV
>> +			|| pad == NULL)
>> +		mxr_warn(mdev, "cannot find remote pad\n");
>> +
>> +	sd = media_entity_to_v4l2_subdev(pad->entity);
>> +	mxr_dbg(mdev, "s_stream of %s sub-device is called\n", sd->name);
>> +
>> +	v4l2_subdev_call(sd, video, s_stream, on);
>> +}
>> +
>>   static int mxr_querycap(struct file *file, void *priv,
>>   	struct v4l2_capability *cap)
>>   {
>> @@ -869,12 +839,21 @@ static void buf_queue(struct vb2_buffer *vb)
>>   	struct mxr_buffer *buffer = container_of(vb, struct mxr_buffer, vb);
>>   	struct mxr_layer *layer = vb2_get_drv_priv(vb->vb2_queue);
>>   	struct mxr_device *mdev = layer->mdev;
>> +	struct tv_graph_pipeline *pipe =&layer->pipe;
>>   	unsigned long flags;
>>
>>   	spin_lock_irqsave(&layer->enq_slock, flags);
>>   	list_add_tail(&buffer->list,&layer->enq_list);
>>   	spin_unlock_irqrestore(&layer->enq_slock, flags);
>>
>> +	if (layer->state == MXR_LAYER_STREAMING) {
>> +		layer->ops.stream_set(layer, MXR_ENABLE);
>> +		/* store starting entity ptr on the tv graphic pipeline */
>> +		pipe->layer = layer;
>> +		/* start streaming all entities on the tv graphic pipeline */
>> +		tv_graph_pipeline_stream(pipe, 1);
>> +	}
>> +
>>   	mxr_dbg(mdev, "queuing buffer\n");
>>   }
>>
>> @@ -917,9 +896,6 @@ static int start_streaming(struct vb2_queue *vq,
>unsigned int count)
>>   	layer->state = MXR_LAYER_STREAMING;
>>   	spin_unlock_irqrestore(&layer->enq_slock, flags);
>>
>> -	layer->ops.stream_set(layer, MXR_ENABLE);
>> -	mxr_streamer_get(mdev);
>> -
>>   	return 0;
>>   }
>>
>> @@ -953,6 +929,7 @@ static int stop_streaming(struct vb2_queue *vq)
>>   	unsigned long flags;
>>   	struct timer_list watchdog;
>>   	struct mxr_buffer *buf, *buf_tmp;
>> +	struct tv_graph_pipeline *pipe =&layer->pipe;
>>
>>   	mxr_dbg(mdev, "%s\n", __func__);
>>
>> @@ -988,8 +965,12 @@ static int stop_streaming(struct vb2_queue *vq)
>>
>>   	/* disabling layer in hardware */
>>   	layer->ops.stream_set(layer, MXR_DISABLE);
>> -	/* remove one streamer */
>> -	mxr_streamer_put(mdev);
>> +
>> +	/* starting entity on the pipeline */
>> +	pipe->layer = layer;
>> +	/* stop streaming all entities on the pipeline */
>> +	tv_graph_pipeline_stream(pipe, 0);
>> +
>>   	/* allow changes in output configuration */
>>   	mxr_output_put(mdev);
>>   	return 0;
>> @@ -1008,8 +989,16 @@ static struct vb2_ops mxr_video_qops = {
>>   int mxr_base_layer_register(struct mxr_layer *layer)
>>   {
>>   	struct mxr_device *mdev = layer->mdev;
>> +	struct exynos_md *md;
>>   	int ret;
>>
>> +	md = (struct exynos_md
>*)module_name_to_driver_data(MDEV_MODULE_NAME);
>> +	if (!md) {
>> +		mxr_err(mdev, "failed to get output media device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	layer->vfd.v4l2_dev =&md->v4l2_dev;
>>   	ret = video_register_device(&layer->vfd, VFL_TYPE_GRABBER, -1);
>>   	if (ret)
>>   		mxr_err(mdev, "failed to register video device\n");
>> @@ -1044,6 +1033,7 @@ struct mxr_layer *mxr_base_layer_create(struct
>mxr_device *mdev,
>>   	int idx, char *name, struct mxr_layer_ops *ops)
>>   {
>>   	struct mxr_layer *layer;
>> +	int ret;
>>
>>   	layer = kzalloc(sizeof *layer, GFP_KERNEL);
>>   	if (layer == NULL) {
>> @@ -1065,13 +1055,21 @@ struct mxr_layer *mxr_base_layer_create(struct
>mxr_device *mdev,
>>   		.fops =&mxr_fops,
>>   		.ioctl_ops =&mxr_ioctl_ops,
>>   	};
>> +
>> +	ret = media_entity_init(&layer->vfd.entity, 1,&layer->vd_pad, 0);
>> +	if (ret) {
>> +		mxr_err(mdev, "failed to initialize media entity\n");
>> +		goto fail_alloc;
>> +	}
>> +
>>   	strlcpy(layer->vfd.name, name, sizeof(layer->vfd.name));
>> +	layer->vfd.entity.name = layer->vfd.name;
>> +
>>   	/* let framework control PRIORITY */
>>   	set_bit(V4L2_FL_USE_FH_PRIO,&layer->vfd.flags);
>>
>>   	video_set_drvdata(&layer->vfd, layer);
>>   	layer->vfd.lock =&layer->mutex;
>> -	layer->vfd.v4l2_dev =&mdev->v4l2_dev;
>>
>>   	layer->vb_queue = (struct vb2_queue) {
>>   		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>> @@ -1084,6 +1082,9 @@ struct mxr_layer *mxr_base_layer_create(struct
>mxr_device *mdev,
>>
>>   	return layer;
>>
>> +fail_alloc:
>> +	kfree(layer);
>> +
>>   fail:
>>   	return NULL;
>>   }
>> diff --git a/drivers/media/video/s5p-tv/sdo_drv.c
>b/drivers/media/video/s5p-tv/sdo_drv.c
>> index 059e774..df3ebe0 100644
>> --- a/drivers/media/video/s5p-tv/sdo_drv.c
>> +++ b/drivers/media/video/s5p-tv/sdo_drv.c
>> @@ -24,6 +24,7 @@
>>   #include<linux/slab.h>
>>
>>   #include<media/v4l2-subdev.h>
>> +#include<media/exynos_mc.h>
>>
>>   #include "regs-sdo.h"
>>
>> @@ -32,6 +33,10 @@ MODULE_DESCRIPTION("Samsung Standard Definition Output
>(SDO)");
>>   MODULE_LICENSE("GPL");
>>
>>   #define SDO_DEFAULT_STD	V4L2_STD_PAL
>> +/* sink pad number of sdo subdev */
>> +#define SDO_PAD_SINK	0
>> +/* number of sdo subdev pads */
>> +#define SDO_PADS_NUM	1
>>
>>   struct sdo_format {
>>   	v4l2_std_id id;
>> @@ -61,6 +66,8 @@ struct sdo_device {
>>   	struct regulator *vdet;
>>   	/** subdev used as device interface */
>>   	struct v4l2_subdev sd;
>> +	/** sink pad of sdo subdev */
>> +	struct media_pad pad;
>>   	/** current format */
>>   	const struct sdo_format *fmt;
>>   };
>> @@ -292,6 +299,63 @@ static const struct dev_pm_ops sdo_pm_ops = {
>>   	.runtime_resume	 = sdo_runtime_resume,
>>   };
>>
>> +static int sdo_link_setup(struct media_entity *entity,
>> +			      const struct media_pad *local,
>> +			      const struct media_pad *remote, u32 flags)
>> +{
>> +	return 0;
>> +}
>> +
>> +/* sdo entity operations */
>> +static const struct media_entity_operations sdo_entity_ops = {
>> +	.link_setup = sdo_link_setup,
>> +};
>> +
>> +static int sdo_register_entity(struct sdo_device *sdev)
>> +{
>> +	struct v4l2_subdev *sd =&sdev->sd;
>> +	struct media_pad *pad =&sdev->pad;
>> +	struct media_entity *me =&sd->entity;
>> +	struct device *dev = sdev->dev;
>> +	struct exynos_md *md;
>> +	int ret;
>> +
>> +	dev_dbg(dev, "SDO entity init\n");
>> +
>why code below is moved? (similar to hdmi)
Same reason with above.

>> +	/* init sdo subdev */
>> +	v4l2_subdev_init(sd,&sdo_sd_ops);
>> +	sd->owner = THIS_MODULE;
>> +	strlcpy(sd->name, "sdo-sd", sizeof(sd->name));
>> +
>> +	dev_set_drvdata(dev, sd);
>> +
>> +	/* init sdo sub-device as entity */
>> +	pad[SDO_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
>> +	me->ops =&sdo_entity_ops;
>> +	ret = media_entity_init(me, SDO_PADS_NUM, pad, 0);
>> +	if (ret) {
>> +		dev_err(dev, "failed to initialize media entity\n");
>> +		return ret;
>> +	}
>> +
>> +	/* get output media ptr for registering sdo's sd */
>> +	md = (struct exynos_md
>*)module_name_to_driver_data(MDEV_MODULE_NAME);
>
>Please update dependence in Kconfig.
Ok.

>
>> +	if (!md) {
>> +		dev_err(dev, "failed to get output media device\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	/* regiser SDO subdev as entity to v4l2_dev pointer of
>> +	 * output media device */
>> +	ret = v4l2_device_register_subdev(&md->v4l2_dev, sd);
>> +	if (ret) {
>> +		dev_err(dev, "failed to register SDO subdev\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int __devinit sdo_probe(struct platform_device *pdev)
>>   {
>>   	struct device *dev =&pdev->dev;
>> @@ -390,17 +454,14 @@ static int __devinit sdo_probe(struct
>platform_device *pdev)
>>   	/* configure power management */
>>   	pm_runtime_enable(dev);
>>
>> -	/* configuration of interface subdevice */
>> -	v4l2_subdev_init(&sdev->sd,&sdo_sd_ops);
>> -	sdev->sd.owner = THIS_MODULE;
>> -	strlcpy(sdev->sd.name, "s5p-sdo", sizeof sdev->sd.name);
>> -
>>   	/* set default format */
>>   	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
>>   	BUG_ON(sdev->fmt == NULL);
>>
>> -	/* keeping subdev in device's private for use by other drivers */
>> -	dev_set_drvdata(dev,&sdev->sd);
>> +	/* register sdo subdev as entity */
>> +	ret = sdo_register_entity(sdev);
>> +	if (ret)
>> +		goto fail_vdac;
>>
>>   	dev_info(dev, "probe succeeded\n");
>>   	return 0;
>
>Regardds,
>Tomasz Stanislawski

