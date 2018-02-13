Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:60757 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964863AbeBMRLe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 12:11:34 -0500
Date: Tue, 13 Feb 2018 18:11:32 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: media: Add Cadence MIPI-CSI2 TX
 Device Tree bindings
Message-ID: <20180213171132.kt2vu2eioactzqkm@flea.lan>
References: <20180207142643.15746-1-maxime.ripard@bootlin.com>
 <20180207142643.15746-2-maxime.ripard@bootlin.com>
 <2476247.yR0nrT2UBg@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="do5rw6i7wiwoksc3"
Content-Disposition: inline
In-Reply-To: <2476247.yR0nrT2UBg@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--do5rw6i7wiwoksc3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Thu, Feb 08, 2018 at 09:00:19PM +0200, Laurent Pinchart wrote:
> > +
> > +           Port Description
> > +           -----------------------------
> > +           0    CSI-2 output
> > +           1    Stream 0 input
> > +           2    Stream 1 input
> > +           3    Stream 2 input
> > +           4    Stream 3 input
> > +
> > +           The stream input port nodes are optional if they are not
> > +           connected to anything at the hardware level or implemented
> > +           in the design.
>=20
> Are they optional (and thus valid if present), or should they be forbidde=
n in=20
> case they're not implemented in the hardware ? I'd go for the latter and =
write
>=20
> "One stream input port node is required per implemented hardware input, a=
nd no=20
> stream input port node can be present for unimplemented inputs."

That works for me.

> > Since there is only one endpoint per port,
> > +           the endpoints are not numbered.
>=20
> I think it would be valid to number endpoints even if not required. I thi=
nk=20
> that what you should document is that at most one endpoint is supported p=
er=20
> port.

Sakari asked to have it worded that way in this review:
https://www.spinics.net/lists/linux-media/msg122713.html

What should I do?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--do5rw6i7wiwoksc3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqDHEAACgkQ0rTAlCFN
r3TMjQ/+Ldxfm7yUdEwwaZmCvbwe1mO0ToRJdXMvurNY4nksSW9x4mPxHNC/48f/
P9xkuE6KyffgUwnuh2zXQ5HtHu6DJu15AjVp7FU2NciuDgIBwWIOlgI8FnwO3Ks2
UII6GLhyqSdNpPzVZtl1Vnuh/SITL/x8/JQGUzeOzGhwQ+LqIOAud/q4PLwrzEQS
7HSFcyOJyrmTs5fKO4tkb3iRp2ximqNAHsvB8dgDrvdPBdeFc7rQ7aWCvDv+BHGX
XqRFAJBnxgDC/k/zcNllv5b4UYHjKyvReLmoNNo7GS2arA5VNUuHhRiBaAga9Z2G
loPPxrUK2YQANK0Ar0OLXTx4rtOrI/+PRE31PNCw9CvRmlbEDBIk5bAgtwUzrAqn
UCuAJ+f8dS9tKHx+A2kIjGOI+a+d1J0279H4+BvRXK4xFK/IPftMJXIers/OLYRL
yaoKWdqMrsW/jJc0op1SHZfGkspkYTM82Oec9QQH1kcWeQtoHWrmFqyOxMe2hYfh
cx8v55WjyiVLf3ps3Rcl2jt/zlbtsmkl4lzJLL8cjmfbu682aARjsaI7w2WTeuV0
vO4D950lC7JBS5oPFDnwrXT10Uw5uW1gTAjfTeIFZ9BYprDUolA9qInJriKPeV18
Y1iZFszAEkL8IB6v0xcF+hvV4anvBdUaTrZLSzeRGnPbnAtq2YY=
=BT9A
-----END PGP SIGNATURE-----

--do5rw6i7wiwoksc3--
