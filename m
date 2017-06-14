Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36096 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751758AbdFNJjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 05:39:02 -0400
MIME-Version: 1.0
In-Reply-To: <7d4b2333912ad23e62dbb8cc3792ad70e9cc1702.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d0545e32d322ca1b939fa2918694173629e680eb.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
 <7d4b2333912ad23e62dbb8cc3792ad70e9cc1702.1497313626.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 14 Jun 2017 11:39:00 +0200
Message-ID: <CAMuHMdWVrqArGasrW8F8KOjRfRzFqQ_5hCskP30zGrTrxJ75hQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] arm64: dts: renesas: salvator-x: Add ADV7482 support
To: Kieran Bingham <kbingham@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Tue, Jun 13, 2017 at 2:35 AM, Kieran Bingham <kbingham@kernel.org> wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>
> Provide ADV7482, and the needed connectors
>
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Thanks for your patch!

> v4:
>  - dt: Rebase to dts/renesas/salvator-x.dtsi
>  - dt: Use AIN0-7 rather than AIN1-8
>
>  arch/arm64/boot/dts/renesas/salvator-x.dtsi | 123 +++++++++++++++++++++-

I believe all of this applies to both Salvator-X and Salvator-XS?

Hence it should be applied to salvator-common.dtsi instead of salvator-x.dtsi.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
