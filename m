Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821A1C4360F
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 12:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 477F221852
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 12:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="q4tdjhGv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfCNMJw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 08:09:52 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:49620 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfCNMJw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 08:09:52 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F014B31C;
        Thu, 14 Mar 2019 13:09:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552565388;
        bh=csHL9WT69OTBj1ejPw07ThEoquCk/pqxq+o+VJr45lk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4tdjhGvjse2pnQVAJ0973yJNT3RKqi34P35H/B/JrMB5ZgTGqmlYrdFypByestCL
         TyF0qGNQT1PtDemH1iFvXS669JI/56LKhZkJxMxjiZ0LWzQJVbPPzNTVSW1s86+OtL
         TI3ycdQFu+PAuA5ESdfeeIEjLi8QiSvlQN/elqgI=
Date:   Thu, 14 Mar 2019 14:09:41 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
Subject: Re: [PATCH v6 11/18] media: vsp1: drm: Implement writeback support
Message-ID: <20190314120941.GC5455@pendragon.ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-12-laurent.pinchart+renesas@ideasonboard.com>
 <ab98c192-9615-809c-2bdd-c1a2d72cff5b@ideasonboard.com>
 <20190313155606.GF4722@pendragon.ideasonboard.com>
 <2fe9b232-36be-bb0d-6c33-91d0050b35c1@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2fe9b232-36be-bb0d-6c33-91d0050b35c1@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Thu, Mar 14, 2019 at 08:28:27AM +0000, Kieran Bingham wrote:
> On 13/03/2019 15:56, Laurent Pinchart wrote:
> > On Wed, Mar 13, 2019 at 11:42:34AM +0000, Kieran Bingham wrote:
> >> On 13/03/2019 00:05, Laurent Pinchart wrote:
> >>> Extend the vsp1_du_atomic_flush() API with writeback support by adding
> >>> format, pitch and memory addresses of the writeback framebuffer.
> >>> Writeback completion is reported through the existing frame completion
> >>> callback with a new VSP1_DU_STATUS_WRITEBACK status flag.
> >>>
> >>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> My concerns have been addressed here:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> >>> ---
> >>>  drivers/media/platform/vsp1/vsp1_dl.c  | 14 ++++++++++++++
> >>>  drivers/media/platform/vsp1/vsp1_dl.h  |  3 ++-
> >>>  drivers/media/platform/vsp1/vsp1_drm.c | 25 ++++++++++++++++++++++++-
> >>>  include/media/vsp1.h                   | 15 +++++++++++++++
> >>>  4 files changed, 55 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> >>> index ed7cda4130f2..104b6f514536 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> >>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> >>> @@ -958,6 +958,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
> >>>   *
> >>>   * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
> >>>   * became active had been queued with the internal notification flag.
> >>> + *
> >>> + * The VSP1_DL_FRAME_END_WRITEBACK flag indicates that the previously active
> >>> + * display list had been queued with the writeback flag.
> >>
> >> How does this interact with the possibility of the writeback being
> >> disabled by the WPF in the event of it failing to get a DL.
> >>
> >> It's only a small corner case, but will the 'writeback' report back as
> >> though it succeeded? (without writing to memory, and thus giving an
> >> unmodified buffer back?)
> > 
> > Wrteback completion will never be reported in that case. This shouldn't
> > happen as we should never fail to get a display list. Do you think it
> > would be better to fake completion ?
> 
> Would this lack of completion cause a hang while DRM waits for the
> completion to occur? I guess this would timeout after some period.

Not in the kernel as far as I can tell, but userspace could then wait
forever.

> I'm not sure what's worse. To hang / block for a timeout - or just
> return a 'bad buffer'. We would know in the VSP that the completion has
> failed, so we could signal a failure, but I think as the rest of the DRM
> model goes with a timeout if the flip_done fails to complete for
> example, we should follow that.
> 
> So leave this as is, and perhaps lets make sure the core writeback
> framework will report a warning if it hits a time out.

There's no timeout handling for writeback in the core.

> If we ever fail to get a display list - we will have bigger issues which
> will propogate elsewhere :)

Yes, I think so too. This should really never happen.

> >>>   */
> >>>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
> >>>  {
> >>> @@ -995,6 +998,17 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
> >>>  	if (status & VI6_STATUS_FLD_STD(dlm->index))
> >>>  		goto done;
> >>>  
> >>> +	/*
> >>> +	 * If the active display list has the writeback flag set, the frame
> >>> +	 * completion marks the end of the writeback capture. Return the
> >>> +	 * VSP1_DL_FRAME_END_WRITEBACK flag and reset the display list's
> >>> +	 * writeback flag.
> >>> +	 */
> >>> +	if (dlm->active && (dlm->active->flags & VSP1_DL_FRAME_END_WRITEBACK)) {
> >>> +		flags |= VSP1_DL_FRAME_END_WRITEBACK;
> >>> +		dlm->active->flags &= ~VSP1_DL_FRAME_END_WRITEBACK;
> >>> +	}
> >>> +
> >>>  	/*
> >>>  	 * The device starts processing the queued display list right after the
> >>>  	 * frame end interrupt. The display list thus becomes active.
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> >>> index e0fdb145e6ed..4d7bcfdc9bd9 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> >>> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> >>> @@ -18,7 +18,8 @@ struct vsp1_dl_list;
> >>>  struct vsp1_dl_manager;
> >>>  
> >>>  #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
> >>> -#define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
> >>> +#define VSP1_DL_FRAME_END_WRITEBACK		BIT(1)
> >>
> >> So below BIT(2) (code above) the flags match the externally exposed
> >> bitfield for the VSP1_DU_STATUS_
> >>
> >> While above (code below), are 'private' bitfields.
> >>
> >> Should this requirement be documented here somehow? especially the
> >> mapping of FRAME_END_{COMPLETED,WRITEBACK} to
> >> DU_STATUS_{COMPLETED,WRITEBACK}.
> > 
> > I've added a comment here, as explained in my reply to your review of
> > 10/18, to document this.
> 
> Great.
> 
> >>> +#define VSP1_DL_FRAME_END_INTERNAL		BIT(2)
> >>>  
> >>>  /**
> >>>   * struct vsp1_dl_ext_cmd - Extended Display command
> >>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> >>> index 0367f88135bf..16826bf184c7 100644
> >>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> >>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> >>> @@ -37,7 +37,9 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
> >>>  
> >>>  	if (drm_pipe->du_complete) {
> >>>  		struct vsp1_entity *uif = drm_pipe->uif;
> >>> -		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;
> >>> +		unsigned int status = completion
> >>> +				    & (VSP1_DU_STATUS_COMPLETE |
> >>> +				       VSP1_DU_STATUS_WRITEBACK);
> >>>  		u32 crc;
> >>>  
> >>>  		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
> >>> @@ -541,6 +543,8 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
> >>>  
> >>>  	if (drm_pipe->force_brx_release)
> >>>  		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
> >>> +	if (pipe->output->writeback)
> >>> +		dl_flags |= VSP1_DL_FRAME_END_WRITEBACK;
> >>>  
> >>>  	dl = vsp1_dl_list_get(pipe->output->dlm);
> >>>  	dlb = vsp1_dl_list_get_body0(dl);
> >>> @@ -870,12 +874,31 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
> >>>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> >>>  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> >>>  	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
> >>> +	int ret;
> >>>  
> >>>  	drm_pipe->crc = cfg->crc;
> >>>  
> >>>  	mutex_lock(&vsp1->drm->lock);
> >>> +
> >>> +	if (pipe->output->has_writeback && cfg->writeback.pixelformat) {
> >>
> >> Is pipe->output->has_writeback necessary here? Can
> >> cfg->writeback.pixelformat be set if pipe->output->has_writeback is false?
> >>
> >> Hrm ... actually - Perhaps it is useful. It validates both sides of the
> >> system.
> >>
> >> pipe->output->has_writeback is a capability of the VSP, where as
> >> cfg->writeback.pixelformat is a 'request' from the DU.
> > 
> > Correct, I think it's best to check both, to ensure we don't try to
> > queue a writeback request on a system that doesn't support writeback. On
> > the other hand this shouldn't happen as the DU driver shouldn't expose
> > writeback to userspace in that case, so if you don't think the check is
> > worth it I can remove the has_writeback field completely.
> 
> It's a cheap check, I don't think it is too much of an issue - but I
> agree (if we don't already) then we should make sure userspace does not
> see a writeback functionality if it is not supported through the whole
> pipeline (i.e. including the capability in the VSP1).
> 
> That would make me lean towards removing this check here - *iff* we
> guarantee that the VSP will only be asked to do write back when it's
> possible.

Unless there's a bug in the DU side, we have such a guarantee. I'll
remove the check.

> >>> +		const struct vsp1_du_writeback_config *wb_cfg = &cfg->writeback;
> >>> +
> >>> +		ret = vsp1_du_pipeline_set_rwpf_format(vsp1, pipe->output,
> >>> +						       wb_cfg->pixelformat,
> >>> +						       wb_cfg->pitch);
> >>> +		if (WARN_ON(ret < 0))
> >>> +			goto done;
> >>> +
> >>> +		pipe->output->mem.addr[0] = wb_cfg->mem[0];
> >>> +		pipe->output->mem.addr[1] = wb_cfg->mem[1];
> >>> +		pipe->output->mem.addr[2] = wb_cfg->mem[2];
> >>> +		pipe->output->writeback = true;
> >>> +	}
> >>> +
> >>>  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
> >>>  	vsp1_du_pipeline_configure(pipe);
> >>> +
> >>> +done:
> >>>  	mutex_unlock(&vsp1->drm->lock);
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
> >>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> >>> index 877496936487..cc1b0d42ce95 100644
> >>> --- a/include/media/vsp1.h
> >>> +++ b/include/media/vsp1.h
> >>> @@ -18,6 +18,7 @@ struct device;
> >>>  int vsp1_du_init(struct device *dev);
> >>>  
> >>>  #define VSP1_DU_STATUS_COMPLETE		BIT(0)
> >>> +#define VSP1_DU_STATUS_WRITEBACK	BIT(1)
> >>>  
> >>>  /**
> >>>   * struct vsp1_du_lif_config - VSP LIF configuration
> >>> @@ -83,12 +84,26 @@ struct vsp1_du_crc_config {
> >>>  	unsigned int index;
> >>>  };
> >>>  
> >>> +/**
> >>> + * struct vsp1_du_writeback_config - VSP writeback configuration parameters
> >>> + * @pixelformat: plane pixel format (V4L2 4CC)
> >>> + * @pitch: line pitch in bytes for the first plane
> >>> + * @mem: DMA memory address for each plane of the frame buffer
> >>> + */
> >>> +struct vsp1_du_writeback_config {
> >>> +	u32 pixelformat;
> >>> +	unsigned int pitch;
> >>> +	dma_addr_t mem[3];
> >>> +};
> >>> +
> >>>  /**
> >>>   * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
> >>>   * @crc: CRC computation configuration
> >>> + * @writeback: writeback configuration
> >>>   */
> >>>  struct vsp1_du_atomic_pipe_config {
> >>>  	struct vsp1_du_crc_config crc;
> >>> +	struct vsp1_du_writeback_config writeback;
> >>>  };
> >>>  
> >>>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
> > 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,

Laurent Pinchart
