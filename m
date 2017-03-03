Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37887 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdCCKel (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 05:34:41 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [RFC PATCH 2/3] v4l: vsp1: extend VSP1 module API to allow DRM
 callback registration
References: <cover.79abe454b4a405227fcacc23f1b6ba624ee99cf0.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
 <b150930211d305da848eed1346e2258340cfbc8b.1488373517.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2628026.T8y166ePVA@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <d6049cd7-3444-79eb-3739-0b868c92aa62@ideasonboard.com>
Date: Fri, 3 Mar 2017 10:08:56 +0000
MIME-Version: 1.0
In-Reply-To: <2628026.T8y166ePVA@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 03/03/17 02:11, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Wednesday 01 Mar 2017 13:12:55 Kieran Bingham wrote:
>> To be able to perform page flips in DRM without flicker we need to be
>> able to notify the rcar-du module when the VSP has completed its
>> processing.
>>
>> To synchronise the page flip events for userspace, we move the required
>> event through the VSP to track the data flow. When the frame is
>> completed, the event can be returned back to the originator through the
>> registered callback.
>>
>> We must not have bidirectional dependencies on the two components to
>> maintain support for loadable modules, thus we extend the API to allow
>> a callback to be registered within the VSP DRM interface.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  2 +-
>>  drivers/media/platform/vsp1/vsp1_drm.c | 42 +++++++++++++++++++++++++--
>>  drivers/media/platform/vsp1/vsp1_drm.h | 12 ++++++++-
>>  include/media/vsp1.h                   |  6 +++-
>>  4 files changed, 58 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>> b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index b5bfbe50bd87..71e70e1e0881
>> 100644
>> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
>> @@ -81,7 +81,7 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
>>
>>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>>  {
>> -	vsp1_du_atomic_flush(crtc->vsp->vsp);
>> +	vsp1_du_atomic_flush(crtc->vsp->vsp, NULL);
>>  }
>>
>>  /* Keep the two tables in sync. */
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
>> b/drivers/media/platform/vsp1/vsp1_drm.c index 8e2aa3f8e52f..743cbce48d0c
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
 >> @@ -52,6 +52,40 @@ int vsp1_du_init(struct device *dev)
>>  EXPORT_SYMBOL_GPL(vsp1_du_init);
>>
>>  /**
>> + * vsp1_du_register_callback - Register VSP completion notifier callback
>> + *
>> + * Allow the DRM framework to register a callback with us to notify the end
>> of + * processing each frame. This allows synchronisation for page
>> flipping. + *
>> + * @dev: the VSP device
>> + * @callback: the callback function to notify the DU module
>> + * @private: private structure data to pass with the callback
>> + *
>> + */
>> +void vsp1_du_register_callback(struct device *dev,
>> +			       void (*callback)(void *, void *),
>> +			       void *private)
>> +{
>> +	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>> +
>> +	vsp1->drm->du_complete = callback;
>> +	vsp1->drm->du_private = private;
>> +}
>> +EXPORT_SYMBOL_GPL(vsp1_du_register_callback);
> 
> As they're not supposed to change at runtime while the display is running, how 
> about passing the callback and private data pointer to the vsp1_du_setup_lif() 
> function ? Feel free to create a structure for all the parameters passed to 
> the function if you think we'll have too much (which would, as a side effect, 
> made updates to the API easier in the future as changes to the two subsystems 
> will be easier to decouple).

Sure, that's fine. I think a config structure makes sense here.

>> +static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
>> +{
>> +	struct vsp1_drm *drm = to_vsp1_drm(pipe);
>> +
>> +	if (drm->du_complete && drm->active_data)
>> +		drm->du_complete(drm->du_private, drm->active_data);
>> +
>> +	/* The pending frame is now active */
>> +	drm->active_data = drm->pending_data;
>> +	drm->pending_data = NULL;
>> +}
> 
> I would move this function to the "Interrupt Handling" section.

Ack.

>> +/**
>>   * vsp1_du_setup_lif - Setup the output part of the VSP pipeline
>>   * @dev: the VSP device
>>   * @width: output frame width in pixels
>> @@ -99,7 +133,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
>> width, }
>>
>>  		pipe->num_inputs = 0;
>> -
>> +		pipe->frame_end = NULL;
> 
> You can drop this if ...
> 
>> +		vsp1->drm->du_complete = NULL;
>>  		vsp1_dlm_reset(pipe->output->dlm);
>>  		vsp1_device_put(vsp1);
>>
>> @@ -196,6 +231,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
>> width, if (ret < 0)
>>  		return ret;
>>
>> +	pipe->frame_end = vsp1_du_pipeline_frame_end;
>> +

> 
> ... you move this to vsp1_drm_init().

Done.


> 
>>  	ret = media_entity_pipeline_start(&pipe->output->entity.subdev.entity,
>>  					  &pipe->pipe);
>>  	if (ret < 0) {
>> @@ -420,7 +457,7 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1,
>> struct vsp1_rwpf *rpf) * vsp1_du_atomic_flush - Commit an atomic update
>>   * @dev: the VSP device
>>   */
>> -void vsp1_du_atomic_flush(struct device *dev)
>> +void vsp1_du_atomic_flush(struct device *dev, void *data)
>>  {
>>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>>  	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
>> @@ -504,6 +541,7 @@ void vsp1_du_atomic_flush(struct device *dev)
>>
>>  	vsp1_dl_list_commit(pipe->dl);
>>  	pipe->dl = NULL;
>> +	vsp1->drm->pending_data = data;
>>
>>  	/* Start or stop the pipeline if needed. */
>>  	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
>> b/drivers/media/platform/vsp1/vsp1_drm.h index 9e28ab9254ba..fde19e5948a0
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.h
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
>> @@ -33,8 +33,20 @@ struct vsp1_drm {
>>  		struct v4l2_rect compose;
>>  		unsigned int zpos;
>>  	} inputs[VSP1_MAX_RPF];
>> +
>> +	/* Frame syncronisation */
>> +	void (*du_complete)(void *, void *);
>> +	void *du_private;
>> +	void *pending_data;
>> +	void *active_data;
>>  };
>>
>> +static inline struct vsp1_drm *
>> +to_vsp1_drm(struct vsp1_pipeline *pipe)
> 
> No need for a line split.

Fixed.

>> +{
>> +	return container_of(pipe, struct vsp1_drm, pipe);
>> +}
>> +
>>  int vsp1_drm_init(struct vsp1_device *vsp1);
>>  void vsp1_drm_cleanup(struct vsp1_device *vsp1);
>>  int vsp1_drm_create_links(struct vsp1_device *vsp1);
>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
>> index 458b400373d4..f82fbab01f21 100644
>> --- a/include/media/vsp1.h
>> +++ b/include/media/vsp1.h
>> @@ -20,6 +20,10 @@ struct device;
>>
>>  int vsp1_du_init(struct device *dev);
>>
>> +void vsp1_du_register_callback(struct device *dev,
>> +			       void (*callback)(void *, void *),
>> +			       void *private);
>> +
>>  int vsp1_du_setup_lif(struct device *dev, unsigned int width,
>>  		      unsigned int height);
>>
>> @@ -36,6 +40,6 @@ struct vsp1_du_atomic_config {
>>  void vsp1_du_atomic_begin(struct device *dev);
>>  int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
>>  			  const struct vsp1_du_atomic_config *cfg);
>> -void vsp1_du_atomic_flush(struct device *dev);
>> +void vsp1_du_atomic_flush(struct device *dev, void *data);
>>
>>  #endif /* __MEDIA_VSP1_H__ */
> 
