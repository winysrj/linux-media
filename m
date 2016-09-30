Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37584 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932269AbcI3Nc4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Sep 2016 09:32:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] ARM: dts: gose: add HDMI input
Date: Fri, 30 Sep 2016 16:32:52 +0300
Message-ID: <3186140.opQPlkUUe2@avalon>
In-Reply-To: <CAMuHMdV3ZSfMeyCv3j8F3rUeT48nQc-03L5iDXYF-=wT7Ek2nw@mail.gmail.com>
References: <20160916130935.21292-1-ulrich.hecht+renesas@gmail.com> <1951325.PMIbTHqE2x@avalon> <CAMuHMdV3ZSfMeyCv3j8F3rUeT48nQc-03L5iDXYF-=wT7Ek2nw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 30 Sep 2016 15:00:59 Geert Uytterhoeven wrote:
> On Fri, Sep 30, 2016 at 2:40 PM, Laurent Pinchart wrote:
> >> --- a/arch/arm/boot/dts/r8a7793-gose.dts
> >> +++ b/arch/arm/boot/dts/r8a7793-gose.dts
> >> @@ -374,6 +374,11 @@
> >>               groups = "audio_clk_a";
> >>               function = "audio_clk";
> >>       };
> >> +
> >> +     vin0_pins: vin0 {
> >> +             groups = "vin0_data24", "vin0_sync", "vin0_clkenb",
> >> "vin0_clk";
> >> +             function = "vin0";
> >> +     };
> >>  };
> >>  
> >>  &ether {
> >> @@ -531,6 +536,21 @@
> >>               };
> >>       };
> >> 
> >> +     hdmi-in@4c {
> >> +             compatible = "adi,adv7612";
> >> +             reg = <0x4c>;
> >> +             interrupt-parent = <&gpio1>;
> >> +             interrupts = <20 IRQ_TYPE_LEVEL_LOW>;
> > 
> > Isn't the interrupt signal connected to GP4_2 ?
> 
> No idea about Gose, but on Koelsch it is (hence koelsch DTS is wrong??)

I believe so. I don't have a Koelsch board anymore so I can't test that. 
Niklas, do you have a Koelsch on which you could confirm the IRQ number ?

-- 
Regards,

Laurent Pinchart

