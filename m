Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC30C4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28A012183F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="RBY+h1rl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfCMLPf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:15:35 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51506 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfCMLPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:15:35 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 624115AA;
        Wed, 13 Mar 2019 12:15:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552475731;
        bh=dVFeM0WyIjDsIgfu2fpRCoVI6LZn4kQ3cfj9K8ZfPTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RBY+h1rlX67mx7snnnt3VQXCOc8gwPLroRqaAOoTgPh9gs08QzQiAa2OSdfYsBFnN
         JD8uJAHcQ5J8XWDWzXTRPq4efqNoviZm3NAgSQT0GhUmRuWclaSEt7xR+MKbRtVKU4
         ZMS619pcDx5hwTKDVbu7p7FxzpDJzGwstUkUoIUk=
Date:   Wed, 13 Mar 2019 13:15:24 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
Subject: Re: [PATCH v6 08/18] media: vsp1: wpf: Add writeback support
Message-ID: <20190313111524.GB4722@pendragon.ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-9-laurent.pinchart+renesas@ideasonboard.com>
 <197df400-59b3-f0ba-9fca-a275bc3b1b97@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <197df400-59b3-f0ba-9fca-a275bc3b1b97@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Wed, Mar 13, 2019 at 10:59:18AM +0000, Kieran Bingham wrote:
> On 13/03/2019 00:05, Laurent Pinchart wrote:
> > Add support for the writeback feature of the WPF, to enable capturing
> > frames at the WPF output for display pipelines. To enable writeback the
> > vsp1_rwpf structure mem field must be set to the address of the
> > writeback buffer and the writeback field set to true before the WPF
> > .configure_stream() and .configure_partition() are called. The WPF will
> > enable writeback in the display list for a single frame, and writeback
> > will then be automatically disabled.
> 
> This looks good.
> 
> Took some time to go through it while I argue with myself, but I think I
> reached an agreement with me in the end :)
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/vsp1/vsp1_rwpf.h |  2 +
> >  drivers/media/platform/vsp1/vsp1_wpf.c  | 73 ++++++++++++++++++++++---
> >  2 files changed, 66 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> > index 70742ecf766f..910990b27617 100644
> > --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> > +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> > @@ -35,6 +35,7 @@ struct vsp1_rwpf {
> >  	struct v4l2_ctrl_handler ctrls;
> >  
> >  	struct vsp1_video *video;
> > +	bool has_writeback;
> >  
> >  	unsigned int max_width;
> >  	unsigned int max_height;
> > @@ -61,6 +62,7 @@ struct vsp1_rwpf {
> >  	} flip;
> >  
> >  	struct vsp1_rwpf_memory mem;
> > +	bool writeback;
> 
> Does this need to be initialised to false somewhere?
> 
> answering my own question;
>  No - because we allocate the "struct vsp1_rwpf *wpf" with devm_kzalloc.
> 
> >  	struct vsp1_dl_manager *dlm;
> >  };
> > diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> > index fc5c1b0f6633..390ac478336d 100644
> > --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> > +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> > @@ -232,6 +232,27 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
> >  	vsp1_dlm_destroy(wpf->dlm);
> >  }
> >  
> > +static int wpf_configure_writeback_chain(struct vsp1_rwpf *wpf,
> > +					 struct vsp1_dl_list *dl)
> > +{
> > +	unsigned int index = wpf->entity.index;
> > +	struct vsp1_dl_list *dl_next;
> > +	struct vsp1_dl_body *dlb;
> > +
> > +	dl_next = vsp1_dl_list_get(wpf->dlm);> +	if (!dl_next) {
> > +		dev_err(wpf->entity.vsp1->dev,
> > +			"Failed to obtain a dl list, disabling writeback\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	dlb = vsp1_dl_list_get_body0(dl_next);
> > +	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index), 0);
> > +	vsp1_dl_list_add_chain(dl, dl_next);
> 
> Two thoughts for future consideration.
> 
> 1) There was a patch I had floated to reduce the allocations of the pool
> sizes. This would need to be checked if it's ever reconsidered, as we
> now use an extra DL.
> 
> This is currently allocated as 64 lists in vsp1_wpf_create() with:
> 
>  	wpf->dlm = vsp1_dlm_create(vsp1, index, 64);
> 
> which is actually 65 lists because there's a + 1 in vsp1_dlm_create(),
> so I think we have more than we'll ever need for a display pipeline
> currently.
> 
> 
> 2) I did think we could pre-allocate this write back display list and
> re-use it, by always attaching the same "writeback disable display list"
> to the chain.
> 
> If we do that - we'll have to be careful about the refcounting of the
> chained list as it will automatically be put back on to the dlm->free
> list currently when the frame completes.

Yes, and that's why I haven't done so yet. I think it can be implemented
on top of this series as it's an optimization.

> I think it's probably only a small optimisation to re-use the list
> anyway, so just getting a new one and chaining it is certainly adequate
> for this solution.
> 
> > +
> > +	return 0;
> > +}
> > +
> >  static void wpf_configure_stream(struct vsp1_entity *entity,
> >  				 struct vsp1_pipeline *pipe,
> >  				 struct vsp1_dl_list *dl,
> > @@ -241,9 +262,11 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
> >  	struct vsp1_device *vsp1 = wpf->entity.vsp1;
> >  	const struct v4l2_mbus_framefmt *source_format;
> >  	const struct v4l2_mbus_framefmt *sink_format;
> > +	unsigned int index = wpf->entity.index;
> >  	unsigned int i;
> >  	u32 outfmt = 0;
> >  	u32 srcrpf = 0;
> > +	int ret;
> >  
> >  	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
> >  						 wpf->entity.config,
> > @@ -251,8 +274,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
> >  	source_format = vsp1_entity_get_pad_format(&wpf->entity,
> >  						   wpf->entity.config,
> >  						   RWPF_PAD_SOURCE);
> > +
> >  	/* Format */
> > -	if (!pipe->lif) {
> > +	if (!pipe->lif || wpf->writeback) {
> >  		const struct v4l2_pix_format_mplane *format = &wpf->format;
> >  		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
> >  
> > @@ -277,8 +301,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
> >  
> >  		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
> >  
> > -		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
> > -		    wpf->entity.index == 0)
> > +		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) && index == 0)
> >  			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
> >  				       VI6_WPF_ROT_CTRL_LN16 |
> >  				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
> > @@ -289,11 +312,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
> >  
> >  	wpf->outfmt = outfmt;
> >  
> > -	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
> > +	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(index),
> >  			   VI6_DPR_WPF_FPORCH_FP_WPFN);
> >  
> > -	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(wpf->entity.index), 0);
> > -
> >  	/*
> >  	 * Sources. If the pipeline has a single input and BRx is not used,
> >  	 * configure it as the master layer. Otherwise configure all
> > @@ -319,9 +340,26 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
> >  	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
> >  
> >  	/* Enable interrupts. */
> > -	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
> > -	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
> > +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(index), 0);
> > +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(index),
> >  			   VI6_WFP_IRQ_ENB_DFEE);
> > +
> > +	/*
> > +	 * Configure writeback for display pipelines (the wpf writeback flag is
> > +	 * never set for memory-to-memory pipelines). Start by adding a chained
> > +	 * display list to disable writeback after a single frame, and process
> > +	 * to enable writeback. If the display list allocation fails don't
> > +	 * enable writeback as we wouldn't be able to safely disable it,
> > +	 * resulting in possible memory corruption.
> > +	 */
> > +	if (wpf->writeback) {
> > +		ret = wpf_configure_writeback_chain(wpf, dl);
> > +		if (ret < 0)
> > +			wpf->writeback = false;
> > +	}
> > +
> > +	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index),
> > +			   wpf->writeback ? VI6_WPF_WRBCK_CTRL_WBMD : 0);
> >  }
> >  
> >  static void wpf_configure_frame(struct vsp1_entity *entity,
> > @@ -391,7 +429,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
> >  		       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
> >  
> > -	if (pipe->lif)
> > +	/*
> > +	 * For display pipelines without writeback enabled there's no memory
> > +	 * address to configure, return now.
> > +	 */
> > +	if (pipe->lif && !wpf->writeback)
> >  		return;
> >  
> >  	/*
> > @@ -480,6 +522,12 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
> >  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
> >  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
> > +
> > +	/*
> > +	 * Writeback operates in single-shot mode and lasts for a single frame,
> > +	 * reset the writeback flag to false for the next frame.
> > +	 */
> > +	wpf->writeback = false;
> >  }
> >  
> >  static unsigned int wpf_max_width(struct vsp1_entity *entity,
> > @@ -530,6 +578,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
> >  		wpf->max_height = WPF_GEN3_MAX_HEIGHT;
> >  	}
> >  
> > +	/*
> > +	 * On Gen3 WPFs with a LIF output can also write to memory for display
> > +	 * writeback.
> > +	 */
> > +	if (vsp1->info->gen > 2 && index < vsp1->info->lif_count)
> > +		wpf->has_writeback = true;
> > +
> >  	wpf->entity.ops = &wpf_entity_ops;
> >  	wpf->entity.type = VSP1_ENTITY_WPF;
> >  	wpf->entity.index = index;

-- 
Regards,

Laurent Pinchart
