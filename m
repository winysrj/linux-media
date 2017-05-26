Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1372 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S971067AbdEZKJj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 06:09:39 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 7/7] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
In-Reply-To: <20170525150626.29748-8-hverkuil@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl> <20170525150626.29748-8-hverkuil@xs4all.nl>
Date: Fri, 26 May 2017 13:13:02 +0300
Message-ID: <87h908lydt.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 25 May 2017, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> @@ -4179,6 +4181,33 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
>  	return -EINVAL;
>  }
>  
> +static bool
> +intel_dp_check_cec_status(struct intel_dp *intel_dp)
> +{
> +	bool handled = false;
> +
> +	for (;;) {
> +		u8 cec_irq;
> +		int ret;
> +
> +		ret = drm_dp_dpcd_readb(&intel_dp->aux,
> +					DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
> +					&cec_irq);
> +		if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
> +			return handled;
> +
> +		cec_irq &= ~DP_CEC_IRQ;
> +		drm_dp_cec_irq(&intel_dp->aux);
> +		handled = true;
> +
> +		ret = drm_dp_dpcd_writeb(&intel_dp->aux,
> +					 DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
> +					 cec_irq);
> +		if (ret < 0)
> +			return handled;
> +	}

DP sinks suck. Please add a limit to the loop.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
