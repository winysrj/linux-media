Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54207 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753110AbeDRLfL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 07:35:11 -0400
Date: Wed, 18 Apr 2018 13:35:06 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v2 06/10] media: dt-bindings: ov772x: add device tree
 binding
Message-ID: <20180418113506.GC20486@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-7-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <1523847111-12986-7-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Apr 16, 2018 at 11:51:47AM +0900, Akinobu Mita wrote:
> This adds a device tree binding documentation for OV7720/OV7725 sensor.
>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

> ---
> * v2
> - Add "dt-bindings:" in the subject
> - Add a brief description of the sensor
> - Update the GPIO names
> - Indicate the GPIO active level
>
>  .../devicetree/bindings/media/i2c/ov772x.txt       | 42 ++++++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 43 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov772x.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov772x.txt b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> new file mode 100644
> index 0000000..b045503
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov772x.txt
> @@ -0,0 +1,42 @@
> +* Omnivision OV7720/OV7725 CMOS sensor
> +
> +The Omnivision OV7720/OV7725 sensor supports multiple resolutions output,
> +such as VGA, QVGA, and any size scaling down from CIF to 40x30. It also can
> +support the YUV422, RGB565/555/444, GRB422 or raw RGB output formats.
> +
> +Required Properties:
> +- compatible: shall be one of
> +	"ovti,ov7720"
> +	"ovti,ov7725"
> +- clocks: reference to the xclk input clock.
> +- clock-names: shall be "xclk".
> +
> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the RSTB pin which is
> +  active low, if any.
> +- powerdown-gpios: reference to the GPIO connected to the PWDN pin which is
> +  active high, if any.
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
> +		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_LOW>;
> +		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_LOW>;
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
> index 0a1410d..f500953 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10344,6 +10344,7 @@ T:	git git://linuxtv.org/media_tree.git
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

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa1y1qAAoJEHI0Bo8WoVY8fTQP/3qehJ4DtCUGgBEYI+UbCd9i
j8KevMhWELsWg5Lg39126hOARl5U7+2e+PBz5t6lTyU62/if5/jSKhMf8lqx+Bdj
T/lE0FV8wNUuq0BHaobXUQz5qgnIlTVxQKc/xWbw6w2+pAB/NDGTsrQW05auSOOJ
HbM2/jySofY/1ZbDCsB0oQsJ9j3byLJAjTlDf07cax4zNwprwpACjZR3+zSN12sB
gU2SaY8N7xrg+efji86mnGZ3K41rB6qMIsBnn/++NWNKD4UWISKjW74j4qZRfKQ1
hSf41QphH9SqPqXPqt5yZSiMfXyRjUKce1rVGtRsbZGLQXm7VdBDLuZcU+6NLlHL
xy3ciF3xo1oJM/bzZBuHQvUOzN6/+wpk9O15O2EjZxDcCk88XiQlEDurRTaUtU1c
ly/AHTxAHviIHk6H1gI1IgGE7ikskL12K6SRLtP06K3TFW/YwhM6MwWUtaC+0aYs
eol6gcR4YCHcSZGJwgUL/EEjg+g2Xnaf6ECSOA52lqKURFk/DYXR7ucbBk3MW5M5
Ng1wOx5kr8fAbKOa3nNPcNkaPP8Td8pddLa4Wr6PJ9w6LAmnPn0l/da9xRuezbCp
nISgq2AUkma4OUNalsYnbHkyTnAZKrjrkawuxjm+uC0jWE7Yo+mYluXq40BeKcF3
6YSoWXpxEQyVjlireBHW
=oq2T
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
