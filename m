Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34526 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752467AbeABOZP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 09:25:15 -0500
Date: Tue, 2 Jan 2018 16:25:12 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v2 2/4] [media] dt/bindings: Add bindings for OV5695
Message-ID: <20180102142512.plf55ngluhbumhh6@valkosipuli.retiisi.org.uk>
References: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
 <1514534905-21393-2-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514534905-21393-2-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

Thanks for the patchset.

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

s/should/shall/

> +- clocks: reference to the 24M xvclk input clock.

I presume 24 MHz may be currently assumed by the driver but it's not a
property of the sensor. You should therefore check the frequency in the
driver instead.

> +- clock-names: should be "xvclk".
> +- dovdd-supply: Digital I/O voltage supply, 1.8 volts
> +- avdd-supply: Analog voltage supply, 2.8 volts
> +- dvdd-supply: Digital core voltage supply, 1.2 volts
> +- reset-gpios: Low active reset gpio
> +
> +The device node must contain one 'port' child node for its digital output

s/must/shall/

Please add that it shall also contain one endpoint node.

> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.

Which properties are mandatory? You may leave out remote-endpoint as it's
already required by the video interface bindings --- the rest are hardware
specific in a way or another.

> +
> +Example:
> +&i2c1: camera-sensor@36 {
> +	compatible = "ovti,ov5695";
> +	reg = <0x36>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&clk_24m_cam>;
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

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
