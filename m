Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35219 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978631AbdDXWHE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 18:07:04 -0400
Date: Tue, 25 Apr 2017 00:07:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170424220701.GA27846@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20170424103802.00d3b554@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Please don't add a new application under lib/. It is fine if you want
> some testing application, if the ones there aren't enough, but please
> place it under contrib/test/.
>=20
> You should likely take a look at v4l2grab first, as it could have
> almost everything you would need.

I really need some kind of video output. v4l2grab is not useful
there. v4l2gl might be, but I don't think I have enough dependencies.

Umm, and it looks like libv4l can not automatically convert from
GRBG10.. and if it could, going through RGB24 would probably be too
slow on this device :-(.

> IMO, the above belongs to a separate processing module under
> 	lib/libv4lconvert/processing/

Is there an example using autogain/autowhitebalance from
libv4lconvert?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlj+dwUACgkQMOfwapXb+vLQ4gCfcmBmg0je4/KgYIpgBulQBxSe
UWQAnRd+5l+HLck/B4mhuDptmczP5Yd2
=Nkgq
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
