Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:41026 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3CFKIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 05:08:01 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so7223042lab.14
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 02:07:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAQKjZOFcfTmK4NNWQScEhTvF+=to4KcNtjFMZQEJgvYdRO_wQ@mail.gmail.com>
References: <1362116080-20063-1-git-send-email-vikas.sajjan@linaro.org>
 <1362116080-20063-2-git-send-email-vikas.sajjan@linaro.org> <CAAQKjZOFcfTmK4NNWQScEhTvF+=to4KcNtjFMZQEJgvYdRO_wQ@mail.gmail.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Wed, 6 Mar 2013 15:37:39 +0530
Message-ID: <CAD025yRBQ6+Aut-xBCmz=5ZWPLtBP9LVPXLv+GFq+FqLgCv8Jg@mail.gmail.com>
Subject: Re: [PATCH v10 1/2] video: drm: exynos: Add display-timing node
 parsing using video helper function
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	l.krishna@samsung.com, sylvester.nawrocki@gmail.com,
	linux-media@vger.kernel.org, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 6 March 2013 14:12, Inki Dae <inki.dae@samsung.com> wrote:
> 2013/3/1 Vikas Sajjan <vikas.sajjan@linaro.org>:
>> Add support for parsing the display-timing node using video helper
>> function.
>>
>> The DT node parsing is done only if 'dev.of_node'
>> exists and the NON-DT logic is still maintained under the 'else' part.
>>
>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   24 ++++++++++++++++++++----
>>  1 file changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index 9537761..e323cf9 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/of_device.h>
>>  #include <linux/pm_runtime.h>
>>
>> +#include <video/of_display_timing.h>
>>  #include <video/samsung_fimd.h>
>>  #include <drm/exynos_drm.h>
>>
>> @@ -883,10 +884,25 @@ static int fimd_probe(struct platform_device *pdev)
>>
>>         DRM_DEBUG_KMS("%s\n", __FILE__);
>>
>> -       pdata = pdev->dev.platform_data;
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
>> +               ret = of_get_fb_videomode(dev->of_node, &pdata->panel.timing,
>> +                                       OF_USE_NATIVE_MODE);
>
> Add "select OF_VIDEOMODE" and "select FB_MODE_HELPERS" to
> drivers/gpu/drm/exynos/Kconfig. When EXYNOS_DRM_FIMD config is
> selected, these two configs should also be selected.
>
Sure. Will add and resend.
> Thanks,
> Inki Dae
>
>> +               if (ret) {
>> +                       DRM_ERROR("failed: of_get_fb_videomode() : %d\n", ret);
>> +                       return ret;
>> +               }
>> +       } else {
>> +               pdata = pdev->dev.platform_data;
>> +               if (!pdata) {
>> +                       DRM_ERROR("no platform data specified\n");
>> +                       return -EINVAL;
>> +               }
>>         }
>>
>>         panel = &pdata->panel;
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
