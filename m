Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56921 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932300AbeCSMs5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:48:57 -0400
Date: Mon, 19 Mar 2018 13:48:55 +0100
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
Message-ID: <20180319124855.GA18886@amd>
References: <c4f61bc5-6650-9468-5fbf-8041403a0ef2@xs4all.nl>
 <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> I really want to work with you on this, but I am not looking for parti=
al
> >> solutions.
> >=20
> > Well, expecting design to be done for opensource development is a bit
> > unusual :-).
>=20
> Why? We have done that quite often in the past. Media is complex and you =
need
> to decide on a design up front.



> > I really see two separate tasks
> >=20
> > 1) support for configuring pipeline. I believe this is best done out
> > of libv4l2. It outputs description file, format below. Currently I
> > have implemented this is in Python. File format is below.
>=20
> You do need this, but why outside of libv4l2? I'm not saying I disagree
> with you, but you need to give reasons for that.

I'd prefer to do this in Python. There's a lot to configure there, and
I'm not sure if libv4l2 is is right place for it. Anyway, design of 2)
does not depend on this.

> > 2) support for running libv4l2 on mc-based devices. I'd like to do
> > that.
> >=20
> > Description file would look like. (# comments would not be not part of =
file).
> >=20
> > V4L2MEDIADESC
> > 3 # number of files to open
> > /dev/video2
> > /dev/video6
> > /dev/video3
>=20
> This won't work. The video nodes numbers (or even names) can change.
> Instead these should be entity names from the media controller.

Yes, it will work. 1) will configure the pipeline, and prepare
V4L2MEDIADESC file. The device names/numbers are stable after the
system is booted.

If these were entity names, v4l2_open() would have to go to /sys and
search for corresponding files... which would be rather complex and
slow.

> > 3 # number of controls to map. Controls not mentioned here go to
> >   # device 0 automatically. Sorted by control id.
> >   # Device 0=20
> > 00980913 1
> > 009a0003 1
> > 009a000a 2
>=20
> You really don't need to specify the files to open. All you need is to
> specify the entity ID and the list of controls that you need.
>=20
> Then libv4l can just figure out which device node(s) to open for
> that.

Yes, but that would slow down v4l2_open() needlessly. I'd prefer to
avoid that.

> > We can parse that easily without requiring external libraries. Sorted
> > data allow us to do binary search.
>=20
> But none of this addresses setting up the initial video pipeline or
> changing formats. We probably want to support that as well.

Well, maybe one day. But I don't believe we should attempt to support
that today.

Currently, there's no way to test that camera works on N900 with
mainline v4l2... which is rather sad. Advanced use cases can come later.

> For that matter: what is it exactly that we want to support? I.e. where do
> we draw the line?

I'd start with fixed format first. Python prepares pipeline, and
provides V4L2MEDIADESC file libv4l2 can use. You can have that this
week.

I guess it would make sense to support "application says preffered
resolution, libv4l2 attempts to set up some kind of pipeline to get
that resolution", but yes, interface there will likely be quite
complex.

Media control is more than 5 years old now. libv4l2 is still
completely uses on media control-based devices, and people are asking
for controls propagation in the kernel to fix that. My proposol
implements simple controls propagation in the userland. I believe we
should do that.

> A good test platform for this (outside the N900) is the i.MX6 platform.

Do you have one?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqvsbcACgkQMOfwapXb+vIblgCfUfvwLVoFYmAO9WRxWdiu4e14
NdIAn3Q99K8qoXINLtf6pieSOGHQNc3r
=xxrj
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
