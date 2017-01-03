Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:41363 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934564AbdACIZG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 03:25:06 -0500
Subject: Re: [PATCHv2 2/4] exynos_hdmi: add HPD notifier support
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
References: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
 <CGME20170102141935epcas1p2a81b8cdc6f0ff3201f903c1e7e13ae27@epcas1p2.samsung.com>
 <1483366747-34288-3-git-send-email-hverkuil@xs4all.nl>
 <e128714d-6e24-7fc5-17be-fa19606cb3b2@samsung.com>
Cc: Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fe69ca48-45a2-be25-c9c8-147a7f949724@xs4all.nl>
Date: Tue, 3 Jan 2017 09:25:01 +0100
MIME-Version: 1.0
In-Reply-To: <e128714d-6e24-7fc5-17be-fa19606cb3b2@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 08:55 AM, Andrzej Hajda wrote:
> On 02.01.2017 15:19, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Implement the HPD notifier support to allow CEC drivers to
>> be informed when there is a new EDID and when a connect or
>> disconnect happens.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/Kconfig       |  1 +
>>  drivers/gpu/drm/exynos/exynos_hdmi.c | 24 +++++++++++++++++++++---
>>  2 files changed, 22 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/Kconfig b/drivers/gpu/drm/exynos/Kconfig
>> index d706ca4..80bfd1d 100644
>> --- a/drivers/gpu/drm/exynos/Kconfig
>> +++ b/drivers/gpu/drm/exynos/Kconfig
>> @@ -77,6 +77,7 @@ config DRM_EXYNOS_DP
>>  config DRM_EXYNOS_HDMI
>>  	bool "HDMI"
>>  	depends on DRM_EXYNOS_MIXER || DRM_EXYNOS5433_DECON
>> +	select HPD_NOTIFIERS
>>  	help
>>  	  Choose this option if you want to use Exynos HDMI for DRM.
>>  
>> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
>> index 5ed8b1e..28bf609 100644
>> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
>> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
>> @@ -31,6 +31,7 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/clk.h>
>>  #include <linux/gpio/consumer.h>
>> +#include <linux/hpd-notifier.h>
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/io.h>
>>  #include <linux/of_address.h>
>> @@ -118,6 +119,7 @@ struct hdmi_context {
>>  	bool				dvi_mode;
>>  	struct delayed_work		hotplug_work;
>>  	struct drm_display_mode		current_mode;
>> +	struct hpd_notifier		*notifier;
>>  	const struct hdmi_driver_data	*drv_data;
>>  
>>  	void __iomem			*regs;
>> @@ -807,9 +809,12 @@ static enum drm_connector_status hdmi_detect(struct drm_connector *connector,
>>  {
>>  	struct hdmi_context *hdata = connector_to_hdmi(connector);
>>  
>> -	if (gpiod_get_value(hdata->hpd_gpio))
>> +	if (gpiod_get_value(hdata->hpd_gpio)) {
>> +		hpd_event_connect(hdata->notifier);
>>  		return connector_status_connected;
>> +	}
>>  
>> +	hpd_event_disconnect(hdata->notifier);
>>  	return connector_status_disconnected;
>>  }
>>  
>> @@ -848,6 +853,9 @@ static int hdmi_get_modes(struct drm_connector *connector)
>>  		edid->width_cm, edid->height_cm);
>>  
>>  	drm_mode_connector_update_edid_property(connector, edid);
>> +	hpd_event_connect(hdata->notifier);
> 
> Is there a reason to call hpd_event_connect here? It was called already
> from hdmi_detect.

True. Will drop this.

	Hans

> 
> Regards
> Andrzej
> 
>> +	hpd_event_new_edid(hdata->notifier, edid,
>> +			    EDID_LENGTH * (1 + edid->extensions));
>>  
>>  	ret = drm_add_edid_modes(connector, edid);
>>  
>> @@ -1483,6 +1491,7 @@ static void hdmi_disable(struct drm_encoder *encoder)
>>  	if (funcs && funcs->disable)
>>  		(*funcs->disable)(crtc);
>>  
>> +	hpd_event_disconnect(hdata->notifier);
>>  	cancel_delayed_work(&hdata->hotplug_work);
>>  
>>  	hdmiphy_disable(hdata);
>> @@ -1832,15 +1841,22 @@ static int hdmi_probe(struct platform_device *pdev)
>>  		}
>>  	}
>>  
>> +	hdata->notifier = hpd_notifier_get(&pdev->dev);
>> +	if (hdata->notifier == NULL) {
>> +		ret = -ENOMEM;
>> +		goto err_hdmiphy;
>> +	}
>> +
>>  	pm_runtime_enable(dev);
>>  
>>  	ret = component_add(&pdev->dev, &hdmi_component_ops);
>>  	if (ret)
>> -		goto err_disable_pm_runtime;
>> +		goto err_notifier_put;
>>  
>>  	return ret;
>>  
>> -err_disable_pm_runtime:
>> +err_notifier_put:
>> +	hpd_notifier_put(hdata->notifier);
>>  	pm_runtime_disable(dev);
>>  
>>  err_hdmiphy:
>> @@ -1859,9 +1875,11 @@ static int hdmi_remove(struct platform_device *pdev)
>>  	struct hdmi_context *hdata = platform_get_drvdata(pdev);
>>  
>>  	cancel_delayed_work_sync(&hdata->hotplug_work);
>> +	hpd_event_disconnect(hdata->notifier);
>>  
>>  	component_del(&pdev->dev, &hdmi_component_ops);
>>  
>> +	hpd_notifier_put(hdata->notifier);
>>  	pm_runtime_disable(&pdev->dev);
>>  
>>  	if (!IS_ERR(hdata->reg_hdmi_en))
> 
> 

