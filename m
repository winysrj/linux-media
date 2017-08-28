Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56901 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751157AbdH1LAL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 07:00:11 -0400
Date: Mon, 28 Aug 2017 13:00:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 1/3] dt: bindings: Document DT bindings for Analog
 devices as3645a
Message-ID: <20170828110008.GA492@amd>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20170823081100.11733-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +led-max-microamp: Maximum torch (assist) current in microamperes. The
> +		  value must be in the range between [20000, 160000] and
> +		  divisible by 20000.
> +ams,input-max-microamp: Maximum flash controller input current. The

"in microamperes".

> +			value must be in the range [1250000, 2000000]
> +			and divisible by 50000.

Is there any reason for "ams," prefix here?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmj97gACgkQMOfwapXb+vL0AwCfTK/KopJd8g0ti8wnQgLDFHjv
eK4An1kQh3Rt6rGSyqD0BX+u2dMmxZ89
=lOvG
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
