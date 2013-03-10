Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:34747 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3CJWAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 18:00:38 -0400
Message-ID: <513D027A.10004@gmail.com>
Date: Sun, 10 Mar 2013 23:00:26 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 01/12] media: s5p-fimc: modify existing mdev to use common
 pipeline
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-2-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-2-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
> This patch modifies the current fimc_pipeline to exynos_pipeline,

I think we could leave it as fimc_pipeline, exynos_pipeline seems
too generic to me.

> which can be used across multiple media device drivers.
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/platform/s5p-fimc/fimc-capture.c |   96 +++++++-----
>   drivers/media/platform/s5p-fimc/fimc-core.h    |    4 +-
>   drivers/media/platform/s5p-fimc/fimc-lite.c    |   73 ++++------
>   drivers/media/platform/s5p-fimc/fimc-lite.h    |    4 +-
>   drivers/media/platform/s5p-fimc/fimc-mdevice.c |  186 ++++++++++++++++++++++--
>   drivers/media/platform/s5p-fimc/fimc-mdevice.h |   41 +++---
>   include/media/s5p_fimc.h                       |   66 ++++++---
>   7 files changed, 326 insertions(+), 144 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
> index 4cbaf46..106466e 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
> @@ -27,24 +27,26 @@
>   #include<media/videobuf2-core.h>
>   #include<media/videobuf2-dma-contig.h>
>
> -#include "fimc-mdevice.h"
>   #include "fimc-core.h"
>   #include "fimc-reg.h"
>
>   static int fimc_capture_hw_init(struct fimc_dev *fimc)
>   {
>   	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
> -	struct fimc_pipeline *p =&fimc->pipeline;
> +	struct exynos_pipeline *p =&fimc->pipeline;
>   	struct fimc_sensor_info *sensor;
>   	unsigned long flags;
> +	struct v4l2_subdev *sd;
>   	int ret = 0;
>
> -	if (p->subdevs[IDX_SENSOR] == NULL || ctx == NULL)
> +	sd = exynos_pipeline_get_subdev(fimc->pipeline_ops,
> +					get_subdev_sensor, p);

Hmm, it feels it is going wrong path this way. I would keep changes
to the s5p-fimc driver as small as possible. And the modules that
are shared across the exynos4 and exynos5 driver should use generic
media graph walking routines where possible.

> +	if (sd == NULL || ctx == NULL)
>   		return -ENXIO;
>   	if (ctx->s_frame.fmt == NULL)
>   		return -EINVAL;
>
> -	sensor = v4l2_get_subdev_hostdata(p->subdevs[IDX_SENSOR]);
> +	sensor = v4l2_get_subdev_hostdata(sd);
>
>   	spin_lock_irqsave(&fimc->slock, flags);
>   	fimc_prepare_dma_offset(ctx,&ctx->d_frame);
...
> @@ -486,9 +491,12 @@ static struct vb2_ops fimc_capture_qops = {
>   int fimc_capture_ctrls_create(struct fimc_dev *fimc)
>   {
>   	struct fimc_vid_cap *vid_cap =&fimc->vid_cap;
> -	struct v4l2_subdev *sensor = fimc->pipeline.subdevs[IDX_SENSOR];
> +	struct v4l2_subdev *sensor;
>   	int ret;
>
> +	sensor = exynos_pipeline_get_subdev(fimc->pipeline_ops,
> +					get_subdev_sensor,&fimc->pipeline);
> +
>   	if (WARN_ON(vid_cap->ctx == NULL))
>   		return -ENXIO;
>   	if (vid_cap->ctx->ctrls.ready)
> @@ -513,7 +521,7 @@ static int fimc_capture_open(struct file *file)
>
>   	dbg("pid: %d, state: 0x%lx", task_pid_nr(current), fimc->state);
>
> -	fimc_md_graph_lock(fimc);
> +	exynos_pipeline_graph_lock(fimc->pipeline_ops,&fimc->pipeline);

Hmm, this look pretty scary to me. But I suspect this change is not
needed at all. The graph lock is _not_ the pipeline lock. It protects
all media entities registered to the media device, and links between
them. Not only entities linked into specific video processing pipeline
at a moment.

>   	mutex_lock(&fimc->lock);
>
>   	if (fimc_m2m_active(fimc))
> @@ -531,7 +539,7 @@ static int fimc_capture_open(struct file *file)
>   	}
>
>   	if (++fimc->vid_cap.refcnt == 1) {
> -		ret = fimc_pipeline_call(fimc, open,&fimc->pipeline,
> +		ret = exynos_pipeline_call(fimc, open,&fimc->pipeline,
>   					&fimc->vid_cap.vfd.entity, true);
>
>   		if (!ret&&  !fimc->vid_cap.user_subdev_api)
> @@ -549,7 +557,7 @@ static int fimc_capture_open(struct file *file)
>   	}
>   unlock:
>   	mutex_unlock(&fimc->lock);
> -	fimc_md_graph_unlock(fimc);
> +	exynos_pipeline_graph_unlock(fimc->pipeline_ops,&fimc->pipeline);
>   	return ret;
>   }
...
>   /**
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
> index 3266c3f..122cf95 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
...
> -/* Called with the media graph mutex held */
> -static struct v4l2_subdev *__find_remote_sensor(struct media_entity *me)
> -{
> -	struct media_pad *pad =&me->pads[0];
> -	struct v4l2_subdev *sd;
> -
> -	while (pad->flags&  MEDIA_PAD_FL_SINK) {
> -		/* source pad */
> -		pad = media_entity_remote_source(pad);
> -		if (pad == NULL ||
> -		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> -			break;
> -
> -		sd = media_entity_to_v4l2_subdev(pad->entity);
> -
> -		if (sd->grp_id == GRP_ID_FIMC_IS_SENSOR)
> -			return sd;
> -		/* sink pad */
> -		pad =&sd->entity.pads[0];
> -	}
> -	return NULL;
> -}

What's wrong with this function ? Why doesn't it work for you ?
I think we should drop direct usage of fimc->pipeline->subdevs[IDX_SENSOR]
instead. The sensor group IDs should probably be moved to some common
header file.

> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> index fc93fad..938cc56 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> @@ -36,6 +36,8 @@
>   #include "fimc-mdevice.h"
>   #include "mipi-csis.h"
>
> +static struct fimc_md *g_fimc_mdev;

Hm, this is pretty ugly. Can you explain why it is needed ?

>   static int __fimc_md_set_camclk(struct fimc_md *fmd,
>   				struct fimc_sensor_info *s_info,
>   				bool on);
> @@ -143,6 +145,73 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
>   }
>
>   /**
> + * __fimc_pipeline_init
> + *      allocate the fimc_pipeline structure and do the basic initialization

This is not a proper kernel-doc style.

> + */
> +static int __fimc_pipeline_init(struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p;
> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;

Why this needs to be allocated dynamically ?

> +	p->is_init = true;
> +	p->fmd = g_fimc_mdev;
> +	ep->priv = (void *)p;
> +	return 0;
> +}
> +
> +/**
> + * __fimc_pipeline_deinit
> + *      free the allocated resources for fimc_pipeline
> + */
> +static int __fimc_pipeline_deinit(struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
> +
> +	if (!p || !p->is_init)
> +		return -EINVAL;
> +
> +	p->is_init = false;
> +	kfree(p);
> +
> +	return 0;
> +}
> +
> +/**
> + * __fimc_pipeline_get_subdev_sensor
> + *      if valid pipeline, returns the sensor subdev pointer
> + *      else returns NULL
> + */
> +static struct v4l2_subdev *__fimc_pipeline_get_subdev_sensor(
> +					struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
> +
> +	if (!p || !p->is_init)
> +		return NULL;
> +
> +	return p->subdevs[IDX_SENSOR];
> +}
> +
> +/**
> + * __fimc_pipeline_get_subdev_csis
> + *      if valid pipeline, returns the csis subdev pointer
> + *      else returns NULL
> + */
> +static struct v4l2_subdev *__fimc_pipeline_get_subdev_csis(
> +					struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
> +
> +	if (!p || !p->is_init)
> +		return NULL;
> +
> +	return p->subdevs[IDX_CSIS];
> +}
> +
> +/**
>    * __fimc_pipeline_open - update the pipeline information, enable power
>    *                        of all pipeline subdevs and the sensor clock
>    * @me: media entity to start graph walk with
> @@ -150,11 +219,15 @@ static int fimc_pipeline_s_power(struct fimc_pipeline *p, bool state)
>    *
>    * Called with the graph mutex held.
>    */
> -static int __fimc_pipeline_open(struct fimc_pipeline *p,
> +static int __fimc_pipeline_open(struct exynos_pipeline *ep,
>   				struct media_entity *me, bool prep)
>   {
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
>   	int ret;
>
> +	if (!p || !p->is_init)
> +		return -EINVAL;
> +
>   	if (prep)
>   		fimc_pipeline_prepare(p, me);
>
> @@ -174,17 +247,20 @@ static int __fimc_pipeline_open(struct fimc_pipeline *p,
>    *
>    * Disable power of all subdevs and turn the external sensor clock off.
>    */
> -static int __fimc_pipeline_close(struct fimc_pipeline *p)
> +static int __fimc_pipeline_close(struct exynos_pipeline *ep)
>   {
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
>   	int ret = 0;
>
> -	if (!p || !p->subdevs[IDX_SENSOR])
> +	if (!p || !p->is_init)
>   		return -EINVAL;
>
> -	if (p->subdevs[IDX_SENSOR]) {
> -		ret = fimc_pipeline_s_power(p, 0);
> -		fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
> -	}
> +	if (!p->subdevs[IDX_SENSOR])
> +		return -EINVAL;
> +
> +	ret = fimc_pipeline_s_power(p, 0);
> +	fimc_md_set_camclk(p->subdevs[IDX_SENSOR], false);
> +
>   	return ret == -ENXIO ? 0 : ret;
>   }
>
> @@ -193,10 +269,14 @@ static int __fimc_pipeline_close(struct fimc_pipeline *p)
>    * @pipeline: video pipeline structure
>    * @on: passed as the s_stream call argument
>    */
> -static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
> +static int __fimc_pipeline_s_stream(struct exynos_pipeline *ep, bool on)
>   {
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
>   	int i, ret;
>
> +	if (!p || !p->is_init)
> +		return -EINVAL;
> +
>   	if (p->subdevs[IDX_SENSOR] == NULL)
>   		return -ENODEV;
>
> @@ -213,11 +293,47 @@ static int __fimc_pipeline_s_stream(struct fimc_pipeline *p, bool on)
>
>   }
>
> +static void __fimc_pipeline_graph_lock(struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
> +	struct fimc_md *fmd = p->fmd;
> +
> +	mutex_lock(&fmd->media_dev.graph_mutex);
> +}
> +
> +static void __fimc_pipeline_graph_unlock(struct exynos_pipeline *ep)
> +{
> +	struct fimc_pipeline *p = (struct fimc_pipeline *)ep->priv;
> +	struct fimc_md *fmd = p->fmd;
> +
> +	mutex_unlock(&fmd->media_dev.graph_mutex);
> +}

This seems really wrong to me. You can reference the media graph mutex
from a subdev or video device through its 'entity' member, e.g.
sd->entity.parent->graph_mutex.

...
>   static int fimc_md_probe(struct platform_device *pdev)
>   {
>   	struct device *dev =&pdev->dev;
> @@ -1175,7 +1327,7 @@ static int fimc_md_probe(struct platform_device *pdev)
>
>   	v4l2_dev =&fmd->v4l2_dev;
>   	v4l2_dev->mdev =&fmd->media_dev;
> -	v4l2_dev->notify = fimc_sensor_notify;
> +	v4l2_dev->notify = fimc_md_sensor_notify;
>   	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
>
>
> @@ -1194,6 +1346,7 @@ static int fimc_md_probe(struct platform_device *pdev)
>   		goto err_clk;
>
>   	fmd->user_subdev_api = (dev->of_node != NULL);
> +	g_fimc_mdev = fmd;
>
>   	/* Protect the media graph while we're registering entities */
>   	mutex_lock(&fmd->media_dev.graph_mutex);
> @@ -1252,6 +1405,7 @@ static int fimc_md_remove(struct platform_device *pdev)
>
>   	if (!fmd)
>   		return 0;
> +	g_fimc_mdev = NULL;
>   	device_remove_file(&pdev->dev,&dev_attr_subdev_conf_mode);
>   	fimc_md_unregister_entities(fmd);
>   	media_device_unregister(&fmd->media_dev);
> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.h b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> index f3e0251..1ea7acf 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.h
> @@ -37,6 +37,15 @@
>   #define FIMC_MAX_SENSORS	8
>   #define FIMC_MAX_CAMCLKS	2
>
> +enum fimc_subdev_index {
> +	IDX_SENSOR,
> +	IDX_CSIS,
> +	IDX_FLITE,
> +	IDX_IS_ISP,
> +	IDX_FIMC,
> +	IDX_MAX,
> +};
> +
>   struct fimc_csis_info {
>   	struct v4l2_subdev *sd;
>   	int id;
> @@ -49,20 +58,6 @@ struct fimc_camclk_info {
>   };
>
>   /**
> - * struct fimc_sensor_info - image data source subdev information
> - * @pdata: sensor's atrributes passed as media device's platform data
> - * @subdev: image sensor v4l2 subdev
> - * @host: fimc device the sensor is currently linked to
> - *
> - * This data structure applies to image sensor and the writeback subdevs.
> - */
> -struct fimc_sensor_info {
> -	struct fimc_source_info pdata;
> -	struct v4l2_subdev *subdev;
> -	struct fimc_dev *host;
> -};
> -
> -/**
>    * struct fimc_md - fimc media device information
>    * @csis: MIPI CSIS subdevs data
>    * @sensor: array of registered sensor subdevs
> @@ -89,6 +84,14 @@ struct fimc_md {
>   	spinlock_t slock;
>   };
>
> +struct fimc_pipeline {
> +	int is_init;
> +	struct fimc_md *fmd;
> +	struct v4l2_subdev *subdevs[IDX_MAX];
> +	void (*sensor_notify)(struct v4l2_subdev *sd,
> +			unsigned int notification, void *arg);
> +};

This is supposed to be the s5p-fimc driver specific only data structure,
right ?

>   #define is_subdev_pad(pad) (pad == NULL || \
>   	media_entity_type(pad->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
>
> @@ -103,16 +106,6 @@ static inline struct fimc_md *entity_to_fimc_mdev(struct media_entity *me)
>   		container_of(me->parent, struct fimc_md, media_dev);
>   }
>
> -static inline void fimc_md_graph_lock(struct fimc_dev *fimc)
> -{
> -	mutex_lock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
> -}
> -
> -static inline void fimc_md_graph_unlock(struct fimc_dev *fimc)
> -{
> -	mutex_unlock(&fimc->vid_cap.vfd.entity.parent->graph_mutex);
> -}

Why to remove these s5p-fimc driver private functions ?

>   int fimc_md_set_camclk(struct v4l2_subdev *sd, bool on);
>
>   #endif
> diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
> index e2434bb..007e998 100644
> --- a/include/media/s5p_fimc.h
> +++ b/include/media/s5p_fimc.h
> @@ -13,6 +13,7 @@
>   #define S5P_FIMC_H_
>
>   #include<media/media-entity.h>
> +#include<media/v4l2-subdev.h>
>
>   /*
>    * Enumeration of data inputs to the camera subsystem.
> @@ -75,6 +76,20 @@ struct fimc_source_info {
>   };
>
>   /**
> + * struct fimc_sensor_info - image data source subdev information
> + * @pdata: sensor's atrributes passed as media device's platform data
> + * @subdev: image sensor v4l2 subdev
> + * @host: capture device the sensor is currently linked to
> + *
> + * This data structure applies to image sensor and the writeback subdevs.
> + */
> +struct fimc_sensor_info {
> +	struct fimc_source_info pdata;
> +	struct v4l2_subdev *subdev;
> +	void *host;
> +};
> +
> +/**
>    * struct s5p_platform_fimc - camera host interface platform data
>    *
>    * @source_info: properties of an image source for the host interface setup
> @@ -93,21 +108,10 @@ struct s5p_platform_fimc {
>    */
>   #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
>
> -enum fimc_subdev_index {
> -	IDX_SENSOR,
> -	IDX_CSIS,
> -	IDX_FLITE,
> -	IDX_IS_ISP,
> -	IDX_FIMC,
> -	IDX_MAX,
> -};
> -
> -struct media_pipeline;
> -struct v4l2_subdev;
>
> -struct fimc_pipeline {
> -	struct v4l2_subdev *subdevs[IDX_MAX];
> -	struct media_pipeline *m_pipeline;
> +struct exynos_pipeline {
> +	struct media_pipeline m_pipeline;
> +	void *priv;
>   };
>
>   /*
> @@ -115,15 +119,39 @@ struct fimc_pipeline {
>    * video node when it is the last entity of the pipeline. Implemented
>    * by corresponding media device driver.
>    */
> -struct fimc_pipeline_ops {
> -	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
> +struct exynos_pipeline_ops {
> +	int (*init) (struct exynos_pipeline *p);
> +	int (*deinit) (struct exynos_pipeline *p);

How about naming it 'free' instead ?

> +	int (*open)(struct exynos_pipeline *p, struct media_entity *me,
>   			  bool resume);
> -	int (*close)(struct fimc_pipeline *p);
> -	int (*set_stream)(struct fimc_pipeline *p, bool state);
> +	int (*close)(struct exynos_pipeline *p);
> +	int (*set_stream)(struct exynos_pipeline *p, bool state);
> +	void (*graph_lock)(struct exynos_pipeline *p);
> +	void (*graph_unlock)(struct exynos_pipeline *p);

Why do you think these graph callbacks are needed here ?

> +	struct v4l2_subdev *(*get_subdev_sensor)(struct exynos_pipeline *p);
> +	struct v4l2_subdev *(*get_subdev_csis)(struct exynos_pipeline *p);

No, we should instead use generic media graph walking routines in the
shared drivers (FIMC-LITE, MIPI-CSIS). FIMC driver could be making
certain assumptions about it's related media device driver. These
drivers are contained in a single module anyway.

> +	void (*register_notify_cb)(struct exynos_pipeline *p,
> +		void (*cb)(struct v4l2_subdev *sd,
> +				unsigned int notification, void *arg));

Hmm, I need to think more about this. AFAIR this would be only needed
for S5P/Exynos4 FIMC.
