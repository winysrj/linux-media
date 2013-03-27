Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:40329 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab3C0Kr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 06:47:57 -0400
Received: by mail-la0-f45.google.com with SMTP id er20so15489097lab.32
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 03:47:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAQKjZNOKu0RxYfuOBj8Fg3OfV8hXsA-QF7mgqQeFW6c4B2xgQ@mail.gmail.com>
References: <1363779119-3255-1-git-send-email-vikas.sajjan@linaro.org> <CAAQKjZNOKu0RxYfuOBj8Fg3OfV8hXsA-QF7mgqQeFW6c4B2xgQ@mail.gmail.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Wed, 27 Mar 2013 16:17:35 +0530
Message-ID: <CAD025yTMPR=0n3ur3KiHEDrxaOh1snC7m0VAGjArP0hz5WL4ug@mail.gmail.com>
Subject: Re: [PATCH v2] drm/exynos: enable FIMD clocks
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	kgene.kim@samsung.com, linaro-kernel@lists.linaro.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 27 March 2013 15:53, Inki Dae <inki.dae@samsung.com> wrote:
> 2013/3/20 Vikas Sajjan <vikas.sajjan@linaro.org>:
>> While migrating to common clock framework (CCF), found that the FIMD clocks
>> were pulled down by the CCF.
>> If CCF finds any clock(s) which has NOT been claimed by any of the
>> drivers, then such clock(s) are PULLed low by CCF.
>>
>> By calling clk_prepare_enable() for FIMD clocks fixes the issue.
>>
>> this patch also replaces clk_disable() with clk_disable_unprepare()
>> during exit.
>>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>> Changes since v1:
>>         - added error checking for clk_prepare_enable() and also replaced
>>         clk_disable() with clk_disable_unprepare() during exit.
>> ---
>>  drivers/gpu/drm/exynos/exynos_drm_fimd.c |   17 +++++++++++++++--
>>  1 file changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index 9537761..014d750 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -934,6 +934,19 @@ static int fimd_probe(struct platform_device *pdev)
>>                 return ret;
>>         }
>>
>> +       ret = clk_prepare_enable(ctx->lcd_clk);
>> +       if (ret) {
>> +               dev_err(dev, "failed to enable 'sclk_fimd' clock\n");
>> +               return ret;
>> +       }
>> +
>> +       ret = clk_prepare_enable(ctx->bus_clk);
>> +       if (ret) {
>> +               clk_disable_unprepare(ctx->lcd_clk);
>> +               dev_err(dev, "failed to enable 'fimd' clock\n");
>> +               return ret;
>> +       }
>> +
>
> Please remove the above two clk_prepare_enable function calls and use
> them in fimd_clock() instead of clk_enable/disable(). When probed,
> fimd clock will be enabled by runtime pm.
>

Sure, will modify and resend.

> Thanks,
> Inki Dae
>
>>         ctx->vidcon0 = pdata->vidcon0;
>>         ctx->vidcon1 = pdata->vidcon1;
>>         ctx->default_win = pdata->default_win;
>> @@ -981,8 +994,8 @@ static int fimd_remove(struct platform_device *pdev)
>>         if (ctx->suspended)
>>                 goto out;
>>
>> -       clk_disable(ctx->lcd_clk);
>> -       clk_disable(ctx->bus_clk);
>> +       clk_disable_unprepare(ctx->lcd_clk);
>> +       clk_disable_unprepare(ctx->bus_clk);
>>
>>         pm_runtime_set_suspended(dev);
>>         pm_runtime_put_sync(dev);
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
