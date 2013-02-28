Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58087 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3B1C4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 21:56:50 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr12so1031057wgb.23
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 18:56:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EC64F.7080602@samsung.com>
References: <1361965796-16117-1-git-send-email-vikas.sajjan@linaro.org>
	<1361965796-16117-2-git-send-email-vikas.sajjan@linaro.org>
	<512EC2CC.2090605@samsung.com>
	<CAD025yS8H-3d2AXi-=XBZFztCjffOVSMUOgegNM-paqDjxBf0g@mail.gmail.com>
	<512EC64F.7080602@samsung.com>
Date: Thu, 28 Feb 2013 08:26:49 +0530
Message-ID: <CAGm_ybjDHkX4Rei5oViG3fsUD7qZi3yXYdXZ=D1H1tTGp=1V0Q@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] video: drm: exynos: Add display-timing node
 parsing using video helper function
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>,
	dri-devel@lists.freedesktop.org, kgene.kim@samsung.com,
	linaro-dev@lists.linaro.org, patches@linaro.org,
	l.krishna@samsung.com, joshi@samsung.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 28, 2013 at 8:21 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> On 02/28/2013 11:45 AM, Vikas Sajjan wrote:
>>
>> Hi,
>>
>> On 28 February 2013 08:07, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>>>
>>> On 02/27/2013 08:49 PM, Vikas Sajjan wrote:
>>>>
>>>> Add support for parsing the display-timing node using video helper
>>>> function.
>>>>
>>>> The DT node parsing and pinctrl selection is done only if 'dev.of_node'
>>>> exists and the NON-DT logic is still maintained under the 'else' part.
>>>>
>>>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>>>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>>>> ---
>>>>    drivers/gpu/drm/exynos/exynos_drm_fimd.c |   25
>>>> +++++++++++++++++++++----
>>>>    1 file changed, 21 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> index 9537761..7932dc2 100644
>>>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> @@ -20,6 +20,7 @@
>>>>    #include <linux/of_device.h>
>>>>    #include <linux/pm_runtime.h>
>>>>    +#include <video/of_display_timing.h>
>>>>    #include <video/samsung_fimd.h>
>>>>    #include <drm/exynos_drm.h>
>>>>    @@ -883,10 +884,26 @@ static int fimd_probe(struct platform_device
>>>> *pdev)
>>>>          DRM_DEBUG_KMS("%s\n", __FILE__);
>>>>    -     pdata = pdev->dev.platform_data;
>>>> -       if (!pdata) {
>>>> -               dev_err(dev, "no platform data specified\n");
>>>> -               return -EINVAL;
>>>> +       if (pdev->dev.of_node) {
>>>> +               pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>>>> +               if (!pdata) {
>>>> +                       DRM_ERROR("memory allocation for pdata
>>>> failed\n");
>>>> +                       return -ENOMEM;
>>>> +               }
>>>> +
>>>> +               ret = of_get_fb_videomode(dev->of_node,
>>>> &pdata->panel.timing,
>>>> +                                       OF_USE_NATIVE_MODE);
>>>> +               if (ret) {
>>>> +                       DRM_ERROR("failed: of_get_fb_videomode()\n"
>>>> +                               "with return value: %d\n", ret);
>>>
>>>
>>> Could you make this error log to one line?
>>>
>> The Line was going beyond 80 line marks, hence I had to split it.
>
>
> So remove or contract some log messages, e.g. "with return value"
> I think that is unnecessary.
>
Will do and resend.
>
>>> except this,
>>> Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
>>>
>>>
>>>> +                       return ret;
>>>> +               }
>>>> +       } else {
>>>> +               pdata = pdev->dev.platform_data;
>>>> +               if (!pdata) {
>>>> +                       DRM_ERROR("no platform data specified\n");
>>>> +                       return -EINVAL;
>>>> +               }
>>>>          }
>>>>          panel = &pdata->panel;
>>>
>>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
