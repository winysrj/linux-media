Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34262 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbdFMOPI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 10:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <20170613133348.48044-2-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170613133348.48044-1-ramesh.shanmugasundaram@bp.renesas.com> <20170613133348.48044-2-ramesh.shanmugasundaram@bp.renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 13 Jun 2017 16:15:06 +0200
Message-ID: <CAMuHMdVSBstPK55-36vJySKc-NAUyWKRMDYGgF4vBce07Pn0Ug@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] iopoll: Avoid namespace collision within macros & tidyup
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Mark Brown <broonie@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        mattw@codeaurora.org, Mitchel Humpherys <mitchelh@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Chris Paterson <chris.paterson2@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Tue, Jun 13, 2017 at 3:33 PM, Ramesh Shanmugasundaram
<ramesh.shanmugasundaram@bp.renesas.com> wrote:
> Renamed variable "timeout" to "__timeout" to avoid namespace collision.
> Tidy up macro arguments with paranthesis.
>
> Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>

Thanks for your patches!

> --- a/include/linux/iopoll.h
> +++ b/include/linux/iopoll.h
> @@ -42,18 +42,19 @@
>   */
>  #define readx_poll_timeout(op, addr, val, cond, sleep_us, timeout_us)  \
>  ({ \
> -       ktime_t timeout = ktime_add_us(ktime_get(), timeout_us); \
> +       ktime_t __timeout = ktime_add_us(ktime_get(), timeout_us); \

I think timeout_us should be within parentheses, too.

>         might_sleep_if(sleep_us); \
>         for (;;) { \
>                 (val) = op(addr); \
>                 if (cond) \
>                         break; \
> -               if (timeout_us && ktime_compare(ktime_get(), timeout) > 0) { \
> +               if ((timeout_us) && \
> +                   ktime_compare(ktime_get(), __timeout) > 0) { \
>                         (val) = op(addr); \
>                         break; \
>                 } \
>                 if (sleep_us) \
> -                       usleep_range((sleep_us >> 2) + 1, sleep_us); \
> +                       usleep_range(((sleep_us) >> 2) + 1, sleep_us); \

Same for sleep_us.

Also in readx_poll_timeout_atomic(), and in your second patch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
