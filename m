Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43219 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbeFFKBy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 06:01:54 -0400
Date: Wed, 6 Jun 2018 12:01:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tomasz Figa <tfiga@chromium.org>
Cc: mchehab+samsung@kernel.org, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606100150.GA32299@amd>
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
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

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

Yep, ok. Still would prefer not to deal with them.

(Opening additional fds behind application's back is quite nasty,
those apps should really switch to v4l2_ variants).

> > > - v4l2_open() would check if given /dev/video? figures in its list of
> > > complex pipelines, for example by calling v4l2_open_complex() and
> > > seeing if it succeeds,
> >
> > I'd rather not have v4l2_open_complex() called on devices. We could
> > test if argument is regular file and then call it... But again, that's
> > next step.
> >
> > > - if it succeeds, the resulting fd would represent the complex
> > > pipeline, otherwise it would just open the requested node directly.
>=20
> What's the answer to my original question of who would be calling
> v4l2_open_complex(), then?

Application ready to deal with additional fds being
opened. contrib/test/sdlcam will be the first one.

We may do some magic to do v4l2_open_complex() in v4l2_open(), but I
believe that should be separate step.

> > >  - handling metadata CAPTURE and OUTPUT buffers controlling the 3A
> > > feedback loop - this might be optional if all we need is just ability
> > > to capture some frames, but required for getting good quality,
> > >  - actually mapping legacy controls into the above metadata,
> >
> > I'm not sure what 3A is. If you mean hardware histograms and friends,
> > yes, it would be nice to support that, but, again, statistics can be
> > computed in software.
>=20
> Auto-exposure, auto-white-balance, auto-focus. In complex camera
> subsystems these need to be done in software. On most hardware
> platforms, ISP provides necessary input data (statistics) and software
> calculates required processing parameters.

Ok, so... statistics support would be nice, but that is really
separate problem.

v4l2 already contains auto-exposure and auto-white-balance. I have
patches for auto-focus. But hardware statistics are not used.

> > Yes, we'll need something more advanced.
> >
> > But.. we also need something to run the devices today, so that kernel
> > drivers can be tested and do not bitrot. That's why I'm doing this
> > work.
>=20
> I guess the most important bit I missed then is what is the intended
> use case for this. It seems to be related to my earlier, unanswered
> question about who would be calliing v4l2_open_complex(), though.
>=20
> What userspace applications would be used for this testing?

Main use case is kernel testing.

Secondary use case is taking .jpg photos using sdlcam.

Test apps such as qv4l2 would be nice to have, and maybe I'll
experiment with capturing video somehow one day. I'm pretty sure it
will not be easy.

Oh and I guess a link to how well it works? See
https://www.youtube.com/watch?v=3DfH6zuK2OOVU .

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsXsQ4ACgkQMOfwapXb+vL2OACffTo29PgatISAO9x/ENv6c4Xj
yH8AoKUVtdLNRwPALlmdGmbPsBVP4J70
=JPd2
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
