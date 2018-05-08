Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35652 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754099AbeEHQG4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 12:06:56 -0400
Date: Tue, 8 May 2018 11:06:54 -0500
From: Rob Herring <robh@kernel.org>
To: Jan Luebbe <jlu@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] media: dt-bindings: add binding for TI SCAN921226H
 video deserializer
Message-ID: <20180508160654.GA5752@rob-hp-laptop>
References: <20180504124903.6276-1-jlu@pengutronix.de>
 <20180504124903.6276-2-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504124903.6276-2-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 02:49:02PM +0200, Jan Luebbe wrote:
> This deserializer can be used with sensors that directly produce a
> 10-bit LVDS stream and converts it to a parallel bus.
> 
> Controlling it via the optional GPIOs is mainly useful for avoiding
> conflicts when another parallel sensor is connected to the same data bus
> as the deserializer.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> ---
>  .../bindings/media/ti,scan921226h.txt         | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/ti,scan921226h.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/ti,scan921226h.txt b/Documentation/devicetree/bindings/media/ti,scan921226h.txt
> new file mode 100644
> index 000000000000..4e475672d7bf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/ti,scan921226h.txt
> @@ -0,0 +1,59 @@
> +TI SCAN921226H Video Deserializer
> +---------------------------------
> +
> +The SCAN921226H receives a LVDS serial data stream with embedded clock and
> +converts it to a 10-bit wide parallel data bus and recovers parallel clock.
> +Some CMOS sensors such as the ON Semiconductor MT9V024 produce a LVDS signal
> +compatible with this deserializer.
> +
> +Required properties:
> +- compatible : should be "ti,scan921226h"
> +- #address-cells: should be <1>
> +- #size-cells: should be <0>
> +- port@0: serial (LVDS) input
> +- port@1: parallel output
> +
> +The device node should contain two 'port' child nodes (one each for input and
> +output), in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Optional Properties:
> +- enable-gpios: reference to the GPIO connected to the REN (output enable) pin,
> +  if any.
> +- npwrdn-gpios: reference to the GPIO connected to the nPWRDN pin, if any.

Use the standard powerdown-gpios here.

Both should state the active level.

> +
> +Optionally, #address-cells, #size-cells, and port nodes can be grouped under a
> +ports node as described in Documentation/devicetree/bindings/graph.txt.
> +
> +Example:
> +
> +      csi0_deserializer: csi0_deserializer {

Don't use '_' in node names.

> +              compatible = "ti,scan921226h";
> +
> +              enable-gpios = <&gpio5 20 GPIO_ACTIVE_HIGH>;
> +              npwrdn-gpios = <&gpio1 24 GPIO_ACTIVE_HIGH>;
> +
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              /* serial sink interface */
> +              port@0 {
> +                      reg = <0>;
> +
> +                      des0_in: endpoint {
> +                              remote-endpoint = <&mt9v024_0_out>;
> +                      };
> +              };
> +
> +              /* parallel source interface */
> +              port@1 {
> +                      reg = <1>;
> +
> +                      des0_out: endpoint {
> +                              remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
> +                              bus-width = <8>;
> +                              hsync-active = <1>;
> +                              vsync-active = <1>;
> +                      };
> +              };
> +      };
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
