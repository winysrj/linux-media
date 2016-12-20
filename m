Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48284 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751701AbcLTNGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 08:06:18 -0500
Date: Tue, 20 Dec 2016 15:05:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robh@kernel.org>, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] media: et8ek8: add device tree binding documentation
Message-ID: <20161220130538.GD16630@valkosipuli.retiisi.org.uk>
References: <20161023191706.GA25754@amd>
 <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
 <20161107104648.GB5326@amd>
 <20161114183040.GB28778@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161114183040.GB28778@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Mon, Nov 14, 2016 at 07:30:40PM +0100, Pavel Machek wrote:
> Add device tree binding documentation for toshiba et8ek8 sensor.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> ---
> 
> v6: added missing article, fixed signal polarity.
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> new file mode 100644
> index 0000000..b03b21d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> @@ -0,0 +1,53 @@
> +Toshiba et8ek8 5MP sensor
> +
> +Toshiba et8ek8 5MP sensor is an image sensor found in Nokia N900 device
> +
> +More detailed documentation can be found in
> +Documentation/devicetree/bindings/media/video-interfaces.txt .
> +
> +
> +Mandatory properties
> +--------------------
> +
> +- compatible: "toshiba,et8ek8"
> +- reg: I2C address (0x3e, or an alternative address)
> +- vana-supply: Analogue voltage supply (VANA), 2.8 volts
> +- clocks: External clock to the sensor
> +- clock-frequency: Frequency of the external clock to the sensor. Camera
> +  driver will set this frequency on the external clock. The clock frequency is
> +  a pre-determined frequency known to be suitable to the board.
> +- reset-gpios: XSHUTDOWN GPIO. The XSHUTDOWN signal is active low. The sensor
> +  is in hardware standby mode when the signal is in the low state.
> +
> +
> +Endpoint node mandatory properties
> +----------------------------------
> +
> +- remote-endpoint: A phandle to the bus receiver's endpoint node.
> +
> +Endpoint node optional properties
> +----------------------------------
> +
> +- clock-lanes: <0>
> +- data-lanes: <1..n>

The driver makes no use of them and CCP2 only supports a single lane. I'll
just remove these and apply it to my tree. Let's continue discussing the
driver patch in the other thread.

> +
> +Example
> +-------
> +
> +&i2c3 {
> +	clock-frequency = <400000>;
> +
> +	cam1: camera@3e {
> +		compatible = "toshiba,et8ek8";
> +		reg = <0x3e>;
> +		vana-supply = <&vaux4>;
> +		clocks = <&isp 0>;
> +		clock-frequency = <9600000>;
> +		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
> +		port {
> +			csi_cam1: endpoint {
> +				remote-endpoint = <&csi_out1>;
> +			};
> +		};
> +	};
> +};
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
