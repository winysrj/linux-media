Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53820 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754842AbeDWNGv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:06:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, peda@axentia.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] arm64: dts: renesas: eagle: Add thc63 LVDS map
Date: Mon, 23 Apr 2018 16:07:03 +0300
Message-ID: <1945499.PUjoDG4czU@avalon>
In-Reply-To: <1524130269-32688-5-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <1524130269-32688-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 19 April 2018 12:31:05 EEST Jacopo Mondi wrote:
> Add LVDS map mode description property to THC63LVD1024 LVDS decoder in
> R-Car V3M-Eagle board device tree.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  arch/arm64/boot/dts/renesas/r8a77970-eagle.dts | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts
> b/arch/arm64/boot/dts/renesas/r8a77970-eagle.dts index ebfbb51..2609fa3
> 100644
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


-- 
Regards,

Laurent Pinchart
