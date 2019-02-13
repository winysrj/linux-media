Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE341C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 17:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9BBE2075C
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 17:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbfBMR5T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 12:57:19 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46187 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfBMR5T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 12:57:19 -0500
X-Originating-IP: 2.224.242.101
Received: from uno.localdomain (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 9296DC0006;
        Wed, 13 Feb 2019 17:57:14 +0000 (UTC)
Date:   Wed, 13 Feb 2019 18:57:33 +0100
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190213175648.l3x2zeych4qj7km7@uno.localdomain>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3oollfukbtvf3f2v"
Content-Disposition: inline
In-Reply-To: <20181218141240.3056-2-m.felsch@pengutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org


--3oollfukbtvf3f2v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marco,
    thanks for the patch.

I have some comments, which I hope might get the ball rolling...

On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> Add corresponding dt-bindings for the Toshiba tc358746 device.
>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> ---
>  .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,t=
c358746.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746=
=2Etxt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> new file mode 100644
> index 000000000000..499733df744a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> @@ -0,0 +1,80 @@
> +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel =
Bridge
> +
> +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to M=
IPI CSI-2 TX

nit:
s/is a bridge that/is a bridge device that/
or drop is a bridge completely?

> +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable throug=
h I2C.

=46rom the thin public available datasheet, it seems to support SPI as
programming interface, but only when doing Parallel->CSI-2. I would
mention that.

> +
> +Required Properties:
> +
> +- compatible: should be "toshiba,tc358746"
> +- reg: should be <0x0e>

nit: s/should/shall

> +- clocks: should contain a phandle link to the reference clock source

just "phandle to the reference clock source" ?

> +- clock-names: the clock input is named "refclk".

According to the clock bindings this is optional, and since you have
a single clock I would drop it.

> +
> +Optional Properties:
> +
> +- reset-gpios: gpio phandle GPIO connected to the reset pin

would you drop one of the two "gpio" here. Like ": phandle to the GPIO
connected to the reset input pin"

> +
> +Parallel Endpoint:

Here I got confused. The chip supports 2 inputs (parallel and CSI-2)
and two outputs (parallel and CSI-2 again). You mention endpoints
propery only here, but it seems from the example you want two ports,
with one endpoint child-node each.

Even if the driver does not support CSI-2->Parallel at the moment,
bindings should be future-proof, so I would reserve the first two
ports for the inputs, and the last two for the output, or, considering
that the two input-output combinations are mutually exclusive, provide
one "input" port with two optional endpoints, and one "output" port with
two optional endpoints.

In both cases only one input and one output at the time could be
described in DT. Up to you, maybe others have different ideas as
well...

> +
> +Required Properties:
> +
> +- reg: should be <0>
> +- bus-width: the data bus width e.g. <8> for eight bit bus, or <16>
> +	     for sixteen bit wide bus.

The chip seems to support up to 24 bits of data bus width

> +
> +MIPI CSI-2 Endpoint:
> +
> +Required Properties:
> +
> +- reg: should be <1>
> +- data-lanes: should be <1 2 3 4> for four-lane operation,
> +	      or <1 2> for two-lane operation
> +- clock-lanes: should be <0>

Can this be changed? If the chip does not allow lane re-ordering you
could drop this.

> +- link-frequencies: List of allowed link frequencies in Hz. Each frequen=
cy is
> +		    expressed as a 64-bit big-endian integer. The frequency
> +		    is half of the bps per lane due to DDR transmission.

Does the chip supports a limited set of bus frequencies, or are this
"hints" ? I admit this property actually puzzles me, so I might got it
wrong..

Thanks
   j

> +
> +Optional Properties:
> +
> +- clock-noncontinuous: Presence of this boolean property decides whether=
 the
> +		       MIPI CSI-2 clock is continuous or non-continuous.
> +
> +For further information on the endpoint node properties, see
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +&i2c {
> +	tc358746: tc358746@0e {
> +		reg =3D <0x0e>;
> +		compatible =3D "toshiba,tc358746";
> +		pinctrl-names =3D "default";
> +		clocks =3D <&clk_cam_ref>;
> +		clock-names =3D "refclk";
> +		reset-gpios =3D <&gpio3 2 GPIO_ACTIVE_LOW>;
> +
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		port@0 {
> +			reg =3D <0>;
> +
> +			tc358746_parallel_in: endpoint {
> +				bus-width =3D <8>;
> +				remote-endpoint =3D <&micron_parallel_out>;
> +			};
> +		};
> +
> +		port@1 {
> +			reg =3D <1>;
> +
> +			tc358746_mipi2_out: endpoint {
> +				remote-endpoint =3D <&mipi_csi2_in>;
> +				data-lanes =3D <1 2>;
> +				clock-lanes =3D <0>;
> +				clock-noncontinuous;
> +				link-frequencies =3D /bits/ 64 <216000000>;
> +			};
> +		};
> +	};
> +};
> --
> 2.19.1
>

--3oollfukbtvf3f2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAlxkWo0ACgkQcjQGjxah
VjyBshAAn69sZKIcuxVmBLm426ATkBswl82ihT8sbuoOZnHOMaI74lmhy4VcJIBn
uWOY6WTmmg/1QI2LuuiOrIv5lo3A8s5tGdrNBOhDh6Nvh7e4OrK1FfmVe4SnQKn1
d8h9RACxH5EG2cv7YWTzP3ceesbBarRovE2nHM0vDklAavIsvQ2cTgiBbMF97LaD
sDYlkWz75QMaIyluRyPrSz6bf+Ytr5zMottogC/alfU20C7cpu/pHJR1rTmPE7Gp
P++0/X0ODu01p5d2GtGFwbLfOdlgp/BiFtkieLHvej2W8Cb4OGYxU+AX4OLVpuP0
liZ10viO70FxLXKpT8D30RtcZqnoSHQsdFpuCzh6aBbenp8nXAEOpL+3Ol5qnM9s
slWmjfA0HAGuRq29RtlekhaoWW/oX/5v+7Zi+YEw++T+HMSwvh8jSjKayNp0wgjI
xcHVpUd6+2pcSvn6VH7NhSOAj9SpYVnXd5OWGkHFMUaKqGkTU9oTA+FpA8oBjpCa
jLJ4jVwuwi5rvwG4826iEj1Hk6uie+ocz68mJTCH+9sS5wQ6C+Psgbkgct6SznA9
25LNJaDXjbdpPE+K4BS9AtalNog4cuIjvLeLbDT2kdj+DmtrPnWZFhCU54bEGhYd
cHT/FFdoXXHY0MVfxgl01s7YLwDEUYrocwDkSzRvnWe7ONcKVgQ=
=7Jx7
-----END PGP SIGNATURE-----

--3oollfukbtvf3f2v--
