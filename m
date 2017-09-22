Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38442 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdIVOwQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 10:52:16 -0400
Date: Fri, 22 Sep 2017 16:52:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
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
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com
Subject: Re: [PATCH 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 TX Device
 Tree bindings
Message-ID: <20170922145214.u245ka35az5ewthm@flea.lan>
References: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
 <20170922114703.30511-2-maxime.ripard@free-electrons.com>
 <20170922120106.mfxoh34anazqakvz@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yvg77p54kzhem33d"
Content-Disposition: inline
In-Reply-To: <20170922120106.mfxoh34anazqakvz@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yvg77p54kzhem33d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Fri, Sep 22, 2017 at 12:01:06PM +0000, Sakari Ailus wrote:
> On Fri, Sep 22, 2017 at 01:47:02PM +0200, Maxime Ripard wrote:
> > The Cadence MIPI-CSI2 RX controller is a CSI2 bridge that supports up t=
o 4
>=20
> Should this be TX?
>=20
> I was just thinking what does this chip do, and saw both. RX it at least
> less common. :-)

Yes, definitely :)

This one's a transceiver, the other one a receiver.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--yvg77p54kzhem33d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZxSOeAAoJEBx+YmzsjxAgFNoP/jAnAZoXrmACWmp81/g53dlT
AM5W8Z3qH9+imHq8ubnGpWXKY34D0gMQTcNzHofaxK/aZNvAAcWlq0I2BaD93RzO
GsCOss2jbRUBHHAdoQY2wJf/uMK4caFjBI0HiQILcihhwUgH4kY6CLjOrGE5dvW3
uewqSE7DIxiSNOggIplH5tXvi3SXBS1L4PjYFUvU2lwNWl6Ip7I3d8mDUafJrlOM
X3lak8A7afwS/9aejF26j9G8GJNOuSW2mM2u6xv0mqeCU+KfrAWRDkEGRVkgB0ad
OQEjmxU/S8Mav/yDCIXt4+Gyi6yVRsDCNF2A3UVjalT73AmsRGtvKFUJfZdXvjJf
0d0qs0CGXNizTUuA6clBrwOwEicmPza9w5D3FNFzNX3sEc78ITwB2OTytTMpyDjT
nDEUO6WyiJjmOx+y/ghzoSyRSeWkoO83VDWLTzb4SZnZC3pqhBYiGHNfzpy79xdQ
uDNDK4pjYauzLvMS9G5iO0BVNN6EUuPSZFMoW9Ck45ULFu72cFSjCgY6gF3s+g1t
4LQr9821WdoaVIoq0kgfuxP9Ucst06FczDIt7gwZxy7AUGtc9u0LolUJNyNsQhHI
iymx9pjeiK0nu1rcUlZSOoP0zM94+ZXyGOK6SD9HjY6jnrpW31dFAsLG6NzT1yqo
wvRQXd/+ZC79enutDgJw
=uB1p
-----END PGP SIGNATURE-----

--yvg77p54kzhem33d--
