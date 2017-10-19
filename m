Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:25709 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdJSNhq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 09:37:46 -0400
Subject: Re: [PATCHv4 4/4] drm/tegra: add cec-notifier support
To: Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-5-hverkuil@xs4all.nl> <20171019131716.GT9005@ulmo>
 <20171019133007.GU9005@ulmo>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <7e1fcffd-76dc-c4f2-942c-b9872f73fff0@cisco.com>
Date: Thu, 19 Oct 2017 15:37:43 +0200
MIME-Version: 1.0
In-Reply-To: <20171019133007.GU9005@ulmo>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/17 15:30, Thierry Reding wrote:
> On Thu, Oct 19, 2017 at 03:17:16PM +0200, Thierry Reding wrote:
>> On Mon, Sep 11, 2017 at 02:29:52PM +0200, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> In order to support CEC the HDMI driver has to inform the CEC driver
>>> whenever the physical address changes. So when the EDID is read the
>>> CEC driver has to be informed and whenever the hotplug detect goes
>>> away.
>>>
>>> This is done through the cec-notifier framework.
>>>
>>> The link between the HDMI driver and the CEC driver is done through
>>> the hdmi_phandle in the tegra-cec node in the device tree.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>>  drivers/gpu/drm/tegra/Kconfig  | 1 +
>>>  drivers/gpu/drm/tegra/drm.h    | 3 +++
>>>  drivers/gpu/drm/tegra/hdmi.c   | 9 +++++++++
>>>  drivers/gpu/drm/tegra/output.c | 6 ++++++
>>>  4 files changed, 19 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
>>> index 2db29d67193d..c882918c2024 100644
>>> --- a/drivers/gpu/drm/tegra/Kconfig
>>> +++ b/drivers/gpu/drm/tegra/Kconfig
>>> @@ -8,6 +8,7 @@ config DRM_TEGRA
>>>  	select DRM_PANEL
>>>  	select TEGRA_HOST1X
>>>  	select IOMMU_IOVA if IOMMU_SUPPORT
>>> +	select CEC_CORE if CEC_NOTIFIER
>>>  	help
>>>  	  Choose this option if you have an NVIDIA Tegra SoC.
>>>  
>>> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
>>> index 6d6da01282f3..c0a18b60caf1 100644
>>> --- a/drivers/gpu/drm/tegra/drm.h
>>> +++ b/drivers/gpu/drm/tegra/drm.h
>>> @@ -212,6 +212,8 @@ int tegra_dc_state_setup_clock(struct tegra_dc *dc,
>>>  			       struct clk *clk, unsigned long pclk,
>>>  			       unsigned int div);
>>>  
>>> +struct cec_notifier;
>>> +
>>>  struct tegra_output {
>>>  	struct device_node *of_node;
>>>  	struct device *dev;
>>> @@ -219,6 +221,7 @@ struct tegra_output {
>>>  	struct drm_panel *panel;
>>>  	struct i2c_adapter *ddc;
>>>  	const struct edid *edid;
>>> +	struct cec_notifier *notifier;
>>>  	unsigned int hpd_irq;
>>>  	int hpd_gpio;
>>>  	enum of_gpio_flags hpd_gpio_flags;
>>> diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
>>> index cda0491ed6bf..fbf14e1efd0e 100644
>>> --- a/drivers/gpu/drm/tegra/hdmi.c
>>> +++ b/drivers/gpu/drm/tegra/hdmi.c
>>> @@ -21,6 +21,8 @@
>>>  
>>>  #include <sound/hda_verbs.h>
>>>  
>>> +#include <media/cec-notifier.h>
>>> +
>>>  #include "hdmi.h"
>>>  #include "drm.h"
>>>  #include "dc.h"
>>> @@ -1720,6 +1722,10 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
>>>  		return PTR_ERR(hdmi->vdd);
>>>  	}
>>>  
>>> +	hdmi->output.notifier = cec_notifier_get(&pdev->dev);
>>> +	if (hdmi->output.notifier == NULL)
>>> +		return -ENOMEM;
>>> +
>>>  	hdmi->output.dev = &pdev->dev;
>>>  
>>>  	err = tegra_output_probe(&hdmi->output);
>>> @@ -1778,6 +1784,9 @@ static int tegra_hdmi_remove(struct platform_device *pdev)
>>>  
>>>  	tegra_output_remove(&hdmi->output);
>>>  
>>> +	if (hdmi->output.notifier)
>>> +		cec_notifier_put(hdmi->output.notifier);
>>> +
>>>  	return 0;
>>>  }
>>>  
>>> diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
>>> index 595d1ec3e02e..57c052521a44 100644
>>> --- a/drivers/gpu/drm/tegra/output.c
>>> +++ b/drivers/gpu/drm/tegra/output.c
>>> @@ -11,6 +11,8 @@
>>>  #include <drm/drm_panel.h>
>>>  #include "drm.h"
>>>  
>>> +#include <media/cec-notifier.h>
>>> +
>>>  int tegra_output_connector_get_modes(struct drm_connector *connector)
>>>  {
>>>  	struct tegra_output *output = connector_to_output(connector);
>>> @@ -33,6 +35,7 @@ int tegra_output_connector_get_modes(struct drm_connector *connector)
>>>  		edid = drm_get_edid(connector, output->ddc);
>>>  
>>>  	drm_mode_connector_update_edid_property(connector, edid);
>>> +	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);
>>
>> I had to guard this with:
>>
>> 	#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
>> 	...
>> 	#endif
>>
>> to enable this driver to be built without CEC_NOTIFIER enabled. I see
>> that there are stubs defined if the above is false, but for some reason
>> they don't seem to be there for me either.
> 
> Nevermind that. This was not actually failing. However, ...
> 
>>>  
>>>  	if (edid) {
>>>  		err = drm_add_edid_modes(connector, edid);
>>> @@ -68,6 +71,9 @@ tegra_output_connector_detect(struct drm_connector *connector, bool force)
>>>  			status = connector_status_connected;
>>>  	}
>>>  
>>> +	if (status != connector_status_connected)
>>> +		cec_notifier_phys_addr_invalidate(output->notifier);
> 
> This doesn't seem to exist in v4.14-rc1 which is the base for the
> drm/tegra tree for v4.15. I see this function will be introduced in
> v4.15 via the media tree.

Strange. This was released in the 4.13 kernel, so you should really have it.
It compiles fine for me, both with the drm tegra driver built-in and as a
module.

This makes no sense to me.

Regards,

	Hans

> 
> How about if I replace this by:
> 
> 	cec_notifier_set_phys(output->notifier, CEC_PHYS_ADDR_INVALID);
> 
> for now and switch it over to the new function after v4.15-rc1? That way
> we can avoid the extra dependency between the media and drm trees.
