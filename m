Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59233 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdCEWBM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 17:01:12 -0500
Subject: Re: [PATCH v3 2/3] v4l: vsp1: Extend VSP1 module API to allow DRM
 callbacks
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <cover.8e2f9686131cb2299b859f056e902b4208061a4e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
 <200127cf978c8d8904e43ab2b28a225e8a786f6e.1488729419.git-series.kieran.bingham+renesas@ideasonboard.com>
 <16730350.NvnRv331tg@avalon>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <900f8a46-8e9c-aad6-30cb-f3e02f388aa2@ideasonboard.com>
Date: Sun, 5 Mar 2017 22:01:07 +0000
MIME-Version: 1.0
In-Reply-To: <16730350.NvnRv331tg@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 05/03/17 21:58, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Sunday 05 Mar 2017 16:00:03 Kieran Bingham wrote:
>> To be able to perform page flips in DRM without flicker we need to be
>> able to notify the rcar-du module when the VSP has completed its
>> processing.
>>
>> We must not have bidirectional dependencies on the two components to
>> maintain support for loadable modules, thus we extend the API to allow
>> a callback to be registered within the VSP DRM interface.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/vsp1/vsp1_drm.c | 17 +++++++++++++++++
>>  drivers/media/platform/vsp1/vsp1_drm.h | 11 +++++++++++
>>  include/media/vsp1.h                   | 13 +++++++++++++
>>  3 files changed, 41 insertions(+)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
>> b/drivers/media/platform/vsp1/vsp1_drm.c index 4ee437c7ff0c..d93bf7d3a39e
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
>> @@ -37,6 +37,14 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
>>  	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
>>  }
>>
>> +static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
>> +{
>> +	struct vsp1_drm *drm = to_vsp1_drm(pipe);
>> +
>> +	if (drm->du_complete)
>> +		drm->du_complete(drm->du_private);
>> +}
>> +
>>  /* ------------------------------------------------------------------------
>>   * DU Driver API
>>   */
>> @@ -96,6 +104,7 @@ int vsp1_du_setup_lif(struct device *dev, const struct
>> vsp1_du_lif_config *cfg) }
>>
>>  		pipe->num_inputs = 0;
>> +		vsp1->drm->du_complete = NULL;
>>
>>  		vsp1_dlm_reset(pipe->output->dlm);
>>  		vsp1_device_put(vsp1);
>> @@ -200,6 +209,13 @@ int vsp1_du_setup_lif(struct device *dev, const struct
>> vsp1_du_lif_config *cfg) if (ret < 0)
>>  		return ret;
>>
>> +	/*
>> +	 * Register a callback to allow us to notify the DRM framework of 
> frame
> 
> s/framework/driver/
> 
>> +	 * completion events.
>> +	 */
>> +	vsp1->drm->du_complete = cfg->callback;
>> +	vsp1->drm->du_private = cfg->callback_data;
>> +
>>  	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
>>  					  &pipe->pipe);
>>  	if (ret < 0) {
>> @@ -607,6 +623,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>>  	pipe->lif = &vsp1->lif->entity;
>>  	pipe->output = vsp1->wpf[0];
>>  	pipe->output->pipe = pipe;
>> +	pipe->frame_end = vsp1_du_pipeline_frame_end;
>>
>>  	return 0;
>>  }
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
>> b/drivers/media/platform/vsp1/vsp1_drm.h index c8d2f88fc483..3de2095cb0ce
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.h
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
>> @@ -23,6 +23,8 @@
>>   * @num_inputs: number of active pipeline inputs at the beginning of an
>> update
>>   * @inputs: source crop rectangle, destination compose rectangle and
>> z-order
>>   *	position for every input
>> + * @du_complete: frame completion callback for the DU driver (optional)
>> + * @du_private: data to be passed to the du_complete callback
>>   */
>>  struct vsp1_drm {
>>  	struct vsp1_pipeline pipe;
>> @@ -33,8 +35,17 @@ struct vsp1_drm {
>>  		struct v4l2_rect compose;
>>  		unsigned int zpos;
>>  	} inputs[VSP1_MAX_RPF];
>> +
>> +	/* Frame syncronisation */
> 
> s/syncronisation/synchronisation/
> 
>> +	void (*du_complete)(void *);
>> +	void *du_private;
>>  };
>>
>> +static inline struct vsp1_drm *to_vsp1_drm(struct vsp1_pipeline *pipe)
>> +{
>> +	return container_of(pipe, struct vsp1_drm, pipe);
>> +}
>> +
>>  int vsp1_drm_init(struct vsp1_device *vsp1);
>>  void vsp1_drm_cleanup(struct vsp1_device *vsp1);
>>  int vsp1_drm_create_links(struct vsp1_device *vsp1);
>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
>> index bfc701f04f3f..d59d0adf560d 100644
>> --- a/include/media/vsp1.h
>> +++ b/include/media/vsp1.h
>> @@ -20,9 +20,22 @@ struct device;
>>
>>  int vsp1_du_init(struct device *dev);
>>
>> +/**
>> + * struct vsp1_du_lif_config - VSP LIF configuration
>> + * @width: output frame width
>> + * @height: output frame height
>> + * @callback: frame completion callback function (optional)
>> + * @callback_data: data to be passed to the frame completion callback
>> + *
>> + * When the optional callback is provided to the VSP1, the VSP1 must
>> guarantee
>> + * that one completion callback is performed after every
>> vsp1_du_atomic_flush()
> 
> This paragraph should be part of the @callback documentation. I would phrase 
> it as
> 
>  * @callback: frame completion callback function (optional). When a callback
>  *	      is provided, the VSP driver guarantees that it will be called
>  *	      once and only once for each vsp1_du_atomic_flush() call.
> 
> With this fixed,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> If you're fine with the above changes there's no need to resubmit, I'll fix 
> when applying the patch.

Thanks - that would be great.
--
Regards
Kieran

> 
>> + */
>>  struct vsp1_du_lif_config {
>>  	unsigned int width;
>>  	unsigned int height;
>> +
>> +	void (*callback)(void *);
>> +	void *callback_data;
>>  };
>>
>>  int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config
>> *cfg);
> 
