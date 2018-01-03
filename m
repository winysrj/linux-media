Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47450 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752198AbeACMOW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 07:14:22 -0500
Date: Wed, 3 Jan 2018 14:14:19 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shunqian Zheng <zhengsq@rock-chips.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
Subject: Re: [PATCH v2 4/4] [media] dt/bindings: Add bindings for OV2685
Message-ID: <20180103121418.r6bysio3cfbl24gn@valkosipuli.retiisi.org.uk>
References: <1514534905-21393-1-git-send-email-zhengsq@rock-chips.com>
 <1514534905-21393-4-git-send-email-zhengsq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514534905-21393-4-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shunqian,

On Fri, Dec 29, 2017 at 04:08:25PM +0800, Shunqian Zheng wrote:
> Add device tree binding documentation for the OV2685 sensor.

DT bindings should precede the driver. Speaking of which --- you should add
an entry in the MAINTAINERS file for both.

> 
> Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
> ---
>  .../devicetree/bindings/media/i2c/ov2685.txt       | 35 ++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2685.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2685.txt b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
> new file mode 100644
> index 0000000..85aec03
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2685.txt
> @@ -0,0 +1,35 @@
> +* Omnivision OV2685 MIPI CSI-2 sensor
> +
> +Required Properties:
> +- compatible: should be "ovti,ov2685"
> +- clocks: reference to the 24M xvclk input clock.
> +- clock-names: should be "xvclk".
> +- avdd-supply: Analog voltage supply, 2.8 volts
> +- dvdd-supply: Digital core voltage supply, 1.2 volts
> +- reset-gpios: Low active reset gpio
> +
> +The device node must contain one 'port' child node for its digital output

s/must/shall/

Please add that the port shall contain one endpoint node as well.

> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.

Which specific properties are required and which ones are optional?

> +
> +Example:
> +	ucam: camera-sensor@3c {
> +		compatible = "ovti,ov2685";
> +		reg = <0x3c>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&clk_24m_cam>;
> +
> +		clocks = <&cru SCLK_TESTCLKOUT1>;
> +		clock-names = "xvclk";
> +
> +		avdd-supply = <&pp2800_cam>;
> +		dovdd-supply = <&pp1800>;
> +		reset-gpios = <&gpio2 3 GPIO_ACTIVE_LOW>;
> +
> +		port {
> +			ucam_out: endpoint {
> +				remote-endpoint = <&mipi_in_ucam>;
> +				data-lanes = <1>;
> +			};
> +		};
> +	};

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
