Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:33888 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdLZX1H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:27:07 -0500
Date: Tue, 26 Dec 2017 17:27:04 -0600
From: Rob Herring <robh@kernel.org>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH 2/4] [media] dt/bindings: Add bindings for OV5695
Message-ID: <20171226232704.2nqcy3v4l6yclsls@rob-hp-laptop>
References: <1514211086-13440-1-git-send-email-zhengsq@rock-chips.com>
 <1514211086-13440-2-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514211086-13440-2-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 25, 2017 at 10:11:24PM +0800, Shunqian Zheng wrote:
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
> index 0000000..ed27eb1
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
> +&i2c1 {

Presumably, i2c1 is your I2C controller, so you are missing a child node 
here: camera-sensor@36

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

> +	compatible = "ovti,ov5695";
> +	reg = <0x36>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&clk_24m_cam &wcam_rst>;
> +
> +	clocks = <&cru SCLK_TESTCLKOUT1>;
> +	clock-names = "xvclk";
> +
> +	avdd-supply = <&pp2800_cam>;
> +	dvdd-supply = <&pp1250_cam>;
> +	dovdd-supply = <&pp1800>;
> +
> +	reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>;
> +
> +	port {
> +		wcam_out: endpoint {
> +			remote-endpoint = <&mipi_in_wcam>;
> +			data-lanes = <1 2>;
> +		};
> +	};
> +};
> -- 
> 1.9.1
> 
