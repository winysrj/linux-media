Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:50009 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbeDCOZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 10:25:24 -0400
Date: Tue, 3 Apr 2018 16:25:13 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Niklas =?utf-8?Q?S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>
Subject: Re: [PATCH v8 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20180403142513.435jdbs7u7nathtm@flea>
References: <20180215133335.9335-1-maxime.ripard@bootlin.com>
 <20180215133335.9335-3-maxime.ripard@bootlin.com>
 <20180329133255.GD26532@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6ghnuyaey5gm4fhd"
Content-Disposition: inline
In-Reply-To: <20180329133255.GD26532@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6ghnuyaey5gm4fhd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

Thanks for your review,

On Thu, Mar 29, 2018 at 03:32:55PM +0200, Niklas S=F6derlund wrote:
> > diff --git a/drivers/media/platform/cadence/Kconfig b/drivers/media/pla=
tform/cadence/Kconfig
> > new file mode 100644
> > index 000000000000..18f061e5cbd1
> > --- /dev/null
> > +++ b/drivers/media/platform/cadence/Kconfig
> > @@ -0,0 +1,17 @@
> > +config VIDEO_CADENCE
> > +	bool "Cadence Video Devices"
>=20
> I'm no expert on Kconfig best practices so if nothing else I might learn=
=20
> something. There is no need to add a description to this option as it=20
> only groups the Cadence drivers?

You don't strictly need it, but you're right and one should be better,
I've added it.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--6ghnuyaey5gm4fhd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrDjsgACgkQ0rTAlCFN
r3QLoQ/+Oyl6xPhBeYQjU23lTQIzC6yjPMV+l8hEv/Rr/jgwwwLoNW1iPqsCxuGa
TNCM5BJHYovSqmaYQ3NlE+ilsMCF4vwi4md+X0IgyYsLRgw+1FblWCJBf3DSIsKG
/oynhDw/Dw5WaQg3ncqBkmGlUZL4nDw3o+j5VZST6VoNS+4BNZPVuucdwKV7vZ8o
aH3VkmxIIiaPMB8ncH2jXEql6EsHpuaWpbya6bdF0qIDcLSKILYMM8GUg3cGvhBk
i5Co3MBY6YXiI8vbS5LV9wZVKuVrPqLPJjYLPqeMfLo94bFNnGuhH59xjyhCGB/C
7fmXxicD/l46SwNL7GWaTFuAhuE29Zijtt95PY6JxmEZL/zLeSNO0PxwVtO6aO6z
DHAtCvo2RKfxCmagGMz5HYf1aDAZDZjlpQggdJHYBSuYFGZEZCVp+c56xYTmTRm7
8E3mt2iwD+PPgfygzRMN3YkNCUIzBQyj1n/t8c9DKfboo8WRLilI+6l6yba3gMyd
+JfHLTTdyA9XDSEjxchXIo2ZYruP5mSpOKeL5j9eWSgCaMcRuPGyTj775fnbof/E
fPLWnl/LMb7GQxESKSXWToMjN/xIdpN9tFxOzkSS/ErAX9KWhYWeQ3HsSlTOUzPb
N0PvwZPsjLZXV8lqzsYuSksBZ7Zk6rRsyGKZvT0IJMaG4DlkD1E=
=rV4V
-----END PGP SIGNATURE-----

--6ghnuyaey5gm4fhd--
