Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592CFC282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 16:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 278C820842
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 16:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HNP4czxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbfBLQba (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 11:31:30 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45126 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbfBLQba (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 11:31:30 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 956B685;
        Tue, 12 Feb 2019 17:31:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1549989087;
        bh=YrWGJgoojV+8n1JmYm4523iaCbPLVShipRkkbD/L00g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HNP4czxWgFIyfsBaK+FMT8SsN1mjLunlAi4ZSxjH2pkuwyZmR3OwjSQDKzaa6e8gh
         z42jLx2ZcS3kNs/G2lUFf7DfG27rDmy+aO5LkpGDZ4HEzaTzls4cITW3Upkvzi8Pse
         lilF/HDlZXkmPmhXlRxF2yU3bKl87BUIN1RpMJt0=
Date:   Tue, 12 Feb 2019 18:31:22 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Subject: Re: [PATCH 4/6] vsp1: fix smatch warning
Message-ID: <20190212163122.GS6279@pendragon.ideasonboard.com>
References: <20190207091338.55705-1-hverkuil-cisco@xs4all.nl>
 <20190207091338.55705-5-hverkuil-cisco@xs4all.nl>
 <853728f6-e4b2-5324-47b2-9a5b99224ad0@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <853728f6-e4b2-5324-47b2-9a5b99224ad0@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Feb 12, 2019 at 01:48:00PM +0000, Kieran Bingham wrote:
> On 07/02/2019 09:13, Hans Verkuil wrote:
> > drivers/media/platform/vsp1/vsp1_drm.c: drivers/media/platform/vsp1/vsp1_drm.c:336 vsp1_du_pipeline_setup_brx() error: we previously assumed 'pipe->brx' could be null (see line 244)
> > 
> > smatch missed that if pipe->brx was NULL, then later on it will be
> > set with a non-NULL value. But it is easier to just use the brx pointer
> > so smatch doesn't get confused.
> > 
> 
> Aha, my initial reaction to this was "Oh - but we've already looked at
> this and it was a false positive ..." And then I looked at your patch ...
> 
> So my initial reaction was completely wrong - and you have indeed got a
> good patch :)
> 
> As this function is to 'setup the brx' I think it's very reasonable to
> use the chosen BRX pointer to do the configuration. (once all the
> dancing has gone on to swap as necessary)
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> And for sanity, I've tested this with our VSP Tests on both:
> 
>   Salvator-XS-H3 ES2.0 : 164 tests: 148 passed, 0 failed, 3 skipped
> and
>   Salvator-XS-M3N      : 164 tests: 148 passed, 0 failed, 3 skipped
> 
> 
> Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Tested-on: Salvator-XS-ES2.0, Salvator-XS-M3N

Taken in my tree with all these tags and my

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> >  drivers/media/platform/vsp1/vsp1_drm.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> > index 8d86f618ec77..84895385d2e5 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -333,19 +333,19 @@ static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
> >  	 * on the BRx sink pad 0 and propagated inside the entity, not on the
> >  	 * source pad.
> >  	 */
> > -	format.pad = pipe->brx->source_pad;
> > +	format.pad = brx->source_pad;
> >  	format.format.width = drm_pipe->width;
> >  	format.format.height = drm_pipe->height;
> >  	format.format.field = V4L2_FIELD_NONE;
> >  
> > -	ret = v4l2_subdev_call(&pipe->brx->subdev, pad, set_fmt, NULL,
> > +	ret = v4l2_subdev_call(&brx->subdev, pad, set_fmt, NULL,
> >  			       &format);
> >  	if (ret < 0)
> >  		return ret;
> >  
> >  	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
> >  		__func__, format.format.width, format.format.height,
> > -		format.format.code, BRX_NAME(pipe->brx), pipe->brx->source_pad);
> > +		format.format.code, BRX_NAME(brx), brx->source_pad);
> >  
> >  	if (format.format.width != drm_pipe->width ||
> >  	    format.format.height != drm_pipe->height) {

-- 
Regards,

Laurent Pinchart
