Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46467 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751794AbdGRV1N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 17:27:13 -0400
Date: Tue, 18 Jul 2017 23:27:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] omap3isp: Return -EPROBE_DEFER if the required
 regulators can't be obtained
Message-ID: <20170718212712.GA19771@amd>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-5-sakari.ailus@linux.intel.com>
 <1652763.9EYemjAvaH@avalon>
 <20170718100352.GA28481@amd>
 <20170718101702.qi72355jjjuq7jjs@valkosipuli.retiisi.org.uk>
 <20170718210228.GA13046@amd>
 <20170718211640.qzplt2sx7gjlgqox@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20170718211640.qzplt2sx7gjlgqox@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > No idea really. I only have N900 working with linux at the moment. I'm
> > trying to get N9 and N950 working, but no luck so far.
>=20
> Still no? :-(
>=20
> Do you know if you get the kernel booting? Do you have access to the seri=
al
> console? I might have seen the e-mail chain but I lost the track. What
> happens after the flasher has pushed the kernel to RAM and the boot start=
s?
> It's wonderful for debugging if something's wrong...

Still no. No serial cable, unfortunately. Flasher seems to run the
kernel, but I see no evidence new kernel started successfully. I was
told display is not expected to work, and on USB I see bootloader
disconnecting and that's it.

If you had a kernel binary that works for you, and does something I
can observe, that would be welcome :-).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllufTAACgkQMOfwapXb+vKJ0wCeIpG0/PbzZq0Z4N/XZqCINgv5
7DEAoK3LgBcgUnHAIijeafD6Yj68SaNo
=+M39
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
