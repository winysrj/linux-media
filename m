Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:35609 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752334AbeEOG3L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 02:29:11 -0400
Subject: Re: [RFC PATCH 3/5] drm/i915: hdmi: add CEC notifier to intel_hdmi
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
 <1526337639-3568-4-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b38aa2db-903a-c882-69d6-170b3c2aa70c@xs4all.nl>
Date: Tue, 15 May 2018 08:29:05 +0200
MIME-Version: 1.0
In-Reply-To: <1526337639-3568-4-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2018 12:40 AM, Neil Armstrong wrote:
> This patchs adds the cec_notifier feature to the intel_hdmi part
> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
> between each HDMI ports.
> The changes will allow the i915 HDMI code to notify EDID and HPD changes
> to an eventual CEC adapter.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>  drivers/gpu/drm/i915/intel_hdmi.c | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
> index d436858..b50e51b 100644
> --- a/drivers/gpu/drm/i915/intel_drv.h
> +++ b/drivers/gpu/drm/i915/intel_drv.h
> @@ -39,6 +39,7 @@
>  #include <drm/drm_dp_mst_helper.h>
>  #include <drm/drm_rect.h>
>  #include <drm/drm_atomic.h>
> +#include <media/cec-notifier.h>
>  
>  /**
>   * __wait_for - magic wait macro
> @@ -1001,6 +1002,7 @@ struct intel_hdmi {
>  	bool has_audio;
>  	bool rgb_quant_range_selectable;
>  	struct intel_connector *attached_connector;
> +	struct cec_notifier *notifier;
>  };
>  
>  struct intel_dp_mst_encoder;
> diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
> index 1baef4a..9b94d72 100644
> --- a/drivers/gpu/drm/i915/intel_hdmi.c
> +++ b/drivers/gpu/drm/i915/intel_hdmi.c
> @@ -1868,6 +1868,8 @@ intel_hdmi_set_edid(struct drm_connector *connector)
>  		connected = true;
>  	}
>  
> +	cec_notifier_set_phys_addr_from_edid(intel_hdmi->notifier, edid);
> +
>  	return connected;
>  }
>  
> @@ -1876,6 +1878,7 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
>  {
>  	enum drm_connector_status status;
>  	struct drm_i915_private *dev_priv = to_i915(connector->dev);
> +	struct intel_hdmi *intel_hdmi = intel_attached_hdmi(connector);
>  
>  	DRM_DEBUG_KMS("[CONNECTOR:%d:%s]\n",
>  		      connector->base.id, connector->name);
> @@ -1891,6 +1894,9 @@ intel_hdmi_detect(struct drm_connector *connector, bool force)
>  
>  	intel_display_power_put(dev_priv, POWER_DOMAIN_GMBUS);
>  
> +	if (status != connector_status_connected)
> +		cec_notifier_phys_addr_invalidate(intel_hdmi->notifier);
> +
>  	return status;
>  }
>  
> @@ -2358,6 +2364,10 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
>  	}
> +
> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev, connector->name);
> +	if (!intel_hdmi->notifier)
> +		DRM_DEBUG_KMS("CEC notifier get failed\n");

You 'get' the notifier here, but where is the cec_notifier_put when the connector is deleted?

Regards,

	Hans

>  }
>  
>  void intel_hdmi_init(struct drm_i915_private *dev_priv,
> 
