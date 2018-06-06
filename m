Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45277 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932428AbeFFKvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 06:51:18 -0400
Date: Wed, 6 Jun 2018 12:51:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606105116.GA4328@amd>
References: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
 <20180319120043.GA20451@amd>
 <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
 <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
 <20180606084612.GB18743@amd>
 <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI!

> > > Thanks for coming up with this proposal. Please see my comments below.
> > >
> > > > Ok, can I get any comments on this one?
> > > > v4l2_open_complex("/file/with/descriptor", 0) can be used to open
> > > > whole pipeline at once, and work if it as if it was one device.
> > >
> > > I'm not convinced if we should really be piggy backing on libv4l, but
> > > it's just a matter of where we put the code added by your patch, so
> > > let's put that aside.
> >
> > There was some talk about this before, and libv4l2 is what we came
> > with. Only libv4l2 is in position to propagate controls to right
> > devices.
> >
> > > Who would be calling this function?
> > >
> > > The scenario that I could think of is:
> > > - legacy app would call open(/dev/video?), which would be handled by
> > > libv4l open hook (v4l2_open()?),
> >
> > I don't think that kind of legacy apps is in use any more. I'd prefer
> > not to deal with them.
>=20
> In another thread ("[ANN v2] Complex Camera Workshop - Tokyo - Jun,
> 19"), Mauro has mentioned a number of those:
>=20
> "open source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and c=
losed
> source ones (Skype, Chrome, ...)"

Thanks for thread pointer... I may be able to get in using hangouts.

Anyway, there's big difference between open("/dev/video0") and
v4l2_open("/dev/video0"). I don't care about the first one, but yes we
should be able to support the second one eventually.

And I don't think Mauro says apps like Camorama are of open() kind.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsXvKQACgkQMOfwapXb+vLV/gCfYQ992IPW3zRvLE5ZqohCvxDb
3O0AoKoVK/7VmDEV9XfxcdzgHx582xtb
=jCWR
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
