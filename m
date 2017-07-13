Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47541 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdGMJtp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 05:49:45 -0400
Date: Thu, 13 Jul 2017 11:49:42 +0200
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
Subject: Re: [patch] propagating controls in libv4l2 was Re: support
 autofocus / autogain in libv4l2
Message-ID: <20170713094942.GE1363@amd>
References: <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="so9zsI5B81VjUb/o"
Content-Disposition: inline
In-Reply-To: <20170426081330.6ca10e42@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--so9zsI5B81VjUb/o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Now. There is autogain support in libv4lconvert, but it expects to use
> > same fd for camera and for the gain... which does not work with
> > subdevs.
> >=20
> > Of course, opening subdevs by name like this is not really
> > acceptable. But can you suggest a method that is?
>=20
> There are two separate things here:
>=20
> 1) Autofoucs for a device that doesn't use subdev API
> 2) libv4l2 support for devices that require MC and subdev API
>=20
> for (1), it should use the /dev/videoX device that was opened with
> v4l2_open().
>=20
> For (2), libv4l2 should be aware of MC and subdev APIs. Sakari
> once tried to write a libv4l2 plugin for OMAP3, but never finished it.
> A more recent trial were to add a libv4l2 plugin for Exynos.
> Unfortunately, none of those code got merged. Last time I checked,
> the Exynos plugin was almost ready to be merged, but Sakari asked
> some changes on it. The developer that was working on it got job on
> some other company. Last time I heard from him, he was still interested
> on finishing his work, but in the need to setup a test environment
> using his own devices.

First... we should not have hardware-specific code in the
userspace. Hardware abstraction should be kernel's job.

Second... we really should solve "ioctl propagation" in
libv4l2. Because otherwise existing userspace is unusable in MC/subdev
drivers.

> IMHO, the right thing to do with regards to autofocus is to
> implement it via a processing module, assuming that just one
> video device is opened.

Ok, I have done that.

> The hole idea is that a libv4l2 client, running on a N900 device
> would just open a fake /dev/video0. Internally, libv4l2 will
> open whatever video nodes it needs to control the device, exporting
> all hardware capabilities (video formats, controls, resolutions,
> etc) as if it was a normal V4L2 camera, hiding all dirty details
> about MC and subdev APIs from userspace application.
>=20
> This way, a normal application, like xawtv, tvtime, camorama,
> zbar, mplayer, vlc, ... will work without any changes.

Well, yes, we'd like to get there eventually. But we are not there at
the moment, and ioctl() propagation is one of the steps.

(I do have support specific for N900, but currently it is in python;
this is enough to make the camera usable.)

Regards,
								Pavel

							=09
> > diff --git a/lib/libv4l2/libv4l2-priv.h b/lib/libv4l2/libv4l2-priv.h
> > index 343db5e..a6bc48e 100644
> > --- a/lib/libv4l2/libv4l2-priv.h
> > +++ b/lib/libv4l2/libv4l2-priv.h
> > @@ -26,6 +26,7 @@
> >  #include "../libv4lconvert/libv4lsyscall-priv.h"
> > =20
> >  #define V4L2_MAX_DEVICES 16
> > +#define V4L2_MAX_SUBDEVS 8
> >  /* Warning when making this larger the frame_queued and frame_mapped m=
embers of
> >     the v4l2_dev_info struct can no longer be a bitfield, so the code n=
eeds to
> >     be adjusted! */
> > @@ -104,6 +105,7 @@ struct v4l2_dev_info {
> >  	void *plugin_library;
> >  	void *dev_ops_priv;
> >  	const struct libv4l_dev_ops *dev_ops;
> > +        int subdev_fds[V4L2_MAX_SUBDEVS];
> >  };
> > =20
> >  /* From v4l2-plugin.c */
> > diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> > index 0ba0a88..edc9642 100644
> > --- a/lib/libv4l2/libv4l2.c
> > +++ b/lib/libv4l2/libv4l2.c
> > @@ -1,3 +1,4 @@
> > +/* -*- c-file-style: "linux" -*- */
> >  /*
> >  #             (C) 2008 Hans de Goede <hdegoede@redhat.com>
> > =20
> > @@ -789,18 +790,25 @@ no_capture:
> > =20
> >  	/* Note we always tell v4lconvert to optimize src fmt selection for
> >  	   our default fps, the only exception is the app explicitly selecting
> > -	   a fram erate using the S_PARM ioctl after a S_FMT */
> > +	   a frame rate using the S_PARM ioctl after a S_FMT */
> >  	if (devices[index].convert)
> >  		v4lconvert_set_fps(devices[index].convert, V4L2_DEFAULT_FPS);
> >  	v4l2_update_fps(index, &parm);
> > =20
> > +	devices[index].subdev_fds[0] =3D SYS_OPEN("/dev/video_sensor", O_RDWR=
, 0);
> > +	devices[index].subdev_fds[1] =3D SYS_OPEN("/dev/video_focus", O_RDWR,=
 0);
> > +	devices[index].subdev_fds[2] =3D -1;
> > +
> > +	printf("Sensor: %d, focus: %d\n", devices[index].subdev_fds[0],=20
> > +	       devices[index].subdev_fds[1]);
> > +
> >  	V4L2_LOG("open: %d\n", fd);
> > =20
> >  	return fd;
> >  }
> > =20
> >  /* Is this an fd for which we are emulating v4l1 ? */
> > -static int v4l2_get_index(int fd)
> > +int v4l2_get_index(int fd)
> >  {
> >  	int index;
> > =20
> >=20
> > commit 1d6a9ce121f53e8f2e38549eed597a3c3dea5233
> > Author: Pavel <pavel@ucw.cz>
> > Date:   Wed Apr 26 12:34:04 2017 +0200
> >=20
> >     Enable ioctl propagation.
> >=20
> > diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
> > index edc9642..6dab661 100644
> > --- a/lib/libv4l2/libv4l2.c
> > +++ b/lib/libv4l2/libv4l2.c
> > @@ -1064,6 +1064,23 @@ static int v4l2_s_fmt(int index, struct v4l2_for=
mat *dest_fmt)
> >  	return 0;
> >  }
> > =20
> > +static int v4l2_propagate_ioctl(int index, unsigned long request, void=
 *arg)
> > +{
> > +	int i =3D 0;
> > +	int result;
> > +	while (1) {
> > +		if (devices[index].subdev_fds[i] =3D=3D -1)
> > +			return -1;
> > +		printf("g_ctrl failed, trying...\n");
> > +		result =3D SYS_IOCTL(devices[index].subdev_fds[i], request, arg);
> > +		printf("subdev %d result %d\n", i, result);
> > +		if (result =3D=3D 0)
> > +			return 0;
> > +		i++;
> > +	}
> > +	return -1;
> > +}
> > +
> >  int v4l2_ioctl(int fd, unsigned long int request, ...)
> >  {
> >  	void *arg;
> > @@ -1193,14 +1210,20 @@ no_capture_request:
> >  	switch (request) {
> >  	case VIDIOC_QUERYCTRL:
> >  		result =3D v4lconvert_vidioc_queryctrl(devices[index].convert, arg);
> > +		if (result =3D=3D -1)
> > +			result =3D v4l2_propagate_ioctl(index, request, arg);
> >  		break;
> > =20
> >  	case VIDIOC_G_CTRL:
> >  		result =3D v4lconvert_vidioc_g_ctrl(devices[index].convert, arg);
> > +		if (result =3D=3D -1)
> > +			result =3D v4l2_propagate_ioctl(index, request, arg);
> >  		break;
> > =20
> >  	case VIDIOC_S_CTRL:
> >  		result =3D v4lconvert_vidioc_s_ctrl(devices[index].convert, arg);
> > +		if (result =3D=3D -1)
> > +			result =3D v4l2_propagate_ioctl(index, request, arg);
> >  		break;
> > =20
> >  	case VIDIOC_G_EXT_CTRLS:
> >=20
> >=20
>=20
>=20
>=20
> Thanks,
> Mauro

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--so9zsI5B81VjUb/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllnQjYACgkQMOfwapXb+vIWbwCgpBqPTsNDLyjisbob9JbGHHTo
xi4An0WKQuhcE6I4ZAPJEvYo6vAmR11M
=USbT
-----END PGP SIGNATURE-----

--so9zsI5B81VjUb/o--
