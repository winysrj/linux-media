Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36152 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754984AbdECT6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 15:58:32 -0400
Date: Wed, 3 May 2017 21:58:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        abcloriens@gmail.com, linux-media@vger.kernel.org,
        khilman@kernel.org, tony@atomide.com, aaro.koskinen@iki.fi,
        kernel list <linux-kernel@vger.kernel.org>, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, linux-omap@vger.kernel.org,
        patrikbachan@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        serge@hallyn.com
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
Message-ID: <20170503195829.GA17315@amd>
References: <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170503190556.GT23750@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20170503190556.GT23750@n2100.armlinux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-05-03 20:05:56, Russell King - ARM Linux wrote:
> On Wed, Apr 26, 2017 at 06:43:54PM +0300, Ivaylo Dimitrov wrote:
> > >+static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_fo=
rmat *fmt)
> > >+{
> > >+	long long avg_lum =3D 0;
> > >+	int x, y;
> > >+=09
> > >+	buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> > >+		fmt->fmt.pix.width / 4;
> > >+
> > >+	for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
> > >+		for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
> >=20
> > That would take some time :). AIUI, we have NEON support in ARM kernels
> > (CONFIG_KERNEL_MODE_NEON), I wonder if it makes sense (me) to convert t=
he
> > above loop to NEON-optimized when it comes to it? Are there any drawbac=
ks in
> > using NEON code in kernel?
>=20
> Using neon without the VFP state saved and restored corrupts userspace's
> FP state.  So, you have to save the entire VFP state to use neon in kernel
> mode.  There are helper functions for this: kernel_neon_begin() and
> kernel_neon_end().
=2E..
> Given that, do we really want to be walking over multi-megabytes of image
> data in the kernel with preemption disabled - it sounds like a recipe for
> a very sluggish system.  I think this should (and can only sensibly be
> done) in userspace.

The patch was for libv4l2. (And I explained why we don't need to
overoptimize this.)
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkKNmUACgkQMOfwapXb+vKfewCeIArUjeHqoSyWWlhdaFa+Ej20
5VkAoLPgQMUkBaWNVRrjkNPJP1r+K32H
=BmM6
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
