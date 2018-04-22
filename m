Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve1eur01on0120.outbound.protection.outlook.com ([104.47.1.120]:22976
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753438AbeDVUC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 16:02:56 -0400
Subject: Re: [PATCH 2/8] dt-bindings: display: bridge: thc63lvd1024: Add lvds
 map property
To: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie
Cc: daniel@ffwll.ch, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
From: Peter Rosin <peda@axentia.se>
Message-ID: <17d6f6b0-e657-4a5f-63a6-572cdf062bd3@axentia.se>
Date: Sun, 22 Apr 2018 22:02:41 +0200
MIME-Version: 1.0
In-Reply-To: <1524130269-32688-3-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-04-19 11:31, Jacopo Mondi wrote:
> The THC63LVD1024 LVDS to RGB bridge supports two different input mapping
> modes, selectable by means of an external pin.
> 
> Describe the LVDS mode map through a newly defined mandatory property in
> device tree bindings.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../devicetree/bindings/display/bridge/thine,thc63lvd1024.txt          | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> index 37f0c04..0937595 100644
> --- a/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/thine,thc63lvd1024.txt
> @@ -12,6 +12,8 @@ Required properties:
>  - compatible: Shall be "thine,thc63lvd1024"
>  - vcc-supply: Power supply for TTL output, TTL CLOCKOUT signal, LVDS input,
>    PPL and digital circuitry
> +- thine,map: LVDS mapping mode selection signal, pin name "MAP". Shall be <1>
> +  for mapping mode 1, <0> for mapping mode 2

Since the MAP pin is an input pin, I would expect there to be an optional gpio
specifier like thine,map-gpios so that the driver can set it according to
the value given in thine,map in case the HW has a line from some gpio output
to the MAP pin (instead of hardwired hi/low which seem to be your thinking).

Cheers,
Peter

>  
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
> 
