Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:46355 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab3B1Co0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 21:44:26 -0500
Received: by mail-la0-f45.google.com with SMTP id er20so1304596lab.32
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 18:44:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EC410.3050301@samsung.com>
References: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org> <512EC410.3050301@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 28 Feb 2013 08:14:04 +0530
Message-ID: <CAD025yRzP4OaSwRLYf_oHnX14e-eM4tDt1GXp+iDvw1ikjgjdg@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos fimd
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, inki.dae@samsung.com, l.krishna@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mr. Shim.

On 28 February 2013 08:12, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> On 02/27/2013 07:32 PM, Vikas Sajjan wrote:
>>
>> modified compatible string for exynos4 fimd as "exynos4210-fimd" and
>> exynos5 fimd as "exynos5250-fimd" to stick to the rule that compatible
>> value should be named after first specific SoC model in which this
>> particular IP version was included as discussed at
>> https://patchwork.kernel.org/patch/2144861/
>>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> ---
>>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> index 9537761..433ed35 100644
>> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> @@ -109,9 +109,9 @@ struct fimd_context {
>>     #ifdef CONFIG_OF
>>   static const struct of_device_id fimd_driver_dt_match[] = {
>> -       { .compatible = "samsung,exynos4-fimd",
>> +       { .compatible = "samsung,exynos4210-fimd",
>>           .data = &exynos4_fimd_driver_data },
>> -       { .compatible = "samsung,exynos5-fimd",
>> +       { .compatible = "samsung,exynos5250-fimd",
>>           .data = &exynos5_fimd_driver_data },
>>         {},
>>   };
>
>
> Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
>
> Thanks.



-- 
Thanks and Regards
 Vikas Sajjan
