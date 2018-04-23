Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:52366 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754710AbeDWMCs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:02:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, peda@axentia.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] dt-bindings: display: bridge: thc63lvd1024: Add lvds map property
Date: Mon, 23 Apr 2018 15:02:59 +0300
Message-ID: <2645564.GDIDDgbfar@avalon>
In-Reply-To: <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 19 April 2018 12:31:03 EEST Jacopo Mondi wrote:
> The THC63LVD1024 LVDS to RGB bridge supports two different input mapping
> modes, selectable by means of an external pin.
> 
> Describe the LVDS mode map through a newly defined mandatory property in
> device tree bindings.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/display/bridge/thine,thc63lvd1024.txt          | 3
> +++ 1 file changed, 3 insertions(+)
> 
> diff --git
> a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> index 37f0c04..0937595 100644
> ---
> a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> +++
> b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> @@ -12,6 +12,8 @@ Required properties:
>  - compatible: Shall be "thine,thc63lvd1024"
>  - vcc-supply: Power supply for TTL output, TTL CLOCKOUT signal, LVDS input,
> PPL and digital circuitry
> +- thine,map: LVDS mapping mode selection signal, pin name "MAP". Shall be
> <1>
> +  for mapping mode 1, <0> for mapping mode 2

That's sounds like an odd mapping. I suppose you have modeled it based on the 
state of the MAP pin instead of the mode number (MAP low means mode 2, MAP 
high means mode 1). To avoid confusing readers I would write it as

- thine,map: level of the MAP pin that selects the LVDS mapping mode. Shall be
  <0> for low level (mapping mode 2) or <1> for high level (mapping mode 1).

Apart from that this patch looks good to me.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  Optional properties:
>  - powerdown-gpios: Power down GPIO signal, pin name "/PDWN". Active low
> @@ -36,6 +38,7 @@ Example:
> 
>  		vcc-supply = <&reg_lvds_vcc>;
>  		powerdown-gpios = <&gpio4 15 GPIO_ACTIVE_LOW>;
> +		thine,map = <1>;
> 
>  		ports {
>  			#address-cells = <1>;

-- 
Regards,

Laurent Pinchart
