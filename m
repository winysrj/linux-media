Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52995 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032237AbdDZWwI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 18:52:08 -0400
Date: Thu, 27 Apr 2017 00:51:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, patrikbachan@gmail.com, serge@hallyn.com,
        abcloriens@gmail.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [patch] autogain support for bayer10 format (was Re: [patch]
 propagating controls in libv4l2)
Message-ID: <20170426225150.GA4188@amd>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>There are two separate things here:
> >>
> >>1) Autofoucs for a device that doesn't use subdev API
> >>2) libv4l2 support for devices that require MC and subdev API
> >
> >Actually there are three: 0) autogain. Unfortunately, I need autogain
> >first before autofocus has a chance...
> >
> >And that means... bayer10 support for autogain.
> >
> >Plus, I changed avg_lum to long long. Quick calculation tells me int
> >could overflow with few megapixel sensor.
> >
> >Oh, btw http://ytse.tricolour.net/docs/LowLightOptimization.html no
> >longer works.
> >
> >Regards,
> >								Pavel
> >
> >diff --git a/lib/libv4lconvert/processing/autogain.c b/lib/libv4lconvert=
/processing/autogain.c
> >index c6866d6..0b52d0f 100644
> >--- a/lib/libv4lconvert/processing/autogain.c
> >+++ b/lib/libv4lconvert/processing/autogain.c
> >@@ -68,6 +71,41 @@ static void autogain_adjust(struct v4l2_queryctrl *ct=
rl, int *value,
> > 	}
> > }
> >
> >+static int get_luminosity_bayer10(uint16_t *buf, const struct v4l2_form=
at *fmt)
> >+{
> >+	long long avg_lum =3D 0;
> >+	int x, y;
> >+=09
> >+	buf +=3D fmt->fmt.pix.height * fmt->fmt.pix.bytesperline / 4 +
> >+		fmt->fmt.pix.width / 4;
> >+
> >+	for (y =3D 0; y < fmt->fmt.pix.height / 2; y++) {
> >+		for (x =3D 0; x < fmt->fmt.pix.width / 2; x++)
>=20
> That would take some time :). AIUI, we have NEON support in ARM kernels
> (CONFIG_KERNEL_MODE_NEON), I wonder if it makes sense (me) to convert the
> above loop to NEON-optimized when it comes to it? Are there any drawbacks=
 in
> using NEON code in kernel?

Well, thanks for offer. This is actualy libv4l2.

But I'd say NEON conversion is not neccessary anytime soon. First,
this is just trying to get average luminosity. We can easily skip
quite a lot of pixels, and still get reasonable answer.

Second, omap3isp actually has a hardware block computing statistics
for us. We just don't use it for simplicity.

(But if you want to play with camera, I'll get you patches; there's
ton of work to be done, both kernel and userspace :-).

Regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkBJIYACgkQMOfwapXb+vIlXgCcC0O2gZ+1Qb6RGo7nSEWdofks
QgwAoI6UOY26tqLmewbaWHowbm38Pl4M
=kC1k
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
