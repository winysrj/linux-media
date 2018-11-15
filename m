Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53075 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725742AbeKPFTe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 00:19:34 -0500
Date: Thu, 15 Nov 2018 20:10:31 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH 0/5] media: Allwinner A10 CSI support
Message-ID: <20181115191031.7jpb2g23fksof625@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <CAGb2v66ygbcomUMkcv8qMCAs_qviFMPzpxj-F4=YBrpuLrdSUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i7rh5slrqsdzymby"
Content-Disposition: inline
In-Reply-To: <CAGb2v66ygbcomUMkcv8qMCAs_qviFMPzpxj-F4=YBrpuLrdSUw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--i7rh5slrqsdzymby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 14, 2018 at 11:24:48AM +0800, Chen-Yu Tsai wrote:
> On Tue, Nov 13, 2018 at 4:24 PM Maxime Ripard <maxime.ripard@bootlin.com>=
 wrote:
> > Here is a series introducing the support for the A10 (and SoCs of the s=
ame
> > generation) CMOS Sensor Interface (called CSI, not to be confused with
> > MIPI-CSI, which isn't support by that IP).
> >
> > That interface is pretty straightforward, but the driver has a few issu=
es
> > that I wanted to bring up:
> >
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
> >
> >   * How to model the CSI module clock isn't really clear to me. It looks
> >     like it goes through the CSI controller and then is muxed to one of=
 the
> >     CSI pin so that it can clock the sensor. I'm not quite sure how to
> >     model it, if it should be a clock, the CSI driver being a clock
> >     provider, or if the sensor should just use the module clock directl=
y.
>=20
> Which clock are you talking about? MCLK? This seems to be fed directly fr=
om
> the CCU, as there doesn't seem to be controls for it within the CSI hardw=
are
> block, and the diagram doesn't list it either. IMO you don't have to mode=
l it.
> The camera sensor device node would just take a reference to it directly.

Yeah, that what I went for, I guess we agree :)

> You would probably enable the (separate) pinmux setting in the CSI
> controller node.

I'll change that.

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--i7rh5slrqsdzymby
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+3EpwAKCRDj7w1vZxhR
xay5AP0YIuMeE90TQHjAJ1bmsn3H3GyD9S7o46GGYjpDWeiDVAEA0LfACvVkvr4a
UO4k+2DcRSF8um3oE1z73dhuaKYkJwk=
=1sff
-----END PGP SIGNATURE-----

--i7rh5slrqsdzymby--
