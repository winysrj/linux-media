Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49633 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeJBT14 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 15:27:56 -0400
Date: Tue, 2 Oct 2018 14:44:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v5 6/6] [media] ad5820: Add support for ad5821 and ad5823
Message-ID: <20181002124444.GB28811@amd>
References: <20181002073222.11368-1-ricardo.ribalda@gmail.com>
 <20181002073222.11368-6-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <20181002073222.11368-6-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-10-02 09:32:22, Ricardo Ribalda Delgado wrote:
> According to the datasheet, both AD5821 and AD5820 share a compatible
> register-set:
> http://www.analog.com/media/en/technical-documentation/data-sheets/AD5821=
=2Epdf
>=20
> Some camera modules also refer that AD5823 is a replacement of AD5820:
> https://download.kamami.com/p564094-OV8865_DS.pdf
>=20
> Suggested-by: Pavel Machek <pavel@ucw.cz>

Acked-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAluzaDwACgkQMOfwapXb+vJJYACglvhKF/6lnCtP4CbVZkx1VLNk
bZwAnRelPeVIShiu8QkvzVIFKGPas0XE
=UaeR
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
