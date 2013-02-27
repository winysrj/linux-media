Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33705 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3B0JaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 04:30:18 -0500
Received: by mail-la0-f51.google.com with SMTP id fo13so331402lab.38
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 01:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5125C74F.3000705@samsung.com>
References: <1361423512-2882-1-git-send-email-vikas.sajjan@linaro.org>
 <1361423512-2882-3-git-send-email-vikas.sajjan@linaro.org> <5125C74F.3000705@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Wed, 27 Feb 2013 14:59:56 +0530
Message-ID: <CAD025yS+jZNqneY6afBbSYAhMrcs24_MRg-xQsde62nPSa6eCw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] video: drm: exynos: Add pinctrl support to fimd
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dri-devel@lists.freedesktop.org, l.krishna@samsung.com,
	kgene.kim@samsung.com, linux-media@vger.kernel.org,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr.Shim,

On 21 February 2013 12:35, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> Hi,
>
>
> On 02/21/2013 02:11 PM, Vikas Sajjan wrote:
>>
>> Adds support for pinctrl to drm fimd.
>>
>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index f80cf68..878b134 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -19,6 +19,7 @@
>>   #include <linux/clk.h>
>>   #include <linux/of_device.h>
>>   #include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>>     #include <video/of_display_timing.h>
>>   #include <video/samsung_fimd.h>
>> @@ -879,6 +880,7 @@ static int fimd_probe(struct platform_device *pdev)
>>         struct exynos_drm_fimd_pdata *pdata;
>>         struct exynos_drm_panel_info *panel;
>>         struct fb_videomode *fbmode;
>> +       struct pinctrl *pctrl;
>>         struct resource *res;
>>         int win;
>>         int ret = -EINVAL;
>> @@ -900,6 +902,13 @@ static int fimd_probe(struct platform_device *pdev)
>>                                 "with return value: %d\n", ret);
>>                         return ret;
>>                 }
>> +               pctrl = devm_pinctrl_get_select_default(dev);
>> +               if (IS_ERR_OR_NULL(pctrl)) {
>> +                       DRM_ERROR("failed:
>> devm_pinctrl_get_select_default()\n"
>> +                               "with return value: %d\n",
>> PTR_RET(pctrl));
>> +                       return PTR_RET(pctrl);
>> +               }
>
>
> I think pinctrl isn't related with dt then it doesn't need to be in "if
> (pdev->dev.of_node)".
>
actuall in V1 patchset it was outside "if (pdev->dev.of_node)".
lated in V2, I moved 'devm_pinctrl_get_select_default' function call under
'if (pdev->dev.of_node)', to keep NON-DT code unchanged.

>>
>
>
> Blank.
>
>
>>         } else {
>>                 pdata = pdev->dev.platform_data;
>>                 if (!pdata) {
>
>



-- 
Thanks and Regards
 Vikas Sajjan
