Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:44066 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751551AbeABJTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 04:19:16 -0500
Date: Tue, 2 Jan 2018 10:19:10 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v2 2/4] [media] dt/bindings: Add bindings for OV5695
Message-ID: <20180102091910.GD4314@w540>
References: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
 <1514534905-21393-2-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1514534905-21393-2-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Shunqian,

On Fri, Dec 29, 2017 at 04:08:23PM +0800, Shunqian Zheng wrote:
> Add device tree binding documentation for the OV5695 sensor.
>
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5695.txt       | 38 ++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5695.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5695.txt b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
> new file mode 100644
> index 0000000..8d87dbc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5695.txt
> @@ -0,0 +1,38 @@
> +* Omnivision OV5695 MIPI CSI-2 sensor
> +
> +Required Properties:
> +- compatible: should be "ovti,ov5695"
> +- clocks: reference to the 24M xvclk input clock.
> +- clock-names: should be "xvclk".
> +- dovdd-supply: Digital I/O voltage supply, 1.8 volts
> +- avdd-supply: Analog voltage supply, 2.8 volts
> +- dvdd-supply: Digital core voltage supply, 1.2 volts
> +- reset-gpios: Low active reset gpio
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +&i2c1: camera-sensor@36 {

I think what Rob asked for in his v1 review was to have a
"camera-sensor" node which is a child of the "i2c1" interface node.

I would expect something like:

&i2c1 {
        pinctrl-names ...
        pinctrl-0...

        camera-sensor@36 {

                compatible = "ovti,ov5695";
                ...
        };
};

Thanks
   j
