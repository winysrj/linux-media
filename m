Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47887 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859Ab2HTLjh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 07:39:37 -0400
Received: by lbbgj3 with SMTP id gj3so3604260lbb.5
        for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 04:39:34 -0700 (PDT)
Message-ID: <1345462770.2684.23.camel@deskari>
Subject: Re: [RFC 0/5] Generic panel framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Date: Mon, 20 Aug 2012 14:39:30 +0300
In-Reply-To: <4948190.AFNtaaFKXQ@avalon>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <15644929.x7ZB0fPYJx@avalon> <1345203751.3158.99.camel@deskari>
	 <4948190.AFNtaaFKXQ@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-+xUJwkSHRxEfQVorDwN4"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+xUJwkSHRxEfQVorDwN4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-08-18 at 03:16 +0200, Laurent Pinchart wrote:
> Hi Tomi,

> mipi-dbi-bus might not belong to include/video/panel/ though, as it can b=
e=20
> used for non-panel devices (at least in theory). The future mipi-dsi-bus=
=20
> certainly will.

They are both display busses. So while they could be used for anything,
I find it quite unlikely as there are much better alternatives for
generic bus needs.

> Would you be able to send incremental patches on top of v2 to implement t=
he=20
> solution you have in mind ? It would be neat if you could also implement =
mipi-
> dsi-bus for the OMAP DSS and test the code with a real device :-)

Yes, I'd like to try this out on OMAP, both DBI and DSI. However, I fear
it'll be quite complex due to the dependencies all around we have in the
current driver. We're working on simplifying things so that it'll be
easier to try thing like the panel framework, though, so we're going in
the right direction.

> > Generally about locks, if we define that panel ops may only be called
> > exclusively, does it simplify things? I think we can make such
> > requirements, as there should be only one display framework that handle=
s
> > the panel. Then we don't need locking for things like enable/disable.
>=20
> Pushing locking to callers would indeed simplify panel drivers, but we ne=
ed to=20
> make sure we won't need to expose a panel to several callers in the futur=
e.

I have a feeling that would be a bad idea.

Display related stuff are quite sensitive to any delays, so any extra
transactions over, say, DSI bus could cause a noticeable glitch on the
screen. I'm not sure what are all the possible ops that a panel can
offer, but I think all that affect the display or could cause delays
should be handled by one controlling entity (drm or such). The
controlling entity needs to handle locking anyway, so in that sense I
don't think it's an extra burden for it.

The things that come to my mind that could possibly cause calls to the
panel outside drm: debugfs, sysfs, audio, backlight. Of those, I think
backlight should go through drm. Audio, no idea. debugfs and sysfs
locking needs to be handled by the panel driver, and they are a bit
problematic as I guess having them requires full locking.

 Tomi


--=-+xUJwkSHRxEfQVorDwN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQMiHyAAoJEPo9qoy8lh71YAYP/jBHrvYE2qSsSo52sAXV14Qn
nvQ2I5W9JrJeHxLqm1P2LlV0KLExL4y4VhMpBEzWIrIxOVaEwOulGaHSitI5/Ps1
sgOL5qXxgSyOsys3v5xBnsufa92b+k3QODpmgk5PYuq0Qb2n2xNywQfuVhZtGeZQ
qT4r8l1yTYkgPo3pSBqlvPkCjbXaT7rc++Q2BspU425TWmMz4MKwR6oWbGtfz8va
vtW2ncPIaLNEpRnf69Q6sV9sXy2z0BF+QmC4063Faf6q2zu0BSZEH6z53lSpzXVn
n3bYEfkPD9EafuQS7b+Zh1VfFYKY4pKgUyPZJ6P6Y3YcDxoggkF9RB4Ny34uU/RL
Jy3ndFBAKETkbpTIHCARHoewmYl3fKQACO1J04tbiOaAOz5CcMjwbGpGYMd+Cc93
hQ8HV+EqR4ry8H2ghNkKkVg7r5yBttZouCjZDq3u1TQEnGA8Xd8M4er4wcAD9uAH
2RUrZFyCh6gOTrfwyhcjpPWY7+hr+LuYxC2N+xgtg9a89ZEMNA6G+HvtPMdTL9K6
XBli1EHDK3fZYgeJJnX7+jhdEG2JbtB+jyW3VRq3HkvbjX5XnmtLWrBe6Svz1m+g
JaJTTGcsNQJH+8ndGjyp3hyPge8HgBAvDOSPJxcKl0oJahs/qAe16rlyOaszXbdm
Yvhs9/CtBpXXk0SgQovm
=uMih
-----END PGP SIGNATURE-----

--=-+xUJwkSHRxEfQVorDwN4--

