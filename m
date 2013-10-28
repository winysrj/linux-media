Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:47163 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3J1GMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 02:12:15 -0400
Message-id: <526E0038.7050805@samsung.com>
Date: Mon, 28 Oct 2013 15:12:08 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Olof Johansson <olof@lixom.net>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	inki.dae@samsung.com, dh09.lee@samsung.com
Subject: Re: [PATCH 3/7] video: exynos_mipi_dsim: Use the generic PHY driver
References: <1381940896-9355-1-git-send-email-kishon@ti.com>
 <1381940896-9355-4-git-send-email-kishon@ti.com>
 <CAOesGMhwotSY-1WQmt+wtsrsH2m30VE=j-MwyhpYU3mt_PSPPw@mail.gmail.com>
 <CAK9yfHxaLsdFGXiCxvs+HpMSuY6xWd=CGPv-YfSkJqWSxE+f-w@mail.gmail.com>
 <52694354.6030603@ti.com> <526997BC.8070602@gmail.com>
In-reply-to: <526997BC.8070602@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, OCT 25, 2013 06:57, Sylwester Nawrocki wrote:
> On 10/24/2013 05:57 PM, Kishon Vijay Abraham I wrote:
>> On Thursday 24 October 2013 09:12 PM, Sachin Kamat wrote:
>>> On 24 October 2013 20:00, Olof Johansson<olof@lixom.net>  wrote:
>>>> On Wed, Oct 16, 2013 at 9:28 AM, Kishon Vijay Abraham I<kishon@ti.com>  wrote:
>>>>> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
>>>>> index 32e5406..00b3a52 100644
>>>>> --- a/drivers/video/exynos/exynos_mipi_dsi.c
>>>>> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
>>>>> @@ -156,8 +157,7 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
>>>>>                  exynos_mipi_regulator_enable(dsim);
>>>>>
>>>>>                  /* enable MIPI-DSI PHY. */
>>>>> -               if (dsim->pd->phy_enable)
>>>>> -                       dsim->pd->phy_enable(pdev, true);
>>>>> +               phy_power_on(dsim->phy);
>>>>>
>>>>>                  clk_enable(dsim->clock);
>>>>>
>>>>
>>>> This introduces the below with exynos_defconfig:
>>>>
>>>> ../../drivers/video/exynos/exynos_mipi_dsi.c: In function
>>>> 'exynos_mipi_dsi_blank_mode':
>>>> ../../drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused
>>>> variable 'pdev' [-Wunused-variable]
>>>>    struct platform_device *pdev = to_platform_device(dsim->dev);
>
> Sorry about missing that, I only noticed this warning recently and didn't
> get around to submit a patch.
>
>>> I have already submitted a patch to fix this [1]
>
> Thanks a lot guys for fixing this.
>
>>> [1] http://marc.info/?l=linux-fbdev&m=138233359617936&w=2
>>
>> Sorry, missed that :-(
>
> This MIPI DSIM driver is affectively a dead code in the mainline now, once
> Exynos become a dt-only platform. I guess it can be deleted for 3.14, once
> S5P gets converted to the device tree. The new driver using CDF is basically
> a complete rewrite. Or device tree support should be added to that driver,
> but I believe it doesn't make sense without CDF.
>

MIPI DSIM driver is not a dead code. There is a steady trickle of patches.
It's kind of late, but, I will update it as DT based drivers as soon as possible.
And Why do you think that DT support of existing MIPI DSIM is something less
than great?


> -- 
> Regards,
> Sylwester
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

