Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55577 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdH1Kd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 06:33:56 -0400
Date: Mon, 28 Aug 2017 12:33:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
Message-ID: <20170828103351.GF18012@amd>
References: <20170819212410.3084-1-sakari.ailus@linux.intel.com>
 <20170819212410.3084-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Content-Disposition: inline
In-Reply-To: <20170819212410.3084-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +
> +Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
> +and b are included in the range.

Normally I've seen <a, b> for closed ranges, (a, b) for open
ranges. Is that different in your country?

Otherwise

Acked-by: Pavel Machek <pavel@ucw.cz>


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmj8Y8ACgkQMOfwapXb+vLv2QCcDDuYKtiJuKG4IJfyJOP7otb5
bkoAnRrWG+ypsWGkuTT4NV3gC2Xeulqw
=Ur/3
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
