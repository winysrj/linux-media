Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33535 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761718AbdAIScb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 13:32:31 -0500
Date: Mon, 9 Jan 2017 12:32:14 -0600
From: Rob Herring <robh@kernel.org>
To: sean.wang@mediatek.com
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, matthias.bgg@gmail.com,
        andi.shyti@samsung.com, hverkuil@xs4all.nl, sean@mess.org,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH 1/2] Documentation: devicetree: Add document bindings for
 mtk-cir
Message-ID: <20170109183214.xonv52sn3fo4exqp@rob-hp-laptop>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
 <1483632384-8107-2-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483632384-8107-2-git-send-email-sean.wang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 06, 2017 at 12:06:23AM +0800, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
> This patch adds documentation for devicetree bindings for
> Mediatek IR controller.
> 
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
>  .../devicetree/bindings/media/mtk-cir.txt          | 23 ++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 linux-4.8.rc1_p0/Documentation/devicetree/bindings/media/mtk-cir.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/mtk-cir.txt b/Documentation/devicetree/bindings/media/mtk-cir.txt
> new file mode 100644
> index 0000000..bbedd71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/mtk-cir.txt
> @@ -0,0 +1,23 @@
> +Device-Tree bindings for Mediatek IR controller found in Mediatek SoC family
> +
> +Required properties:
> +- compatible	    : "mediatek,mt7623-ir"
> +- clocks	    : list of clock specifiers, corresponding to
> +		      entries in clock-names property;
> +- clock-names	    : should contain "clk" entries;
> +- interrupts	    : should contain IR IRQ number;
> +- reg		    : should contain IO map address for IR.
> +
> +Optional properties:
> +- linux,rc-map-name : Remote control map name.

Would 'label' be appropriate here instead? If not, this needs to be 
documented in a common location and explained better.

> +
> +Example:
> +
> +cir: cir@0x10013000 {

Drop the '0x'.

> +	compatible = "mediatek,mt7623-ir";
> +	reg = <0 0x10013000 0 0x1000>;
> +	interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_LOW>;
> +	clocks = <&infracfg CLK_INFRA_IRRX>;
> +	clock-names = "clk";
> +	linux,rc-map-name = "rc-rc6-mce";
> +};
> -- 
> 1.9.1
> 
