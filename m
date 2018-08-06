Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57563 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727451AbeHFQaZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Aug 2018 12:30:25 -0400
Message-ID: <130e4f08534d0dfbd26f97f9b95d533ce86ceada.camel@bootlin.com>
Subject: Re: [PATCH v6 4/8] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Mon, 06 Aug 2018 16:21:01 +0200
In-Reply-To: <faa0436aad809ca562b5c152420b1e4d4b6f507b.camel@collabora.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <faa0436aad809ca562b5c152420b1e4d4b6f507b.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-r7SMzHuFY9GvmukQMWuj"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-r7SMzHuFY9GvmukQMWuj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-08-03 at 17:49 -0300, Ezequiel Garcia wrote:
> On Wed, 2018-07-25 at 12:02 +0200, Paul Kocialkowski wrote:
> > This introduces the Cedrus VPU driver that supports the VPU found in
> > Allwinner SoCs, also known as Video Engine. It is implemented through
> > a v4l2 m2m decoder device and a media device (used for media requests).
> > So far, it only supports MPEG2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for Allwinner VPU.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>=20
> [..]
> > +static int cedrus_probe(struct platform_device *pdev)
> > +{
> > +	struct cedrus_dev *dev;
> > +	struct video_device *vfd;
> > +	int ret;
> > +
> > +	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > +	if (!dev)
> > +		return -ENOMEM;
> > +
> > +	dev->dev =3D &pdev->dev;
> > +	dev->pdev =3D pdev;
> > +
> > +	ret =3D cedrus_hw_probe(dev);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed to probe hardware\n");
> > +		return ret;
> > +	}
> > +
> > +	dev->dec_ops[CEDRUS_CODEC_MPEG2] =3D &cedrus_dec_ops_mpeg2;
> > +
> > +	mutex_init(&dev->dev_mutex);
> > +	spin_lock_init(&dev->irq_lock);
> > +
>=20
> A minor thing.
>=20
> I believe this spinlock is not needed. All the data structures
> it's accessing are already protected, and some operations
> (stop_streaming) are guaranteed to not run at the same
> time as a job.

I think we were afraid of this kind of scenario happening, but
everything seems to indicate that these data structures are already
properly protected by the core, as you're suggesting.

Removing the lock does not cause any noticeable issue at first try, but
I'd like to test decoding for a few hours in a row to reduce the
probability of missing a corner case that our lock was preventing.

If that goes well, I guess we can remove it from our driver.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-r7SMzHuFY9GvmukQMWuj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltoWU0ACgkQ3cLmz3+f
v9FoWAf/WG03qz9Fjv7JGnd7X5HALk//tyU8gOO6QPBxy76EGuvrPjv/JethusXV
RUUYVbEarEXgfk8JrEGlewzbM7Zlwi5F1AFSRbVZTTB871buDt8W7hjzXIVJu9yR
Ie5K1jB6lh7prMRPjPodOli8EuE4b7GM30R+IbMnUrVr8cJfTN09IAb0Pzr1iM6/
1nYCvQyhB88kxm+KVTNEIJiDDMSmFia5pBQw5TgInO1G1QKi0beTICqTv5hUnw6l
Rfs5/g1apthU/eDVqQrh0b9Gf/QPyJLc118ISxXgKfNetOQ/35B9hyJCAUq7bveT
VZQj3QqckS6YTocGreXR/nol0jKH8Q==
=XOnT
-----END PGP SIGNATURE-----

--=-r7SMzHuFY9GvmukQMWuj--
