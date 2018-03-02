Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48012 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164765AbeCBIPT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 03:15:19 -0500
Date: Fri, 2 Mar 2018 09:15:17 +0100
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
Subject: Re: [PATCH v5 0/2] media: v4l: Add support for the Cadence MIPI-CSI2
 TX controller
Message-ID: <20180302081517.pkscagz77mrjtzp4@flea.lan>
References: <20180301113049.16470-1-maxime.ripard@bootlin.com>
 <20180301161338.GA12470@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v55cl5o2jsrcxmfu"
Content-Disposition: inline
In-Reply-To: <20180301161338.GA12470@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--v55cl5o2jsrcxmfu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Niklas,

On Thu, Mar 01, 2018 at 05:13:38PM +0100, Niklas S=F6derlund wrote:
> On 2018-03-01 12:30:47 +0100, Maxime Ripard wrote:
> > Here is an attempt at supporting the MIPI-CSI2 TX block from Cadence.
> >=20
> > This IP block is able to receive 4 video streams and stream them over
> > a MIPI-CSI2 link using up to 4 lanes. Those streams are basically the
> > interfaces to controllers generating some video signals, like a camera
> > or a pattern generator.
> >=20
> > It is able to map input streams to CSI2 virtual channels and datatypes
> > dynamically. The streaming devices choose their virtual channels
> > through an additional signal that is transparent to the CSI2-TX. The
> > datatypes however are yet another additional input signal, and can be
> > mapped to any CSI2 datatypes.
> >=20
> > Since v4l2 doesn't really allow for that setup at the moment, this
> > preliminary version is a rather dumb one in order to start the
> > discussion on how to address this properly.
>=20
> I'm sure you already are aware of this but in case you are not. Sakari=20
> have a branch [1] which addresses much of the CSI-2 virtual channel=20
> problems. It handles data types, virtual channels and format validation=
=20
> for pipelines in IMHO good way.  I have used it for my base when=20
> implementing the R-Car CSI-2 receiver which adds a proposed way on how=20
> to start and stop streams using Sakaris work [2].
>=20
> Would it be possible for you to try this series on-top of Sakaris branch=
=20
> and see if it fits your needs? I would be happy if it did and we can=20
> start the process of trying to get his work upstream so we can clear=20
> that dependency for our hopefully shared problem :-)

Thanks for pointing this out :)

I already started to look into this a few weeks back, and while it's
not yet feature complete, it seemed to work quite well for the RX
case. I haven't had time to test it on the TX controller yet.

So I'd say that for now, his patches look enough to me :)

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--v55cl5o2jsrcxmfu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqZCBQACgkQ0rTAlCFN
r3R0rg//YD1lwwe1hQH7dVvSVzYhChsHHv01g5LZ9Ud875yoFLb2IGzOSszdOf9U
GPrtMbfSTzfBFe+IRo1itTtIyimuZuIjWrvQ+axLjEBJNbH0MlkGNRUOnB3XfQ03
ag6vMNT3wqdSGG4gUhgLCeaFYV1Q6Sd69WUv7oBnw11BFl4Ok9jHmi5y/WPVvu81
i0pL/Um70+YL49R41pWSVFLbMrCsIMXCZuaUXUU2cqwIWUxPYOsLAxUcYCXjvIHO
625Mb/u7J2/+eNzoxFdzxAP8aJWc3iVZ0URMEiiWH4kB56VYyr+/SGXSQfH4X7JA
ejTbWXvadzmPU/iaZVCcy+WOxqeJqqWVzfzkswHUby2Mr875ss+pooSq/26TsjSE
TN1Emkl9hHRjirpgZsKHpf8RD2asdx3ZrWyyVBt2F2jxQLO6jVIkAwqff4kkrsny
xPmThUndNHB3WaoDIjVK3KTaXOFZ0bMStwCq0osXQsc/+7ZOT1hB92KkCGjld2Gk
iPi0QxY+CfCIpsLY3z8tadYCRu/xOXKybBsubM18f9bxzeOro0BDofLMuiSBqucY
LRx8eTa803zqP+pqOU7k08y+RBZM8PADsvxUqsF8iXJOfLJxI2wEbid3rSO/frqW
k/36/YR/0xI8WWanXwf9ipICiLsPE/3epL54fouzLll3rq0Axuo=
=KJLl
-----END PGP SIGNATURE-----

--v55cl5o2jsrcxmfu--
