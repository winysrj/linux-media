Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:24323 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030Ab2GMJvW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 05:51:22 -0400
Message-ID: <4FFFEFA8.10709@iki.fi>
Date: Fri, 13 Jul 2012 12:51:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH v2 5/6] omap3isp: preview: Merge gamma correction and
 gamma bypass
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341581569-8292-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341581569-8292-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patches.

Laurent Pinchart wrote:
...
> @@ -817,7 +817,7 @@ static const struct preview_update update_attrs[] = {
>  		offsetof(struct omap3isp_prev_update_config, dcor),
>  	}, /* OMAP3ISP_PREV_GAMMABYPASS */ {
>  		NULL,
> -		preview_enable_gammabypass,
> +		NULL,
>  	}, /* OMAP3ISP_PREV_DRK_FRM_CAPTURE */ {
>  		NULL,
>  		preview_enable_drkframe_capture,
> @@ -835,7 +835,7 @@ static const struct preview_update update_attrs[] = {
>  		offsetof(struct omap3isp_prev_update_config, nf),
>  	}, /* OMAP3ISP_PREV_GAMMA */ {
>  		preview_config_gammacorrn,
> -		NULL,
> +		preview_enable_gammacorrn,
>  		offsetof(struct prev_params, gamma),
>  		FIELD_SIZEOF(struct prev_params, gamma),
>  		offsetof(struct omap3isp_prev_update_config, gamma),

Doesn't this change the behaviour of the user space API?

I'm not sure if we _really_ need to worry about that _too_ much, but I
think that if OMAP3ISP_PREV_GAMMABYPASS is no longer used anywhere the
definition should be removed as well to prevent anyone accidentally from
using it.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi


