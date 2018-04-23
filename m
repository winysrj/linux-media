Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44745 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754617AbeDWK3k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 06:29:40 -0400
Date: Mon, 23 Apr 2018 12:29:36 +0200
From: Simon Horman <horms@verge.net.au>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie,
        daniel@ffwll.ch, peda@axentia.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] arm64: dts: renesas: eagle: Add thc63 LVDS map
Message-ID: <20180423102936.cdll63ivb7ww5b7r@verge.net.au>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524130269-32688-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 19, 2018 at 11:31:05AM +0200, Jacopo Mondi wrote:
> Add LVDS map mode description property to THC63LVD1024 LVDS decoder in
> R-Car V3M-Eagle board device tree.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Hi Jacopo,

it looks like there has been a request to change this binding.
So I have marked this as "Changes Requested". Please repost or otherwise
ping me if that turns out not to be the case.

> ---
>  arch/arm64/boot/dts/renesas/r8a77970-eagle.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts b/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
> index ebfbb51..2609fa3 100644
> --- a/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
> +++ b/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
> @@ -56,6 +56,7 @@
>  		compatible = "thine,thc63lvd1024";
>  
>  		vcc-supply = <&d3p3>;
> +		thine,map = <1>;
>  
>  		ports {
>  			#address-cells = <1>;
> -- 
> 2.7.4
> 
