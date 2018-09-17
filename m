Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33525 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbeIQXHk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 19:07:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id d4-v6so7905943pfn.0
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 10:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20180915061615.25308-1-natechancellor@gmail.com>
In-Reply-To: <20180915061615.25308-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 17 Sep 2018 10:39:05 -0700
Message-ID: <CAKwvOd=FY9_F=yDOPaesM1VmYW0jTaAAYcMTmG6TFwa=ACu62w@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: Fix implicit enum conversion warning
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: prabhakar.csengg@gmail.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2018 at 11:16 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another.
>
> drivers/media/platform/davinci/vpbe_display.c:524:24: warning: implicit
> conversion from enumeration type 'enum osd_v_exp_ratio' to different
> enumeration type 'enum osd_h_exp_ratio' [-Wenum-conversion]
>                         layer_info->h_exp = V_EXP_6_OVER_5;
>                                           ~ ^~~~~~~~~~~~~~
> 1 warning generated.
>
> This appears to be a copy and paste error judging from the couple of
> lines directly above this statement and the way that height is handled
> in the if block above this one.


The above code for reference looks like:
   492                 if (h_exp)
   493                         layer_info->h_exp = H_EXP_9_OVER_8;

so it makes sense to me that:
if (h_exp) layer_info->h_exp = H_EXP_...;
then
if (v_exp) layer_info->v_exp = V_EXP_...;

Thanks for this patch Nathan, looks like an actual bug has been fixed.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

We should send this to stable if/when it lands.  Maybe the maintainers
could apply it with:
Cc: stable@vger.kernel.org


>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/media/platform/davinci/vpbe_display.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index d6bf96ad474c..5c235898af7b 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -521,7 +521,7 @@ vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
>                 else if (v_scale == 4)
>                         layer_info->v_zoom = ZOOM_X4;
>                 if (v_exp)
> -                       layer_info->h_exp = V_EXP_6_OVER_5;
> +                       layer_info->v_exp = V_EXP_6_OVER_5;
>         } else {
>                 /* no scaling, only cropping. Set display area to crop area */
>                 cfg->ysize = expected_ysize;
> --
> 2.18.0
>


-- 
Thanks,
~Nick Desaulniers
