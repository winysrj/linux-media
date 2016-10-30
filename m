Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36480 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755486AbcJ3Ulg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Oct 2016 16:41:36 -0400
Date: Sun, 30 Oct 2016 15:41:34 -0500
From: Rob Herring <robh@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: et8ek8: add device tree binding documentation
Message-ID: <20161030204134.hpmfrnqhd4mg563o@rob-hp-laptop>
References: <20161023191706.GA25754@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161023191706.GA25754@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 23, 2016 at 09:17:06PM +0200, Pavel Machek wrote:
> 
> Add device tree binding documentation for toshiba et8ek8 sensor.
> 
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> ---
> 
> diff from v3: explain what clock-frequency means
> 
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> new file mode 100644
> index 0000000..54863cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
> @@ -0,0 +1,51 @@
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
> +  driver will set this frequency on the external clock.

This is fine if the frequency is fixed (e.g. an oscillator), but you 
should use the clock binding if clocks are programable.

> +- reset-gpios: XSHUTDOWN GPIO

Please state what the active polarity is.

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
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


