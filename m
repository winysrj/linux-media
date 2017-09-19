Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36279 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751109AbdISMZa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <20170908163929.9277-1-sthemmin@microsoft.com>
References: <20170908163929.9277-1-sthemmin@microsoft.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 Sep 2017 14:25:29 +0200
Message-ID: <CAMuHMdXV=LFyKqrZ1-e7qnLdYay69ov3vxEsk-ZjWvs876RdpQ@mail.gmail.com>
Subject: Re: [PATCH] media: default for RC_CORE should be n
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 8, 2017 at 6:39 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> The Linus policy on Kconfig is that the default should be no
> for all new devices. I.e the user rebuild a new kernel from an
> old config should not by default get a larger kernel.
>
> Fixes: b4c184e506a4 ("[media] media: reorganize the main Kconfig items")
> Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> ---
>  drivers/media/rc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index d9ce8ff55d0c..5aa384afcfef 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -2,7 +2,7 @@
>  menuconfig RC_CORE
>         tristate "Remote Controller support"
>         depends on INPUT
> -       default y
> +       default n

"default n" is the default, so you can just drop this line.

For the principle:
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
