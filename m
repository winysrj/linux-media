Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35663 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752005AbeFFUhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 16:37:15 -0400
Date: Wed, 6 Jun 2018 22:37:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606203713.GA10491@amd>
References: <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
 <20180319095544.7e235a3e@vento.lan>
 <20180515200117.GA21673@amd>
 <20180515190314.2909e3be@vento.lan>
 <20180602210145.GB20439@amd>
 <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
 <20180606084612.GB18743@amd>
 <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
 <20180606105116.GA4328@amd>
 <CAAFQd5Cy+77D-hr1k7QVrxaGhsGqM8rrqCKAk9Z+GoHEG=Q_mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <CAAFQd5Cy+77D-hr1k7QVrxaGhsGqM8rrqCKAk9Z+GoHEG=Q_mw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Thanks for thread pointer... I may be able to get in using hangouts.
> >
> > Anyway, there's big difference between open("/dev/video0") and
> > v4l2_open("/dev/video0"). I don't care about the first one, but yes we
> > should be able to support the second one eventually.
> >
> > And I don't think Mauro says apps like Camorama are of open() kind.
>=20
> I don't think there is much difference between open() and v4l2_open(),
> since the former can be changed to the latter using LD_PRELOAD.

Well, if everyone thinks opening more than one fd in v4l2_open() is
okay, I can do that. Probably "if argument is regular file and has .mc
extension, use open_complex"? =20

> If we simply add v4l2_open_complex() to libv4l, we would have to get
> developers of the applications (regardless of whether they use open()
> or v4l2_open()) to also support v4l2_open_complex(). For testing
> purposes of kernel developers it would work indeed, but I wonder if it
> goes anywhere beyond that.

I'd like people to think "is opening multiple fds okay at this
moment?" before switching to v4l2_open_complex(). But I guess I'm too caref=
ul.

> If all we need is some code to be able to test kernel camera drivers,
> I don't think there is any big problem in adding v4l2_open_complex()
> to libv4l. However, we must either ensure that either:
> a) it's not going to be widely used
> OR
> b) it is designed well enough to cover the complex cases I mentioned
> and which are likely to represent most of the hardware in the wild.

=2Emc descriptors should be indeed extensible enough for that.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsYRfkACgkQMOfwapXb+vLmoACgvAHHS3j0GrgpnbjucLg8YuSE
R60AoKnSuFFUoop6ha8ReSoQODdOniPz
=3AkM
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
