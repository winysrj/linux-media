Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90569C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 23:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60C31218AD
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 23:24:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="WBk9ce/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfBRXYM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 18:24:12 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:37146 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730410AbfBRXYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 18:24:10 -0500
Received: from pendragon.ideasonboard.com (91-152-6-44.elisa-laajakaista.fi [91.152.6.44])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4D7A753B;
        Tue, 19 Feb 2019 00:24:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550532248;
        bh=xM0dgMwcqOZ2sg5KkzgNDaEKlakZTj+dBN0Iom8enuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WBk9ce/4kTm9ifQi3SdsiJ1A5/obM9VjSyY2Ri4WL9tE8k0LPa1OsOXeri3M2oXN3
         YGcmPWFCTEW6MAnJB06pE95h0aqRBVjfWuB5QDktvJzgFTFAt3H2LVQNp5vEs4ajpG
         efI6j+XlyXI+TS7ILrUmOfso9ZEOY3aQey5lB5AM=
Date:   Tue, 19 Feb 2019 01:24:03 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 2/7] media: vsp1: wpf: Fix partition configuration for
 display pipelines
Message-ID: <20190218232403.GC5082@pendragon.ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190217024852.23328-3-laurent.pinchart+renesas@ideasonboard.com>
 <5f5c255c-1071-78e9-e64f-8dcdfa20ea80@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f5c255c-1071-78e9-e64f-8dcdfa20ea80@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Sun, Feb 17, 2019 at 08:16:27PM +0000, Kieran Bingham wrote:
> On 17/02/2019 02:48, Laurent Pinchart wrote:
> > The WPF accesses partition configuration from pipe->partition in the
> > partition configuration that is not used for display pipelines.
> 
> That sentence is hard to read...

Indeed. I'll rewrite it.

> > Writeback support will require full configuration of the WPF while not
> > providing a valid pipe->partition. Rework the configuration code to fall
> > back to the full image width in that case, as is already done for the
> > part of the configuration currently relevant for display pipelines.
> > 
> 
> Ah yes - this is probably a better route than allocating a table for a
> single partition (which is what I had locally).
> 
> 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> I like that this change also simplifies the flip/rotate handling code to
> make that easier to read.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> >  drivers/media/platform/vsp1/vsp1_wpf.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> > index 32bb207b2007..a07c5944b598 100644
> > --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> > +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> > @@ -362,6 +362,7 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  	const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
> >  	unsigned int width;
> >  	unsigned int height;
> > +	unsigned int left;
> >  	unsigned int offset;
> >  	unsigned int flip;
> >  	unsigned int i;
> > @@ -371,13 +372,16 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  						 RWPF_PAD_SINK);
> >  	width = sink_format->width;
> >  	height = sink_format->height;
> > +	left = 0;
> >  
> >  	/*
> >  	 * Cropping. The partition algorithm can split the image into
> >  	 * multiple slices.
> >  	 */
> > -	if (pipe->partitions > 1)
> > +	if (pipe->partitions > 1) {
> >  		width = pipe->partition->wpf.width;
> > +		left = pipe->partition->wpf.left;
> > +	}
> >  
> >  	vsp1_wpf_write(wpf, dlb, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
> >  		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
> > @@ -408,13 +412,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  	flip = wpf->flip.active;
> >  
> >  	if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
> > -		offset = format->width - pipe->partition->wpf.left
> > -			- pipe->partition->wpf.width;
> > +		offset = format->width - left - width;
> >  	else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
> > -		offset = format->height - pipe->partition->wpf.left
> > -			- pipe->partition->wpf.width;
> > +		offset = format->height - left - width;
> >  	else
> > -		offset = pipe->partition->wpf.left;
> > +		offset = left;
> 
> This hunk looks a lot simpler :)
> 
> 
> >  
> >  	for (i = 0; i < format->num_planes; ++i) {
> >  		unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
> > @@ -436,7 +438,7 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
> >  		 * image height.
> >  		 */
> >  		if (wpf->flip.rotate)
> > -			height = pipe->partition->wpf.width;
> > +			height = width;
> >  		else
> >  			height = format->height;
> >  
> > 
> 
> -- 
> Regards
> --
> Kieran

-- 
Regards,

Laurent Pinchart
