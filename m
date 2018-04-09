Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46027 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeDIJHA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 05:07:00 -0400
Date: Mon, 9 Apr 2018 11:06:51 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 5/6] media: ov772x: add device tree binding
Message-ID: <20180409090649.GX20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-6-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ViWwB84N1zFtNiVD"
Content-Disposition: inline
In-Reply-To: <1523116090-13101-6-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ViWwB84N1zFtNiVD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Akinobu,

On Sun, Apr 08, 2018 at 12:48:09AM +0900, Akinobu Mita wrote:
> This adds a device tree binding documentation for OV7720/OV7725 sensor.

Please use as patch subject
media: dt-bindings:

>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  .../devicetree/bindings/media/i2c/ov772x.txt       | 36 ++++++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> new file mode 100644
> index 0000000..9b0df3b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> @@ -0,0 +1,36 @@
> +* Omnivision OV7720/OV7725 CMOS sensor
> +

Could you please provide a brief description of the sensor (supported
resolution and formats is ok)

> +Required Properties:
> +- compatible: shall be one of
> +	"ovti,ov7720"
> +	"ovti,ov7725"
> +- clocks: reference to the xclk input clock.
> +- clock-names: shall be "xclk".
> +
> +Optional Properties:
> +- rstb-gpios: reference to the GPIO connected to the RSTB pin, if any.
> +- pwdn-gpios: reference to the GPIO connected to the PWDN pin, if any.

As a general note:
This is debated, and I'm not enforcing it, but please consider using
generic names for GPIOs with common functions. In this case
"reset-gpios" and "powerdown-gpios". Also please indicate the GPIO
active level in bindings description.

For this specific driver:
The probe routine already looks for a GPIO named 'pwdn', so I guess
the DT bindings should use the same name. Unless you're willing to
change it in the board files that register it (Migo-R only in mainline) and
use the generic 'powerdown' name for both. Either is fine with me.

There is no support for the reset GPIO in the driver code, it
supports soft reset only. Either ditch it from bindings or add support
for it in driver's code.

Thanks
   j

> +
> +The device node shall contain one 'port' child node with one child 'endpoint'
> +subnode for its digital output video port, in accordance with the video
> +interface bindings defined in Documentation/devicetree/bindings/media/
> +video-interfaces.txt.
> +
> +Example:
> +
> +&i2c0 {
> +	ov772x: camera@21 {
> +		compatible = "ovti,ov7725";
> +		reg = <0x21>;
> +		rstb-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_LOW>;
> +		pwdn-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_LOW>;
> +		clocks = <&xclk>;
> +		clock-names = "xclk";
> +
> +		port {
> +			ov772x_0: endpoint {
> +				remote-endpoint = <&vcap1_in0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e48624..3e0224a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10295,6 +10295,7 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Odd fixes
>  F:	drivers/media/i2c/ov772x.c
>  F:	include/media/i2c/ov772x.h
> +F:	Documentation/devicetree/bindings/media/i2c/ov772x.txt
>
>  OMNIVISION OV7740 SENSOR DRIVER
>  M:	Wenyou Yang <wenyou.yang@microchip.com>
> --
> 2.7.4
>

--ViWwB84N1zFtNiVD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJayy0rAAoJEHI0Bo8WoVY8wAAQALdRQ1Az6yLPh9NVNECc3BAa
23kmns2OPY9FGIfGaPp3Y4Gl7szly1FTEWZxQMglnhw92/nbHNXthcX2gArRXKuv
zyHTlJyPckaKFrCRrUOn4OE6u9cm2fSl4Mebf/Cap5Z8zAyNlzdjtfVy0Y8x6oaN
K7s91iC0L5jt9CtzZvtdOw/wmNMe8SOWGZPDQ5M2Rf9coRkPrhbIdGOS+otczGjE
QMmwD3Tz4ZkLQn2sz4+kxX3Dfb43nbW68h/V/XPTei7Q47vvQsidHSrjhZ/7YZRM
FQBTvj6lJZqSBRHqVpfGOQyLGENZ3BaPa6C0IZdTpickmdIiLdkr16hm2TTTFQK5
H68Y3p9t+4dv4hd6z5AUu6zSW2pjf9zZ4MsuujpcyZdsn9A8b4Qo/xKsxQwGmy+X
UOu7quiwKrdSsYdCu17rEwpm+OiUeWG4YYE9cOj+7C7vyRmzKZDbWnqe0jL/x4+n
vNafVn3hWZqmX6wKoLVslbEAi6sQp5XEPDgMhYllQPwvkP1zJBGtr9x5o4q7N3vi
Mr5XcGOWsq7CzPuBwsvsSG5oUFvJSJGsrSrkHvMRicTGAWU2VnwoJlxmYiEOOHYC
sat8BHUH8a9mHa8NyhSU9Lknj8g4XW3JNBdatpbLvc3G5jeLOnYZ3WvWrZI08pYX
Q4eTO7wrA3UKBwBtJYNy
=ZhpB
-----END PGP SIGNATURE-----

--ViWwB84N1zFtNiVD--
