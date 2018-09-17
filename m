Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39893 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbeIQXNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 19:13:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id w14-v6so7757952plp.6
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 10:45:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180915060612.21812-1-natechancellor@gmail.com>
In-Reply-To: <20180915060612.21812-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 17 Sep 2018 10:45:13 -0700
Message-ID: <CAKwvOd=Mx7T4tMAC0v46b=9BrkOS8MNxprkFWEQP5Bz6rZvvxg@mail.gmail.com>
Subject: Re: [PATCH] [media] bt8xx: Remove unnecessary self-assignment
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 14, 2018 at 11:06 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when a variable is assigned to itself.
>
> drivers/media/pci/bt8xx/bttv-driver.c:2043:13: warning: explicitly
> assigning value of variable of type '__s32' (aka 'int') to itself
> [-Wself-assign]
>         min_height = min_height;
>         ~~~~~~~~~~ ^ ~~~~~~~~~~
> 1 warning generated.
>
> There doesn't appear to be any good reason for this and this statement
> was added in commit e5bd0260e7d3 ("V4L/DVB (5077): Bttv cropping
> support") back in 2007. Just remove it.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>
> I'm not sure if the comment should have been removed as well. If it
> does, I can easily send a v2.

I think the comments are actually reversed; the comment about max
scale should be for max_height and min scale should be for min_height.

Self assignment usually is used to silence unused variable warnings,
which doesn't look to be the case here.

Not sure about the comment; I think it's good to keep it, just unsure
of the exact statement it applies to.  Maybe Mauro has thoughts on
that?

Either way, you can add my reviewed by tag to this or a v2 that
moves/removes the comment, though I think this patch may just be fine.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the patch.

>
> Thanks!
>
>  drivers/media/pci/bt8xx/bttv-driver.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 413bf287547c..b2cfcbb0008e 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2040,7 +2040,6 @@ limit_scaled_size_lock       (struct bttv_fh *               fh,
>         max_width = max_width & width_mask;
>
>         /* Max. scale factor is 16:1 for frames, 8:1 for fields. */
> -       min_height = min_height;
>         /* Min. scale factor is 1:1. */
>         max_height >>= !V4L2_FIELD_HAS_BOTH(field);
>
> --
> 2.18.0
>


-- 
Thanks,
~Nick Desaulniers
