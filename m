Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60311 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732000AbeKNBvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 20:51:08 -0500
Date: Tue, 13 Nov 2018 16:52:27 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
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
Message-ID: <20181113155227.62jjs3mpomwgr7xd@flea>
References: <cover.71b0f9855c251f9dc389ee77ee6f0e1fad91fb0b.1542097288.git-series.maxime.ripard@bootlin.com>
 <df54f2e6-e207-92de-767a-e356345a1a56@xs4all.nl>
 <20181113135259.onutfjtoi25afnfe@flea>
 <f07a0460-cdba-c1a5-acfd-66a39f447a5a@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mey3hhnj2kgojfyq"
Content-Disposition: inline
In-Reply-To: <f07a0460-cdba-c1a5-acfd-66a39f447a5a@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mey3hhnj2kgojfyq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2018 at 03:01:45PM +0100, Hans Verkuil wrote:
> On 11/13/18 14:52, Maxime Ripard wrote:
> > Hi Hans,
> >=20
> > On Tue, Nov 13, 2018 at 01:30:49PM +0100, Hans Verkuil wrote:
> >> On 11/13/18 09:24, Maxime Ripard wrote:
> >>> Hi,
> >>>
> >>> Here is a series introducing the support for the A10 (and SoCs of the=
 same
> >>> generation) CMOS Sensor Interface (called CSI, not to be confused with
> >>> MIPI-CSI, which isn't support by that IP).
> >>>
> >>> That interface is pretty straightforward, but the driver has a few is=
sues
> >>> that I wanted to bring up:
> >>>
> >>>   * The only board I've been testing this with has an ov5640 sensor
> >>>     attached, which doesn't work with the upstream driver. Copying the
> >>>     Allwinner init sequence works though, and this is how it has been
> >>>     tested. Testing with a second sensor would allow to see if it's an
> >>>     issue on the CSI side or the sensor side.
> >>>   * When starting a capture, the last buffer to capture will fail due=
 to
> >>>     double buffering being used, and we don't have a next buffer for =
the
> >>>     last frame. I'm not sure how to deal with that though. It seems l=
ike
> >>>     some drivers use a scratch buffer in such a case, some don't care=
, so
> >>>     I'm not sure which solution should be preferred.
> >>>   * We don't have support for the ISP at the moment, but this can be =
added
> >>>     eventually.
> >>>
> >>>   * How to model the CSI module clock isn't really clear to me. It lo=
oks
> >>>     like it goes through the CSI controller and then is muxed to one =
of the
> >>>     CSI pin so that it can clock the sensor. I'm not quite sure how to
> >>>     model it, if it should be a clock, the CSI driver being a clock
> >>>     provider, or if the sensor should just use the module clock direc=
tly.
> >>>
> >>> Here is the v4l2-compliance output:
> >>
> >> Test v4l2-compliance with the -s option so you test streaming as well.
> >> Even better is -f where it tests streaming with all available formats.
> >=20
> > I will, thanks for the tip!
> >=20
> >>> v4l2-compliance SHA   : 339d550e92ac15de8668f32d66d16f198137006c
> >>
> >> Hmm, I can't find this SHA. Was this built from the main v4l-utils rep=
o?
> >=20
> > It was, but using Buildroot. The version packaged in the latest stable
> > version I was using (2018.08) is 1.14.2.
>=20
> That's seriously out of date. That's why I show the SHA, to see if
> someone is testing with a recent version of the utility, so it served
> its purpose here :-)
>=20
> Latest release is 1.16.2.
>=20
> But when submitting new drivers you really need to build it yourself from
> the master branch, that's the only way to be sure you have all the latest
> compliance checks.

Ack, I'll update it and test again then.

> >=20
> > Looking at the Makefile from v4l2-compliance, it looks like it just
> > invokes git to retrieve the git commit and uses that as the hash. In
> > Buildroot's case, since buildroot will download the tarball, this will
> > end up returning the SHA commit of the buildroot repo building the
> > sources, not the version of the sources themselves.
> >=20
> > I'm not sure how to address that properly though. Thomas, how do you
> > usually deal with this?
>=20
> Note that cec-compliance and cec-follower do the same, for the same
> reason.
>=20
> Where does the tarball come from?

This is the official tarball from linuxtv:
https://git.buildroot.net/buildroot/tree/package/libv4l/libv4l.mk?h=3D2018.=
08.2#n8

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--mey3hhnj2kgojfyq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+rzOwAKCRDj7w1vZxhR
xVxpAQCloz1Vkj2/cuDI4diTpHaBCq7l4uo9Zmc8oh9YZ+aafQEAs4eps+X9umhd
CXAHluGjfnAjjJoNzgm/blLXPCkI2Qc=
=0tqf
-----END PGP SIGNATURE-----

--mey3hhnj2kgojfyq--
