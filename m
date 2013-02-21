Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:44505 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3BUEof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Feb 2013 23:44:35 -0500
Received: by mail-la0-f45.google.com with SMTP id er20so8328338lab.4
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2013 20:44:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <022e01ce0f5b$9c6be3c0$d543ab40$%dae@samsung.com>
References: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
 <1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org> <022e01ce0f5b$9c6be3c0$d543ab40$%dae@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 21 Feb 2013 10:14:13 +0530
Message-ID: <CAD025ySfZb7O6Ku0AWbdPDXezCQKSiBsB2t+TJeyHhi=tocVZw@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] video: drm: exynos: Add display-timing node
 parsing using video helper function
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, l.krishna@samsung.com, patches@linaro.org,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr. Inki Dae,

On 20 February 2013 16:45, Inki Dae <inki.dae@samsung.com> wrote:
>
>
>> -----Original Message-----
>> From: Vikas Sajjan [mailto:vikas.sajjan@linaro.org]
>> Sent: Friday, February 15, 2013 3:43 PM
>> To: dri-devel@lists.freedesktop.org
>> Cc: linux-media@vger.kernel.org; kgene.kim@samsung.com;
>> inki.dae@samsung.com; l.krishna@samsung.com; patches@linaro.org
>> Subject: [PATCH v6 1/1] video: drm: exynos: Add display-timing node
>> parsing using video helper function
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
>>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   37
>> ++++++++++++++++++++++++++----
>>  1 file changed, 33 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index 9537761..8b2c0ff 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -19,7 +19,9 @@
>>  #include <linux/clk.h>
>>  #include <linux/of_device.h>
>>  #include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>>
>> +#include <video/of_display_timing.h>
>>  #include <video/samsung_fimd.h>
>>  #include <drm/exynos_drm.h>
>>
>> @@ -877,16 +879,43 @@ static int fimd_probe(struct platform_device *pdev)
>>       struct exynos_drm_subdrv *subdrv;
>>       struct exynos_drm_fimd_pdata *pdata;
>>       struct exynos_drm_panel_info *panel;
>> +     struct fb_videomode *fbmode;
>> +     struct pinctrl *pctrl;
>>       struct resource *res;
>>       int win;
>>       int ret = -EINVAL;
>>
>>       DRM_DEBUG_KMS("%s\n", __FILE__);
>>
>> -     pdata = pdev->dev.platform_data;
>> -     if (!pdata) {
>> -             dev_err(dev, "no platform data specified\n");
>> -             return -EINVAL;
>> +     if (pdev->dev.of_node) {
>> +             pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +             if (!pdata) {
>> +                     DRM_ERROR("memory allocation for pdata failed\n");
>> +                     return -ENOMEM;
>> +             }
>> +
>> +             fbmode = &pdata->panel.timing;
>> +             ret = of_get_fb_videomode(dev->of_node, fbmode,
>> +                                     OF_USE_NATIVE_MODE);
>> +             if (ret) {
>> +                     DRM_ERROR("failed: of_get_fb_videomode()\n"
>> +                             "with return value: %d\n", ret);
>> +                     return ret;
>> +             }
>> +
>> +             pctrl = devm_pinctrl_get_select_default(dev);
>
> Why does it need pinctrl? and even though needed, I think this should be
> separated into another one.
>
Will separate it out and send it in a separate patch.

> Thanks,
> Inki Dae
>
>> +             if (IS_ERR_OR_NULL(pctrl)) {
>> +                     DRM_ERROR("failed:
>> devm_pinctrl_get_select_default()\n"
>> +                             "with return value: %d\n", PTR_RET(pctrl));
>> +                     return PTR_RET(pctrl);
>> +             }
>> +
>> +     } else {
>> +             pdata = pdev->dev.platform_data;
>> +             if (!pdata) {
>> +                     DRM_ERROR("no platform data specified\n");
>> +                     return -EINVAL;
>> +             }
>>       }
>>
>>       panel = &pdata->panel;
>> --
>> 1.7.9.5
>



-- 
Thanks and Regards
 Vikas Sajjan
