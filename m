Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388104AbeGWPb1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 11:31:27 -0400
Date: Mon, 23 Jul 2018 17:29:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: mchehab@kernel.org, robh@kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: media: i2c: Document MT9V111 bindings
Message-ID: <20180723142955.fdbeenlz6fltww46@valkosipuli.retiisi.org.uk>
References: <1528730253-25135-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528730253-25135-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528730253-25135-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Mon, Jun 11, 2018 at 05:17:32PM +0200, Jacopo Mondi wrote:
> Add documentation for Aptina MT9V111 image sensor.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  .../bindings/media/i2c/aptina,mt9v111.txt          | 46 ++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
> new file mode 100644
> index 0000000..bac4bf0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
> @@ -0,0 +1,46 @@
> +* Aptina MT9V111 CMOS sensor
> +----------------------------
> +
> +The Aptina MT9V111 is a 1/4-Inch VGA-format digital image sensor with a core
> +based on Aptina MT9V011 sensor and an integrated Image Flow Processor (IFP).
> +
> +The sensor has an active pixel array of 649x489 pixels and can output a number

640x480 ?

> +of image resolution and formats controllable through a simple two-wires
> +interface.
> +
> +Required properties:
> +--------------------
> +
> +- compatible: shall be "aptina,mt9v111".
> +- clocks: reference to the system clock input provider.
> +
> +Optional properties:
> +--------------------
> +
> +- enable-gpios: output enable signal, pin name "OE#". Active low.
> +- standby-gpios: low power state control signal, pin name "STANDBY".
> +  Active high.
> +- reset-gpios: chip reset signal, pin name "RESET#". Active low.
> +
> +The device node must contain one 'port' child node with one 'endpoint' child
> +sub-node for its digital output video port, in accordance with the video
> +interface bindings defined in:
> +Documentation/devicetree/bindings/media/video-interfaces.txt
> +
> +Example:
> +--------
> +
> +        &i2c1 {
> +                camera@48 {
> +                        compatible = "aptina,mt9v111";
> +                        reg = <0x48>;
> +
> +                        clocks = <&camera_clk>;
> +
> +                        port {
> +                                mt9v111_out: endpoint {
> +                                        remote-endpoint = <&ceu_in>;
> +                                };
> +                        };
> +                };
> +        };

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
