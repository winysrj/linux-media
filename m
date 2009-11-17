Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:50863 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZKQUlP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 15:41:15 -0500
Received: by ywh6 with SMTP id 6so405983ywh.4
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 12:41:20 -0800 (PST)
Date: Tue, 17 Nov 2009 18:41:12 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: new sensor for a t613 camera
Message-ID: <20091117204112.GA27785@pathfinder.pcs.usp.br>
References: <20091113193405.GA9499@pathfinder.pcs.usp.br> <62e5edd40911131204w2b8203eexc079ae46d88f1d0d@mail.gmail.com> <20091113202746.GA24318@pathfinder.pcs.usp.br> <c2fe070d0911131235m2e7a5b66hfe6366b0bf4cca0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <c2fe070d0911131235m2e7a5b66hfe6366b0bf4cca0b@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello, people.

I did it! I looked at the log and modified the driver to support my
webcam. It's working!! I'm sending an image attached. :]

I'll clean up my code now, and submit a patch later. Help is
appreciated, because I don't have much experience contributing to
large projects...

This webcam is a very cheap one, quite easy to find these days. I
hope the support will be appreciated by many users.


See you,
   ++nicolau




On Fri, Nov 13, 2009 at 03:35:26PM -0500, leandro Costantino wrote:
> Hi Nicolau,
> Are you able to give me some usb traces?
> there's a little how to
> http://deaglecito.blogspot.com/2008/10/new-sensor-merge-faq-tascorp-17a10=
128.html
> here.
>=20
> I don't have too much time now, but i can take a look and made some
> changes to test and guide you.
>=20
> Best Regards
> Costantino Leandro
>=20
> On Fri, Nov 13, 2009 at 3:27 PM, Nicolau Werneck <nwerneck@gmail.com> wro=
te:
> > On Fri, Nov 13, 2009 at 09:04:23PM +0100, Erik Andr=E9n wrote:
> >> 2009/11/13 Nicolau Werneck <nwerneck@gmail.com>:
> >> > Hello.
> >> >
> >> > I bought me a new webcam. lsusb said me it was a 17a1:0128 device, f=
or
> >> > which the gspca_t613 module is available. But it did not recognize t=
he
> >> > sensor number, 0x0802.
> >> >
> >> > I fiddled with the driver source code, and just made it recognize it
> >> > as a 0x0803 sensor, called "others" in the code, and I did get images
> >> > from the camera. But the colors are extremely wrong, like the contra=
st
> >> > was set to a very high number. It's probably some soft of color
> >> > encoding gone wrong...
> >> >
> >> > How can I start hacking this driver to try to make my camera work
> >> > under Linux?
> >> >
> >>
> >> If possible you could open the camera to investigate if there is
> >> anything printed on the sensor chip. This might give you a clue to
> >> what sensor it is.
> >
> > Thanks for redirecting me.
> >
> > I opened it (So much for the warranty seal...), but there is just
> > huge black blob of goo over the chip, as usual these days.
> >
> > ++nicolau
> >
> > --
> > Nicolau Werneck <nwerneck@gmail.com> =A0 =A0 =A0 =A0 =A01AAB 4050 1999 =
BDFF 4862
> > http://www.lti.pcs.usp.br/~nwerneck =A0 =A0 =A0 =A0 =A0 4A33 D2B5 648B =
4789 0327
> > Linux user #460716
> >
> >
> > -----BEGIN PGP SIGNATURE-----
> > Version: GnuPG v1.4.9 (GNU/Linux)
> >
> > iEYEARECAAYFAkr9wUIACgkQ0rVki0eJAycSegCfRQyYN54CNH2thIo/PHBnVaL9
> > avAAoMe6ihIbvX23kM1ir2sJK32q6jxm
> > =3DHI4V
> > -----END PGP SIGNATURE-----
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Nicolau Werneck <nwerneck@gmail.com>          1AAB 4050 1999 BDFF 4862
http://www.lti.pcs.usp.br/~nwerneck           4A33 D2B5 648B 4789 0327
Linux user #460716


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksDCmgACgkQ0rVki0eJAyfs3QCeJz8skhHixReBoIShZeRiKafv
IQ0AoIi24OnTEPe77UUhw8U6RztAMsjO
=5NY4
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
