Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44037 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757027AbdHYOow (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 10:44:52 -0400
Date: Fri, 25 Aug 2017 16:44:40 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Cyprian Wronka <cwronka@cadence.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
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
Subject: Re: [PATCH v2 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 RX
 Device Tree bindings
Message-ID: <20170825144440.beettgwsynics3hs@flea.lan>
References: <20170720092302.2982-1-maxime.ripard@free-electrons.com>
 <6400552.TlCMAsqn3H@avalon>
 <EB0D0DEA-1418-4237-910D-F0BE0B9069A1@cadence.com>
 <2518768.foDtbh9bhx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kg6e2lxjy7lvnzvb"
Content-Disposition: inline
In-Reply-To: <2518768.foDtbh9bhx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--kg6e2lxjy7lvnzvb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Wed, Aug 23, 2017 at 12:03:32AM +0300, Laurent Pinchart wrote:
> >>>>> +  - phys: phandle to the external D-PHY
> >>>>> +  - phy-names: must contain dphy, if the implementation uses an
> >>>>> +     external D-PHY
> >>>>=20
> >>>> I would move the last two properties in an optional category as
> >>>> they're effectively optional. I think you should also explain a bit =
more
> >>>> clearly that the phys property must not be present if the phy-names
> >>>> property is not present.
> >>>=20
> >>> It's not really optional. The IP has a configuration register that
> >>> allows you to see if it's been synthesized with or without a PHY. If
> >>> the right bit is set, that property will be mandatory, if not, it's
> >>> useless.
> >>=20
> >> Just to confirm, the PHY is a separate IP core, right ? Is the CSI-2
> >> receiver input interface different when used with a PHY and when used
> >> without one ? Could a third-party PHY be used as well ? If so, would t=
he
> >> PHY synthesis bit be set or not ?
> >=20
> > The PHY (in our case a D-PHY) is a separate entity, it can be from a 3rd
> > party as the IP interface is standard, the SoC integrator would set the=
 bit
> > accordingly based on whether any PHY is present or not. There is also an
> > option of routing digital output from a CSI-TX to a CSI-RX and in such =
case
> > a PHY would not need to be used (as in the case of our current platform=
).=20
>=20
> OK, thank you for the clarification.=20
>=20
> Maxime mentioned that a bit can be read from a register to notify whether=
 a=20
> PHY has been synthesized or not. Does it influence the CSI-2 RX input=20
> interface at all, or is the CSI-2 RX IP core synthesized the same way=20
> regardless of whether a PHY is present or not ?

So we got an answer to this, and the physical interface remains the
same.

However, the PHY bit is set only when there's an internal D-PHY, which
means we have basically three cases:
  - No D-PHY at all, D-PHY presence bit not set
  - Internal D-PHY, D-PHY presence bit set
  - External D-PHY, D-PHY presence bit not set

I guess that solves our discussion about whether the phys property
should be marked optional or not. It should indeed be optional, and
when it's not there, the D-PHY presence bit will tell whether we have
to program the internal D-PHY or not.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--kg6e2lxjy7lvnzvb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZoDfYAAoJEBx+YmzsjxAg/BUP/AkINzgm7mIxywWlSsy+nVdL
4evQiODK2NKY3AhosavTKDbwCOSOkAWJb8lO0knhWQ/7DtEw81V0ZxMrSu0faVZg
lpiTuXCKwwWK9up+Zc4V1xgKe9huyYcOdixk4EPRDYvsdJwmXa9Bv1krZb/i/6Oh
GDNDbVG1dPVB+3pX92wMINFM2cZDMDjLCSfgWTYyE893FvF/9U/ZX3vZr+m9ECJR
SSLQQjQBdFPZ3I81ngIjByhhQ7BwmEd8R5gCIwUPlwoCVQ4dHiYfPgVI48GH+HqJ
WTblG6jADnfjdBO5gvGBRsm9FKxiltcCMATno8CPwL974DkrMGDKd+iSuu2GwZZE
HYlGgAecKKot7wFcVw6GblA/YbmKulBuMPpsbXbVLuqNwvn+zP5uwpUfrMJyYDcW
qGiXBojOE9nLnd48gZHwcBs4cTFiGc8NDP4+SW6WHjOrnmFUeBC++hYGZZjUpJ4J
h93MzKRNyL+dEGurmKfh3mJEauHvcmoFV5G2i9vKTuFRRdScKqLxxUwZfgksxQDI
Q4c63daFHpfASNZipG4bhE0vXyrxT2EZ4u1x742fE1OEm1+khuOH1oD3stP/BsMN
ah0dpehrlpDecQo6A9blMHGEB6yNfJdvK8J8piKr0wkzGWe6beL3Dyzft2VFJpuR
UeRSMLRw1DHgigcqB8Gj
=iIfR
-----END PGP SIGNATURE-----

--kg6e2lxjy7lvnzvb--
