Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9728 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751974AbdHJAk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 20:40:58 -0400
Message-ID: <1502325562.76063.10.camel@intel.com>
Subject: Re: [PATCH 3/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
From: Carlos Santa <carlos.santa@intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Wed, 09 Aug 2017 17:39:22 -0700
In-Reply-To: <20170711133011.41139-4-hverkuil@xs4all.nl>
References: <20170711133011.41139-1-hverkuil@xs4all.nl>
         <20170711133011.41139-4-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-07-11 at 15:30 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Implement support for this DisplayPort feature.
> 
> The cec device is created whenever it detects an adapter that
> has this feature. It is only removed when a new adapter is connected
> that does not support this. If a new adapter is connected that has
> different properties than the previous one, then the old cec device
> is
> unregistered and a new one is registered to replace the old one.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

This was tested internally using the EE-PW700 adapter (DisplayPort/USB-
C to HDMI) from Samsung on a Skylake platform.

Several commands were tested including: 

# cec-ctl --playback

# turns the TV off
# cec-ctl -t=0 --standby

# turns the TV on
# cec-ctl -t=0 --image-view-on

The cec-compliance binary was also run and it reported no failures.

Tested-by: Carlos Santa <carlos.santa@intel.com>

>  drivers/gpu/drm/i915/intel_dp.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c
> b/drivers/gpu/drm/i915/intel_dp.c
> index 64fa774c855b..fdb853d2c458 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -32,6 +32,7 @@
>  #include <linux/notifier.h>
>  #include <linux/reboot.h>
>  #include <asm/byteorder.h>
> +#include <media/cec.h>
>  #include <drm/drmP.h>
>  #include <drm/drm_atomic_helper.h>
>  #include <drm/drm_crtc.h>
> @@ -1449,6 +1450,7 @@ static void intel_aux_reg_init(struct intel_dp
> *intel_dp)
>  static void
>  intel_dp_aux_fini(struct intel_dp *intel_dp)
>  {
> +	cec_unregister_adapter(intel_dp->aux.cec_adap);
>  	kfree(intel_dp->aux.name);
>  }
>  
> @@ -4587,6 +4589,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
>  	intel_connector->detect_edid = edid;
>  
>  	intel_dp->has_audio = drm_detect_monitor_audio(edid);
> +	cec_s_phys_addr_from_edid(intel_dp->aux.cec_adap, edid);
>  }
>  
>  static void
> @@ -4596,6 +4599,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
>  
>  	kfree(intel_connector->detect_edid);
>  	intel_connector->detect_edid = NULL;
> +	cec_phys_addr_invalidate(intel_dp->aux.cec_adap);
>  
>  	intel_dp->has_audio = false;
>  }
> @@ -4616,13 +4620,17 @@ intel_dp_long_pulse(struct intel_connector
> *intel_connector)
>  	intel_display_power_get(to_i915(dev), intel_dp-
> >aux_power_domain);
>  
>  	/* Can't disconnect eDP, but you can close the lid... */
> -	if (is_edp(intel_dp))
> +	if (is_edp(intel_dp)) {
>  		status = edp_detect(intel_dp);
> -	else if (intel_digital_port_connected(to_i915(dev),
> -					      dp_to_dig_port(intel_d
> p)))
> +	} else if (intel_digital_port_connected(to_i915(dev),
> +						dp_to_dig_port(intel
> _dp))) {
>  		status = intel_dp_detect_dpcd(intel_dp);
> -	else
> +		if (status == connector_status_connected)
> +			drm_dp_cec_configure_adapter(&intel_dp->aux,
> +				     intel_dp->aux.name, dev->dev);
> +	} else {
>  		status = connector_status_disconnected;
> +	}
>  
>  	if (status == connector_status_disconnected) {
>  		memset(&intel_dp->compliance, 0, sizeof(intel_dp-
> >compliance));
> @@ -5011,6 +5019,8 @@ intel_dp_hpd_pulse(struct intel_digital_port
> *intel_dig_port, bool long_hpd)
>  
>  	intel_display_power_get(dev_priv, intel_dp-
> >aux_power_domain);
>  
> +	drm_dp_cec_irq(&intel_dp->aux);
> +
>  	if (intel_dp->is_mst) {
>  		if (intel_dp_check_mst_status(intel_dp) == -EINVAL)
> {
>  			/*
