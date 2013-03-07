Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:60750 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3CGHJ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:09:28 -0500
Received: by mail-lb0-f172.google.com with SMTP id n8so194156lbj.3
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:09:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512EC410.3050301@samsung.com>
References: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org> <512EC410.3050301@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 7 Mar 2013 12:39:06 +0530
Message-ID: <CAD025yT+VQ=bv1Sk61QtMft45nw7BWqn9ox5B5opGpr3s-1nxw@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos fimd
To: InKi Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, Joonyoung Shim <jy0922.shim@samsung.com>,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mr Inki Dae,

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

Can you please apply this patch.

>
> Thanks.



-- 
Thanks and Regards
 Vikas Sajjan
