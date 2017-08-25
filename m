Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43495 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754759AbdHYOaj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 10:30:39 -0400
Date: Fri, 25 Aug 2017 16:30:28 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20170825143028.dh2cgfvfde6w567n@flea.lan>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
 <20170720092302.2982-3-maxime.ripard@free-electrons.com>
 <5380447.UyHVojvDsx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u5nte5v5onvnlzvn"
Content-Disposition: inline
In-Reply-To: <5380447.UyHVojvDsx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u5nte5v5onvnlzvn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

I've removed the comments I'll take into account

On Mon, Aug 07, 2017 at 11:42:01PM +0300, Laurent Pinchart wrote:
> > +	csi2rx_reset(csi2rx);
> > +
> > +	// TODO: modify the mapping of the DPHY lanes?
>=20
> The mapping should be read from DT and applied here.

As far as I understand it, this is a mapping between logical and
physical lanes before forwarding it to the D-PHY. Would data-lanes
apply for such a case?

> > +static int csi2rx_s_stream(struct v4l2_subdev *sd, int enable)
> > +{
> > +	struct csi2rx_priv *csi2rx =3D v4l2_subdev_to_csi2rx(sd);
> > +
> > +	v4l2_subdev_call(csi2rx->sensor_subdev, video, s_stream,
> > +			 enable);
>=20
> Shouldn't you handle errors here ?

Yes.

> I'm not familiar with this IP core, but most D-PHYs need to synchronize t=
o the=20
> input and must be started before the source.

We don't have any kind of D-PHY support at the moment, but I guess we
should put it there once we do.

> > +		return PTR_ERR(csi2rx->base);
> > +	}
> > +
> > +	reg =3D readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);
>=20
> Shouldn't you enable the register access clock(s) before reading the
> register ?

Argh, you're right.

>=20
> > +	csi2rx->max_lanes =3D (reg & 7) + 1;
>=20
> Up to 8 lanes ? Shouldn't this be (reg & 3) + 1 ?

The bit field is indeed documented 3 bits wide, hence the 7.

> > +	csi2rx->max_streams =3D ((reg >> 4) & 7);
>=20
> Should you validate the value as you use it as an array access index ?

I should, yes.

> > +	csi2rx->cdns_dphy =3D reg & BIT(3);
> > +
> > +	csi2rx->sys_clk =3D devm_clk_get(&pdev->dev, "sys_clk");
> > +	if (IS_ERR(csi2rx->sys_clk)) {
> > +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
>=20
> If you wrote this as
>=20
> 		dev_err(&pdev->dev, "Couldn't get %s clock\n", "sys");
>=20
> and the next messages in a similar fashion, most of the message wouldn't =
be=20
> duplicated, resulting in smaller code size.

I'm usually not a big fan of this, since one side effect is also that
you can't grep / search it anymore, and I'm not sure it's worth the
hassle for a couple dozen bytes.

>=20
> > +		return PTR_ERR(csi2rx->sys_clk);
> > +	}
> > +
> > +	csi2rx->p_clk =3D devm_clk_get(&pdev->dev, "p_clk");
> > +	if (IS_ERR(csi2rx->p_clk)) {
> > +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> > +		return PTR_ERR(csi2rx->p_clk);
> > +	}
> > +
> > +	csi2rx->p_free_clk =3D devm_clk_get(&pdev->dev, "p_free_clk");
> > +	if (IS_ERR(csi2rx->p_free_clk)) {
> > +		dev_err(&pdev->dev, "Couldn't get free running P clock\n");
> > +		return PTR_ERR(csi2rx->p_free_clk);
> > +	}
> > +
> > +	for (i =3D 0; i < csi2rx->max_streams; i++) {
> > +		char clk_name[16];
>=20
> Isn't 13 enough ?

It is, if you have an int short enough.

> > +	csi2rx->sensor_node =3D remote;
> > +	csi2rx->asd.match.fwnode.fwnode =3D &remote->fwnode;
> > +	csi2rx->asd.match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> > +
> > +	subdevs =3D devm_kzalloc(csi2rx->dev, sizeof(*subdevs), GFP_KERNEL);
>=20
> Could you store this in the csi2rx_priv structure to avoid a dynamic=20
> allocation ?

It's used only in this function, so it seems a bit overkill to do
that. But I guess I could just allocate it on the stack.

> > +
> > +	csi2rx =3D devm_kzalloc(&pdev->dev, sizeof(*csi2rx), GFP_KERNEL);
>=20
> Please don't use devm_kzalloc() to allocate structures that can be access=
ed=20
> from userspace (in this case because it embeds the subdev structure,=20
> accessible at least through the subdevs ioctls). This is incompatible wit=
h=20
> proper unplug handling. There are many other issues that we will need to =
solve=20
> in the V4L2 core to handling unplugging properly, but let's not add a new=
 one.

What's wrong with kzalloc in such a case? As far as I know, the
userspace can access such a memory, as long as you use copy_to_user,
right? Or is it because of the life-cycle of the allocation that would
be gone while the userspace might not be yet? I'm not sure what would
be a proper fix for it though.

Thanks for your review!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--u5nte5v5onvnlzvn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZoDSEAAoJEBx+YmzsjxAgGJgQAJyjrAag2gRT5d7YveFsz54Y
YlO0JYvmuBUAhBudjRbD4ezVEfZEfMsQpxefVhSbUTh6njWOeCRcBysDYNMiLwZo
7mH9FDgD2V2FKYsGLBauaHLc5YBV6x4azUr/4W767vST4oD3Y9PWU9N+Ml1kwSYw
YYPMyCpQrHLzDFtY6SJohF2YXmWa6WmM0yLZIwwBJLNyWlq6BwPYoWoFDMtztEPS
JgZAS3xtq7u1PQ/c8F8aXnTFSVrYVKhIpRIJcRKCoL9/0Fes42L9TSaO9LXK4Gfb
EPkAjnAL09Jf8a6KUF2ixmRenLdFsIlJ6TAHfOHnXH4J7CO/sv+bJdXjW0ifomz+
LvP6lNHmrd1Yy/NI3mx4be0qDSRZAZXYDxxEE7np3RYcSrLf8qMCZYQKkBfurbAn
cu7hBrutdMYl+bRnkdkdMSwEs8qFDJuiJOrcLK5fyo6jmb2zLwGSipaZiV7gd7KN
mcC7v5Suf6Cwy+Qh51lf2S+cRJn+QFP9RpcofY4FwbY+Rr/jA0aY6c2VQUlxH9oT
ULrxLxSqfcIc1AIuSFRCyaiHqiNVi5LcpWu80TaDeyd7puOTRRWu2J2A4kUHS1Kj
gS+7XfInMf0nobQ9e8dJuJNOT7erPEML/l+1zVTRqpa6sFnlr/CZeVOme5cUuyAP
pyNZNaU7ltLrH7si8Jyp
=OvRs
-----END PGP SIGNATURE-----

--u5nte5v5onvnlzvn--
