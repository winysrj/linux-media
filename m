Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53379 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754110AbaKUKAF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 05:00:05 -0500
Date: Fri, 21 Nov 2014 10:59:35 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/9] rc: sunxi-cir: Add support for the larger fifo found
 on sun5i and sun6i
Message-ID: <20141121095934.GA4752@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-6-git-send-email-hdegoede@redhat.com>
 <20141120142856.16b6562d@recife.lan>
 <20141121082620.GJ24143@lukather>
 <546EFAE1.9050506@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <546EFAE1.9050506@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 09:42:09AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/21/2014 09:26 AM, Maxime Ripard wrote:
> > Hi Mauro,
> >=20
> > On Thu, Nov 20, 2014 at 02:28:56PM -0200, Mauro Carvalho Chehab wrote:
> >> Em Thu, 20 Nov 2014 16:55:24 +0100
> >> Hans de Goede <hdegoede@redhat.com> escreveu:
> >>
> >>> Add support for the larger fifo found on sun5i and sun6i, having a se=
parate
> >>> compatible for the ir found on sun5i & sun6i also is useful if we eve=
r want
> >>> to add ir transmit support, because the sun5i & sun6i version do not =
have
> >>> transmit support.
> >>>
> >>> Note this commits also adds checking for the end-of-packet interrupt =
flag
> >>> (which was already enabled), as the fifo-data-available interrupt fla=
g only
> >>> gets set when the trigger-level is exceeded. So far we've been gettin=
g away
> >>> with not doing this because of the low trigger-level, but this is som=
ething
> >>> which we should have done since day one.
> >>>
> >>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>
> >> As this is meant to be merged via some other tree:
> >>
> >> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >=20
> > I think merging it through your tree would be just fine.
> >=20
> > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Heh, I was thinking it would be best if it went through Maxime's tree bec=
ause
> it also has some deps on new clk stuff (well the dts have deps on that), =
but either
> way works for me.
>=20
> Maxime if you want this go through Mauro's tree, I can send a pull-req to=
 Mauro
> (I'm a linux-media sub-maintainer), so if that is the case let me know an=
d I'll
> prepare a pull-req (after fixing the missing reset documentation in the b=
indings).

So much for not reading the cover letter... Sorry.

We're getting quite close to the end of the ARM merge window, and I
got a couple comments, Lee hasn't commented yet, so I'd say it's a bit
too late for this to come in.

If Mauro is happy with the current patches for him, it's completely
fine to merge it through his tree. The DTS can wait.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbw0GAAoJEBx+YmzsjxAgR6wP/if+hlLF48mTbjR+IyrvTBwK
XHUSgIRTZY/VH39ZHc9r+zc1NavKZzBFA3pBv931DiKVrnctX8588IObznM3fLLs
OhKqOyzGT81+/o+kqTOZliD5CIMB2mt9HGEB+GZt/LYAhDpvPgkNKD6YmJPNPDE2
Zw7s05f03m2ry2VBOLRNNRhG0ag5ed9BCbg/VFN6oiTLqvvJrZUGFEXE8tmi83QU
Wj3s6mvtsCAMXoY71LLnw+oQY+eQiQyHO0rKjA7DOHUu5Rat4eRc5e6sP8mWawHy
eFPHFgbJxnkkkixosqG4P/scqOUWFdI3ji6m/uPoK2uwYF6MIuRv1HVFg6HgQagP
jgKA/Y+xmnSMNJp6VK9Z8bTTaDdsnOG0ERpitHodmedvWc2pHypjiojm2upd2K7W
4rYB+R5jAKC5RQVxZwNYK9XuEjtjF2r1npZSv+tlvTCxep9bE5jJIMGFtFV5S0Ep
pizMt4iczU3249Tm/maH4qXZtiGIkA3jdev83L+7dtdc6nM5ITWfKpBR/p9r7j5B
nEUZetCzoQPumhKNEIZuPV9qDBwVFBdmCFbbFe/WVYR4LcmL20xZ9YnPx5XjrdE9
THxOdqOI4JLOkhmXVTqewZeor7LaZy0MEQTzPZ86qxHYbi6fpi2EtVu9OM9hjqL/
Tjrqa69dZTR+1RUPf595
=QCnI
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
