Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34724 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756722AbcISHRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 03:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <20160916130935.21292-2-ulrich.hecht+renesas@gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com> <20160916130935.21292-2-ulrich.hecht+renesas@gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 19 Sep 2016 09:17:30 +0200
Message-ID: <CAMuHMdWcDc0FY+mXzspF6aVs=m-t+etjmNzaJkMXb3N3n5jQQw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: r8a7793: Enable VIN0, VIN1
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: Simon Horman <horms@verge.net.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

On Fri, Sep 16, 2016 at 3:09 PM, Ulrich Hecht
<ulrich.hecht+renesas@gmail.com> wrote:
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/arch/arm/boot/dts/r8a7793.dtsi
> +++ b/arch/arm/boot/dts/r8a7793.dtsi
> @@ -30,6 +30,8 @@
>                 i2c7 = &i2c7;
>                 i2c8 = &i2c8;
>                 spi0 = &qspi;
> +               vin0 = &vin0;
> +               vin1 = &vin1;
>         };
>
>         cpus {
> @@ -852,6 +854,24 @@
>                 status = "disabled";
>         };
>
> +       vin0: video@e6ef0000 {

> +       vin1: video@e6ef1000 {

Any specific reason you didn't add vin2?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
