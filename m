Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42862 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbdDNJrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 05:47:12 -0400
Date: Fri, 14 Apr 2017 11:47:00 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] drm: mali-dp: Add writeback connector
Message-ID: <20170414114700.552acc82@bbrezillon>
In-Reply-To: <1480092544-1725-7-git-send-email-brian.starkey@arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
        <1480092544-1725-7-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Nov 2016 16:49:04 +0000
Brian Starkey <brian.starkey@arm.com> wrote:

> +static int
> +malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
> +			       struct drm_crtc_state *crtc_state,
> +			       struct drm_connector_state *conn_state)
> +{
> +	struct malidp_mw_connector_state *mw_state = to_mw_state(conn_state);
> +	struct malidp_drm *malidp = encoder->dev->dev_private;
> +	struct drm_framebuffer *fb;
> +	int i, n_planes;
> +
> +	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
> +		return 0;
> +
> +	fb = conn_state->writeback_job->fb;
> +	if ((fb->width != crtc_state->mode.hdisplay) ||
> +	    (fb->height != crtc_state->mode.vdisplay)) {
> +		DRM_DEBUG_KMS("Invalid framebuffer size %ux%u\n",
> +				fb->width, fb->height);
> +		return -EINVAL;
> +	}

These checks look pretty generic to me. Shouldn't we have a default
helper doing that?

> +
> +	mw_state->format =
> +		malidp_hw_get_format_id(&malidp->dev->map, SE_MEMWRITE,
> +					fb->pixel_format);
> +	if (mw_state->format == MALIDP_INVALID_FORMAT_ID) {

Same goes here. By adding a format_types table similar to what is
exposed in drm_plane [1], we could do this check in the core. The only
thing left to the driver is the 4CC -> driver-specific-id conversion.

> +		struct drm_format_name_buf format_name;
> +
> +		DRM_DEBUG_KMS("Invalid pixel format %s\n",
> +			      drm_get_format_name(fb->pixel_format, &format_name));
> +		return -EINVAL;
> +	}
> +
> +	n_planes = drm_format_num_planes(fb->pixel_format);
> +	for (i = 0; i < n_planes; i++) {
> +		struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(fb, i);
> +		if (!malidp_hw_pitch_valid(malidp->dev, fb->pitches[i])) {
> +			DRM_DEBUG_KMS("Invalid pitch %u for plane %d\n",
> +				      fb->pitches[i], i);
> +			return -EINVAL;
> +		}
> +		mw_state->pitches[i] = fb->pitches[i];
> +		mw_state->addrs[i] = obj->paddr + fb->offsets[i];
> +	}
> +	mw_state->n_planes = n_planes;
> +
> +	return 0;
> +}


[1]http://lxr.free-electrons.com/source/include/drm/drm_plane.h#L482
