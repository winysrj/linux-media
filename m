Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58943 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbeCTHu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 03:50:56 -0400
Date: Tue, 20 Mar 2018 08:50:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180320075054.GA30239@amd>
References: <20170516124519.GA25650@amd>
 <76e09f45-8f04-1149-a744-ccb19f36871a@xs4all.nl>
 <20180316205512.GA6069@amd>
 <c2a7e1f3-589d-7186-2a85-545bfa1c4536@xs4all.nl>
 <20180319102354.GA12557@amd>
 <20180319074715.5b700405@vento.lan>
 <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20180319095544.7e235a3e@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > 2) support for running libv4l2 on mc-based devices. I'd like to do
> > > that.
> > >=20
> > > Description file would look like. (# comments would not be not part o=
f file).
> > >=20
> > > V4L2MEDIADESC
> > > 3 # number of files to open
> > > /dev/video2
> > > /dev/video6
> > > /dev/video3 =20
>=20
> "Easy" file formats usually means maintenance troubles as new
> things are needed, and makes worse for users to write it.=20
> You should take a look at lib/libdvbv5/dvb-file.c, mainly at=20
> fill_entry() and dvb_read_file().

Well, file formats just need to be maintained.

> > Instead these should be entity names from the media controller.
>=20
> Agreed that it should use MC. Yet, IMHO, the best would be to use
> the entity function instead, as entity names might eventually
> change on newer versions of the Kernel.

Kernel interfaces are not supposed to be changing.

> (again, user may specify just name, just function or both)
>=20
> > > 3 # number of controls to map. Controls not mentioned here go to
> > >   # device 0 automatically. Sorted by control id.
> > >   # Device 0=20
> > > 00980913 1
> > > 009a0003 1
> > > 009a000a 2 =20
>=20
> I would, instead, encode it as:
>=20
> 	[control white balance]
> 		control_id =3D 0x00980913
> 		entity =3D foo_entity_name

Ok, that's really overly complex. If futrue extensibility is concern
we can do

0x00980913=3Dwhatever.

> Allowing both hexadecimal values and control macro names (can easily pars=
ed=20
> from the header file, as we already do for other things with "make
> sync").

"Easily" as in "more complex then rest of proposed code combined" :-(.

> It should probably be easy to add a generic pipeline descriptor
> with a format like:
>=20
> 	[pipeline pipe1]
> 		link0 =3D SGRBG10 640x480: entity1:0 -> entity2:0[1]
> 		link1 =3D SGRBG10 640x480: entity2:2-> entity3:0[1]
> 		link2 =3D UYVY 640x480: entity3:1-> entity4:0[1]
> 		link3 =3D UYVY 640x480: entity4:1-> entity5:0[1]
>=20
> 		sink0 =3D UYVY 320x200: entity5:0[1]
> 		sink1 =3D UYVY 640x480: entity3:0[1]

Well, first, this looks like very unsuitable for key=3Dvalue file. Plus,
it will not be easy to parse. .... and control map needs to be
per-pipeline-configuration. Again, proposed Windows-style format can
not easily do that.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqwvV0ACgkQMOfwapXb+vI6FQCfZnn9sxW/IYLl8JSYS93jxQHa
+X8An1ERZqtfpLmG5TDCO6uCg/HDWOoz
=Q6UJ
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
