Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47079 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdBSWM3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Feb 2017 17:12:29 -0500
Date: Sun, 19 Feb 2017 23:02:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v4 15/36] platform: add video-multiplexer subdevice driver
Message-ID: <20170219220237.GD32327@amd>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-16-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <1487211578-11360-16-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Philipp Zabel <p.zabel@pengutronix.de>
>=20
> This driver can handle SoC internal and external video bus multiplexers,
> controlled either by register bit fields or by a GPIO. The subdevice
> passes through frame interval and mbus configuration of the active input
> to the output side.
>=20
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> --
>

Again, this is slightly non-standard format. Normally changes from v1
go below ---, but in your case it would cut off the signoff...

> diff --git a/Documentation/devicetree/bindings/media/video-multiplexer.tx=
t b/Documentation/devicetree/bindings/media/video-multiplexer.txt
> new file mode 100644
> index 0000000..9d133d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/video-multiplexer.txt
> @@ -0,0 +1,59 @@
> +Video Multiplexer
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Video multiplexers allow to select between multiple input ports. Video r=
eceived
> +on the active input port is passed through to the output port. Muxes des=
cribed
> +by this binding may be controlled by a syscon register bitfield or by a =
GPIO.
> +
> +Required properties:
> +- compatible : should be "video-multiplexer"
> +- reg: should be register base of the register containing the control bi=
tfield
> +- bit-mask: bitmask of the control bitfield in the control register
> +- bit-shift: bit offset of the control bitfield in the control register
> +- gpios: alternatively to reg, bit-mask, and bit-shift, a single GPIO ph=
andle
> +  may be given to switch between two inputs
> +- #address-cells: should be <1>
> +- #size-cells: should be <0>
> +- port@*: at least three port nodes containing endpoints connecting to t=
he
> +  source and sink devices according to of_graph bindings. The last port =
is
> +  the output port, all others are inputs.

At least three? I guess it is exactly three with the gpio?

Plus you might want to describe which port correspond to which gpio
state/bitfield values...

> +struct vidsw {

I knew it: it is secretely a switch! :-).

> +static void vidsw_set_active(struct vidsw *vidsw, int active)
> +{
> +	vidsw->active =3D active;
> +	if (active < 0)
> +		return;
> +
> +	dev_dbg(vidsw->subdev.dev, "setting %d active\n", active);
> +
> +	if (vidsw->field)
> +		regmap_field_write(vidsw->field, active);
> +	else if (vidsw->gpio)
> +		gpiod_set_value(vidsw->gpio, active);

         else dev_err()...?
	=20
> +static int vidsw_async_init(struct vidsw *vidsw, struct device_node *nod=
e)
> +{
> +	struct device_node *ep;
> +	u32 portno;
> +	int numports;

numbports is int, so I guess portno should be, too?

> +		portno =3D endpoint.base.port;
> +		if (portno >=3D numports - 1)
> +			continue;


> +	if (!pad) {
> +		/* Mirror the input side on the output side */
> +		cfg->type =3D vidsw->endpoint[vidsw->active].bus_type;
> +		if (cfg->type =3D=3D V4L2_MBUS_PARALLEL ||
> +		    cfg->type =3D=3D V4L2_MBUS_BT656)
> +			cfg->flags =3D vidsw->endpoint[vidsw->active].bus.parallel.flags;
> +	}

Will this need support for other V4L2_MBUS_ values?

> +MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> +MODULE_AUTHOR("Philipp Zabel, Pengutronix");

Normally, MODULE_AUTHOR contains comma separated names of authors,
perhaps with <email@addresses>. Not sure two MODULE_AUTHORs per file
will work.

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliqFf0ACgkQMOfwapXb+vLlWgCfW2USB7xbrACrPywn2fBqw1Py
5K8AoK0xQ5eBKNcm4zkZmogfE9+YF3xM
=3IO0
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
