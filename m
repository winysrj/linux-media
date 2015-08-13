Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45582 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbbHMXCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 19:02:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Fornazier <helen.fornazier@gmail.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH 4/7] [media] vimc: Add vimc_pipeline_s_stream in the core
Date: Fri, 14 Aug 2015 02:03:47 +0300
Message-ID: <9930006.3So169rE2G@avalon>
In-Reply-To: <768d2a9cbca2b48f16133b004f4656794d83b343.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com> <768d2a9cbca2b48f16133b004f4656794d83b343.1438891530.git.helen.fornazier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for the patch.

On Thursday 06 August 2015 17:26:11 Helen Fornazier wrote:
> Move the vimc_cap_pipeline_s_stream from the vimc-cap.c to vimc-core.c
> as this core will be reused by other subdevices to activate the stream
> in their directly connected nodes
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
>  drivers/media/platform/vimc/vimc-capture.c | 32  ++------------------------
>  drivers/media/platform/vimc/vimc-core.c    | 27 +++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h    |  4 ++++
>  3 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-capture.c
> b/drivers/media/platform/vimc/vimc-capture.c index 161ddc9..7d21966 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -163,34 +163,6 @@ static void vimc_cap_return_all_buffers(struct
> vimc_cap_device *vcap, spin_unlock(&vcap->qlock);
>  }
> 
> -static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap, int
> enable)
> -{
> -	int ret;
> -	struct media_pad *pad;
> -	struct media_entity *entity;
> -	struct v4l2_subdev *sd;
> -
> -	/* Start the stream in the subdevice direct connected */
> -	entity = &vcap->vdev.entity;
> -	pad = media_entity_remote_pad(&entity->pads[0]);
> -
> -	/* If we are not connected to any subdev node, it means there is nothing
> -	 * to activate on the pipe (e.g. we can be connected with an input
> -	 * device or we are not connected at all)*/
> -	if (pad == NULL ||
> -	    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> -		return 0;
> -
> -	entity = pad->entity;
> -	sd = media_entity_to_v4l2_subdev(entity);
> -
> -	ret = v4l2_subdev_call(sd, video, s_stream, enable);
> -	if (ret && ret != -ENOIOCTLCMD)
> -		return ret;
> -
> -	return 0;
> -}
> -
>  static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int
> count) {
>  	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> @@ -208,7 +180,7 @@ static int vimc_cap_start_streaming(struct vb2_queue
> *vq, unsigned int count) }
> 
>  	/* Enable streaming from the pipe */
> -	ret = vimc_cap_pipeline_s_stream(vcap, 1);
> +	ret = vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
>  	if (ret) {
>  		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
>  		return ret;
> @@ -226,7 +198,7 @@ static void vimc_cap_stop_streaming(struct vb2_queue
> *vq) struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> 
>  	/* Disable streaming from the pipe */
> -	vimc_cap_pipeline_s_stream(vcap, 0);
> +	vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
> 
>  	/* Stop the media pipeline */
>  	media_entity_pipeline_stop(&vcap->vdev.entity);
> diff --git a/drivers/media/platform/vimc/vimc-core.c
> b/drivers/media/platform/vimc/vimc-core.c index 96d53fd..a824b31 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -312,6 +312,33 @@ static void vimc_device_unregister(struct vimc_device
> *vimc) }
>  }
> 
> +int vimc_pipeline_s_stream(struct media_entity *entity, int enable)
> +{
> +	int ret;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *sd;
> +
> +	/* Start the stream in the subdevice direct connected */
> +	/* TODO: do this to all pads */
> +	pad = media_entity_remote_pad(&entity->pads[0]);
> +
> +	/* If we are not connected to any subdev node, it means there is nothing
> +	 * to activate on the pipe (e.g. we can be connected with an input
> +	 * device or we are not connected at all)*/

I know this patch just moves code, but I still want to point out that the 
kernel coding style closes comment blocks on a separate line

 /*
  * ...
  * ...
  */

> +	if (pad == NULL ||
> +	    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return 0;
> +
> +	entity = pad->entity;
> +	sd = media_entity_to_v4l2_subdev(entity);
> +
> +	ret = v4l2_subdev_call(sd, video, s_stream, enable);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	return 0;
> +}
> +
>  /* Helper function to allocate and initialize pads */
>  struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long
> *pads_flag) {
> diff --git a/drivers/media/platform/vimc/vimc-core.h
> b/drivers/media/platform/vimc/vimc-core.h index 295a554..38d4855 100644
> --- a/drivers/media/platform/vimc/vimc-core.h
> +++ b/drivers/media/platform/vimc/vimc-core.h
> @@ -65,6 +65,10 @@ struct vimc_ent_subdevice *vimc_ent_sd_init(size_t
> struct_size, void (*sd_destroy)(struct vimc_ent_device *));
>  void vimc_ent_sd_cleanup(struct vimc_ent_subdevice *vsd);
> 
> +/* Helper function to call the s_stream of the subdevice
> + * directly connected with entity*/

This belongs to a kerneldoc comment block right above the function definition 
in vimc-core.c.

> +int vimc_pipeline_s_stream(struct media_entity *entity, int enable);
> +
>  const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
> 
>  const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);

-- 
Regards,

Laurent Pinchart

