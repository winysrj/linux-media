Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:56949 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdJKLzs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 07:55:48 -0400
Date: Wed, 11 Oct 2017 13:55:44 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, nm@ti.com
Subject: Re: [PATCH 2/2] v4l: cadence: Add Cadence MIPI-CSI2 TX driver
Message-ID: <20171011115544.w7eswyhke6dskgbb@flea>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-3-maxime.ripard@free-electrons.com>
 <20170929182125.GB3163@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qcs55slvibc6hjsc"
Content-Disposition: inline
In-Reply-To: <20170929182125.GB3163@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qcs55slvibc6hjsc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Fri, Sep 29, 2017 at 06:21:25PM +0000, Benoit Parrot wrote:
> > +struct csi2tx_priv {
> > +	struct device			*dev;
> > +	atomic_t			count;
> > +
> > +	void __iomem			*base;
> > +
> > +	struct clk			*esc_clk;
> > +	struct clk			*p_clk;
> > +	struct clk			*pixel_clk[CSI2TX_STREAMS_MAX];
> > +
> > +	struct v4l2_subdev		subdev;
> > +	struct media_pad		pads[CSI2TX_PAD_MAX];
> > +	struct v4l2_mbus_framefmt	pad_fmts[CSI2TX_PAD_MAX];
> > +
> > +	bool				has_internal_dphy;
>=20
> I assume dphy support is for a subsequent revision?

Yes, the situation is similar to the CSI2-RX driver.

> > +		/*
> > +		 * We use the stream ID there, but it's wrong.
> > +		 *
> > +		 * A stream could very well send a data type that is
> > +		 * not equal to its stream ID. We need to find a
> > +		 * proper way to address it.
> > +		 */
>=20
> I don't quite get the above comment, from the code below it looks like
> you are using the current fmt as a source to provide the correct DT.
> Am I missing soemthing?

Yes, so far the datatype is inferred from the format set. Is there
anything wrong with that?

>=20
> > +		writel(CSI2TX_DT_CFG_DT(fmt->dt),
> > +		       csi2tx->base + CSI2TX_DT_CFG_REG(stream));
> > +
> > +		writel(CSI2TX_DT_FORMAT_BYTES_PER_LINE(mfmt->width * fmt->bpp) |
> > +		       CSI2TX_DT_FORMAT_MAX_LINE_NUM(mfmt->height + 1),
> > +		       csi2tx->base + CSI2TX_DT_FORMAT_REG(stream));
> > +
> > +		/*
> > +		 * TODO: This needs to be calculated based on the
> > +		 * clock rate.
> > +		 */
> > +		writel(CSI2TX_STREAM_IF_CFG_FILL_LEVEL(4),
> > +		       csi2tx->base + CSI2TX_STREAM_IF_CFG_REG(stream));
> > +	}
> > +
> > +	/* Disable the configuration mode */
> > +	writel(0, csi2tx->base + CSI2TX_CONFIG_REG);
> > +
> > +	return 0;
> > +}
> > +
> > +static int csi2tx_stop(struct csi2tx_priv *csi2tx)
> > +{
> > +	/*
> > +	 * Let the last user turn off the lights
> > +	 */
> > +	if (!atomic_dec_and_test(&csi2tx->count))
> > +		return 0;
> > +
> > +	/* FIXME: Disable the IP here */
> > +
> > +	return 0;
> > +}
>=20
> At this point both _start() and _stop() only return 0.
> Are there any cases where any of these might fail to "start" or "stop"?

None that I know of.

There might be some errors with the video stream itself, but that
can be detected after the block has been enabled.

> > +	csi2tx->lanes =3D csi2tx_get_num_lanes(&pdev->dev);
> > +	if (csi2tx->lanes < 0) {
> > +		dev_err(&pdev->dev, "Invalid number of lanes, bailing out.\n");
> > +		ret =3D csi2tx->lanes;
> > +		goto err_free_priv;
> > +	}
>=20
> csi2tx->lanes is unsigned so it will never be negative.

Ah, right, I'll change that.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--qcs55slvibc6hjsc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ3gbAAAoJEBx+YmzsjxAg6gwP/1UIcPeIKkTMuiGKIJ69FZfv
bVTujMQd1GfxVLqev+0RW3iVw+XUjpf9GHSVWv61ip1dSWIwd4N0mNzdHyJkAbrF
NWsE0II7OYoCMqs2uYDVnQM/C/8R22s0Q6laVKPzyEnXRF6RBYiRjIGlFac71Iik
AKRWy/fxu653ZfPvQ9PbLQVuoMhM8/kxgRqdNqtG8Lo83t53Rx7xcTntJ1p3azLC
7zL/+g+06kOct1a2kfd8L5CCET2C/GRwnwcNdeWEUg8ZwVHxnRidMjqDDvdIfYvY
MbORToUsKs/ri/82v6ZZKmpTweMngs+FhhANnaO9jg5nLV0yxULY31/pZujmr6Ds
k7rZD4XcKWYN4yied6JrWDF2dfurTN0noaC8xJcRYoupHWEPqlY40zJxbOmjUl1l
AX35HENCqCUfntQiEfH5gGTyjXb5ZvLnLjdWz/Gp3KONvNelMn6fUULL20JdScg0
n4HB64jgc3NB5JUmXzkL6rW8HcfS+/daIvarTf0lQSxQNvCLmYOLTZsqIKKiyBvB
h7+dGVLAot+KqsLq04hezKAOEUzaDewhYGsvjlAgeJ+ae3oj1GnJBP/YRrPDmEcw
1tpuFyS9QklgZ3Zc20jRPiUiGKsZieQFKftFm9vCKsYKSajFJDGdOOdUJ27i+bHE
FwdnVpQwU1r1b7r+s/Yg
=w8B1
-----END PGP SIGNATURE-----

--qcs55slvibc6hjsc--
