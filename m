Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:54098 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733103AbeKMXvb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 18:51:31 -0500
Date: Tue, 13 Nov 2018 14:52:59 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 0/5] media: Allwinner A10 CSI support
Message-ID: <20181113135259.onutfjtoi25afnfe@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <df54f2e6-e207-92de-767a-e356345a1a56@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tuowivvrq2idyzks"
Content-Disposition: inline
In-Reply-To: <df54f2e6-e207-92de-767a-e356345a1a56@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tuowivvrq2idyzks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Tue, Nov 13, 2018 at 01:30:49PM +0100, Hans Verkuil wrote:
> On 11/13/18 09:24, Maxime Ripard wrote:
> > Hi,
> >=20
> > Here is a series introducing the support for the A10 (and SoCs of the s=
ame
> > generation) CMOS Sensor Interface (called CSI, not to be confused with
> > MIPI-CSI, which isn't support by that IP).
> >=20
> > That interface is pretty straightforward, but the driver has a few issu=
es
> > that I wanted to bring up:
> >=20
> >   * The only board I've been testing this with has an ov5640 sensor
> >     attached, which doesn't work with the upstream driver. Copying the
> >     Allwinner init sequence works though, and this is how it has been
> >     tested. Testing with a second sensor would allow to see if it's an
> >     issue on the CSI side or the sensor side.
> >   * When starting a capture, the last buffer to capture will fail due to
> >     double buffering being used, and we don't have a next buffer for the
> >     last frame. I'm not sure how to deal with that though. It seems like
> >     some drivers use a scratch buffer in such a case, some don't care, =
so
> >     I'm not sure which solution should be preferred.
> >   * We don't have support for the ISP at the moment, but this can be ad=
ded
> >     eventually.
> >=20
> >   * How to model the CSI module clock isn't really clear to me. It looks
> >     like it goes through the CSI controller and then is muxed to one of=
 the
> >     CSI pin so that it can clock the sensor. I'm not quite sure how to
> >     model it, if it should be a clock, the CSI driver being a clock
> >     provider, or if the sensor should just use the module clock directl=
y.
> >=20
> > Here is the v4l2-compliance output:
>=20
> Test v4l2-compliance with the -s option so you test streaming as well.
> Even better is -f where it tests streaming with all available formats.

I will, thanks for the tip!

> > v4l2-compliance SHA   : 339d550e92ac15de8668f32d66d16f198137006c
>=20
> Hmm, I can't find this SHA. Was this built from the main v4l-utils repo?

It was, but using Buildroot. The version packaged in the latest stable
version I was using (2018.08) is 1.14.2.

Looking at the Makefile from v4l2-compliance, it looks like it just
invokes git to retrieve the git commit and uses that as the hash. In
Buildroot's case, since buildroot will download the tarball, this will
end up returning the SHA commit of the buildroot repo building the
sources, not the version of the sources themselves.

I'm not sure how to address that properly though. Thomas, how do you
usually deal with this?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--tuowivvrq2idyzks
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+rXOwAKCRDj7w1vZxhR
xabMAQCXY5WuoarBlzgehUDkLQh39CHaTJXUvqty0a5lsPAz6QD+OCaF3COJhxGV
h5v5o8g6gjkqE90OzFIbKD+YWrm8DAM=
=Brps
-----END PGP SIGNATURE-----

--tuowivvrq2idyzks--
