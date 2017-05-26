Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38796 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1947562AbdEZKUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 06:20:53 -0400
Subject: Re: [RFC PATCH 7/7] drm/i915: add DisplayPort CEC-Tunneling-over-AUX
 support
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
 <20170525150626.29748-8-hverkuil@xs4all.nl>
 <20170526071550.3gsq3pc375cnk2gk@phenom.ffwll.local>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0a417a9c-4a41-796c-9876-51b61d429bb5@xs4all.nl>
Date: Fri, 26 May 2017 12:20:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170526071550.3gsq3pc375cnk2gk@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/26/2017 09:15 AM, Daniel Vetter wrote:
> On Thu, May 25, 2017 at 05:06:26PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Implement support for this DisplayPort feature.
>>
>> The cec device is created whenever it detects an adapter that
>> has this feature. It is only removed when a new adapter is connected
>> that does not support this. If a new adapter is connected that has
>> different properties than the previous one, then the old cec device is
>> unregistered and a new one is registered to replace the old one.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Some small comments below.
> 
>> ---
>>  drivers/gpu/drm/i915/Kconfig    | 11 ++++++++++
>>  drivers/gpu/drm/i915/intel_dp.c | 46 +++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 53 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
>> index a5cd5dacf055..f317b13a1409 100644
>> --- a/drivers/gpu/drm/i915/Kconfig
>> +++ b/drivers/gpu/drm/i915/Kconfig
>> @@ -124,6 +124,17 @@ config DRM_I915_GVT_KVMGT
>>  	  Choose this option if you want to enable KVMGT support for
>>  	  Intel GVT-g.
>>  
>> +config DRM_I915_DP_CEC
>> +	tristate "Enable DisplayPort CEC-Tunneling-over-AUX HDMI support"
>> +	depends on DRM_I915 && CEC_CORE
>> +	select DRM_DP_CEC
>> +	help
>> +	  Choose this option if you want to enable HDMI CEC support for
>> +	  DisplayPort/USB-C to HDMI adapters.
>> +
>> +	  Note: not all adapters support this feature, and even for those
>> +	  that do support this often do not hook up the CEC pin.
> 
> Why Kconfig? There's not anything else optional in i915.ko (except debug
> stuff ofc), since generally just not worth the pain. Also doesn't seem to
> be wired up at all :-)

It selects DRM_DP_CEC, but you're right, it can be dropped.

> 
>> +
>>  menu "drm/i915 Debugging"
>>  depends on DRM_I915
>>  depends on EXPERT
>> diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
>> index ee77b519835c..38e17ee2548d 100644
>> --- a/drivers/gpu/drm/i915/intel_dp.c
>> +++ b/drivers/gpu/drm/i915/intel_dp.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/notifier.h>
>>  #include <linux/reboot.h>
>>  #include <asm/byteorder.h>
>> +#include <media/cec.h>
>>  #include <drm/drmP.h>
>>  #include <drm/drm_atomic_helper.h>
>>  #include <drm/drm_crtc.h>
>> @@ -1405,6 +1406,7 @@ static void intel_aux_reg_init(struct intel_dp *intel_dp)
>>  static void
>>  intel_dp_aux_fini(struct intel_dp *intel_dp)
>>  {
>> +	cec_unregister_adapter(intel_dp->aux.cec_adap);
>>  	kfree(intel_dp->aux.name);
>>  }
>>  
>> @@ -4179,6 +4181,33 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
>>  	return -EINVAL;
>>  }
>>  
>> +static bool
>> +intel_dp_check_cec_status(struct intel_dp *intel_dp)
>> +{
>> +	bool handled = false;
>> +
>> +	for (;;) {
>> +		u8 cec_irq;
>> +		int ret;
>> +
>> +		ret = drm_dp_dpcd_readb(&intel_dp->aux,
>> +					DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
>> +					&cec_irq);
>> +		if (ret < 0 || !(cec_irq & DP_CEC_IRQ))
>> +			return handled;
>> +
>> +		cec_irq &= ~DP_CEC_IRQ;
>> +		drm_dp_cec_irq(&intel_dp->aux);
>> +		handled = true;
>> +
>> +		ret = drm_dp_dpcd_writeb(&intel_dp->aux,
>> +					 DP_DEVICE_SERVICE_IRQ_VECTOR_ESI1,
>> +					 cec_irq);
>> +		if (ret < 0)
>> +			return handled;
>> +	}
>> +}
> 
> Shouldn't the above be a helper in the cec library? Doesn't look i915
> specific to me at least ...

Good point, this can be moved to drm_dp_cec_irq().

> 
>> +
>>  static void
>>  intel_dp_retrain_link(struct intel_dp *intel_dp)
>>  {
>> @@ -4553,6 +4582,7 @@ intel_dp_set_edid(struct intel_dp *intel_dp)
>>  		intel_dp->has_audio = intel_dp->force_audio == HDMI_AUDIO_ON;
>>  	else
>>  		intel_dp->has_audio = drm_detect_monitor_audio(edid);
>> +	cec_s_phys_addr_from_edid(intel_dp->aux.cec_adap, edid);
>>  }
>>  
>>  static void
>> @@ -4562,6 +4592,7 @@ intel_dp_unset_edid(struct intel_dp *intel_dp)
>>  
>>  	kfree(intel_connector->detect_edid);
>>  	intel_connector->detect_edid = NULL;
>> +	cec_phys_addr_invalidate(intel_dp->aux.cec_adap);
>>  
>>  	intel_dp->has_audio = false;
>>  }
>> @@ -4582,13 +4613,17 @@ intel_dp_long_pulse(struct intel_connector *intel_connector)
>>  	intel_display_power_get(to_i915(dev), intel_dp->aux_power_domain);
>>  
>>  	/* Can't disconnect eDP, but you can close the lid... */
>> -	if (is_edp(intel_dp))
>> +	if (is_edp(intel_dp)) {
>>  		status = edp_detect(intel_dp);
>> -	else if (intel_digital_port_connected(to_i915(dev),
>> -					      dp_to_dig_port(intel_dp)))
>> +	} else if (intel_digital_port_connected(to_i915(dev),
>> +						dp_to_dig_port(intel_dp))) {
>>  		status = intel_dp_detect_dpcd(intel_dp);
>> -	else
>> +		if (status == connector_status_connected)
>> +			drm_dp_cec_configure_adapter(&intel_dp->aux,
>> +				     intel_dp->aux.name, dev->dev);
> 
> Did you look into also wiring this up for dp mst chains?

Isn't this sufficient? I have no way of testing mst chains.

I think I need some pointers from you, since I am a complete newbie when it
comes to mst.

Regards,

	Hans

> -Daniel
> 
>> +	} else {
>>  		status = connector_status_disconnected;
>> +	}
>>  
>>  	if (status == connector_status_disconnected) {
>>  		memset(&intel_dp->compliance, 0, sizeof(intel_dp->compliance));
>> @@ -5080,6 +5115,9 @@ intel_dp_hpd_pulse(struct intel_digital_port *intel_dig_port, bool long_hpd)
>>  
>>  	intel_display_power_get(dev_priv, intel_dp->aux_power_domain);
>>  
>> +	if (intel_dp->aux.cec_adap)
>> +		intel_dp_check_cec_status(intel_dp);
>> +
>>  	if (intel_dp->is_mst) {
>>  		if (intel_dp_check_mst_status(intel_dp) == -EINVAL) {
>>  			/*
>> -- 
>> 2.11.0
>>
> 
