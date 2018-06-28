Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:51029 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbeF1IsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 04:48:02 -0400
Date: Thu, 28 Jun 2018 10:47:58 +0200
From: Simon Horman <horms@verge.net.au>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Mark Rutland <mark.rutland@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/2] arm64: dts: renesas: salvator-common: Fix
 adv7482 decimal unit addresses
Message-ID: <20180628084758.lyfmvawuep4ql6eq@verge.net.au>
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
 <20180626195747.GB30143@rob-hp-laptop>
 <20180627151030.o2peqxdnesni3wfi@verge.net.au>
 <CAMuHMdXWKuzJ5jzAMugZArXuK_NRwaptXMSGuWjtOEcPwv6CJA@mail.gmail.com>
 <f0445e88-a8ca-081d-e553-bdfae6f374a5@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0445e88-a8ca-081d-e553-bdfae6f374a5@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 27, 2018 at 05:45:34PM +0100, Kieran Bingham wrote:
> On 27/06/18 17:40, Geert Uytterhoeven wrote:
> > Hi Simon,
> > 
> > On Wed, Jun 27, 2018 at 5:10 PM Simon Horman <horms@verge.net.au> wrote:
> >> On Tue, Jun 26, 2018 at 01:57:47PM -0600, Rob Herring wrote:
> >>> On Thu, Jun 14, 2018 at 03:48:08PM +0200, Geert Uytterhoeven wrote:
> >>>> With recent dtc and W=1:
> >>>>
> >>>>     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@10: graph node unit address error, expected "a"
> >>>>     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@11: graph node unit address error, expected "b"
> >>>>
> >>>> Unit addresses are always hexadecimal (without prefix), while the bases
> >>>> of reg property values depend on their prefixes.
> >>>>
> >>>> Fixes: 908001d778eba06e ("arm64: dts: renesas: salvator-common: Add ADV7482 support")
> >>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >>>> ---
> >>>>  arch/arm64/boot/dts/renesas/salvator-common.dtsi | 4 ++--
> >>>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> Reviewed-by: Rob Herring <robh@kernel.org>
> >>
> >> Geert, shall I apply this?
> > 
> > I'd say yes. Thanks!
> 
> I'm happy to throw an
> 
> Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> on the patch - but I had a pending question regarding the reg = <10> part.
> 
> Shouldn't the reg become hex "reg = <0xa>" to be consistent?
> 
> Either way - if there's precedent - take that route and I'm happy.

Consistency seems good to me, Geert?
