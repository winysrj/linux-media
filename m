Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45571 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbbHMWof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 18:44:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Fornazier <helen.fornazier@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 3/7] [media] vimc: Add vimc_ent_sd_init/cleanup helper functions
Date: Fri, 14 Aug 2015 01:45:32 +0300
Message-ID: <2514598.UtNTkORACt@avalon>
In-Reply-To: <61e4a06a3fbc57ff71050df52ae42fcbf07a5394.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com> <61e4a06a3fbc57ff71050df52ae42fcbf07a5394.1438891530.git.helen.fornazier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for the patch.

On Thursday 06 August 2015 17:26:10 Helen Fornazier wrote:
> As all the subdevices in the topology will be initialized in the same
> way, to avoid code repetition the vimc_ent_sd_init/cleanup helper functions
> were created
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
>  drivers/media/platform/vimc/vimc-core.c   |  76 ++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h   |  17 +++++
>  drivers/media/platform/vimc/vimc-sensor.c | 104  ++++++++------------------
>  3 files changed, 123 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-core.c
> b/drivers/media/platform/vimc/vimc-core.c index 3ef9b51..96d53fd 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -332,6 +332,82 @@ struct media_pad *vimc_pads_init(u16 num_pads, const
> unsigned long *pads_flag) return pads;
>  }
> 
> +/* media operations */
> +static const struct media_entity_operations vimc_ent_sd_mops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +void vimc_ent_sd_cleanup(struct vimc_ent_subdevice *vsd)
> +{
> +	media_entity_cleanup(vsd->ved.ent);
> +	v4l2_device_unregister_subdev(&vsd->sd);

v4l2_device_unregister_subdev() calls media_entity_remove_links() and 
media_device_unregister_entity(), so it would be better to call 
media_entity_cleanup() after v4l2_device_unregister_subdev().

> +	kfree(vsd);
> +}
> +
> +struct vimc_ent_subdevice *vimc_ent_sd_init(size_t struct_size,
> +				struct v4l2_device *v4l2_dev,
> +				const char *const name,
> +				u16 num_pads,
> +				const unsigned long *pads_flag,
> +				const struct v4l2_subdev_ops *sd_ops,
> +				void (*sd_destroy)(struct vimc_ent_device *))
> +{
> +	int ret;
> +	struct vimc_ent_subdevice *vsd;
> +
> +	if (!v4l2_dev || !v4l2_dev->dev || !name || (num_pads && !pads_flag))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vsd struct */
> +	vsd = kzalloc(struct_size, GFP_KERNEL);

This requires vimc_ent_subdevice being embedded as the first field of the 
parent structure, which restricts options for the code using this API. If you 
were implementing a subsystem API I'd ask for the allocation to happen outside 
of this function, with the vimc_ent_subdevice pointer being passed to the 
function. However, as this is local to the vimc driver, if you believe it 
won't be an issue in the foreseeable future then I'm fine with the 
implementation.

By the way, such core functions should really be documented with a kerneldoc 
comment block. Requirements such as the embedding field position isn't very 
apparent when you glance at the code and would benefit from being documented.

> +	if (!vsd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vimc_deb_device struct with the v4l2 parent */
> +	vsd->v4l2_dev = v4l2_dev;
> +	/* Link the vimc_deb_device struct with the dev parent */
> +	vsd->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vsd->ved.pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vsd->ved.pads)) {
> +		ret = PTR_ERR(vsd->ved.pads);
> +		goto err_free_vsd;
> +	}
> +
> +	/* Initialize the media entity */
> +	vsd->sd.entity.name = name;
> +	vsd->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	ret = media_entity_init(&vsd->sd.entity, num_pads,
> +				vsd->ved.pads, num_pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vsd->ved.destroy = sd_destroy;
> +	vsd->ved.ent = &vsd->sd.entity;
> +
> +	/* Initialize the subdev */
> +	v4l2_subdev_init(&vsd->sd, sd_ops);
> +	vsd->sd.entity.ops = &vimc_ent_sd_mops;
> +	vsd->sd.owner = THIS_MODULE;
> +	strlcpy(vsd->sd.name, name, sizeof(vsd->sd.name));
> +	v4l2_set_subdevdata(&vsd->sd, vsd);
> +
> +	/* Expose this subdev to user space */
> +	vsd->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* return the created vimc subdevice*/
> +	return vsd;
> +
> +err_clean_pads:
> +	vimc_pads_cleanup(vsd->ved.pads);
> +err_free_vsd:
> +	kfree(vsd);
> +
> +	return ERR_PTR(ret);
> +}
> +
>  /* TODO: remove this function when all the
>   * entities specific code are implemented */
>  static void vimc_raw_destroy(struct vimc_ent_device *ved)
> diff --git a/drivers/media/platform/vimc/vimc-core.h
> b/drivers/media/platform/vimc/vimc-core.h index be05469..295a554 100644
> --- a/drivers/media/platform/vimc/vimc-core.h
> +++ b/drivers/media/platform/vimc/vimc-core.h
> @@ -37,6 +37,13 @@ struct vimc_ent_device {
>  			      struct media_pad *sink, const void *frame);
>  };
> 
> +struct vimc_ent_subdevice {
> +	struct vimc_ent_device ved;
> +	struct v4l2_subdev sd;
> +	struct v4l2_device *v4l2_dev;

Given that struct v4l2_subdev stores a pointer to the same struct v4l2_device, 
can't you get rid of this field and use the one inside v4l2_subdev instead ?

> +	struct device *dev;

Similarly you could get the struct device from sd.v4l2_dev->mdev->dev. That 
might become a bit long though, so I'm fine keeping the field here for now.

> +};
> +
>  int vimc_propagate_frame(struct device *dev,
>  			 struct media_pad *src, const void *frame);
> 
> @@ -48,6 +55,16 @@ static inline void vimc_pads_cleanup(struct media_pad
> *pads) kfree(pads);
>  }
> 
> +/* Helper function to initialize/cleanup a subdevice used */
> +struct vimc_ent_subdevice *vimc_ent_sd_init(size_t struct_size,
> +				struct v4l2_device *v4l2_dev,
> +				const char *const name,
> +				u16 num_pads,
> +				const unsigned long *pads_flag,
> +				const struct v4l2_subdev_ops *sd_ops,
> +				void (*sd_destroy)(struct vimc_ent_device *));
> +void vimc_ent_sd_cleanup(struct vimc_ent_subdevice *vsd);
> +
>  const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
> 
>  const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c
> b/drivers/media/platform/vimc/vimc-sensor.c index a2879ad..319bebb 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -26,11 +26,8 @@
>  #define VIMC_SEN_FRAME_MAX_WIDTH 4096
> 
>  struct vimc_sen_device {
> -	struct vimc_ent_device ved;
> -	struct v4l2_subdev sd;
> +	struct vimc_ent_subdevice vsd;
>  	struct tpg_data tpg;
> -	struct v4l2_device *v4l2_dev;
> -	struct device *dev;
>  	struct task_struct *kthread_sen;
>  	u8 *frame;
>  	/* The active format */
> @@ -45,7 +42,7 @@ static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
> struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> 
>  	/* Check if it is a valid pad */
> -	if (code->pad >= vsen->sd.entity.num_pads)
> +	if (code->pad >= vsen->vsd.sd.entity.num_pads)
>  		return -EINVAL;
> 
>  	code->code = vsen->mbus_format.code;
> @@ -60,8 +57,8 @@ static int vimc_sen_enum_frame_size(struct v4l2_subdev
> *sd, struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> 
>  	/* Check if it is a valid pad */
> -	if (fse->pad >= vsen->sd.entity.num_pads ||
> -	    !(vsen->sd.entity.pads[fse->pad].flags & MEDIA_PAD_FL_SOURCE))
> +	if (fse->pad >= vsen->vsd.sd.entity.num_pads ||
> +	    !(vsen->vsd.sd.entity.pads[fse->pad].flags & MEDIA_PAD_FL_SOURCE))
>  		return -EINVAL;
> 
>  	/* TODO: Add support to other formats */
> @@ -122,11 +119,6 @@ static const struct v4l2_subdev_pad_ops
> vimc_sen_pad_ops = { .set_fmt		= vimc_sen_get_fmt,
>  };
> 
> -/* media operations */
> -static const struct media_entity_operations vimc_sen_mops = {
> -	.link_validate = v4l2_subdev_link_validate,
> -};
> -
>  static int vimc_thread_sen(void *data)
>  {
>  	unsigned int i;
> @@ -142,11 +134,13 @@ static int vimc_thread_sen(void *data)
>  		tpg_fill_plane_buffer(&vsen->tpg, V4L2_STD_PAL, 0, vsen->frame);
> 
>  		/* Send the frame to all source pads */
> -		for (i = 0; i < vsen->sd.entity.num_pads; i++)
> -			if (vsen->sd.entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
> -				vimc_propagate_frame(vsen->dev,
> -						     &vsen->sd.entity.pads[i],
> -						     vsen->frame);
> +		for (i = 0; i < vsen->vsd.sd.entity.num_pads; i++) {
> +			struct media_pad *pad = &vsen->vsd.sd.entity.pads[i];
> +
> +			if (pad->flags & MEDIA_PAD_FL_SOURCE)
> +				vimc_propagate_frame(vsen->vsd.dev,
> +						     pad, vsen->frame);
> +		}
> 
>  		/* Wait one second */
>  		schedule_timeout_interruptible(HZ);
> @@ -182,9 +176,10 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd,
> int enable)
> 
>  		/* Initialize the image generator thread */
>  		vsen->kthread_sen = kthread_run(vimc_thread_sen, vsen,
> -						"%s-sen", vsen->v4l2_dev->name);
> +					"%s-sen", vsen->vsd.v4l2_dev->name);
>  		if (IS_ERR(vsen->kthread_sen)) {
> -			v4l2_err(vsen->v4l2_dev, "kernel_thread() failed\n");
> +			v4l2_err(vsen->vsd.v4l2_dev,
> +				 "kernel_thread() failed\n");
>  			vfree(vsen->frame);
>  			vsen->frame = NULL;
>  			return PTR_ERR(vsen->kthread_sen);
> @@ -216,13 +211,11 @@ static const struct v4l2_subdev_ops vimc_sen_ops = {
> 
>  static void vimc_sen_destroy(struct vimc_ent_device *ved)
>  {
> -	struct vimc_sen_device *vsen = container_of(ved,
> -						struct vimc_sen_device, ved);
> +	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
> +						    vsd.ved);
> 
>  	tpg_free(&vsen->tpg);
> -	media_entity_cleanup(ved->ent);
> -	v4l2_device_unregister_subdev(&vsen->sd);
> -	kfree(vsen);
> +	vimc_ent_sd_cleanup(&vsen->vsd);
>  }
> 
>  struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
> @@ -232,34 +225,15 @@ struct vimc_ent_device *vimc_sen_create(struct
> v4l2_device *v4l2_dev, {
>  	int ret;
>  	struct vimc_sen_device *vsen;
> +	struct vimc_ent_subdevice *vsd;
> 
> -	if (!v4l2_dev || !v4l2_dev->dev || !name || (num_pads && !pads_flag))
> -		return ERR_PTR(-EINVAL);
> -
> -	/* Allocate the vsen struct */
> -	vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
> -	if (!vsen)
> -		return ERR_PTR(-ENOMEM);
> -
> -	/* Link the vimc_sen_device struct with the v4l2 parent */
> -	vsen->v4l2_dev = v4l2_dev;
> -	/* Link the vimc_sen_device struct with the dev parent */
> -	vsen->dev = v4l2_dev->dev;
> +	vsd = vimc_ent_sd_init(sizeof(struct vimc_sen_device),
> +			       v4l2_dev, name, num_pads, pads_flag,
> +			       &vimc_sen_ops, vimc_sen_destroy);
> +	if (IS_ERR(vsd))
> +		return (struct vimc_ent_device *)vsd;
> 
> -	/* Allocate the pads */
> -	vsen->ved.pads = vimc_pads_init(num_pads, pads_flag);
> -	if (IS_ERR(vsen->ved.pads)) {
> -		ret = PTR_ERR(vsen->ved.pads);
> -		goto err_free_vsen;
> -	}
> -
> -	/* Initialize the media entity */
> -	vsen->sd.entity.name = name;
> -	vsen->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> -	ret = media_entity_init(&vsen->sd.entity, num_pads,
> -				vsen->ved.pads, num_pads);
> -	if (ret)
> -		goto err_clean_pads;
> +	vsen = container_of(vsd, struct vimc_sen_device, vsd);
> 
>  	/* Set the active frame format (this is hardcoded for now) */
>  	vsen->mbus_format.width = 640;
> @@ -275,43 +249,25 @@ struct vimc_ent_device *vimc_sen_create(struct
> v4l2_device *v4l2_dev, vsen->mbus_format.height);
>  	ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
>  	if (ret)
> -		goto err_clean_m_ent;
> +		goto err_clean_vsd;
> 
>  	/* Configure the tpg */
>  	vimc_sen_tpg_s_format(vsen);
> 
> -	/* Fill the vimc_ent_device struct */
> -	vsen->ved.destroy = vimc_sen_destroy;
> -	vsen->ved.ent = &vsen->sd.entity;
> -
> -	/* Initialize the subdev */
> -	v4l2_subdev_init(&vsen->sd, &vimc_sen_ops);
> -	vsen->sd.entity.ops = &vimc_sen_mops;
> -	vsen->sd.owner = THIS_MODULE;
> -	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
> -	v4l2_set_subdevdata(&vsen->sd, vsen);
> -
> -	/* Expose this subdev to user space */
> -	vsen->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> -
>  	/* Register the subdev with the v4l2 and the media framework */
> -	ret = v4l2_device_register_subdev(vsen->v4l2_dev, &vsen->sd);
> +	ret = v4l2_device_register_subdev(vsen->vsd.v4l2_dev, &vsen->vsd.sd);
>  	if (ret) {
> -		dev_err(vsen->dev,
> +		dev_err(vsen->vsd.dev,
>  			"subdev register failed (err=%d)\n", ret);
>  		goto err_free_tpg;
>  	}
> 
> -	return &vsen->ved;
> +	return &vsen->vsd.ved;
> 
>  err_free_tpg:
>  	tpg_free(&vsen->tpg);
> -err_clean_m_ent:
> -	media_entity_cleanup(&vsen->sd.entity);
> -err_clean_pads:
> -	vimc_pads_cleanup(vsen->ved.pads);
> -err_free_vsen:
> -	kfree(vsen);
> +err_clean_vsd:
> +	vimc_ent_sd_cleanup(vsd);
> 
>  	return ERR_PTR(ret);
>  }

-- 
Regards,

Laurent Pinchart

