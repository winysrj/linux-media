Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44193 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752241AbdEMLIK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 May 2017 07:08:10 -0400
Date: Sat, 13 May 2017 13:08:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170513110807.GA16170@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170512104930.GJ3227@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20170512104930.GJ3227@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > Nevertheless, V4L2_CID_FOCUS_ABSOLUTE
> > > is documented as follows (emphasis mine):
> > >=20
> > > 	This control sets the *focal point* of the camera to the specified
> > > 	position. The unit is undefined. Positive values set the focus
> > > 	closer to the camera, negative values towards infinity.
> > >=20
> > > What you control in voice coil devices is current (in Amp=E8res) and =
the
> > > current only has a relatively loose relation to the focal point.
> >=20
> > The real problem I'm seeing here is that this control is already
> > used by voice coil motor (VCM). Several UVC-based Logitech cameras
> > come with VCM, like their QuickCam Pro-series webcams:
> >=20
> > 	https://secure.logitech.com/en-hk/articles/3231
> >=20
> > The voice coil can be seen on this picture:
> > 	https://photo.stackexchange.com/questions/48678/can-i-modify-a-logitec=
h-c615-webcam-for-infinity-focus
>=20
> There may be voice coil lens implementations that are indirectly controll=
ed
> through this control. Those are hardware solutions that have been taken in
> UVC webcams, for instance. The UVC standard itself uses millimeters.
>=20
> Lens systems based on voice coils generally cannot focus at a given exact
> distance for they have no concept of focussing at a particular distance.
> Instead, an auto focus algorithm analyses the image data (or statistics of
> image data) to control the lens --- in other words, to set current, not
> distance.

Well, you are right that voice coil does not focus on _exact_
distance. I guess nothing ever focuses on _exact_ distance ;-). (Ok,
voice coils may be worse then other systems.)

> As the auto focus algorithms require both image data (or statistics) and
> access to lens voice coil as well as for algorithmic complexity, they are
> typically implemented in user space.
>=20
> In other words, the VOICE_COIL_CURRENT control is thus used by user space=
 to
> implement what the user expects from FOCUS_AUTO control. It could be
> implemented in libv4l2 or a different user space component.
> VOICE_COIL_CURRENT control is not a control which is expected to be used =
by
> an end user application --- unlike FOCUS_AUTO.

End user application definitely _wants_ to control voice coil control
directly. Original Maemo application has landscape-mode, which
presumably just sets control to infinity. FCam application has full
manual focus. I'm writing SDLcam, it also has manual focus.

N900 camera has depth of field of 2 diopters. That means you can have
everything from 0.5m to infinity in focus... At normal range manual
focus makes a lot of sense. At macro range, yes, autofocus is needed.

Applications want to know focus in diopters... user wants to
know. Even when autofocus is active, it is good to know where the
camera is focused to monitor its progress.

> Additionally, there will be controls related to ringing compensation. The
> user (for an auto focus algorithm) still might want to disable the hardwa=
re
> ringing compensation so a menu control would be needed for the purpose.
> That's something that can well be addressed later on, just FYI.

Well, I don't see why we can't add ringing compensation controls to
the FOCUS_ABSOLUTE. Yes, userspace should know that it is the voice
coil. But userspace should be also able to get/set approximate focus
distance (diopters).

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkW6RYACgkQMOfwapXb+vIm6gCgo+iMOhrCp7shnz+9YjLQ/IE0
3BYAnAlU7IF+Yz2k2JOGRpr1+Wm/Nfvr
=K6KK
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
