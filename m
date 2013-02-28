Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23170 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B1Bvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 20:51:33 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MIW00GKUQFU0PE0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Feb 2013 10:51:21 +0900 (KST)
Message-id: <512EB830.5030808@samsung.com>
Date: Thu, 28 Feb 2013 10:51:44 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
MIME-version: 1.0
To: Vikas Sajjan <vikas.sajjan@linaro.org>, linus.walleij@linaro.org
Cc: kgene.kim@samsung.com, patches@linaro.org, l.krishna@samsung.com,
	sunil joshi <joshi@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 1/1] video: drm: exynos: Add display-timing node parsing
 using video helper function
References: <1360910587-25548-1-git-send-email-vikas.sajjan@linaro.org>
 <1360910587-25548-2-git-send-email-vikas.sajjan@linaro.org>
 <5125C4D4.5040804@samsung.com>
 <CAD025yR8u79VHg0oACTWTFQxiEBzzw6hHA6c=+CA9VP__fRJuA@mail.gmail.com>
 <5125CA44.10506@samsung.com>
In-reply-to: <5125CA44.10506@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/21/2013 04:18 PM, Joonyoung Shim wrote:
> On 02/21/2013 04:12 PM, Vikas Sajjan wrote:
>> Hi,
>>
>> On 21 February 2013 12:25, Joonyoung Shim <jy0922.shim@samsung.com> 
>> wrote:
>>> Hi,
>>>
>>>
>>> On 02/15/2013 03:43 PM, Vikas Sajjan wrote:
>>>> Add support for parsing the display-timing node using video helper
>>>> function.
>>>>
>>>> The DT node parsing and pinctrl selection is done only if 
>>>> 'dev.of_node'
>>>> exists and the NON-DT logic is still maintained under the 'else' part.
>>>>
>>>> Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
>>>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>>>> ---
>>>>    drivers/gpu/drm/exynos/exynos_drm_fimd.c |   37
>>>> ++++++++++++++++++++++++++----
>>>>    1 file changed, 33 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> index 9537761..8b2c0ff 100644
>>>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>>>> @@ -19,7 +19,9 @@
>>>>    #include <linux/clk.h>
>>>>    #include <linux/of_device.h>
>>>>    #include <linux/pm_runtime.h>
>>>> +#include <linux/pinctrl/consumer.h>
>>>>    +#include <video/of_display_timing.h>
>>>>    #include <video/samsung_fimd.h>
>>>>    #include <drm/exynos_drm.h>
>>>>    @@ -877,16 +879,43 @@ static int fimd_probe(struct platform_device
>>>> *pdev)
>>>>          struct exynos_drm_subdrv *subdrv;
>>>>          struct exynos_drm_fimd_pdata *pdata;
>>>>          struct exynos_drm_panel_info *panel;
>>>> +       struct fb_videomode *fbmode;
>>>> +       struct pinctrl *pctrl;
>>>>          struct resource *res;
>>>>          int win;
>>>>          int ret = -EINVAL;
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
>>>> +               fbmode = &pdata->panel.timing;
>>>> +               ret = of_get_fb_videomode(dev->of_node, fbmode,
>>>> +                                       OF_USE_NATIVE_MODE);
>>>
>>> fbmode variable can be substituted to &pdata->panel.timing directly 
>>> then can
>>> remove fbmode variable.
>>>
>> this is can be done.
>>>> +               if (ret) {
>>>> +                       DRM_ERROR("failed: of_get_fb_videomode()\n"
>>>> +                               "with return value: %d\n", ret);
>>>> +                       return ret;
>>>> +               }
>>>> +
>>>> +               pctrl = devm_pinctrl_get_select_default(dev);
>>>> +               if (IS_ERR_OR_NULL(pctrl)) {
>>>
>>> It's enough to "if (IS_ERR(pctrl)) {".
>>>
>> what if it returns NULL?
>
> devm_pinctrl_get_select_default() never return NULL.
>

My mistake. If CONFIG_PINCTRL is disabled, 
devm_pinctrl_get_select_default can return NULL.

Linus,

devm_pinctrl_get_select() and pinctrl_get_select() also need 
IS_ERR_OR_NULL instead of IS_ERR?
And many drivers using above functions don't check NULL, right?

Thanks.

>
>>>> + DRM_ERROR("failed:
>>>> devm_pinctrl_get_select_default()\n"
>>>> +                               "with return value: %d\n",
>>>> PTR_RET(pctrl));
>>>> +                       return PTR_RET(pctrl);
>>>
>>> It's enough to "return PTR_ERR(pctrl);"
>>>
>> ok.
>>
>>>> +               }
>>>
>>> If this needs, parts for pinctrl should go to another patch.
>>>
>> I have it as a separate patch already. [PATCH v7 2/2] video: drm:
>> exynos: Add pinctrl support to fimd
>>>> +
>>>> +       } else {
>>>> +               pdata = pdev->dev.platform_data;
>>>> +               if (!pdata) {
>>>> +                       DRM_ERROR("no platform data specified\n");
>>>> +                       return -EINVAL;
>>>> +               }
>>>>          }
>>>>          panel = &pdata->panel;
>>>
>>> Thanks.
>>
>>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

