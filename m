Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44924 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750788AbdESJNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 05:13:08 -0400
Date: Fri, 19 May 2017 11:13:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: [libv4l]: How to do 10-bit support? Stand-alone conversions?
Message-ID: <20170519091306.GA29363@amd>
References: <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170509110440.GC28248@amd>
 <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I much rather do this as part of a longer series that actually adds 10 bi=
t support.

> The problem is that adding support for 10 bit doesn't mean you can just u=
se LSIZE
> all the time since you still need support for 8 bit as well.

Heh. I was afraid to hear that. I can probably support 10-bits for
white balance somehow.

How would complete support for 10-bits work? Introduce RGB48 and
modify processing to work in 16-bits?

And the big question: is it possible to do processing with
libv4lconvert, without actually have v4l device available?

For example... I do have a simple camera application. In a viewfinder
mode, it has to work at GRBG10 format, because any conversion is just
too slow. We'd also want to save raw GRBG10 image to disk for raw
processing. So far so good. But we'd also want to save jpeg, which
means converting existing buffer to RGB24, applying white balance (and
maybe bad-pixel, lens shading, vignetting compensation) and saving
jpeg.

I'm trying to use this for conversion:

static void convert_rgb(struct dev_info *dev, struct v4l2_format sfmt, void=
 *buf, struct v4l2_f\
ormat dfmt, void *buf2, int wb)
{
        struct v4lconvert_data *data =3D v4lconvert_create(dev->fd);
        int res;

        printf("Converting first.");
        if (wb) {
                struct v4l2_control ctrl;
                ctrl.id =3D V4L2_CID_AUTO_WHITE_BALANCE;
                ctrl.value =3D 1;
		v4lconvert_vidioc_s_ctrl(data, &ctrl);
	}
        res =3D v4lconvert_convert(data, &sfmt, &dfmt, buf, SIZE, buf2, SIZ=
E);
	printf("Converting: %d\n", res);
        v4lconvert_destroy(data);
}

but

1) it feels like improper use of internal functions.

2) it crashes when I attempt to do white balance processing.

Is there an interface I could use? Should I create interface for
v4lconvert_ for this kind of processing? Any preferences how it should
look like?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlketyIACgkQMOfwapXb+vIlgACgrUyty/nR3Tjpat3RHFHFktCY
1sgAn0aqkwZWdDQ5OOjL5eB/xk7m3QB6
=24kk
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
