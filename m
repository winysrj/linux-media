Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39977 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3D2LYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 07:24:08 -0400
Message-id: <517E5853.2000207@samsung.com>
Date: Mon, 29 Apr 2013 13:24:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 1/6] media: exynos4-is: modify existing mdev to use common
 pipeline
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
 <1366789273-30184-2-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1366789273-30184-2-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

Thanks for the updated patch series.

On 04/24/2013 09:41 AM, Shaik Ameer Basha wrote:
> Current fimc_pipeline is tightly coupled with exynos4-is media
> device driver. And this will not allow to use the same pipeline
> across different exynos series media device drivers.
> 
> This patch adds,
> 1] Changing of the existing pipeline as a common pipeline
>    to be used across multiple exynos series media device drivers.
> 2] Modifies the existing exynos4-is media device driver to
>    use the updated common pipeline implementation.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-capture.c |   47 ++++--
>  drivers/media/platform/exynos4-is/fimc-lite.c    |    4 +-
>  drivers/media/platform/exynos4-is/media-dev.c    |  179 +++++++++++++++++++---
>  drivers/media/platform/exynos4-is/media-dev.h    |   16 ++
>  include/media/s5p_fimc.h                         |   46 ++++--
>  5 files changed, 248 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
> index 72c516a..904d725 100644
> --- a/drivers/media/platform/exynos4-is/fimc-capture.c
> +++ b/drivers/media/platform/exynos4-is/fimc-capture.c
[...]
> @@ -1830,6 +1847,9 @@ static int fimc_capture_subdev_registered(struct v4l2_subdev *sd)
>   		return ret;
>
>   	fimc->pipeline_ops = v4l2_get_subdev_hostdata(sd);
> +	fimc->pipeline_ops->init(&fimc->pipeline);
> +	fimc->pipeline_ops->register_notify_cb(&fimc->pipeline,
> +						fimc_sensor_notify);

Why is this needed ? The 'notify' callback belongs to struct v4l2_device,
which is on same level in the V4L2 API as struct media_device in the MC API.

Once a v4l2 subdev is registered it gets its v4l2_dev field set to its parent
v4l2 device and can send notification, e.g. by using the v4l2_subdev_notify() 
macro.
In exynos4-is the media device driver then routes such notification to the FIMC
capture driver, depending on the media links configuration.

I know, the current code upstream needs to get fixed to work as described above
also after links reconfiguration at run time.

Still it's not clear to, me why you need this new register_notify_cb callback ?

>   	ret = fimc_register_capture_device(fimc, sd->v4l2_dev);
>   	if (ret) {
> @@ -1852,6 +1872,7 @@ static void fimc_capture_subdev_unregistered(struct v4l2_subdev *sd)
>   	if (video_is_registered(&fimc->vid_cap.vfd)) {
>   		video_unregister_device(&fimc->vid_cap.vfd);
>   		media_entity_cleanup(&fimc->vid_cap.vfd.entity);
> +		fimc->pipeline_ops->free(&fimc->pipeline);
>   		fimc->pipeline_ops = NULL;
>   	}
>   	kfree(fimc->vid_cap.ctx);

> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index 1dbd554..c80633a 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -36,6 +36,8 @@
>   #include "fimc-lite.h"
>   #include "mipi-csis.h"
>
> +static struct exynos4_pipeline exynos4_pl;
> +
[...]
> +static int __fimc_pipeline_init(struct fimc_pipeline *p)
> +{
> +	struct exynos4_pipeline *ep =&exynos4_pl;
> +
> +	if (ep->is_init)
> +		return 0;
> +
> +	ep->is_init = true;
> +	p->priv = (void *)ep;

This will not work since there can be more than one video pipeline operating
simultaneously, and a static variable is used here.

I think we could ditch those fimc_pipeline_init/free ops by designing properly
data structures describing video pipelines. Please see below for more details.

> +	return 0;
> +}
> +
> +/**
> + * __fimc_pipeline_free - free the allocated resources for fimc_pipeline
> + * @p: Pointer to fimc_pipeline structure
> + *
> + * sets the 'is_init' variable to false, to indicate the pipeline structure
> + * is not valid.
> + *
> + * RETURNS:
> + * Zero in case of success and -EINVAL in case of failure.

nit: According to Documentation the correct format is:

+ Return: Zero in case of success and -EINVAL in case of failure.

> + */
> +static int __fimc_pipeline_free(struct fimc_pipeline *p)
> +{
> +	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
> +
> +	if (!ep || !ep->is_init)
> +		return -EINVAL;
> +
> +	ep->is_init = false;

I find it hard to see justification for existence of this function.

> +	return 0;
> +}

> +/**
> + * __fimc_pipeline_get_subdev_sensor - if valid pipeline, returns the sensor
> + *                                     subdev pointer else returns NULL
> + * @p: Pointer to fimc_pipeline structure
> + * @sd_idx: Index of the subdev associated with the current pipeline
> + *
> + * RETURNS:
> + * If success, returns valid subdev pointer or NULL in case of sudbev not found
> + */
> +static struct v4l2_subdev *__fimc_pipeline_get_subdev(struct fimc_pipeline *p,
> +					enum exynos_subdev_index sd_idx)
> +{
> +	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
> +	struct v4l2_subdev *sd;
> +
> +	if (!ep || !ep->is_init)
> +		return NULL;
> +
> +	switch (sd_idx) {
> +	case EXYNOS_SD_SENSOR:
> +		sd = ep->subdevs[IDX_SENSOR];
> +		break;
> +	case EXYNOS_SD_CSIS:
> +		sd = ep->subdevs[IDX_CSIS];
> +		break;
> +	case EXYNOS_SD_FLITE:
> +		sd = ep->subdevs[IDX_FLITE];
> +		break;
> +	case EXYNOS_SD_IS_ISP:
> +		sd = ep->subdevs[IDX_IS_ISP];
> +		break;
> +	case EXYNOS_SD_FIMC:
> +		sd = ep->subdevs[IDX_FIMC];
> +		break;

There is no need for new EXYNOS_SD_* enumeration, subdev group ids could be 
used instead. And for exynos4-is I don't want such get_subdev callback. Only
one entity would be using it (FIMC video capture device). I prefer to make 
enum fimc_subdev_index local to the exynos4-is driver and use IDX_* there 
directly. Until such usage is replaced by more generic code - not a driver 
specific data pipeline callback.

Also, with so many elements in the array using switch looks pretty ugly 
to me. Iterating over the array and comparing against subdev group id might
be a better idea, e.g.

	unsigned int i;
	for (i = 0; i < IDX_MAX; i++) {
		if (ep->subdevs[i] && ep->subdevs[i]->grp_id == requested_grp_id)
			return ep->subdevs[i];
	}
	return NULL;	

> +	default:
> +		sd = NULL;
> +		break;
> +	}
> +	return sd;
> +}
> +
> +static void __fimc_pipeline_register_notify_callback(
> +		struct fimc_pipeline *p,
> +		void (*notify_cb)(struct v4l2_subdev *sd,
> +					unsigned int notification, void *arg))
> +{
> +	struct exynos4_pipeline *ep = (struct exynos4_pipeline *)p->priv;
> +
> +	if (!notify_cb)
> +		return;
> +
> +	ep->sensor_notify = notify_cb;
> +}

This really seems redundant code to me. Could you explain a bit what is the
purpose of this ?

> +
>   /* Media pipeline operations for the FIMC/FIMC-LITE video device driver */
>   static const struct fimc_pipeline_ops fimc_pipeline_ops = {
> +	.init		= __fimc_pipeline_init,
> +	.free		= __fimc_pipeline_free,
>   	.open		= __fimc_pipeline_open,
>   	.close		= __fimc_pipeline_close,
>   	.set_stream	= __fimc_pipeline_s_stream,
> +	.get_subdev	= __fimc_pipeline_get_subdev,
> +	.register_notify_cb     = __fimc_pipeline_register_notify_callback,
>   };

> +/**
> + * fimc_md_sensor_notify - v4l2_device notification from a sensor subdev
> + * @sd: pointer to a subdev generating the notification
> + * @notification: the notification type, must be S5P_FIMC_TX_END_NOTIFY
> + * @arg: pointer to an u32 type integer that stores the frame payload value
> + *
> + * Passes the sensor notification to the capture device
> + */
> +void fimc_md_sensor_notify(struct v4l2_subdev *sd,
> +				unsigned int notification, void *arg)
> +{
> +	struct fimc_md *fmd;
> +	struct exynos4_pipeline *ep;
> +	struct fimc_pipeline *p;
> +	unsigned long flags;
> +
> +	fmd = entity_to_fimc_mdev(&sd->entity);
> +
> +	if (sd == NULL)
> +		return;
> +
> +	p = media_pipe_to_fimc_pipeline(sd->entity.pipe);

When video streaming is off (before VIDIOC_STREAMON and after VIDIOC_STREAMOFF
ioctl) sd->entity.pipe will be NULL. So this code is not safe.

> +	ep = (struct exynos4_pipeline *)p->priv;
> +
> +	spin_lock_irqsave(&fmd->slock, flags);
> +
> +	if (ep->sensor_notify)
> +		ep->sensor_notify(sd, notification, arg);
> +
> +	spin_unlock_irqrestore(&fmd->slock, flags);
> +}

Creating the notification handler function in this file might be a good idea,
I remember having something like this done for some experiments. But I'm not
happy with introducing yet another callback for it in the pipeline struct.
The pipeline callbacks are supposed to be called by the video node drivers
and implemented by the media driver, not the other way around.

Actually what is the problem you tried to solve by introducing this code ?

> @@ -1375,7 +1518,7 @@ static int fimc_md_probe(struct platform_device *pdev)
>
>   	v4l2_dev =&fmd->v4l2_dev;
>   	v4l2_dev->mdev =&fmd->media_dev;
> -	v4l2_dev->notify = fimc_sensor_notify;
> +	v4l2_dev->notify = fimc_md_sensor_notify;
>   	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
>
>   	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
> diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
> index 44d86b6..7ee8dd8 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.h
> +++ b/drivers/media/platform/exynos4-is/media-dev.h
> @@ -40,6 +40,15 @@ enum {
>   	FIMC_MAX_WBCLKS
>   };
>
> +enum exynos4_subdev_index {
> +	IDX_SENSOR,
> +	IDX_CSIS,
> +	IDX_FLITE,
> +	IDX_IS_ISP,
> +	IDX_FIMC,
> +	IDX_MAX,
> +};
>   struct fimc_csis_info {
>   	struct v4l2_subdev *sd;
>   	int id;
> @@ -107,6 +116,13 @@ struct fimc_md {
>   	spinlock_t slock;
>   };
>
> +struct exynos4_pipeline {
> +	int is_init;
> +	struct v4l2_subdev *subdevs[IDX_MAX];
> +	void (*sensor_notify)(struct v4l2_subdev *sd,
> +			unsigned int notification, void *arg);
> +};

> diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
> index f509690..2908a02 100644
> --- a/include/media/s5p_fimc.h
> +++ b/include/media/s5p_fimc.h
> @@ -105,6 +105,24 @@ struct s5p_platform_fimc {
>    */
>   #define S5P_FIMC_TX_END_NOTIFY _IO('e', 0)
>
> +/* Group IDs of sensor, MIPI-CSIS, FIMC-LITE and the writeback subdevs. */
> +#define GRP_ID_SENSOR		(1<<  8)
> +#define GRP_ID_FIMC_IS_SENSOR	(1<<  9)
> +#define GRP_ID_WRITEBACK	(1<<  10)
> +#define GRP_ID_CSIS		(1<<  11)
> +#define GRP_ID_FIMC		(1<<  12)
> +#define GRP_ID_FLITE		(1<<  13)
> +#define GRP_ID_FIMC_IS		(1<<  14)

These definitions are already in this file, I made recently a patch moving 
those from media-dev.h. So this chunk must not be repeated here.

> +enum exynos_subdev_index {
> +	EXYNOS_SD_SENSOR,
> +	EXYNOS_SD_CSIS,
> +	EXYNOS_SD_FLITE,
> +	EXYNOS_SD_IS_ISP,
> +	EXYNOS_SD_FIMC,
> +	EXYNOS_SD_MAX,

So we now have 3 different types of the subdev identifiers: GRP_ID_*, EXYNOS_SD_*, 
IDX_* ? As I mentioned above subdev group ids could be used instead of this 
new enumeration.

I think we could just rename GRP_ID_* constants that are already in this file 
to EXYNOS_SD_GROUP_ID_* and use it. Probably there is even no need for renaming.

>   /**
> @@ -140,21 +158,12 @@ struct fimc_fmt {
>   #define FMT_FLAGS_YUV		(1<<  7)
>   };
>
> -enum fimc_subdev_index {
> -	IDX_SENSOR,
> -	IDX_CSIS,
> -	IDX_FLITE,
> -	IDX_IS_ISP,
> -	IDX_FIMC,
> -	IDX_MAX,
> -};

We probably need to create new header file, include/media/exynos_is.h, which
would hold all common definitions for the exynos4-is and exynos5-is driver.

I intend to rename s5p_fimc.h to exynos4_is.h, once most of board files using
it are dropped, presumably for 3.11.

>   struct fimc_pipeline {
> -	struct v4l2_subdev *subdevs[IDX_MAX];
> -	struct media_pipeline *m_pipeline;
> +	struct media_pipeline m_pipeline;
> +	void *priv;

Since there is already going to be plenty of different structures describing
video pipeline, i.e.:

 - struct media_pipeline
 - struct fimc_pipeline
 - struct exynos4_pipeline
 - struct exynos5_pipeline

I think we could have specific pipeline structures "inherited" from struct
media_pipeline. I though initially about using only struct media_pipeline
and a exynos4/exynos5 pipeline structure, e.g.

struct exynos4_media_pipeline {
	struct media_pipeline mp;
	...
};

struct exynos5_media_pipeline {
	struct media_pipeline mp;
	...
};

And have entities passing around and using pointers to struct media_pipeline.
So the ops would have become something like:

struct exynos_pipeline_ops {
	int (*open)(struct media_pipeline *p, struct media_entity *me,
					bool resume);
	int (*close)(struct media_pipeline *p);
	int (*set_stream)(struct media_pipeline *p, bool state);
	...
};

But if we added struct exynos_pipeline_ops * to struct exynos_pipeline, which
is needed to handle link reconfiguration events when multiple subdevs/video
nodes are involved in a single video pipeline, some shared subdevs (FIMC-LITE)
would need to dereference more specific pipeline struct than struct 
media_pipeline to access the pipeline ops. So those shared subdevs would need
a common pipeline data structure type, since we wanted them to perform some
operations on a pipeline struct, but still allow a specific media device
driver to define its pipeline object type, inherited from base type.

So would have something like below, which becomes a bit uglier, but is likely
no different from performance POV. Since struct media_pipeline is an empty
data structure, and 'ep' is first field of struct exynos*_media_pipeline.

struct exynos_media_pipeline {
	struct media_pipeline mp;
	struct exynos_pipeline_ops *ops;
};


struct exynos4_media_pipeline {
	struct exynos_media_pipeline ep;
	...
};

struct exynos5_media_pipeline {
	struct exynos_media_pipeline ep;
	...
};

The shared subdevs would (and should) in general not be aware of details 
of the the pipeline structure specific to a given media device driver.

Would then still init/free ops be necessary ?

BTW, I would really like to limit usage of struct fimc_pipeline to minimum,
i.e. use generic graph/media entity operations where possible.


>   };
>
>   /*
> @@ -163,14 +172,27 @@ struct fimc_pipeline {
>    * by corresponding media device driver.
>    */
>   struct fimc_pipeline_ops {
> +	int (*init) (struct fimc_pipeline *p);
> +	int (*free) (struct fimc_pipeline *p);
>   	int (*open)(struct fimc_pipeline *p, struct media_entity *me,
> -			  bool resume);
> +					bool resume);
>   	int (*close)(struct fimc_pipeline *p);
>   	int (*set_stream)(struct fimc_pipeline *p, bool state);
> +	struct v4l2_subdev *(*get_subdev)(struct fimc_pipeline *p,
> +					enum exynos_subdev_index sd_idx);
> +	void (*register_notify_cb)(struct fimc_pipeline *p,
> +					void (*cb)(struct v4l2_subdev *sd,
> +					unsigned int notification, void *arg));
>   };
>
>   #define fimc_pipeline_call(f, op, p, args...)				\
>   	(!(f) ? -ENODEV : (((f)->pipeline_ops&&  (f)->pipeline_ops->op) ? \
>   			    (f)->pipeline_ops->op((p), ##args) : -ENOIOCTLCMD))
>
> +#define fimc_pipeline_get_subdev(ops, p, idx_subdev)			\
> +	((ops&&  ops->get_subdev) ? ops->get_subdev(p, idx_subdev) : NULL)

I'm not sure it belongs here. The shared subdevs should use generic APIs
to deal with media entities. And the not shared ones could make assumptions 
about their media device specific pipeline data structure.

Regards,
Sylwester
