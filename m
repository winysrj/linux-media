Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15127 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932601AbdDGMHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 08:07:37 -0400
Subject: Re: [PATCHv6 03/10] exynos_hdmi: add CEC notifier support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>, Patrice.chotard@st.com,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <c8a28cd7-e11d-892e-5f76-3fb18f94118d@samsung.com>
Date: Fri, 07 Apr 2017 14:07:31 +0200
MIME-version: 1.0
In-reply-to: <20170331122036.55706-4-hverkuil@xs4all.nl>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <20170331122036.55706-1-hverkuil@xs4all.nl>
 <CGME20170331122130epcas4p29c4d79360b900367143b9338308bac08@epcas4p2.samsung.com>
 <20170331122036.55706-4-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31.03.2017 14:20, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Implement the CEC notifier support to allow CEC drivers to
> be informed when there is a new physical address.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Acked-by: Krzysztof Kozlowski <krzk@kernel.org>

Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>

 --
Regards
Andrzej

> ---
>  drivers/gpu/drm/exynos/exynos_hdmi.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index 88ccc0469316..bc4c8d0a66f4 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -43,6 +43,8 @@
>  
>  #include <drm/exynos_drm.h>
>  
> +#include <media/cec-notifier.h>
> +
>  #include "exynos_drm_drv.h"
>  #include "exynos_drm_crtc.h"
>  
> @@ -119,6 +121,7 @@ struct hdmi_context {
>  	bool				dvi_mode;
>  	struct delayed_work		hotplug_work;
>  	struct drm_display_mode		current_mode;
> +	struct cec_notifier		*notifier;
>  	const struct hdmi_driver_data	*drv_data;
>  
>  	void __iomem			*regs;
> @@ -822,6 +825,7 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
>  	if (gpiod_get_value(hdata->hpd_gpio))
>  		return connector_status_connected;
>  
> +	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
>  	return connector_status_disconnected;
>  }
>  
> @@ -860,6 +864,7 @@ static int hdmi_get_modes(struct drm_connector *connector)
>  		edid->width_cm, edid->height_cm);
>  
>  	drm_mode_connector_update_edid_property(connector, edid);
> +	cec_notifier_set_phys_addr_from_edid(hdata->notifier, edid);
>  
>  	ret = drm_add_edid_modes(connector, edid);
>  
> @@ -1503,6 +1508,7 @@ static void hdmi_disable(struct drm_encoder *encoder)
>  	if (funcs && funcs->disable)
>  		(*funcs->disable)(crtc);
>  
> +	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
>  	cancel_delayed_work(&hdata->hotplug_work);
>  
>  	hdmiphy_disable(hdata);
> @@ -1878,15 +1884,22 @@ static int hdmi_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	hdata->notifier = cec_notifier_get(&pdev->dev);
> +	if (hdata->notifier == NULL) {
> +		ret = -ENOMEM;
> +		goto err_hdmiphy;
> +	}
> +
>  	pm_runtime_enable(dev);
>  
>  	ret = component_add(&pdev->dev, &hdmi_component_ops);
>  	if (ret)
> -		goto err_disable_pm_runtime;
> +		goto err_notifier_put;
>  
>  	return ret;
>  
> -err_disable_pm_runtime:
> +err_notifier_put:
> +	cec_notifier_put(hdata->notifier);
>  	pm_runtime_disable(dev);
>  
>  err_hdmiphy:
> @@ -1905,9 +1918,11 @@ static int hdmi_remove(struct platform_device *pdev)
>  	struct hdmi_context *hdata = platform_get_drvdata(pdev);
>  
>  	cancel_delayed_work_sync(&hdata->hotplug_work);
> +	cec_notifier_set_phys_addr(hdata->notifier, CEC_PHYS_ADDR_INVALID);
>  
>  	component_del(&pdev->dev, &hdmi_component_ops);
>  
> +	cec_notifier_put(hdata->notifier);
>  	pm_runtime_disable(&pdev->dev);
>  
>  	if (!IS_ERR(hdata->reg_hdmi_en))
