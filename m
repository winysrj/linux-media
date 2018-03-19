Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45983 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936367AbeCSWSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 18:18:46 -0400
Date: Mon, 19 Mar 2018 23:18:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180319221844.GB2057@amd>
References: <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319124855.GA18886@amd>
 <a1acc1c7-69df-3b74-16c0-8e7868786559@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <a1acc1c7-69df-3b74-16c0-8e7868786559@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>> V4L2MEDIADESC
> >>> 3 # number of files to open
> >>> /dev/video2
> >>> /dev/video6
> >>> /dev/video3
> >>
> >> This won't work. The video nodes numbers (or even names) can change.
> >> Instead these should be entity names from the media controller.
> >=20
> > Yes, it will work. 1) will configure the pipeline, and prepare
> > V4L2MEDIADESC file. The device names/numbers are stable after the
> > system is booted.
>=20
> No, they are not. Drivers can be unloaded and reloaded, thus changing
> the device nodes. The media device will give you the right major/minor
> numbers and with libudev you can find the corresponding device node.
> That's the right approach.

Well, yes, drivers can be unloaded and reloaded. But at that point
pipeline will need to be set up again, so we'll get new V4L2MEDIADESC
file.

> > Yes, but that would slow down v4l2_open() needlessly. I'd prefer to
> > avoid that.
>=20
> It should be quite fast. BTW, v4l2-ctl has code to find the media device
> node for a given video node.

Ok, I'll take a look, but I'd still prefer fast & simple.

> >> For that matter: what is it exactly that we want to support? I.e. wher=
e do
> >> we draw the line?
> >=20
> > I'd start with fixed format first. Python prepares pipeline, and
> > provides V4L2MEDIADESC file libv4l2 can use. You can have that this
> > week.
>=20
> I'm not sure I want python. An embedded system might not have python
> installed. Also, if we need to parse the configuration file in libv4l
> (and I am 90% certain that that is what we need to do), then you don't
> want to call a python script from there.

No, I don't propose calling python from libv4l2.

I propose "separate component configures the pipeline, and writes
V4L2MEDIADESC file libv4l2 then uses to map controls to devices". For
me, that component is currently python. In embededded world, I guess
they could hard-code the config, or write it in whatever language they
prefer.

> > Media control is more than 5 years old now. libv4l2 is still
> > completely uses on media control-based devices, and people are asking
> > for controls propagation in the kernel to fix that. My proposol
> > implements simple controls propagation in the userland. I believe we
> > should do that.
>=20
> Your proposal implements one specific use-case. One piece of a
> larger puzzle.

Well, rather important piece, because it allows the complex cameras to
be used at all.

> >> A good test platform for this (outside the N900) is the i.MX6 platform.
> >=20
> > Do you have one?
>=20
> Yes. Although I would need to set it up, I still haven't done that.

Ok.

> But Steve Longerbeam is probably the right person to test this for you.
>=20
> What I have been thinking of (although never in any real detail) is that =
we
> probably want to have an application that is run from udev when a media d=
evice
> is created and that reads a config file and does an initial pipeline conf=
iguration.
>=20
> So once that's setup you should be able to do: 'v4l2-ctl --stream-mmap' a=
nd
> get video.
>=20
> Next, libv4l will also read the same configuration file and use it to pro=
vide
> a compatibility layer so applications that use libv4l will work better wi=
th
> MC devices. Part of that is indeed control handling.

Yep, that would be nice. And yes, control handling is important for
me.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqwN0QACgkQMOfwapXb+vK+OQCghq0y+DoA0ogiqoaumoH2uBM9
U1gAoJNkwHgBiTZegm3BGyR5KQln71MH
=ebcd
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
