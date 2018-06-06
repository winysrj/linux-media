Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36757 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752094AbeFFV1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 17:27:31 -0400
Date: Wed, 6 Jun 2018 23:27:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Tomasz Figa <tfiga@chromium.org>, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606212728.GB10491@amd>
References: <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
 <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
 <20180606084612.GB18743@amd>
 <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
 <20180606100150.GA32299@amd>
 <20180606135620.38668a3f@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20180606135620.38668a3f@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > I don't think that kind of legacy apps is in use any more. I'd pref=
er
> > > > not to deal with them. =20
> > >=20
> > > In another thread ("[ANN v2] Complex Camera Workshop - Tokyo - Jun,
> > > 19"), Mauro has mentioned a number of those:
> > >=20
> > > "open source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) a=
nd closed
> > > source ones (Skype, Chrome, ...)" =20
> >=20
> > Yep, ok. Still would prefer not to deal with them.
>=20
> I guess we'll end by needing to handle them. Anyway, now that PCs are
> starting to come with complex cameras[1], we'll need to address this
> with a focus on adding support for existing apps.
>=20
> [1] we had a report from one specific model but I heard from a reliable
> source that there are already other devices with similar issues.

Well, now that the issue hit PCs, we'll get help from Linux distributors.

> > (Opening additional fds behind application's back is quite nasty,
> > those apps should really switch to v4l2_ variants).
>=20
> Only closed source apps use the LD_PRELOAD hack. All the others
> use v4l2_ variants, but, as Nicolas mentioned at the other
> thread, there are a number of problems with the current approach.
>=20
> Perhaps is time for us to not be limited to the current ABI, writing
> a new API from scratch, and then adding a compatibility layer to be
> used by apps that rely on v4l2_ variants, in order to avoid breaking
> the ABI and keep providing LD_PRELOAD. We can then convert the apps
> we use/care most to use the new ABI.

I believe we can support current features using existing libv4l2 abi
-- complex cameras should work as well as dumb ones do.

=2E..something like that is certainly needed for testing.

But yes, long-term better interface is needed -- and code should not
be in library but in separate process.

> > Application ready to deal with additional fds being
> > opened. contrib/test/sdlcam will be the first one.
> >=20
> > We may do some magic to do v4l2_open_complex() in v4l2_open(), but I
> > believe that should be separate step.
>=20
> In order to avoid breaking the ABI for existing apps, v4l2_open() should
> internally call v4l2_open_complex() (or whatever we call it at the new
> API design).

Ok... everyone wants that. I can do that.

> > Ok, so... statistics support would be nice, but that is really
> > separate problem.
> >=20
> > v4l2 already contains auto-exposure and auto-white-balance. I have
> > patches for auto-focus. But hardware statistics are not used.
>=20
> Feel free to submit the auto-focus patches anytime. With all 3A
> algos there (even on a non-optimal way using hw stats), it will
> make easier for us when designing a solution that would work for
> both IMAP3 and ISP (and likely be generic enough for other hardware).

Let me finish the control propagation, first. My test hardware
supporting autofocus is N900, so I need control propagation to be able
to test autofocus.

> > Secondary use case is taking .jpg photos using sdlcam.
>=20
> If a v4l2_complex_open() will, for now, be something that we don't
> export publicly, using it only for the tools already at libv4l2,
> I don't see much troubles on adding it, but I would hate to have to
> stick with this ABI. Otherwise, we should analyze it after having
> a bigger picture. So, better to wait for the Complex Camera
> Workshop before adding this.
>=20
> Btw, would you be able to join us there (either locally or
> remotely via Google Hangouts)?

I don't plan going to Japan. Hangouts... I'm not big fan of Google,
but I'll try. I'm in GMT+2.

> > Test apps such as qv4l2 would be nice to have, and maybe I'll
> > experiment with capturing video somehow one day. I'm pretty sure it
> > will not be easy.
>=20
> Capture video is a must have for PCs. The final solution should
> take it into account.

N900 is quite slow for JPEG compression (and I don't really want
solution depending on hardware extras like DSP)... so that will be
fun.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsYUcAACgkQMOfwapXb+vLYQACfR+W3KeBeGGnKuwNPDG/eve27
dH0AoIoVnAlBe5U4h0fojdSizex/j2od
=kbKa
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
