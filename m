Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45610 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbeH3TVa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 15:21:30 -0400
MIME-Version: 1.0
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org> <1534760202-20114-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534760202-20114-8-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 30 Aug 2018 17:18:38 +0200
Message-ID: <CAMuHMdXU_0n0n+9FavatBJth8iiEBp+dPSwpGbBp01j0g3vPVQ@mail.gmail.com>
Subject: Re: [RFT 7/8] arm64: dts: r8a77990: Add I2C device nodes
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Simon Horman <horms@verge.net.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Magnus Damm <damm+renesas@opensource.se>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch!

On Mon, Aug 20, 2018 at 12:17 PM Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> From: Takeshi Kihara <takeshi.kihara.df@renesas.com>
>
> Add device nodes for I2C ch{0,1,2,3,4,5,6,7} to R-Car E3 R8A77990 device tree.

ch[0-7]?

>
> Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Buses 0 and 3 are the only buses hosting devices on Ebisu, and i2cdetect
sees them, so:

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
