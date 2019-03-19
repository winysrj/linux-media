Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787C6C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 08:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DF320854
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 08:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfCSIua (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 04:50:30 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45911 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfCSIua (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 04:50:30 -0400
X-Originating-IP: 90.88.22.102
Received: from aptenodytes (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 28796240013;
        Tue, 19 Mar 2019 08:50:24 +0000 (UTC)
Message-ID: <83d5db0b3e40cbd541ed8084d8a8052ce95887b7.camel@bootlin.com>
Subject: Re: [linux-sunxi] [PATCH 6/6] arm64: dts: allwinner: h6: Add Video
 Engine node
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     jernej.skrabec@siol.net, maxime.ripard@bootlin.com, wens@csie.org
Cc:     mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Date:   Tue, 19 Mar 2019 09:50:24 +0100
In-Reply-To: <20190128205504.11225-7-jernej.skrabec@siol.net>
References: <20190128205504.11225-1-jernej.skrabec@siol.net>
         <20190128205504.11225-7-jernej.skrabec@siol.net>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Le lundi 28 janvier 2019 à 21:55 +0100, Jernej Skrabec a écrit :
> This adds the Video engine node for H6. It can use whole DRAM range so
> there is no need for reserved memory node.

Looks like the patch adding SRAM support made it through but this one
didn't. It looks ready to be picked up though.

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> index 247dc0a5ce89..de4b7a1f1012 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
> @@ -146,6 +146,17 @@
>  			};
>  		};
>  
> +		video-codec@1c0e000 {
> +			compatible = "allwinner,sun50i-h6-video-engine";
> +			reg = <0x01c0e000 0x2000>;
> +			clocks = <&ccu CLK_BUS_VE>, <&ccu CLK_VE>,
> +				 <&ccu CLK_MBUS_VE>;
> +			clock-names = "ahb", "mod", "ram";
> +			resets = <&ccu RST_BUS_VE>;
> +			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
> +			allwinner,sram = <&ve_sram 1>;
> +		};
> +
>  		syscon: syscon@3000000 {
>  			compatible = "allwinner,sun50i-h6-system-control",
>  				     "allwinner,sun50i-a64-system-control";
> -- 
> 2.20.1
> 
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

