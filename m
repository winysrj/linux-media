Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36569 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756111AbdELG4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 May 2017 02:56:33 -0400
MIME-Version: 1.0
In-Reply-To: <b7f89ec984dcb1cd14c61de72b43c6e55fd80b88.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
 <b7f89ec984dcb1cd14c61de72b43c6e55fd80b88.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 12 May 2017 08:56:32 +0200
Message-ID: <CAMuHMdWXUkqSz6XUtsBjJH1U=fS8w7PAw0Av8WM+Uzi3N+w0Zw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] arm64: dts: r8a7795: salvator-x: enable VIN,
 CSI and ADV7482
To: Kieran Bingham <kbingham@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thu, May 11, 2017 at 7:21 PM, Kieran Bingham <kbingham@kernel.org> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Provide bindings between the VIN, CSI and the ADV7482 on the r8a7795.
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> index 7a8986edcdc0..e295f041b36a 100644
> --- a/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts
> +++ b/arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts

I think this should be added to salvator-x.dtsi instead.

> @@ -387,6 +403,68 @@
>         };
>  };
>
> +&i2c4 {
> +       status = "okay";

Please extend the existing "&i2c4 { ... }" section.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
