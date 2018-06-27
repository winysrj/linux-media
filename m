Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:43867 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964784AbeF0QlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 12:41:04 -0400
MIME-Version: 1.0
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
 <20180626195747.GB30143@rob-hp-laptop> <20180627151030.o2peqxdnesni3wfi@verge.net.au>
In-Reply-To: <20180627151030.o2peqxdnesni3wfi@verge.net.au>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 27 Jun 2018 18:40:51 +0200
Message-ID: <CAMuHMdXWKuzJ5jzAMugZArXuK_NRwaptXMSGuWjtOEcPwv6CJA@mail.gmail.com>
Subject: Re: [PATCH/RFC 2/2] arm64: dts: renesas: salvator-common: Fix adv7482
 decimal unit addresses
To: Simon Horman <horms@verge.net.au>
Cc: Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Rutland <mark.rutland@arm.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Wed, Jun 27, 2018 at 5:10 PM Simon Horman <horms@verge.net.au> wrote:
> On Tue, Jun 26, 2018 at 01:57:47PM -0600, Rob Herring wrote:
> > On Thu, Jun 14, 2018 at 03:48:08PM +0200, Geert Uytterhoeven wrote:
> > > With recent dtc and W=1:
> > >
> > >     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@10: graph node unit address error, expected "a"
> > >     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@11: graph node unit address error, expected "b"
> > >
> > > Unit addresses are always hexadecimal (without prefix), while the bases
> > > of reg property values depend on their prefixes.
> > >
> > > Fixes: 908001d778eba06e ("arm64: dts: renesas: salvator-common: Add ADV7482 support")
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > >  arch/arm64/boot/dts/renesas/salvator-common.dtsi | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
>
> Geert, shall I apply this?

I'd say yes. Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
