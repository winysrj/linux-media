Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36881 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2GMKAR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 06:00:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH v2 5/6] omap3isp: preview: Merge gamma correction and gamma bypass
Date: Fri, 13 Jul 2012 12:00:18 +0200
Message-ID: <2167182.W0ubqqSnGZ@avalon>
In-Reply-To: <4FFFEFA8.10709@iki.fi>
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341581569-8292-6-git-send-email-laurent.pinchart@ideasonboard.com> <4FFFEFA8.10709@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 13 July 2012 12:51:36 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> ...
> 
> > @@ -817,7 +817,7 @@ static const struct preview_update update_attrs[] = {
> >  		offsetof(struct omap3isp_prev_update_config, dcor),
> >  	}, /* OMAP3ISP_PREV_GAMMABYPASS */ {
> >  		NULL,
> > -		preview_enable_gammabypass,
> > +		NULL,
> >  	}, /* OMAP3ISP_PREV_DRK_FRM_CAPTURE */ {
> >  		NULL,
> >  		preview_enable_drkframe_capture,
> > @@ -835,7 +835,7 @@ static const struct preview_update update_attrs[] = {
> >  		offsetof(struct omap3isp_prev_update_config, nf),
> >  	}, /* OMAP3ISP_PREV_GAMMA */ {
> >  		preview_config_gammacorrn,
> > -		NULL,
> > +		preview_enable_gammacorrn,
> >  		offsetof(struct prev_params, gamma),
> >  		FIELD_SIZEOF(struct prev_params, gamma),
> >  		offsetof(struct omap3isp_prev_update_config, gamma),
> 
> Doesn't this change the behaviour of the user space API?

That's correct, it does.

> I'm not sure if we _really_ need to worry about that _too_ much, but I
> think that if OMAP3ISP_PREV_GAMMABYPASS is no longer used anywhere the
> definition should be removed as well to prevent anyone accidentally from
> using it.

Good point. I'll replace it with a comment that warns not to use bit 11.

-- 
Regards,

Laurent Pinchart

