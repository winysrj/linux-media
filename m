Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:35609 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbaKWPuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 10:50:06 -0500
Date: Sun, 23 Nov 2014 16:47:27 +0100
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
Message-ID: <20141123154727.GK4752@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-6-git-send-email-hdegoede@redhat.com>
 <20141120142856.16b6562d@recife.lan>
 <20141121082620.GJ24143@lukather>
 <546EFAE1.9050506@redhat.com>
 <20141121095934.GA4752@lukather>
 <546F103D.6050004@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HTLCc13+3hfAZ6SL"
Content-Disposition: inline
In-Reply-To: <546F103D.6050004@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--HTLCc13+3hfAZ6SL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 11:13:17AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/21/2014 10:59 AM, Maxime Ripard wrote:
> > On Fri, Nov 21, 2014 at 09:42:09AM +0100, Hans de Goede wrote:
> >> Hi,
> >>
> >> On 11/21/2014 09:26 AM, Maxime Ripard wrote:
> >>> Hi Mauro,
> >>>
> >>> On Thu, Nov 20, 2014 at 02:28:56PM -0200, Mauro Carvalho Chehab wrote:
> >>>> Em Thu, 20 Nov 2014 16:55:24 +0100
> >>>> Hans de Goede <hdegoede@redhat.com> escreveu:
> >>>>
> >>>>> Add support for the larger fifo found on sun5i and sun6i, having a =
separate
> >>>>> compatible for the ir found on sun5i & sun6i also is useful if we e=
ver want
> >>>>> to add ir transmit support, because the sun5i & sun6i version do no=
t have
> >>>>> transmit support.
> >>>>>
> >>>>> Note this commits also adds checking for the end-of-packet interrup=
t flag
> >>>>> (which was already enabled), as the fifo-data-available interrupt f=
lag only
> >>>>> gets set when the trigger-level is exceeded. So far we've been gett=
ing away
> >>>>> with not doing this because of the low trigger-level, but this is s=
omething
> >>>>> which we should have done since day one.
> >>>>>
> >>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>>
> >>>> As this is meant to be merged via some other tree:
> >>>>
> >>>> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>>
> >>> I think merging it through your tree would be just fine.
> >>>
> >>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>
> >> Heh, I was thinking it would be best if it went through Maxime's tree =
because
> >> it also has some deps on new clk stuff (well the dts have deps on that=
), but either
> >> way works for me.
> >>
> >> Maxime if you want this go through Mauro's tree, I can send a pull-req=
 to Mauro
> >> (I'm a linux-media sub-maintainer), so if that is the case let me know=
 and I'll
> >> prepare a pull-req (after fixing the missing reset documentation in th=
e bindings).
> >=20
> > So much for not reading the cover letter... Sorry.
> >=20
> > We're getting quite close to the end of the ARM merge window, and I
> > got a couple comments, Lee hasn't commented yet, so I'd say it's a bit
> > too late for this to come in.
>=20
> Oh, but this was not intended for 3.19, this can wait till 3.20 from my p=
ov,
> sorry if that was not clear. I was assuming that the merge window was more
> or less closed already, so that this going into 3.20 was expected.

Perfect then :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HTLCc13+3hfAZ6SL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcgGPAAoJEBx+YmzsjxAgQRUQALU7ErkoBAzX/zpvdiPdi11M
EoYn8kVdjk/ZUtLaPkxGHn+C5EgwoEK4LA2L1Y5EFsSKc3Q8G3DZKnt0ipi96zDo
idDN83yJj6qaGkRPhD55WdQhXx90DKjwmY5La8TWG2sMACghm4zyh/DUuDug1qpH
zD4vH8odRsjtbWu9/MQ0fHS6s0SJk2jzN7cEAAmoQuyDxFBNQ0e6S5WlFCjU5L9l
d30k/Wk6VYXFmbsuWsDllmgK7DkzCOND/VlN2nPAaPLcWdulZ3IZgUYtv7jG1LaW
3g2IUE/dK7FB0hD69t0iPQJVDa6G7i/wfTMelPl8Z8GibvTBn2KOpU70xqkePi0y
J/+mPTgURZY9eVHn8EzSzFEWh+vY1a5W+LobMeM62CTgx1wwAB6oVOvP5a0YWrMA
XSWp5c1Tw5T8astEIEjk8miZPrxqJptpwnFDdIx7+nB9OUByIDAW7PRIX81kgJ/e
Y34etFwDJ6LVgHC+xotczNv6Lk8l2t29MznkILzQkau6uuxfm8zF5/7qQvld5JQ2
LE4+Q2q2k4l2/JM86EHaEMXJri3nJUssFx32/9MjcddyP8wBhwNSTolhjVJJINFO
/UBAWdGdTCzOUD1D6XKbP3UFXd3KkbkGcFHreWqBTVkh9AMxQioS9t9YJXwy2c/Z
hRpbhWcUBb8PlI3ZrjPf
=ftrh
-----END PGP SIGNATURE-----

--HTLCc13+3hfAZ6SL--
