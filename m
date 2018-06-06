Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44207 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeFFKX3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 06:23:29 -0400
Date: Wed, 6 Jun 2018 12:23:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606102326.GB32299@amd>
References: <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
 <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +       while (lo < hi) {
> > +               int i =3D (lo + hi) / 2;
> > +               if (map->map[i].control =3D=3D control) {
> > +                       return map->map[i].fd;
> > +               }
> > +               if (map->map[i].control > control) {
> > +                       hi =3D i;
> > +                       continue;
> > +               }
> > +               if (map->map[i].control < control) {
> > +                       lo =3D i+1;
> > +                       continue;
> > +               }
> > +               printf("Bad: impossible condition in binary search\n");
> > +               exit(1);
> > +       }
>=20
> Could we use bsearch() here?

We could, but it will mean passing function pointers etc. It would
make sense if we want to do sorting.

> > @@ -1076,18 +1115,20 @@ int v4l2_ioctl(int fd, unsigned long int reques=
t, ...)
> >            ioctl, causing it to get sign extended, depending upon this =
behavior */
> >         request =3D (unsigned int)request;
> >
> > +       /* FIXME */
> >         if (devices[index].convert =3D=3D NULL)
> >                 goto no_capture_request;
> >
> >         /* Is this a capture request and do we need to take the stream =
lock? */
> >         switch (request) {
> > -       case VIDIOC_QUERYCAP:
> >         case VIDIOC_QUERYCTRL:
> >         case VIDIOC_G_CTRL:
> >         case VIDIOC_S_CTRL:
> >         case VIDIOC_G_EXT_CTRLS:
> > -       case VIDIOC_TRY_EXT_CTRLS:
> >         case VIDIOC_S_EXT_CTRLS:
> > +               is_subdev_request =3D 1;
> > +       case VIDIOC_QUERYCAP:
> > +       case VIDIOC_TRY_EXT_CTRLS:
>=20
> I'm not sure why we are moving those around. Is this perhaps related
> to the FIXME comment above? If so, it would be helpful to have some
> short explanation next to it.

I want to do controls propagation only on ioctls that manipulate
controls, so I need to group them together. The FIXME comment is not
related.

> >
> >         if (!is_capture_request) {
> > +         int sub_fd;
> >  no_capture_request:
> > +                 sub_fd =3D fd;
> > +               if (is_subdev_request) {
> > +                 sub_fd =3D v4l2_get_fd_for_control(index, ((struct v4=
l2_queryctrl *) arg)->id);
> > +               }
>=20
> nit: Looks like something weird going on here with indentation.

Fixed.

> > @@ -1782,3 +1828,195 @@ int v4l2_get_control(int fd, int cid)
> >                         (qctrl.maximum - qctrl.minimum) / 2) /
> >                 (qctrl.maximum - qctrl.minimum);
> >  }
> > +
> > +
>=20
> nit: Double blank line.

Fixed.

> > +               if (i>=3D1 && map->map[i].control <=3D map->map[i-1].co=
ntrol) {
> > +                       V4L2_LOG_ERR("v4l2_open_pipeline: Controls not =
sorted.\n");
> > +                       return -1;
>=20
> I guess we could just sort them at startup with qsort()?

We could... but I'd prefer them sorted on-disk, as it is written very
seldom, but needs to be readed on every device open.

Thanks for review,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsXth4ACgkQMOfwapXb+vI+fQCfT4RjJwEfWSdLJwBlLQeX/oCv
EQoAoJv065QVm7yQsLyYUqSDzFK60R+b
=h0Do
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
