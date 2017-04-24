Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34258 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S977936AbdDXV3R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 17:29:17 -0400
Date: Mon, 24 Apr 2017 23:29:14 +0200
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
        linux-media@vger.kernel.org
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170424212914.GA20780@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20170424103802.00d3b554@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > For focus to be useful, we need autofocus implmented
> > somewhere. Unfortunately, v4l framework does not seem to provide good
> > place where to put autofocus. I believe, long-term, we'll need some
> > kind of "video server" providing this kind of services.
> >=20
> > Anyway, we probably don't want autofocus in kernel (even through some
> > cameras do it in hardware), and we probably don't want autofocus in
> > each and every user application.
> >=20
> > So what remains is libv4l2.=20
>=20
> IMO, the best place for autofocus is at libv4l2. Putting it on a
> separate "video server" application looks really weird for me.

Well... let me see. libraries are quite limited -- it is hard to open
files, or use threads/have custom main loop. It may be useful to
switch resolutions -- do autofocus/autogain at lower resolution, then
switch to high one for taking picture. It would be good to have that
in "system" code, but I'm not at all sure libv4l2 design will allow
that.

It would be good if application could say "render live camera into
this window" and only care about user interface, then say "give me a
high resolution jpeg". But that would require main loop in the
library...

It would be nice if more than one application could be accessing the
camera at the same time... (I.e. something graphical running preview
then using command line tool to grab a picture.) This one is
definitely not solveable inside a library...

> Btw, libv4l2 already has some autotools for auto gain and auto
> white balance. See the implementation under:
> 	lib/libv4lconvert/processing
>=20
> The libv4l internal controls can be seen at:
> 	lib/libv4lconvert/control/libv4lcontrol.h
>=20
> The ones implemented by the processing part of the library are:

Thanks for pointer, will take a look.

> > Now, this is in no way clean or complete,
> > and functionality provided by sdl.c and asciicam.c probably _should_
> > be in application, but... I'd like to get the code out there.
> >=20
> > Oh and yes, I've canibalized decode_tm6000.c application instead of
> > introducing my own. Autotools scare me, sorry.
>=20
> Why replace decode_tm6000.c by something else? If you want to add another
> test application, just place it on a new file.

Scary scary scary autotools ;-). Yes, I did rather lot of hacks, as
you noted below. I do development on n900, so not everything is easy.

> I added a few notes together with the code, pointing the main things
> I think it require changes, in order for me to do a better review
> at the code. I didn't test nor tried to check the algorithms inside,
> as the code, on its current state, requires rework and code cleanup.

Thanks, I'll take a look.

> Please don't add a new application under lib/. It is fine if you want
> some testing application, if the ones there aren't enough, but please
> place it under contrib/test/.
>=20
> You should likely take a look at v4l2grab first, as it could have
> almost everything you would need.

Will take a look, thanks for pointer.

> IMHO, it would be better to use aalib. Btw, xawtv3 has a code example
> using it, under:
> 	console/ttv.c
>=20
> As it already uses libv4l, prhaps you could use it, instead of adding
> a new ascii app.

No need to duplicate it, then. I was trying to quickly test video
works, this was before SDL.

> > +#include "sdl.c"
> > +
> > +static struct sdl sdl;
> > +
> > +int v4l2_get_index(int fd);
> > +void my_main(void);
> > +
>=20
> The above looks really odd. Why do you want to make libv4l2 dependent
> on sdl?

I don't, but I had some nasty problems with linker; this should really
go into application but it refused to link. Scary libtool.

> > +static void v4l2_histogram(unsigned char *buf, int cdf[], struct v4l2_=
format *fmt)
> > +{
> > +    for (int y =3D 0; y < fmt->fmt.pix.height; y+=3D19)
> > +      for (int x =3D 0; x < fmt->fmt.pix.width; x+=3D19) {
> > +	pixel p =3D buf_pixel(fmt, buf, x, y);
> > +=09
> > +	int b;
> > +	/* HACK: we divide green by 2 to have nice picture, undo it here. */
> > +	b =3D p.r + 2*p.g + p.b;
> > +	b =3D (b * BUCKETS)/(256);
> > +	cdf[b]++;
> > +      }
> > +}
> > +
> > +static long v4l2_sharpness(unsigned char *buf, struct v4l2_format *fmt)
> > +{
> > +  int h =3D fmt->fmt.pix.height;
> > +  int w =3D fmt->fmt.pix.width;
> > +  long r =3D 0;
> > +
> > +    for (int y =3D h/3; y < h-h/3; y+=3Dh/9)
> > +      for (int x =3D w/3; x < w-w/3; x++) {
> > +	pixel p1 =3D buf_pixel(fmt, buf, x, y);
> > +	pixel p2 =3D buf_pixel(fmt, buf, x+2, y);
> > +=09
> > +	int b1, b2;
> > +	/* HACK: we divide green by 2 to have nice picture, undo it here. */
> > +	b1 =3D p1.r + 2*p1.g + p1.b;
> > +	b2 =3D p2.r + 2*p2.g + p2.b;
> > +
> > +	int v;
> > +	v =3D (b1-b2)*(b1-b2);
> > +	if (v > 36)
> > +		r+=3Dv;
> > +      }
> > +
> > +    return r;
> > +}
>=20
> IMO, the above belongs to a separate processing module under
> 	lib/libv4lconvert/processing/

I guess so.

> > +
> > +int v4l2_set_exposure(int fd, int exposure)
> > +{
> > +	int index =3D v4l2_get_index(fd);
> > +
> > +	if (index =3D=3D -1 || devices[index].convert =3D=3D NULL) {
> > +		V4L2_LOG_ERR("v4l2_set_exposure called with invalid fd: %d\n", fd);
> > +		errno =3D EBADF;
> > +		return -1;
> > +	}
> > +
> > +	struct v4l2_control ctrl;
> > +	ctrl.id =3D V4L2_CID_EXPOSURE;
> > +	ctrl.value =3D exposure;
> > +	if (ioctl(devices[index].subdev_fds[0], VIDIOC_S_CTRL, &ctrl) < 0) {
> > +	  printf("Could not set exposure\n");
> > +	}
> > +	return 0;
> > +}
>=20
> Shouldn't it be together with lib/libv4lconvert/processing/autogain.c,
> perhaps as an alternative implementation, if what's there is not
> enough?

I'll take a look, thanks.

> > @@ -823,6 +1246,10 @@ int v4l2_close(int fd)
> >  {
> >  	int index, result;
> > =20
> > +	if (fd =3D=3D -2) {
> > +	  my_main();
> > +	}
> > +
>=20
> That looks a hack!

That is _the_ hack ;-). Yes, agreed, need to look at
processing/. .. when I get time.


> > +#include <SDL2/SDL.h>
> > +#include <SDL2/SDL_image.h>
>=20
> If you're adding a SDL-specific application, you'll need to add the=20
> needed autoconf bits to detect if SDL devel package is installed,
> auto-disabling it if not.
>=20
> Yet, I don't think that SDL should be part of the library, but,
> instead, part of some application.

Agreed. libtool prevented me from doing the right thing.

> > index 4bffbdd..fda7e3b 100644
> > --- a/utils/decode_tm6000/decode_tm6000.c
> > +++ b/utils/decode_tm6000/decode_tm6000.c
>=20
> Everything below it is completely wrong!

And most of the stuff above is, too :-). I wanted to get the code out
in case I won't have time...

Thanks,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlj+bioACgkQMOfwapXb+vKUIgCdGQtHLhpVXoRHt/OjNsEWXser
030AlRZ103BUBMNDwQqwn6NiYKvyy7A=
=wDus
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
