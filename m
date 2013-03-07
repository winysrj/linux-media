Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40336 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3CGHe0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:34:26 -0500
Received: by mail-lb0-f177.google.com with SMTP id go11so206640lbb.36
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:34:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <014501ce1b03$c70ccdc0$55266940$%dae@samsung.com>
References: <1361961178-1912-1-git-send-email-vikas.sajjan@linaro.org>
 <512EC410.3050301@samsung.com> <CAD025yT+VQ=bv1Sk61QtMft45nw7BWqn9ox5B5opGpr3s-1nxw@mail.gmail.com>
 <014501ce1b03$c70ccdc0$55266940$%dae@samsung.com>
From: Vikas Sajjan <vikas.sajjan@linaro.org>
Date: Thu, 7 Mar 2013 13:04:04 +0530
Message-ID: <CAD025yQb9qae563cnbd9zvEA=i3cuDQ48Qp3yZen9CD_DKf8Kg@mail.gmail.com>
Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos fimd
To: Inki Dae <inki.dae@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	kgene.kim@samsung.com, Joonyoung Shim <jy0922.shim@samsung.com>,
	sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks.

On 7 March 2013 12:47, Inki Dae <inki.dae@samsung.com> wrote:
> Already merged. :)
>
>> -----Original Message-----
>> From: Vikas Sajjan [mailto:vikas.sajjan@linaro.org]
>> Sent: Thursday, March 07, 2013 4:09 PM
>> To: InKi Dae
>> Cc: dri-devel@lists.freedesktop.org; linux-media@vger.kernel.org;
>> kgene.kim@samsung.com; Joonyoung Shim; sunil joshi
>> Subject: Re: [PATCH] drm/exynos: modify the compatible string for exynos
>> fimd
>>
>> Hi Mr Inki Dae,
>>
>> On 28 February 2013 08:12, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>> > On 02/27/2013 07:32 PM, Vikas Sajjan wrote:
>> >>
>> >> modified compatible string for exynos4 fimd as "exynos4210-fimd" and
>> >> exynos5 fimd as "exynos5250-fimd" to stick to the rule that compatible
>> >> value should be named after first specific SoC model in which this
>> >> particular IP version was included as discussed at
>> >> https://patchwork.kernel.org/patch/2144861/
>> >>
>> >> Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
>> >> ---
>> >>   drivers/gpu/drm/exynos/exynos_drm_fimd.c |    4 ++--
>> >>   1 file changed, 2 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> >> b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> >> index 9537761..433ed35 100644
>> >> --- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> >> +++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
>> >> @@ -109,9 +109,9 @@ struct fimd_context {
>> >>     #ifdef CONFIG_OF
>> >>   static const struct of_device_id fimd_driver_dt_match[] = {
>> >> -       { .compatible = "samsung,exynos4-fimd",
>> >> +       { .compatible = "samsung,exynos4210-fimd",
>> >>           .data = &exynos4_fimd_driver_data },
>> >> -       { .compatible = "samsung,exynos5-fimd",
>> >> +       { .compatible = "samsung,exynos5250-fimd",
>> >>           .data = &exynos5_fimd_driver_data },
>> >>         {},
>> >>   };
>> >
>> >
>> > Acked-by: Joonyoung Shim <jy0922.shim@samsung.com>
>>
>> Can you please apply this patch.
>>
>> >
>> > Thanks.
>>
>>
>>
>> --
>> Thanks and Regards
>>  Vikas Sajjan
>



-- 
Thanks and Regards
 Vikas Sajjan
