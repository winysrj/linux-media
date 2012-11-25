Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:57364 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2KYHAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 02:00:07 -0500
Received: by mail-vc0-f174.google.com with SMTP id m18so6695443vcm.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 23:00:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
References: <1353668682-13366-1-git-send-email-sachin.kamat@linaro.org>
Date: Sun, 25 Nov 2012 12:30:04 +0530
Message-ID: <CAOD6ATpPKvG3H2Z3_XK+yozM3KC4kh5=70HM2hpMUYvPfpe_6w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] [media] exynos-gsc: Some fixes
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, patches@linaro.org,
	Sachin Kamat <sachin.kamat@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

I tested this patch series. Looks good to me.

Thanks,
Shaik Ameer Basha

On Fri, Nov 23, 2012 at 4:34 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Changes since v1:
> Removed the label 'err' from function gsc_clk_get as suggested
> by Sylwester Nawrocki <s.nawrocki@samsung.com> in patch 3/4.
> Other patches remain the same.
>
> Patch series build tested and based on samsung/for_v3.8 branch of
> git://linuxtv.org/snawrocki/media.git.
>
> Sachin Kamat (4):
>   [media] exynos-gsc: Rearrange error messages for valid prints
>   [media] exynos-gsc: Remove gsc_clk_put call from gsc_clk_get
>   [media] exynos-gsc: Use devm_clk_get()
>   [media] exynos-gsc: Fix checkpatch warning in gsc-m2m.c
>
>  drivers/media/platform/exynos-gsc/gsc-core.c |   21 ++++++++-------------
>  drivers/media/platform/exynos-gsc/gsc-m2m.c  |    2 +-
>  2 files changed, 9 insertions(+), 14 deletions(-)
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
