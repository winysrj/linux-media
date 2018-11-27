Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42144 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbeK1HQg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 02:16:36 -0500
Date: Tue, 27 Nov 2018 21:17:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v5 0/9] Asynchronous UVC
Message-ID: <20181127201730.GC20692@amd>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-11-06 21:27:11, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham@ideasonboard.com>
>=20
> The Linux UVC driver has long provided adequate performance capabilities =
for
> web-cams and low data rate video devices in Linux while resolutions were =
low.
>=20
> Modern USB cameras are now capable of high data rates thanks to USB3 with
> 1080p, and even 4k capture resolutions supported.
>=20
> Cameras such as the Stereolabs ZED (bulk transfers) or the Logitech BRIO
> (isochronous transfers) can generate more data than an embedded ARM core =
is
> able to process on a single core, resulting in frame loss.
>=20
> A large part of this performance impact is from the requirement to
> =E2=80=98memcpy=E2=80=99 frames out from URB packets to destination frame=
s. This unfortunate
> requirement is due to the UVC protocol allowing a variable length header,=
 and
> thus it is not possible to provide the target frame buffers directly.
>=20
> Extra throughput is possible by moving the actual memcpy actions to a work
> queue, and moving the memcpy out of interrupt context thus allowing work =
tasks
> to be scheduled across multiple cores.

Hmm. Doing memcpy() on many cores is improvement but... not really.
Would it be possible to improve kernel<->user interface, so it says
"data is in this buffer, and it starts here" and so that memcpy in
kernel is not neccessary?
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlv9ploACgkQMOfwapXb+vIrAACfW7AE/YI1u3OfD9Fa5DzJYi/W
EI8AnA8dnu2E3B0BW68UuK4k5NOKohUW
=V8Nj
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
