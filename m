Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49381 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3AaFLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 00:11:07 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so1689594wgb.2
        for <linux-media@vger.kernel.org>; Wed, 30 Jan 2013 21:11:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOw6vbKSeQ05o7VSQek0w4rhumN1B+ighrxC3wqUKZ_Sxfo3xw@mail.gmail.com>
References: <1359527449-5174-1-git-send-email-vikas.sajjan@linaro.org>
	<1359527449-5174-2-git-send-email-vikas.sajjan@linaro.org>
	<CAOw6vbKSeQ05o7VSQek0w4rhumN1B+ighrxC3wqUKZ_Sxfo3xw@mail.gmail.com>
Date: Thu, 31 Jan 2013 10:41:05 +0530
Message-ID: <CAD025yS51jOyCMGnAUi5A6Djjjc-XZT6ze21CNeMGoYSFPNF8w@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] video: drm: exynos: Adds display-timing node
 parsing using video helper function
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: Sean Paul <seanpaul@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
	Leelakrishna A <l.krishna@samsung.com>,
	"kgene.kim" <kgene.kim@samsung.com>, s.trumtrar@pengutronix.de,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On 30 January 2013 21:28, Sean Paul <seanpaul@chromium.org> wrote:
> On Wed, Jan 30, 2013 at 1:30 AM, Vikas Sajjan <vikas.sajjan@linaro.org> wrote:
>> This patch adds display-timing node parsing using video helper function
>>
>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   38 +++++++++++++++++++++++++++---
>>  1 file changed, 35 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index bf0d9ba..94729ed 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/clk.h>
>>  #include <linux/of_device.h>
>>  #include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>>
>>  #include <video/samsung_fimd.h>
>>  #include <drm/exynos_drm.h>
>> @@ -905,15 +906,46 @@ static int __devinit fimd_probe(struct platform_device *pdev)
>>         struct exynos_drm_subdrv *subdrv;
>>         struct exynos_drm_fimd_pdata *pdata;
>>         struct exynos_drm_panel_info *panel;
>> +       struct fb_videomode *fbmode;
>> +       struct device *disp_dev = &pdev->dev;
>
> Isn't this the same as dev (maybe I'm missing some dependent patch)?
>
yeah, its same. Will remove the duplicate variable.

>> +       struct pinctrl *pctrl;
>>         struct resource *res;
>>         int win;
>>         int ret = -EINVAL;
>>
>>         DRM_DEBUG_KMS("%s\n", __FILE__);
>>
>> -       pdata = pdev->dev.platform_data;
>> -       if (!pdata) {
>> -               dev_err(dev, "no platform data specified\n");
>> +       if (pdev->dev.of_node) {
>> +               pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +               if (!pdata) {
>> +                       DRM_ERROR("memory allocation for pdata failed\n");
>> +                       return -ENOMEM;
>> +               }
>> +
>> +               fbmode = devm_kzalloc(dev, sizeof(*fbmode), GFP_KERNEL);
>> +               if (!fbmode) {
>> +                       DRM_ERROR("memory allocation for fbmode failed\n");
>> +                       return -ENOMEM;
>> +               }
>> +
>> +               ret = of_get_fb_videomode(disp_dev->of_node, fbmode, -1);
>> +               if (ret) {
>> +                       DRM_ERROR("failed to get fb_videomode\n");
>> +                       return -EINVAL;
>> +               }
>> +               pdata->panel.timing = (struct fb_videomode) *fbmode;
>> +
>> +       } else {
>> +               pdata = pdev->dev.platform_data;
>> +               if (!pdata) {
>> +                       DRM_ERROR("no platform data specified\n");
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +
>> +       pctrl = devm_pinctrl_get_select_default(dev);
>> +       if (IS_ERR(pctrl)) {
>
> Will this work for exynos5? AFAICT, there's no pinctrl setup for it.

Was tested with
>
> Sean
>
>> +               DRM_ERROR("no pinctrl data provided.\n");
>>                 return -EINVAL;
>>         }
>>
>> --
>> 1.7.9.5
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Thanks and Regards
 Vikas Sajjan
