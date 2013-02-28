Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:45481 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab3B1Cp6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 21:45:58 -0500
Received: by mail-la0-f47.google.com with SMTP id fj20so1278450lab.20
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 18:45:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EC2CC.2090605@samsung.com>
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
 <1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org> <512EC2CC.2090605@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 28 Feb 2013 08:15:36 +0530
Message-ID: <CAD025yS8H-3d2AXi-=XBZFztCjffOVSMUOgegNM-paqDjxBf0g@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] video: drm: exynos: Add display-timing node
 parsing using video helper function
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	l.krishna@samsung.com, joshi@samsung.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 28 February 2013 08:07, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> On 02/27/2013 08:49 PM, Vikas Sajjan wrote:
>>
>> Add support for parsing the display-timing node using video helper
>> function.
>>
>> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
>> exists and the NON-DT logic is still maintained under the 'else' part.
>>
>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |   25
>> +++++++++++++++++++++----
>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index 9537761..7932dc2 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -20,6 +20,7 @@
>>   #include <linux/of_device.h>
>>   #include <linux/pm_runtime.h>
>>   +#include <video/of_display_timing.h>
>>   #include <video/samsung_fimd.h>
>>   #include <drm/exynos_drm.h>
>>   @@ -883,10 +884,26 @@ static int fimd_probe(struct platform_device
>> *pdev)
>>         DRM_DEBUG_KMS("%s\n", __FILE__);
>>   -     pdata = pdev->dev.platform_data;
>> -       if (!pdata) {
>> -               dev_err(dev, "no platform data specified\n");
>> -               return -EINVAL;
>> +       if (pdev->dev.of_node) {
>> +               pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +               if (!pdata) {
>> +                       DRM_ERROR("memory allocation for pdata failed\n");
>> +                       return -ENOMEM;
>> +               }
>> +
>> +               ret = of_get_fb_videomode(dev->of_node,
>> &pdata->panel.timing,
>> +                                       OF_USE_NATIVE_MODE);
>> +               if (ret) {
>> +                       DRM_ERROR("failed: of_get_fb_videomode()\n"
>> +                               "with return value: %d\n", ret);
>
>
> Could you make this error log to one line?
>
The Line was going beyond 80 line marks, hence I had to split it.

> except this,
> Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
>
>
>> +                       return ret;
>> +               }
>> +       } else {
>> +               pdata = pdev->dev.platform_data;
>> +               if (!pdata) {
>> +                       DRM_ERROR("no platform data specified\n");
>> +                       return -EINVAL;
>> +               }
>>         }
>>         panel = &pdata->panel;
>
>



-- 
Thanks and Regards
 Vikas Sajjan
