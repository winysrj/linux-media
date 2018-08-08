Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54255 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbeHHLr7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Aug 2018 07:47:59 -0400
Message-ID: <d807ea19fa4fbbab81d6580399d406f351ac324e.camel@bootlin.com>
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
Date: Wed, 08 Aug 2018 11:28:55 +0200
In-Reply-To: <130e4f08534d0dfbd26f97f9b95d533ce86ceada.camel@bootlin.com>
References: <20180725100256.22833-1-paul.kocialkowski@bootlin.com>
         <20180725100256.22833-5-paul.kocialkowski@bootlin.com>
         <faa0436aad809ca562b5c152420b1e4d4b6f507b.camel@collabora.com>
         <130e4f08534d0dfbd26f97f9b95d533ce86ceada.camel@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-oFjxIpdcI3M+8NHK4cGK"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oFjxIpdcI3M+8NHK4cGK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-08-06 at 16:21 +0200, Paul Kocialkowski wrote:
> Hi,
>=20
> On Fri, 2018-08-03 at 17:49 -0300, Ezequiel Garcia wrote:
> > On Wed, 2018-07-25 at 12:02 +0200, Paul Kocialkowski wrote:
> > > This introduces the Cedrus VPU driver that supports the VPU found in
> > > Allwinner SoCs, also known as Video Engine. It is implemented through
> > > a v4l2 m2m decoder device and a media device (used for media requests=
).
> > > So far, it only supports MPEG2 decoding.
> > >=20
> > > Since this VPU is stateless, synchronization with media requests is
> > > required in order to ensure consistency between frame headers that
> > > contain metadata about the frame to process and the raw slice data th=
at
> > > is used to generate the frame.
> > >=20
> > > This driver was made possible thanks to the long-standing effort
> > > carried out by the linux-sunxi community in the interest of reverse
> > > engineering, documenting and implementing support for Allwinner VPU.
> > >=20
> > > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
> > [..]
> > > +static int cedrus_probe(struct platform_device *pdev)
> > > +{
> > > +	struct cedrus_dev *dev;
> > > +	struct video_device *vfd;
> > > +	int ret;
> > > +
> > > +	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > > +	if (!dev)
> > > +		return -ENOMEM;
> > > +
> > > +	dev->dev =3D &pdev->dev;
> > > +	dev->pdev =3D pdev;
> > > +
> > > +	ret =3D cedrus_hw_probe(dev);
> > > +	if (ret) {
> > > +		dev_err(&pdev->dev, "Failed to probe hardware\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev->dec_ops[CEDRUS_CODEC_MPEG2] =3D &cedrus_dec_ops_mpeg2;
> > > +
> > > +	mutex_init(&dev->dev_mutex);
> > > +	spin_lock_init(&dev->irq_lock);
> > > +
> >=20
> > A minor thing.
> >=20
> > I believe this spinlock is not needed. All the data structures
> > it's accessing are already protected, and some operations
> > (stop_streaming) are guaranteed to not run at the same
> > time as a job.
>=20
> I think we were afraid of this kind of scenario happening, but
> everything seems to indicate that these data structures are already
> properly protected by the core, as you're suggesting.
>=20
> Removing the lock does not cause any noticeable issue at first try, but
> I'd like to test decoding for a few hours in a row to reduce the
> probability of missing a corner case that our lock was preventing.

After testing for several hours in a row, I got some cases of CPU stall
which did not happen with the driver lock. So it seems safer to keep the
lock around for now and maybe revisit this later, when there is time to
investigate why it is needed.

Cheers,

Paul

> If that goes well, I guess we can remove it from our driver.
>=20
> Cheers,
>=20
> Paul
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-oFjxIpdcI3M+8NHK4cGK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltqt9cACgkQ3cLmz3+f
v9GGdAgAgOcza158hDe97SqAwSLU4Uc/mPJb02CUTrU+puLnhcCF58q/Q6EH/C4I
pko7tul7pB4QLNmRuvh8ox4x80Be9+XiqQZIqTloW3J+bzXW2EypY3L3WfhETaNu
TlqXSgxexOOs180e/dkffh3iHBjDxe6bi0EJ5IFT4NikGSEB0jP5Y6RazUxGrDwt
Koa5dKdAcKDq0LfBsbM4Qr9B9Y2Qmb/oGxlUrNSu+G+VuISAPrj+A3nAEF5Om1aV
WP0i8L9NzOZTHxV7z4Tcf0a8FGc92rjFPevskB5UjrNzgqi7stV5U4EqOtnxoFen
5YKaUcA7oG1V8gTpmCdc8z8b6bWL3g==
=8ov9
-----END PGP SIGNATURE-----

--=-oFjxIpdcI3M+8NHK4cGK--
