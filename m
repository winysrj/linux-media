Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:36403 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab3JXPmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 11:42:11 -0400
Received: by mail-oa0-f41.google.com with SMTP id o9so2604718oag.14
        for <linux-media@vger.kernel.org>; Thu, 24 Oct 2013 08:42:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOesGMhwotSY-1WQmt+wtsrsH2m30VE=j-MwyhpYU3mt_PSPPw@mail.gmail.com>
References: <1381940896-9355-1-git-send-email-kishon@ti.com>
	<1381940896-9355-4-git-send-email-kishon@ti.com>
	<CAOesGMhwotSY-1WQmt+wtsrsH2m30VE=j-MwyhpYU3mt_PSPPw@mail.gmail.com>
Date: Thu, 24 Oct 2013 21:12:09 +0530
Message-ID: <CAK9yfHxaLsdFGXiCxvs+HpMSuY6xWd=CGPv-YfSkJqWSxE+f-w@mail.gmail.com>
Subject: Re: [PATCH 3/7] video: exynos_mipi_dsim: Use the generic PHY driver
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Olof,

On 24 October 2013 20:00, Olof Johansson <olof@lixom.net> wrote:
> Hi Kishon,
>
> On Wed, Oct 16, 2013 at 9:28 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
>> index 32e5406..00b3a52 100644
>> --- a/drivers/video/exynos/exynos_mipi_dsi.c
>> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
>> @@ -156,8 +157,7 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
>>                 exynos_mipi_regulator_enable(dsim);
>>
>>                 /* enable MIPI-DSI PHY. */
>> -               if (dsim->pd->phy_enable)
>> -                       dsim->pd->phy_enable(pdev, true);
>> +               phy_power_on(dsim->phy);
>>
>>                 clk_enable(dsim->clock);
>>
>
> This introduces the below with exynos_defconfig:
>
> ../../drivers/video/exynos/exynos_mipi_dsi.c: In function
> 'exynos_mipi_dsi_blank_mode':
> ../../drivers/video/exynos/exynos_mipi_dsi.c:144:26: warning: unused
> variable 'pdev' [-Wunused-variable]
>   struct platform_device *pdev = to_platform_device(dsim->dev);
>

I have already submitted a patch to fix this [1]

[1] http://marc.info/?l=linux-fbdev&m=138233359617936&w=2


-- 
With warm regards,
Sachin
