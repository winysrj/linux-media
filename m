Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33559 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753633AbcJKPox (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 11:44:53 -0400
Received: by mail-lf0-f67.google.com with SMTP id l131so1725024lfl.0
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 08:44:52 -0700 (PDT)
Date: Tue, 11 Oct 2016 17:44:48 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl, eric@anholt.net,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 02/11] drm/fb-helper: Skip writeback connectors
Message-ID: <20161011154448.GE20761@phenom.ffwll.local>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <1476197648-24918-3-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476197648-24918-3-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 03:53:59PM +0100, Brian Starkey wrote:
> Writeback connectors aren't much use to the fbdev helpers, as they won't
> show anything to the user. Skip them when looking for candidate output
> configurations.
> 
> Signed-off-by: Brian Starkey <brian.starkey@arm.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 03414bd..dedf6e7 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -2016,6 +2016,10 @@ static int drm_pick_crtcs(struct drm_fb_helper *fb_helper,
>  	if (modes[n] == NULL)
>  		return best_score;
>  
> +	/* Writeback connectors aren't much use for fbdev */
> +	if (connector->connector_type == DRM_MODE_CONNECTOR_WRITEBACK)
> +		return best_score;

I think we could handle this by always marking writeback connectors as
disconnected. Userspace and fbdev emulation should then avoid them,
always.
-Daniel

> +
>  	crtcs = kzalloc(fb_helper->connector_count *
>  			sizeof(struct drm_fb_helper_crtc *), GFP_KERNEL);
>  	if (!crtcs)
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
