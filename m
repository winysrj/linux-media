Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C85C65BAF
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 09:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C54120865
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 09:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C54120865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbeLJJAz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 04:00:55 -0500
Received: from mail.bootlin.com ([62.4.15.54]:50889 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbeLJJAy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 04:00:54 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 6D51820CE8; Mon, 10 Dec 2018 10:00:52 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 57D8A20E31;
        Mon, 10 Dec 2018 10:00:34 +0100 (CET)
Message-ID: <c276fb045ab285c0907c4831f3b71a31f09cd4a5.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH v2 15/15] arm64: dts: allwinner: a64: Add
 Video Engine node
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@googlegroups.com
Cc:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date:   Mon, 10 Dec 2018 10:00:34 +0100
In-Reply-To: <2823800.C4zEU5jiS7@jernej-laptop>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
         <20181205092444.29497-16-paul.kocialkowski@bootlin.com>
         <2823800.C4zEU5jiS7@jernej-laptop>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Fri, 2018-12-07 at 22:22 +0100, Jernej Škrabec wrote:
> Hi!
> 
> Dne sreda, 05. december 2018 ob 10:24:44 CET je Paul Kocialkowski napisal(a):
> > This adds the Video Engine node for the A64. Since it can map the whole
> > DRAM range, there is no particular need for a reserved memory node
> > (unlike platforms preceding the A33).
> > 
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > ---
> >  arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi index
> > 8557d52c7c99..8d024c10d7cb 100644
> > --- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > +++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
> > @@ -397,6 +397,17 @@
> >  			};
> >  		};
> > 
> > +		video-codec@1c0e000 {
> > +			compatible = "allwinner,sun50i-h5-video-engine";
> 
> You meant A64 instead of H5, right?

Ah yes definitely, that's a mistake right here.

I'll send a follow-up patch for switching the compatible to describe
the a64 instead of the h5. In practice, having the a64 use the h5
compatible doesn't cause any issue, but it should be fixed
nevertheless.

Cheers,

Paul

> Best regards,
> Jernej
> 
> > +			reg = <0x01c0e000 0x1000>;
> > +			clocks = <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
> > +				 <&ccu CLK_DRAM_VE>;
> > +			clock-names = "ahb", "mod", "ram";
> > +			resets = <&ccu RST_BUS_VE>;
> > +			interrupts = <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
> > +			allwinner,sram = <&ve_sram 1>;
> > +		};
> > +
> >  		mmc0: mmc@1c0f000 {
> >  			compatible = "allwinner,sun50i-a64-mmc";
> >  			reg = <0x01c0f000 0x1000>;
> 
> 
> 
-- 
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

