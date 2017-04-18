Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:59286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757370AbdDRRfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 13:35:37 -0400
Date: Tue, 18 Apr 2017 18:35:29 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        liviu.dudau@arm.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] drm: mali-dp: Add writeback connector
Message-ID: <20170418173529.GC325@e106950-lin.cambridge.arm.com>
References: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
 <1480092544-1725-7-git-send-email-brian.starkey@arm.com>
 <20170414114700.552acc82@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20170414114700.552acc82@bbrezillon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 14, 2017 at 11:47:00AM +0200, Boris Brezillon wrote:
>On Fri, 25 Nov 2016 16:49:04 +0000
>Brian Starkey <brian.starkey@arm.com> wrote:
>
>> +static int
>> +malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
>> +			       struct drm_crtc_state *crtc_state,
>> +			       struct drm_connector_state *conn_state)
>> +{
>> +	struct malidp_mw_connector_state *mw_state = to_mw_state(conn_state);
>> +	struct malidp_drm *malidp = encoder->dev->dev_private;
>> +	struct drm_framebuffer *fb;
>> +	int i, n_planes;
>> +
>> +	if (!conn_state->writeback_job || !conn_state->writeback_job->fb)
>> +		return 0;
>> +
>> +	fb = conn_state->writeback_job->fb;
>> +	if ((fb->width != crtc_state->mode.hdisplay) ||
>> +	    (fb->height != crtc_state->mode.vdisplay)) {
>> +		DRM_DEBUG_KMS("Invalid framebuffer size %ux%u\n",
>> +				fb->width, fb->height);
>> +		return -EINVAL;
>> +	}
>
>These checks look pretty generic to me. Shouldn't we have a default
>helper doing that?
>

Yeah makes sense. These should be common to everyone until
cropping/scaling support is added.

>> +
>> +	mw_state->format =
>> +		malidp_hw_get_format_id(&malidp->dev->map, SE_MEMWRITE,
>> +					fb->pixel_format);
>> +	if (mw_state->format == MALIDP_INVALID_FORMAT_ID) {
>
>Same goes here. By adding a format_types table similar to what is
>exposed in drm_plane [1], we could do this check in the core. The only
>thing left to the driver is the 4CC -> driver-specific-id conversion.
>

Yeah could do, but given our driver requires us to run through the
whole table to get the HW ID anyway it seemed like totally wasted
effort to do the same thing in the core.

It's probably a negligible overhead, but it's also unnecessary for
100% of the current writeback implementations ;-)

If a different driver is implemented such that the HW ID lookup isn't
an exhaustive list search then we could add a helper for them to use
which checks the blob.

Cheers,
-Brian

>> +		struct drm_format_name_buf format_name;
>> +
>> +		DRM_DEBUG_KMS("Invalid pixel format %s\n",
>> +			      drm_get_format_name(fb->pixel_format, &format_name));
>> +		return -EINVAL;
>> +	}
>> +
>> +	n_planes = drm_format_num_planes(fb->pixel_format);
>> +	for (i = 0; i < n_planes; i++) {
>> +		struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(fb, i);
>> +		if (!malidp_hw_pitch_valid(malidp->dev, fb->pitches[i])) {
>> +			DRM_DEBUG_KMS("Invalid pitch %u for plane %d\n",
>> +				      fb->pitches[i], i);
>> +			return -EINVAL;
>> +		}
>> +		mw_state->pitches[i] = fb->pitches[i];
>> +		mw_state->addrs[i] = obj->paddr + fb->offsets[i];
>> +	}
>> +	mw_state->n_planes = n_planes;
>> +
>> +	return 0;
>> +}
>
>
>[1]http://lxr.free-electrons.com/source/include/drm/drm_plane.h#L482
