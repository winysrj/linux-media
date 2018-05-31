Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:56096 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755181AbeEaNVE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 09:21:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id a8-v6so53965689wmg.5
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 06:21:04 -0700 (PDT)
Subject: Re: [Intel-gfx] [PATCH v6 2/6] drm/i915: hdmi: add CEC notifier to
 intel_hdmi
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com, sadolfsson@google.com,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, fparent@baylibre.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        linux-media@vger.kernel.org
References: <1527155841-28494-1-git-send-email-narmstrong@baylibre.com>
 <1527155841-28494-3-git-send-email-narmstrong@baylibre.com>
 <20180530152936.GQ23723@intel.com>
From: Neil Armstrong <narmstrong@baylibre.com>
Message-ID: <fd9af0f6-67d2-d792-8643-62a24f149f60@baylibre.com>
Date: Thu, 31 May 2018 15:21:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180530152936.GQ23723@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/05/2018 17:29, Ville Syrjälä wrote:
> On Thu, May 24, 2018 at 11:57:17AM +0200, Neil Armstrong wrote:
>> This patchs adds the cec_notifier feature to the intel_hdmi part
>> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
>> between each HDMI ports.
>> The changes will allow the i915 HDMI code to notify EDID and HPD changes
>> to an eventual CEC adapter.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/gpu/drm/i915/Kconfig         |  1 +
>>  drivers/gpu/drm/i915/intel_display.h | 20 ++++++++++++++++++++
>>  drivers/gpu/drm/i915/intel_drv.h     |  2 ++
>>  drivers/gpu/drm/i915/intel_hdmi.c    | 13 +++++++++++++
>>  4 files changed, 36 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
>> index dfd9588..2d65d56 100644
>> --- a/drivers/gpu/drm/i915/Kconfig
>> +++ b/drivers/gpu/drm/i915/Kconfig
>> @@ -23,6 +23,7 @@ config DRM_I915
>>  	select SYNC_FILE
>>  	select IOSF_MBI
>>  	select CRC32
>> +	select CEC_CORE if CEC_NOTIFIER
>>  	help
>>  	  Choose this option if you have a system that has "Intel Graphics
>>  	  Media Accelerator" or "HD Graphics" integrated graphics,
>> diff --git a/drivers/gpu/drm/i915/intel_display.h b/drivers/gpu/drm/i915/intel_display.h
>> index 4e7418b..c68d1c8 100644
>> --- a/drivers/gpu/drm/i915/intel_display.h
>> +++ b/drivers/gpu/drm/i915/intel_display.h
>> @@ -126,6 +126,26 @@ enum port {
>>  
>>  #define port_name(p) ((p) + 'A')
>>  
>> +static inline const char *port_identifier(enum port port)
>> +{
>> +	switch (port) {
>> +	case PORT_A:
>> +		return "Port A";
>> +	case PORT_B:
>> +		return "Port B";
>> +	case PORT_C:
>> +		return "Port C";
>> +	case PORT_D:
>> +		return "Port D";
>> +	case PORT_E:
>> +		return "Port E";
>> +	case PORT_F:
>> +		return "Port F";
>> +	default:
>> +		return "<invalid>";
>> +	}
>> +}
> 
> Could use a comment to make it clear that this identifier is
> expected to remain stable since it's referenced from other drivers.
> 
>> +
>>  enum dpio_channel {
>>  	DPIO_CH0,
>>  	DPIO_CH1
>> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
>> index d436858..b50e51b 100644
>> --- a/drivers/gpu/drm/i915/intel_drv.h
>> +++ b/drivers/gpu/drm/i915/intel_drv.h
>> @@ -39,6 +39,7 @@
>>  #include <drm/drm_dp_mst_helper.h>
>>  #include <drm/drm_rect.h>
>>  #include <drm/drm_atomic.h>
>> +#include <media/cec-notifier.h>
>>  
>>  /**
>>   * __wait_for - magic wait macro
>> @@ -1001,6 +1002,7 @@ struct intel_hdmi {
>>  	bool has_audio;
>>  	bool rgb_quant_range_selectable;
>>  	struct intel_connector *attached_connector;
>> +	struct cec_notifier *notifier;
> 
> "notifier" seems a bit too generic a name. "cec_notifier" would be
> better.

OK

> 
> Apart from that this seems OK to me
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

Thanks for the review !

Neil

> 
>>  };
>>  
>>  struct intel_dp_mst_encoder;
>> diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
>> index 1baef4a..d522b5b 100644
>> --- a/drivers/gpu/drm/i915/intel_hdmi.c
>> +++ b/drivers/gpu/drm/i915/intel_hdmi.c
>> @@ -1868,6 +1868,8 @@ intel_hdmi_set_edid(struct drm_connector *connector)
>>  		connected = true;
>>  	}
>>  
>> +	cec_notifier_set_phys_addr_from_edid(intel_hdmi->notifier, edid);
>> +
>>  	return connected;
>>  }
>>  
>> @@ -1876,6 +1878,7 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
>>  {
>>  	enum drm_connector_status status;
>>  	struct drm_i915_private *dev_priv = to_i915(connector->dev);
>> +	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
>>  
>>  	DRM_DEBUG_KMS("[CONNECTOR:%d:%s]\n",
>>  		      connector->base.id, connector->name);
>> @@ -1891,6 +1894,9 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
>>  
>>  	intel_display_power_put(dev_priv, POWER_DOMAIN_GMBUS);
>>  
>> +	if (status != connector_status_connected)
>> +		cec_notifier_phys_addr_invalidate(intel_hdmi->notifier);
>> +
>>  	return status;
>>  }
>>  
>> @@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
>>  
>>  static void intel_hdmi_destroy(struct drm_connector *connector)
>>  {
>> +	if (intel_attached_hdmi(connector)->notifier)
>> +		cec_notifier_put(intel_attached_hdmi(connector)->notifier);
>>  	kfree(to_intel_connector(connector)->detect_edid);
>>  	drm_connector_cleanup(connector);
>>  	kfree(connector);
>> @@ -2358,6 +2366,11 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
>>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
>>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
>>  	}
>> +
>> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev,
>> +						     port_identifier(port));
>> +	if (!intel_hdmi->notifier)
>> +		DRM_DEBUG_KMS("CEC notifier get failed\n");
>>  }
>>  
>>  void intel_hdmi_init(struct drm_i915_private *dev_priv,
>> -- 
>> 2.7.4
>>
>> _______________________________________________
>> Intel-gfx mailing list
>> Intel-gfx@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
