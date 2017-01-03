Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:42883 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933594AbdACILc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 03:11:32 -0500
Subject: Re: [PATCHv2 4/4] s5p-cec: add hpd-notifier support, move out of
 staging
To: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org
References: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
 <CGME20170102141935epcas1p3b093bcf648e1fa5873683cea60803f60@epcas1p3.samsung.com>
 <1483366747-34288-5-git-send-email-hverkuil@xs4all.nl>
 <4dd103b4-6f9b-8ef5-540e-6c5673b82c98@samsung.com>
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
Message-ID: <9652e8a9-1f5e-eadd-e588-b3051b0a8eb3@xs4all.nl>
Date: Tue, 3 Jan 2017 09:11:25 +0100
MIME-Version: 1.0
In-Reply-To: <4dd103b4-6f9b-8ef5-540e-6c5673b82c98@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2017 09:00 AM, Andrzej Hajda wrote:
> On 02.01.2017 15:19, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> By using the HPD notifier framework there is no longer any reason
>> to manually set the physical address. This was the one blocking
>> issue that prevented this driver from going out of staging, so do
>> this move as well.
>>
>> Update the bindings documenting the new hdmi phandle and
>> update exynos4.dtsi accordingly.
>>
>> Tested with my Odroid U3.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  .../devicetree/bindings/media/s5p-cec.txt          |  2 ++
>>  arch/arm/boot/dts/exynos4.dtsi                     |  1 +
>>  drivers/media/platform/Kconfig                     | 18 +++++++++++
>>  drivers/media/platform/Makefile                    |  1 +
>>  .../media => media/platform}/s5p-cec/Makefile      |  0
>>  .../platform}/s5p-cec/exynos_hdmi_cec.h            |  0
>>  .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |  0
>>  .../media => media/platform}/s5p-cec/regs-cec.h    |  0
>>  .../media => media/platform}/s5p-cec/s5p_cec.c     | 35 ++++++++++++++++++----
>>  .../media => media/platform}/s5p-cec/s5p_cec.h     |  3 ++
>>  drivers/staging/media/Kconfig                      |  2 --
>>  drivers/staging/media/Makefile                     |  1 -
>>  drivers/staging/media/s5p-cec/Kconfig              |  9 ------
>>  drivers/staging/media/s5p-cec/TODO                 |  7 -----
>>  14 files changed, 55 insertions(+), 24 deletions(-)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
>>  rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
>>  delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
>>  delete mode 100644 drivers/staging/media/s5p-cec/TODO
>>
>> diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
>> index 925ab4d..710fc00 100644
>> --- a/Documentation/devicetree/bindings/media/s5p-cec.txt
>> +++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
>> @@ -15,6 +15,7 @@ Required properties:
>>    - clock-names : from common clock binding: must contain "hdmicec",
>>  		  corresponding to entry in the clocks property.
>>    - samsung,syscon-phandle - phandle to the PMU system controller
>> +  - samsung,hdmi-phandle - phandle to the HDMI controller
>>  
>>  Example:
>>  
>> @@ -25,6 +26,7 @@ hdmicec: cec@100B0000 {
>>  	clocks = <&clock CLK_HDMI_CEC>;
>>  	clock-names = "hdmicec";
>>  	samsung,syscon-phandle = <&pmu_system_controller>;
>> +	samsung,hdmi-phandle = <&hdmi>;
>>  	pinctrl-names = "default";
>>  	pinctrl-0 = <&hdmi_cec>;
>>  	status = "okay";
>> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
>> index c64737b..51dfcbb 100644
>> --- a/arch/arm/boot/dts/exynos4.dtsi
>> +++ b/arch/arm/boot/dts/exynos4.dtsi
>> @@ -762,6 +762,7 @@
>>  		clocks = <&clock CLK_HDMI_CEC>;
>>  		clock-names = "hdmicec";
>>  		samsung,syscon-phandle = <&pmu_system_controller>;
>> +		samsung,hdmi-phandle = <&hdmi>;
>>  		pinctrl-names = "default";
>>  		pinctrl-0 = <&hdmi_cec>;
>>  		status = "disabled";
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index d944421..cab1637 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -392,6 +392,24 @@ config VIDEO_TI_SC
>>  config VIDEO_TI_CSC
>>  	tristate
>>  
>> +menuconfig V4L_CEC_DRIVERS
>> +	bool "Platform HDMI CEC drivers"
>> +	depends on MEDIA_CEC_SUPPORT
>> +
>> +if V4L_CEC_DRIVERS
>> +
>> +config VIDEO_SAMSUNG_S5P_CEC
>> +       tristate "Samsung S5P CEC driver"
>> +       depends on VIDEO_DEV && MEDIA_CEC_SUPPORT && (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
>> +       select HPD_NOTIFIERS
>> +       ---help---
>> +         This is a driver for Samsung S5P HDMI CEC interface. It uses the
>> +         generic CEC framework interface.
>> +         CEC bus is present in the HDMI connector and enables communication
>> +         between compatible devices.
>> +
>> +endif #V4L_CEC_DRIVERS
>> +
>>  menuconfig V4L_TEST_DRIVERS
>>  	bool "Media test drivers"
>>  	depends on MEDIA_CAMERA_SUPPORT
>> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
>> index 5b3cb27..ad3bf22 100644
>> --- a/drivers/media/platform/Makefile
>> +++ b/drivers/media/platform/Makefile
>> @@ -33,6 +33,7 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>>  
>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
>> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC)	+= s5p-cec/
>>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
>>  
>>  obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
>> diff --git a/drivers/staging/media/s5p-cec/Makefile b/drivers/media/platform/s5p-cec/Makefile
>> similarity index 100%
>> rename from drivers/staging/media/s5p-cec/Makefile
>> rename to drivers/media/platform/s5p-cec/Makefile
>> diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cec.h b/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
>> similarity index 100%
>> rename from drivers/staging/media/s5p-cec/exynos_hdmi_cec.h
>> rename to drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
>> diff --git a/drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
>> similarity index 100%
>> rename from drivers/staging/media/s5p-cec/exynos_hdmi_cecctrl.c
>> rename to drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
>> diff --git a/drivers/staging/media/s5p-cec/regs-cec.h b/drivers/media/platform/s5p-cec/regs-cec.h
>> similarity index 100%
>> rename from drivers/staging/media/s5p-cec/regs-cec.h
>> rename to drivers/media/platform/s5p-cec/regs-cec.h
>> diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
>> similarity index 89%
>> rename from drivers/staging/media/s5p-cec/s5p_cec.c
>> rename to drivers/media/platform/s5p-cec/s5p_cec.c
>> index 2a07968..2014f79 100644
>> --- a/drivers/staging/media/s5p-cec/s5p_cec.c
>> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
>> @@ -14,15 +14,18 @@
>>   */
>>  
>>  #include <linux/clk.h>
>> +#include <linux/hpd-notifier.h>
>>  #include <linux/interrupt.h>
>>  #include <linux/kernel.h>
>>  #include <linux/mfd/syscon.h>
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>> +#include <linux/of_platform.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/pm_runtime.h>
>>  #include <linux/timer.h>
>>  #include <linux/workqueue.h>
>> +#include <media/cec-edid.h>
>>  #include <media/cec.h>
>>  
>>  #include "exynos_hdmi_cec.h"
>> @@ -167,10 +170,22 @@ static const struct cec_adap_ops s5p_cec_adap_ops = {
>>  static int s5p_cec_probe(struct platform_device *pdev)
>>  {
>>  	struct device *dev = &pdev->dev;
>> +	struct device_node *np;
>> +	struct platform_device *hdmi_dev;
>>  	struct resource *res;
>>  	struct s5p_cec_dev *cec;
>>  	int ret;
>>  
>> +	np = of_parse_phandle(pdev->dev.of_node, "samsung,hdmi-phandle", 0);
>> +
>> +	if (!np) {
>> +		dev_err(&pdev->dev, "Failed to find hdmi node in device tree\n");
>> +		return -ENODEV;
>> +	}
>> +	hdmi_dev = of_find_device_by_node(np);
>> +	if (hdmi_dev == NULL)
>> +		return -EPROBE_DEFER;
>> +
>>  	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
>>  	if (!cec)
>>  		return -ENOMEM;
>> @@ -200,24 +215,33 @@ static int s5p_cec_probe(struct platform_device *pdev)
>>  	if (IS_ERR(cec->reg))
>>  		return PTR_ERR(cec->reg);
>>  
>> +	cec->notifier = hpd_notifier_get(&hdmi_dev->dev);
>> +	if (cec->notifier == NULL)
>> +		return -ENOMEM;
>> +
>>  	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
>>  		CEC_NAME,
>> -		CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
>> +		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
>>  		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
>>  	ret = PTR_ERR_OR_ZERO(cec->adap);
>>  	if (ret)
>>  		return ret;
>> +
>>  	ret = cec_register_adapter(cec->adap, &pdev->dev);
>> -	if (ret) {
>> -		cec_delete_adapter(cec->adap);
>> -		return ret;
>> -	}
>> +	if (ret)
>> +		goto err_delete_adapter;
>> +
>> +	cec_register_hpd_notifier(cec->adap, cec->notifier);
> 
> Is there a reason to split registration into two steps?
> Wouldn't be better to integrate hpd_notifier_get into
> cec_register_hpd_notifier.

One problem is that hpd_notifier_get can fail, whereas cec_register_hpd_notifier can't.
And I rather not have to register a CEC device only to unregister it again if the
hpd_notifier_get would fail.

Another reason is that this keeps the responsibility of the hpd_notifier life-time
handling in the driver instead of hiding it in the CEC framework, which is IMHO
unexpected.

I think I want to keep this as-is, at least for now.

Regards,

	Hans

