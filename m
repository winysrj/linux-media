Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:57771 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3HEFMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 01:12:13 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so4790854obc.27
        for <linux-media@vger.kernel.org>; Sun, 04 Aug 2013 22:12:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375425134-17080-2-git-send-email-sachin.kamat@linaro.org>
References: <1375425134-17080-1-git-send-email-sachin.kamat@linaro.org>
	<1375425134-17080-2-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 5 Aug 2013 10:42:12 +0530
Message-ID: <CAK9yfHyhDyoAphFC=MtDxtCedhN8-A=+gtXKZevsFg=JYq=ZUQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] [media] exynos4-is: Annotate unused functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: sachin.kamat@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 2 August 2013 12:02, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> __is_set_init_isp_aa and fimc_is_hw_set_tune currently do not have
> any callers. However these functions may be used in the future. Hence
> instead of deleting them, staticize and annotate them with __maybe_unused
> flag to avoid compiler warnings.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks for applying the other 2 patches in this series. What is your
opinion about this one?
Does this look good or do you prefer to delete the code altogether?

> ---
>  drivers/media/platform/exynos4-is/fimc-is-param.c |    2 +-
>  drivers/media/platform/exynos4-is/fimc-is-regs.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/exynos4-is/fimc-is-param.c b/drivers/media/platform/exynos4-is/fimc-is-param.c
> index a353be0..9bf3ddd 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is-param.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is-param.c
> @@ -287,7 +287,7 @@ void __is_set_sensor(struct fimc_is *is, int fps)
>         fimc_is_set_param_bit(is, PARAM_ISP_OTF_INPUT);
>  }
>
> -void __is_set_init_isp_aa(struct fimc_is *is)
> +static void __maybe_unused __is_set_init_isp_aa(struct fimc_is *is)
>  {
>         struct isp_param *isp;
>
> diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
> index 63c68ec..cf2e13a 100644
> --- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
> +++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
> @@ -96,7 +96,7 @@ int fimc_is_hw_set_param(struct fimc_is *is)
>         return 0;
>  }
>
> -int fimc_is_hw_set_tune(struct fimc_is *is)
> +static int __maybe_unused fimc_is_hw_set_tune(struct fimc_is *is)
>  {
>         fimc_is_hw_wait_intmsr0_intmsd0(is);
>
> --
> 1.7.9.5
>



-- 
With warm regards,
Sachin
