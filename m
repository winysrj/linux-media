Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60160 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdJVIb7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Oct 2017 04:31:59 -0400
Date: Sun, 22 Oct 2017 10:31:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: Camera support, Prague next week, sdlcam
Message-ID: <20171022083157.GA27581@amd>
References: <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426082608.7dd52fbf@vento.lan>
 <20171021220026.GA26881@amd>
 <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <f85cab54-30cf-0774-7376-abced86842af@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > I'd still like to get some reasonable support for cellphone camera in
> > Linux.
> >=20
> > IMO first reasonable step is to merge sdlcam, then we can implement
> > autofocus, improve autogain... and rest of the boring stuff. Ouch and
> > media graph support would be nice. Currently, _nothing_ works with
> > media graph device, such as N900.
>=20
> Can you post your latest rebased patch for sdlcam for v4l-utils?
>=20
> I'll do a review and will likely merge it for you. Yes, I've changed my
> mind on that.

Ok, will do, thanks!

> > I'll talk about the issues at ELCE in few days:
> >=20
> > https://osseu17.sched.com/event/ByYH/cheap-complex-cameras-pavel-machek=
-denx-software-engineering-gmbh
> >=20
> > Will someone else be there? Is there some place where v4l people meet?
>=20
> Why don't we discuss this Tuesday morning at 9am? I have no interest in t=
he
> keynotes on that day, so those who are interested can get together.
>=20
> I'll be at your presentation tomorrow and we can discuss a bit during
> the following coffee break if time permits.

Ok, sounds like a plan. Lets confirm Tuesday morning tommorow.

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnsV30ACgkQMOfwapXb+vLcLQCfUXx5HVuWUKwV6svMxfLw2XaG
KssAoIhoEc2H3xhMWiG1AdCTJazMeOKJ
=CzlX
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
