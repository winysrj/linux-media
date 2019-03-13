Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6788C4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 15:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85E19206DF
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 15:50:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="VEyJcMhb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfCMPub (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:50:31 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:53958 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfCMPub (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 11:50:31 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4269C5AA;
        Wed, 13 Mar 2019 16:50:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552492229;
        bh=wzf2sEsZPvRsi/aRVxoSiXfcETr8OC35CZEYVSFcgqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VEyJcMhbqVDUlndpgvS2XVidBg2LPlMtjYCaPkZIp2bKK8fbQNZjApF6+lvkCYrt+
         3Td8GwxZr1I+i7yv+yuxBGkIHf+dWTYJGhoAGGE+9C2UiD4fu2Nhww1oPXhBzJz0ea
         dnOcapq7ibnIEZzfEPFtWU0tBxQ7l9HHdqkZbwOU=
Date:   Wed, 13 Mar 2019 17:50:22 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
Subject: Re: [PATCH v6 10/18] media: vsp1: drm: Extend frame completion API
 to the DU driver
Message-ID: <20190313155022.GE4722@pendragon.ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-11-laurent.pinchart+renesas@ideasonboard.com>
 <481d3ccd-ad52-9998-2edf-e7774f03145d@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481d3ccd-ad52-9998-2edf-e7774f03145d@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Wed, Mar 13, 2019 at 11:26:14AM +0000, Kieran Bingham wrote:
> On 13/03/2019 00:05, Laurent Pinchart wrote:
> > The VSP1 driver will need to pass extra flags to the DU through the
> > frame completion API. Replace the completed bool flag by a bitmask to
> > support this.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 4 ++--
> >  drivers/media/platform/vsp1/vsp1_drm.c | 4 ++--
> >  drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
> >  include/media/vsp1.h                   | 4 +++-
> >  4 files changed, 8 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > index 76a39eee7c9c..28bfeb8c24fb 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > @@ -26,14 +26,14 @@
> >  #include "rcar_du_kms.h"
> >  #include "rcar_du_vsp.h"
> >  
> > -static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
> > +static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
> >  {
> >  	struct rcar_du_crtc *crtc = private;
> >  
> >  	if (crtc->vblank_enable)
> >  		drm_crtc_handle_vblank(&crtc->crtc);
> >  
> > -	if (completed)
> > +	if (status & VSP1_DU_STATUS_COMPLETE)
> >  		rcar_du_crtc_finish_page_flip(crtc);
> >  
> >  	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> > index 5601a787688b..0367f88135bf 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -34,14 +34,14 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
> >  				       unsigned int completion)
> >  {
> >  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
> > -	bool complete = completion & VSP1_DL_FRAME_END_COMPLETED;
> >  
> >  	if (drm_pipe->du_complete) {
> >  		struct vsp1_entity *uif = drm_pipe->uif;
> > +		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;
> 
> 
> Why do you mask the bit(s) here?
> 
> Can't we just pass completion into
>   drm_pipe->du_complete(p, completion, c); ?
> 
> [(edit: no, because completion contains things such as
> VSP1_DL_FRAME_END_INTERNAL)]
> 
> Or are you relying on the fact that,
>  VSP1_DL_FRAME_END_COMPLETED == VSP1_DU_STATUS_COMPLETE
> 
> in which case perhaps we should be more explicit somehow, either in code
> or with a comment that this section is converting between the two
> bitfield types.

Good point. I'll add the following comment above the definition of
VSP1_DL_FRAME_END_COMPLETED:

/* Keep these flags in sync with VSP1_DU_STATUS_* in include/media/vsp1.h. */

> However you resolve, the rest looks fine:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> >  		u32 crc;
> >  
> >  		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
> > -		drm_pipe->du_complete(drm_pipe->du_private, complete, crc);
> > +		drm_pipe->du_complete(drm_pipe->du_private, status, crc);
> >  	}
> >  
> >  	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> > index 8dfd274a59e2..e85ad4366fbb 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.h
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> > @@ -42,7 +42,7 @@ struct vsp1_drm_pipeline {
> >  	struct vsp1_du_crc_config crc;
> >  
> >  	/* Frame synchronisation */
> > -	void (*du_complete)(void *data, bool completed, u32 crc);
> > +	void (*du_complete)(void *data, unsigned int status, u32 crc);
> >  	void *du_private;
> >  };
> >  
> > diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> > index 1cf868360701..877496936487 100644
> > --- a/include/media/vsp1.h
> > +++ b/include/media/vsp1.h
> > @@ -17,6 +17,8 @@ struct device;
> >  
> >  int vsp1_du_init(struct device *dev);
> >  
> > +#define VSP1_DU_STATUS_COMPLETE		BIT(0)
> > +
> >  /**
> >   * struct vsp1_du_lif_config - VSP LIF configuration
> >   * @width: output frame width
> > @@ -32,7 +34,7 @@ struct vsp1_du_lif_config {
> >  	unsigned int height;
> >  	bool interlaced;
> >  
> > -	void (*callback)(void *data, bool completed, u32 crc);
> > +	void (*callback)(void *data, unsigned int status, u32 crc);
> >  	void *callback_data;
> >  };
> >  

-- 
Regards,

Laurent Pinchart
