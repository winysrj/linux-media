Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37256 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab2LNSQC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 13:16:02 -0500
Date: Fri, 14 Dec 2012 20:08:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>,
	Timo Kokkonen <timo.t.kokkonen@iki.fi>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/7] ir-rx51: Handle signals properly
Message-ID: <20121214180829.GA11582@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
 <1353251589-26143-2-git-send-email-timo.t.kokkonen@iki.fi>
 <20121120195755.GM18567@atomide.com>
 <20121214172809.GT4989@atomide.com>
 <20121214172616.GC9620@arwen.pp.htv.fi>
 <20121214174629.GV4989@atomide.com>
 <20121214174918.GA11029@arwen.pp.htv.fi>
 <20121214180645.GW4989@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20121214180645.GW4989@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 14, 2012 at 10:06:45AM -0800, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121214 09:59]:
> > On Fri, Dec 14, 2012 at 09:46:29AM -0800, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [121214 09:36]:
> > > >=20
> > > > if it's really for PWM, shouldn't we be using drivers/pwm/ ??
> > > >=20
> > > > Meaning that $SUBJECT would just request a PWM device and use it. T=
hat
> > > > doesn't solve the whole problem, however, as pwm-omap.c would still=
 need
> > > > access to timer-omap.h.
> > >=20
> > > That would only help with omap_dm_timer_set_pwm() I think.
> > >=20
> > > The other functions are also needed by the clocksource and clockevent
> > > drivers. And tidspbridge too:
> >=20
> > well, we _do_ have drivers/clocksource ;-)
>=20
> That's where the dmtimer code should live. But still it does not help
> with the header.

yeah, the header should be where you suggested, no doubts. I was
actually criticizing the current timer code.

cheers

--=20
balbi

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQy2sdAAoJEIaOsuA1yqREonQP/ihIj0ioTVx88CYVULy98Xqc
w1MCh2HjwXkw6XVSWUEpLM0EE6j/T8M0sNj3jCkpsa4+27o3ekjJZ5Z3Bbutze9H
NboHc38+MVWfANizzfU58VgB9PbUqr3btAZrSloieYrQu2A1tqkUMJ52WHapcNu2
LfTIVo5MXqyzEhjZkR/b6vUNKPUxze7eSQud0bG5JH391TT9pL6xG5X7aRiciqbN
Yxu3evBsEq8gRORiX+54z6sXuWrdaQ6r2RF8yVjojQwlJR2uSe8ALH0qFnkcPTeV
G46Nw20c47D0GQN2GlacWdfhy/wJw2F1GzFViOcJDMkOiiDH7gejUkA2bL6KR7h/
zkamCMwTMiPSAu/BwLlSIkhWYA2KM4HXFNrPaICx+R3KxQj0tqQLVkZ9po87Kmal
6TBSw/1HCnE6K2t4MkKon1q5hjjEHGB5zT2VUBmdTj7SxuA30rMCqiVZ93ENJ6ZS
aUibS2Nbz3K7PtBz0V5V1AxYXuXd/jML+cx8FBdBO6xIIafWx7vuEqglqBvJMqqM
EfbUHPqsTLQJLN1pDIh9AWWDqWeMfRS6elNa/RLRTOy5GqOH/kNWxdKl/eBHv8b7
fhlSrWhAPCcxJMKXYQIoH6O/qafYklC/haLZHTgqZkKssZDSyQ92eYX/EzsD0aCS
+t2U9zGNOdeigMtTB2yU
=nlkE
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
