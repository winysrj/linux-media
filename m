Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A52C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 593A32171F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:17:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="nFDIhkTd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfCMLRw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:17:52 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51540 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfCMLRw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:17:52 -0400
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id E12605AA;
        Wed, 13 Mar 2019 12:17:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552475871;
        bh=RRjHUtBaLIshVXjgus34u8P4lf3FgEx/3cxMuFDfcOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFDIhkTdvI6q/A9R54bVAe/jQ78jI+af9BcWW8V1uvtQTt2WeG79ehguNLl54v3fy
         dMG/tHbCMx55EzI/Ap7BJG4QaA9qqzdRReoIKH+8Ir/7SJ+UhR6hdM57tKKt0jWOy/
         blPPXbMEyFnc0gHbBjhgihKPvEh6wEIPGf6QvDWc=
Date:   Wed, 13 Mar 2019 13:17:44 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
Subject: Re: [PATCH v6 09/18] media: vsp1: drm: Split RPF format setting to
 separate function
Message-ID: <20190313111744.GC4722@pendragon.ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-10-laurent.pinchart+renesas@ideasonboard.com>
 <7b446a1c-823e-2cb9-64c4-26f6c828ac7a@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7b446a1c-823e-2cb9-64c4-26f6c828ac7a@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Wed, Mar 13, 2019 at 11:12:57AM +0000, Kieran Bingham wrote:
> On 13/03/2019 00:05, Laurent Pinchart wrote:
> > The code that initializes the RPF format-related fields for display
> > pipelines will also be useful for the WPF to implement writeback
> > support. Split it from vsp1_du_atomic_update() to a new
> > vsp1_du_pipeline_set_rwpf_format() function.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/vsp1/vsp1_drm.c | 55 ++++++++++++++++----------
> >  1 file changed, 35 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> > index 4f1bc51d1ef4..5601a787688b 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -566,6 +566,36 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
> >  	vsp1_dl_list_commit(dl, dl_flags);
> >  }
> >  
> > +static int vsp1_du_pipeline_set_rwpf_format(struct vsp1_device *vsp1,
> > +					    struct vsp1_rwpf *rwpf,
> > +					    u32 pixelformat, unsigned int pitch)
> > +{
> > +	const struct vsp1_format_info *fmtinfo;
> > +	unsigned int chroma_hsub;
> > +
> > +	fmtinfo = vsp1_get_format_info(vsp1, pixelformat);
> > +	if (!fmtinfo) {
> > +		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
> 
> Isn't this now a RWPF ?

It is. I'll drop the "for RPF" part.

> Other than that
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > +			pixelformat);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/*
> > +	 * Only formats with three planes can affect the chroma planes pitch.
> > +	 * All formats with two planes have a horizontal subsampling value of 2,
> > +	 * but combine U and V in a single chroma plane, which thus results in
> > +	 * the luma plane and chroma plane having the same pitch.
> > +	 */
> > +	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
> > +
> > +	rwpf->fmtinfo = fmtinfo;
> > +	rwpf->format.num_planes = fmtinfo->planes;
> > +	rwpf->format.plane_fmt[0].bytesperline = pitch;
> > +	rwpf->format.plane_fmt[1].bytesperline = pitch / chroma_hsub;
> > +
> > +	return 0;
> > +}
> > +
> >  /* -----------------------------------------------------------------------------
> >   * DU Driver API
> >   */
> > @@ -773,9 +803,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
> >  {
> >  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> >  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> > -	const struct vsp1_format_info *fmtinfo;
> > -	unsigned int chroma_hsub;
> >  	struct vsp1_rwpf *rpf;
> > +	int ret;
> >  
> >  	if (rpf_index >= vsp1->info->rpf_count)
> >  		return -EINVAL;
> > @@ -808,25 +837,11 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
> >  	 * Store the format, stride, memory buffer address, crop and compose
> >  	 * rectangles and Z-order position and for the input.
> >  	 */
> > -	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
> > -	if (!fmtinfo) {
> > -		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
> > -			cfg->pixelformat);
> > -		return -EINVAL;
> > -	}
> > +	ret = vsp1_du_pipeline_set_rwpf_format(vsp1, rpf, cfg->pixelformat,
> > +					       cfg->pitch);
> > +	if (ret < 0)
> > +		return ret;
> >  
> > -	/*
> > -	 * Only formats with three planes can affect the chroma planes pitch.
> > -	 * All formats with two planes have a horizontal subsampling value of 2,
> > -	 * but combine U and V in a single chroma plane, which thus results in
> > -	 * the luma plane and chroma plane having the same pitch.
> > -	 */
> > -	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
> > -
> > -	rpf->fmtinfo = fmtinfo;
> > -	rpf->format.num_planes = fmtinfo->planes;
> > -	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
> > -	rpf->format.plane_fmt[1].bytesperline = cfg->pitch / chroma_hsub;
> >  	rpf->alpha = cfg->alpha;
> >  
> >  	rpf->mem.addr[0] = cfg->mem[0];

-- 
Regards,

Laurent Pinchart
