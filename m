Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44168 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965772AbeF0Qpj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 12:45:39 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH/RFC 2/2] arm64: dts: renesas: salvator-common: Fix adv7482
 decimal unit addresses
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Simon Horman <horms@verge.net.au>
Cc: Rob Herring <robh@kernel.org>,
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
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
 <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
 <20180626195747.GB30143@rob-hp-laptop>
 <20180627151030.o2peqxdnesni3wfi@verge.net.au>
 <CAMuHMdXWKuzJ5jzAMugZArXuK_NRwaptXMSGuWjtOEcPwv6CJA@mail.gmail.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <f0445e88-a8ca-081d-e553-bdfae6f374a5@ideasonboard.com>
Date: Wed, 27 Jun 2018 17:45:34 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXWKuzJ5jzAMugZArXuK_NRwaptXMSGuWjtOEcPwv6CJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/06/18 17:40, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Wed, Jun 27, 2018 at 5:10 PM Simon Horman <horms@verge.net.au> wrote:
>> On Tue, Jun 26, 2018 at 01:57:47PM -0600, Rob Herring wrote:
>>> On Thu, Jun 14, 2018 at 03:48:08PM +0200, Geert Uytterhoeven wrote:
>>>> With recent dtc and W=1:
>>>>
>>>>     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@10: graph node unit address error, expected "a"
>>>>     ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@11: graph node unit address error, expected "b"
>>>>
>>>> Unit addresses are always hexadecimal (without prefix), while the bases
>>>> of reg property values depend on their prefixes.
>>>>
>>>> Fixes: 908001d778eba06e ("arm64: dts: renesas: salvator-common: Add ADV7482 support")
>>>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>>>> ---
>>>>  arch/arm64/boot/dts/renesas/salvator-common.dtsi | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> Reviewed-by: Rob Herring <robh@kernel.org>
>>
>> Geert, shall I apply this?
> 
> I'd say yes. Thanks!

I'm happy to throw an

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

on the patch - but I had a pending question regarding the reg = <10> part.

Shouldn't the reg become hex "reg = <0xa>" to be consistent?

Either way - if there's precedent - take that route and I'm happy.

--
Regards

Kieran


> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
