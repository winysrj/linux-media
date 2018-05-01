Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:43665 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755831AbeEAO2R (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2018 10:28:17 -0400
Date: Tue, 1 May 2018 09:28:16 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: media: i2c: Add mt9t111 image sensor
Message-ID: <20180501142816.GA15492@rob-hp-laptop>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654014-17852-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524654014-17852-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:00:13PM +0200, Jacopo Mondi wrote:
> Add device tree bindings documentation for Micron MT9T111/MT9T112 image
> sensors.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/mt9t112.txt | 41 +++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mt9t112.txt
> 
> diff --git a/Documentation/devicetree/bindings/mt9t112.txt b/Documentation/devicetree/bindings/mt9t112.txt
> new file mode 100644
> index 0000000..cbad475
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mt9t112.txt
> @@ -0,0 +1,41 @@
> +Micron 3.1Mp CMOS Digital Image Sensor
> +--------------------------------------
> +
> +The Micron MT9T111 and MT9T112 are 1/4 inch 3.1Mp System-On-A-Chip (SOC) CMOS
> +digital image sensors which support up to QXGA (2048x1536) image resolution in
> +4/3 format.
> +
> +The sensors can be programmed through a two-wire serial interface and can
> +work both in parallel data output mode as well as in MIPI CSI-2 mode.
> +
> +Required Properties:
> +- compatible: shall be one of the following values
> +  	"micron,mt9t111" for MT9T111 sensors
> +	"micron,mt9t112" for MT9T112 sensors
> +
> +Optional properties:
> +- powerdown-gpios: reference to powerdown input GPIO signal. Pin name "STANDBY".
> +  Active level is high.
> +
> +The device node shall contain one 'port' sub-node with one 'endpoint' child
> +node, modeled accordingly to bindings described in:
> +Documentation/devicetree/bindings/media/video-interfaces.txt
> +
> +Example:
> +--------
> +
> +	mt9t112@3d {

camera-sensor@3d

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>

> +		compatible = "micron,mt9t112";
> +		reg = <0x3d>;
> +
> +		powerdown-gpios = <&gpio4 2 GPIO_ACTIVE_HIGH>;
> +
> +		port {
> +			mt9t112_out: endpoint {
> +				pclk-sample = <1>;
> +				remote-endpoint = <&ceu_in>;
> +			};
> +		};
> +	};
> +
> +
> -- 
> 2.7.4
> 
