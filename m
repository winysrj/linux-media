Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38294 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753005AbeEOPYA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 11:24:00 -0400
Subject: Re: [PATCH v2 2/5] drm/i915: hdmi: add CEC notifier to intel_hdmi
To: Neil Armstrong <narmstrong@baylibre.com>, airlied@linux.ie,
        hans.verkuil@cisco.com, lee.jones@linaro.org, olof@lixom.net,
        seanpaul@google.com
Cc: sadolfsson@google.com, felixe@google.com, bleung@google.com,
        darekm@google.com, marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
 <1526395342-15481-3-git-send-email-narmstrong@baylibre.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <64d3d3b4-8242-ef78-ef74-a9dc354c7f26@xs4all.nl>
Date: Tue, 15 May 2018 17:23:54 +0200
MIME-Version: 1.0
In-Reply-To: <1526395342-15481-3-git-send-email-narmstrong@baylibre.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2018 04:42 PM, Neil Armstrong wrote:
> This patchs adds the cec_notifier feature to the intel_hdmi part
> of the i915 DRM driver. It uses the HDMI DRM connector name to differentiate
> between each HDMI ports.
> The changes will allow the i915 HDMI code to notify EDID and HPD changes
> to an eventual CEC adapter.
> 
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/gpu/drm/i915/Kconfig      |  1 +
>  drivers/gpu/drm/i915/intel_drv.h  |  2 ++
>  drivers/gpu/drm/i915/intel_hdmi.c | 12 ++++++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
> index dfd9588..2d65d56 100644
> --- a/drivers/gpu/drm/i915/Kconfig
> +++ b/drivers/gpu/drm/i915/Kconfig
> @@ -23,6 +23,7 @@ config DRM_I915
>  	select SYNC_FILE
>  	select IOSF_MBI
>  	select CRC32
> +	select CEC_CORE if CEC_NOTIFIER
>  	help
>  	  Choose this option if you have a system that has "Intel Graphics
>  	  Media Accelerator" or "HD Graphics" integrated graphics,
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
> index 1baef4a..e98103d 100644
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
> @@ -2031,6 +2037,8 @@ static void chv_hdmi_pre_enable(struct intel_encoder *encoder,
>  
>  static void intel_hdmi_destroy(struct drm_connector *connector)
>  {
> +	if (intel_attached_hdmi(connector)->notifier)
> +		cec_notifier_put(intel_attached_hdmi(connector)->notifier);
>  	kfree(to_intel_connector(connector)->detect_edid);
>  	drm_connector_cleanup(connector);
>  	kfree(connector);
> @@ -2358,6 +2366,10 @@ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
>  		u32 temp = I915_READ(PEG_BAND_GAP_DATA);
>  		I915_WRITE(PEG_BAND_GAP_DATA, (temp & ~0xf) | 0xd);
>  	}
> +
> +	intel_hdmi->notifier = cec_notifier_get_conn(dev->dev, connector->name);
> +	if (!intel_hdmi->notifier)
> +		DRM_DEBUG_KMS("CEC notifier get failed\n");
>  }
>  
>  void intel_hdmi_init(struct drm_i915_private *dev_priv,
> 
