Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36173 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751492AbdIRNFt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:05:49 -0400
Date: Mon, 18 Sep 2017 16:05:31 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 3/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
Message-ID: <20170918130531.GW4914@intel.com>
References: <20170916141726.4921-1-hverkuil@xs4all.nl>
 <20170916141726.4921-4-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170916141726.4921-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 16, 2017 at 04:17:26PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Implement support for this DisplayPort feature.
> 
> The cec device is created whenever it detects an adapter that
> has this feature. It is only removed when a new adapter is connected
> that does not support this. If a new adapter is connected that has
> different properties than the previous one, then the old cec device is
> unregistered and a new one is registered to replace the old one.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Carlos Santa <carlos.santa@intel.com>
> ---
>  drivers/gpu/drm/i915/intel_dp.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
> index 64fa774c855b..fdb853d2c458 100644
> --- a/drivers/gpu/drm/i915/intel_dp.c
> +++ b/drivers/gpu/drm/i915/intel_dp.c
> @@ -32,6 +32,7 @@
>  #include <linux/notifier.h>
>  #include <linux/reboot.h>
>  #include <asm/byteorder.h>
> +#include <media/cec.h>
>  #include <drm/drmP.h>
>  #include <drm/drm_atomic_helper.h>
>  #include <drm/drm_crtc.h>
> @@ -1449,6 +1450,7 @@ static void intel_aux_reg_init(struct intel_dp *intel_dp)
>  static void
>  intel_dp_aux_fini(struct intel_dp *intel_dp)
>  {
> +	cec_unregister_adapter(intel_dp->aux.cec_adap);
>  	kfree(intel_dp->aux.name);
>  }
>  
> @@ -4587,6 +4589,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
>  	intel_connector->detect_edid = edid;
>  
>  	intel_dp->has_audio = drm_detect_monitor_audio(edid);
> +	cec_s_phys_addr_from_edid(intel_dp->aux.cec_adap, edid);
>  }
>  
>  static void
> @@ -4596,6 +4599,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
>  
>  	kfree(intel_connector->detect_edid);
>  	intel_connector->detect_edid = NULL;
> +	cec_phys_addr_invalidate(intel_dp->aux.cec_adap);
>  
>  	intel_dp->has_audio = false;
>  }
> @@ -4616,13 +4620,17 @@ intel_dp_long_pulse(struct intel_connector *intel_connector)
>  	intel_display_power_get(to_i915(dev), intel_dp->aux_power_domain);
>  
>  	/* Can't disconnect eDP, but you can close the lid... */
> -	if (is_edp(intel_dp))
> +	if (is_edp(intel_dp)) {
>  		status = edp_detect(intel_dp);
> -	else if (intel_digital_port_connected(to_i915(dev),
> -					      dp_to_dig_port(intel_dp)))
> +	} else if (intel_digital_port_connected(to_i915(dev),
> +						dp_to_dig_port(intel_dp))) {
>  		status = intel_dp_detect_dpcd(intel_dp);
> -	else
> +		if (status == connector_status_connected)
> +			drm_dp_cec_configure_adapter(&intel_dp->aux,
> +				     intel_dp->aux.name, dev->dev);

This is cluttering up the code a bit. Maybe do this call somewhere
around the intel_dp_configure_mst() call instead since that seems to be
the place where we start to do changes to externally visible state.

Actually, do we want to register cec adapters for MST devices?

And shouldn't we call this regardless of the connector state so that
the cec adapter gets unregistered when the device is disconnected?

> +	} else {
>  		status = connector_status_disconnected;
> +	}
>  
>  	if (status == connector_status_disconnected) {
>  		memset(&intel_dp->compliance, 0, sizeof(intel_dp->compliance));
> @@ -5011,6 +5019,8 @@ intel_dp_hpd_pulse(struct intel_digital_port *intel_dig_port, bool long_hpd)
>  
>  	intel_display_power_get(dev_priv, intel_dp->aux_power_domain);
>  
> +	drm_dp_cec_irq(&intel_dp->aux);
> +
>  	if (intel_dp->is_mst) {
>  		if (intel_dp_check_mst_status(intel_dp) == -EINVAL) {
>  			/*
> -- 
> 2.14.1

-- 
Ville Syrjälä
Intel OTC
