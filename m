Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59426 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2998510AbdDZKyD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 06:54:03 -0400
Date: Wed, 26 Apr 2017 12:53:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170426105356.GB857@amd>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170425080538.GA30380@amd>
 <1493139207.19105.16.camel@ndufresne.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <1493139207.19105.16.camel@ndufresne.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-04-25 12:53:27, Nicolas Dufresne wrote:
> Le mardi 25 avril 2017 =E0 10:05 +0200, Pavel Machek a =E9crit=A0:
> > Well, fd's are hard, because application can do fork() and now
> > interesting stuff happens. Threads are tricky, because now you have
> > locking etc.
> >=20
> > libv4l2 is designed to be LD_PRELOADED. That is not really feasible
> > with "complex" library.
>=20
> That is incorrect. The library propose an API where you simply replace
> certain low level calls, like ioctl -> v4l2_ioctl, open -> v4l2_open().
> You have to do that explicitly in your existing code. It does not
> abstract the API itself unlike libdrm.

You are right, no LD_PRELOAD. But same API as kernel, which is really
limiting -- see my other mail.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkAfEQACgkQMOfwapXb+vKIAACghQ/X/Q5sbmaQlYnPL6nkpmvu
IGQAn2SmMkHl9FuK8w8Evg7xTAkkl2yt
=OK34
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
