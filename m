Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46385 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932324AbeGDI6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 04:58:14 -0400
Date: Wed, 4 Jul 2018 10:58:01 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v7 1/2] media: ov2680: dt: Add bindings for OV2680
Message-ID: <20180704085801.GB4463@w540>
References: <20180703140803.19580-1-rui.silva@linaro.org>
 <20180703140803.19580-2-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Content-Disposition: inline
In-Reply-To: <20180703140803.19580-2-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Rui,
   sorry, I'm a bit late, you're already at v7 and I don't want to
slow down inclusion with a few minor comments.

Please bear with me and see below...

On Tue, Jul 03, 2018 at 03:08:02PM +0100, Rui Miguel Silva wrote:
> Add device tree binding documentation for the OV2680 camera sensor.
>
> CC: devicetree@vger.kernel.org
> Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
> ---
>  .../devicetree/bindings/media/i2c/ov2680.txt  | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov2680.txt b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
> new file mode 100644
> index 000000000000..11e925ed9dad
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
> @@ -0,0 +1,46 @@
> +* Omnivision OV2680 MIPI CSI-2 sensor
> +
> +Required Properties:
> +- compatible: should be "ovti,ov2680".
> +- clocks: reference to the xvclk input clock.
> +- clock-names: should be "xvclk".

Having a single clock source I think you can omit 'clock-names' (or at
least not marking it as required)

> +- DOVDD-supply: Digital I/O voltage supply.
> +- DVDD-supply: Digital core voltage supply.
> +- AVDD-supply: Analog voltage supply.
> +
> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the powerdown/reset pin,
> +               if any. This is an active low signal to the OV2680.
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, and this port must have a single endpoint in accordance with
> + the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Endpoint node required properties for CSI-2 connection are:
> +- remote-endpoint: a phandle to the bus receiver's endpoint node.
> +- clock-lanes: should be set to <0> (clock lane on hardware lane 0).
> +- data-lanes: should be set to <1> (one CSI-2 lane supported).

What is the value of marking as required two properties which can only have
default values (the sensor does not support clock on different lanes,
nor it supports more than 1 data lane) ?

Thanks
   j

> +
> +Example:
> +
> +&i2c2 {
> +	ov2680: camera-sensor@36 {
> +		compatible = "ovti,ov2680";
> +		reg = <0x36>;
> +		clocks = <&osc>;
> +		clock-names = "xvclk";
> +		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
> +		DOVDD-supply = <&sw2_reg>;
> +		DVDD-supply = <&sw2_reg>;
> +		AVDD-supply = <&reg_peri_3p15v>;
> +
> +		port {
> +			ov2680_to_mipi: endpoint {
> +				remote-endpoint = <&mipi_from_sensor>;
> +				clock-lanes = <0>;
> +				data-lanes = <1>;
> +			};
> +		};
> +	};
> +};
> --
> 2.18.0
>

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbPIwZAAoJEHI0Bo8WoVY8cW0P/A5VWYmSRtq6HWtcFtySW8fL
geGFy0z7nTTNYUdpn8KnBOXv5bSS8DiPjwstaQFTo+v1qmehXIXYQgVmZ156QKrQ
r+eZ2BQddst3DLd1heUeYPoGqbwu53q8VtifxNfQ1d+YRUUE/pkvKH7s9EQTEF83
jVY8cv29CvECD+hWZ3wmAQ3wuioy5fc0bhAdsO1nts0E1/vIjh87sU5Hm3DmKWtv
hxhePs52RAyvAaHjM3UyYsWFnZX7LIL2tLd9NlczZQzpk5DjaKPDpQ1OCJYiGeoS
7GdraPC4AY77rW9RLBKVZpOkE9nLz8PIKR5BvdvN8S3/xlP6cP275yxhKIPtSXF8
YQnPhv2cUOl3uBR7TdyAkFWTNggdF9mfYboGCI0s21oeT0JG9oHS7RVbWBq9x2Em
Bw0nyHT2A05qZPh7vr3v6tdLYTpBkCSPQxx6Kzw+9/A4pB9GXxo9D4H9dfyjmOyK
SOpi9b4jZG16qJoKqYeKLjAVsD9MAkWEOSb8ZQ5cDuMB3m4zKO/1oYBwONqmAVEy
F+kYDp+Uzie0Rly6QfZPPx2oZxLpxFlPoYoFbUrFDNdLGdCgkechXmbONjSSwwbi
1panC32Jn3WveJxVwt96NdwmymXZt8jdDKTH2WG3DMBTY4mzoylG5dAnji20dC/Y
4G7tk+BJXZBzAqzVTZF8
=cvhq
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
