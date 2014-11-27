Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34948 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbaK0TKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 14:10:13 -0500
Date: Thu, 27 Nov 2014 20:05:09 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	Boris Brezillon <boris@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/9] clk: sunxi: Add prcm mod0 clock driver
Message-ID: <20141127190509.GR25249@lukather>
References: <20141126211318.GN25249@lukather>
 <5476E3A5.4000708@redhat.com>
 <CAGb2v652m0bCdPWFF4LWwjcrCJZvnLibFPw8xXJ3Q-Ge+_-p7g@mail.gmail.com>
 <5476F8AB.2000601@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TDVcAd+kFgbLxwBe"
Content-Disposition: inline
In-Reply-To: <5476F8AB.2000601@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--TDVcAd+kFgbLxwBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 27, 2014 at 11:10:51AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 11/27/2014 10:28 AM, Chen-Yu Tsai wrote:
> >Hi,
> >
> >On Thu, Nov 27, 2014 at 4:41 PM, Hans de Goede <hdegoede@redhat.com> wro=
te:
>=20
> <snip>
>=20
> >>I notice that you've not responded to my proposal to simple make the cl=
ock
> >>node a child node of the clocks node in the dt, that should work nicely=
, and
> >>avoid the need for any kernel level changes to support it, I'm beginnin=
g to
> >>think that that is probably the best solution.
> >
> >Would that not cause an overlap of the io regions, and cause one of them
> >to fail? AFAIK the OF subsystem doesn't like overlapping resources.
>=20
> No the overlap check is done by the platform dev resource code, and of_cl=
k_declare
> does not use that. So the overlap would be there, but not an issue (in th=
eory
> I did not test this).

An overlap is always an issue.

> Thinking more about this, I believe that using the MFD framework for the =
prcm seems
> like a mistake to me. It gains us nothing, since we have no irq to de-mul=
tiplex or
> some such. We're not using MFD for the CMU, why use it for CMU2 (which th=
e prcm
> effectively is) ?

Because the PRCM is much more than that. It also handles the power
domains for example.

And also because the 1 node per clock is no longer the current trend
and that Mike discourages to use that model nowadays.

> So I think it would be best to remove the prcm node from the dt, and simp=
ly put the
> different blocks inside it directly under the soc node, this will work fi=
ne with
> current kernels, since as said we do not use any MFD features, we use it =
to
> create platform devs and assign resources, something which will happen au=
tomatically
> if we put the nodes directly under the soc node, since then simple-bus wi=
ll do the
> work for us.
>=20
> And then in a release or 2 we can remove the mfd prcm driver from the ker=
nel, and we
> have the same functionality we have now with less code.
>=20
> We could then also chose to move the existing prcm clock nodes to of_clk_=
declare
> (this will work once they are nodes directly under soc with a proper reg =
property).
> and the ir-clk can use allwinner,sun4i-a10-mod0-clk compatible and can li=
ve under
> either clocks or soc, depending on what we want to do with the other prcm=
 clocks.

Have you considered the SMP code in that smooth plan?

The one that is in neither a platform driver, nor a clock, nor does it
have a compatible of its own, but still needs to access some of the
PRCM registers?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TDVcAd+kFgbLxwBe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUd3XlAAoJEBx+YmzsjxAgvNgP/jWzd7vK8Hmu9MssNzLvCwOh
B7bPBEBhRzwBAZbXEI2wtyZ7BlBzd0jZ0MnoJsezMq5ZasI/no//E99TY4HysnN6
vIfhJcChVdE4wMjJv5d9z/5GIWrWtz4+DSN9OSvNDUuw7wpI5B6a3Ud5H4oTd+Z5
ytmUCVHaQfoQULBUQR07DvieNkb8MP5TlukRzkro2AdAm71USbQFbqkNtujg/gFn
Juxl6aX9sQtWQQnr11RgJjaN5ADtk20A8XNbawCxYPmtAuAfaqOmHUTxVSb7bEhF
AyE6+2mg6sltRTPnGNT+dj4Z6CiFuIMgoMVP4V3iz16ujd+g2Tq+UQ1k1WxUG4oQ
q3zWzOi9e9ygg7oOR1P4vF+FN0AlBalslg8EtjtxEAW1OS5pyBvAC92BUa0gs0GW
IAV5sGIoCINeTlPzOmoRqQpZIzqqegOyB2Gpxc9K4uEbpVSxKbo7xwpVqdgzOBUm
wXLCpHYIsASBZySi9Ww2xTz1P28pj4iJpqqdtU7o5UDJYVdpEbui4Tww72qebqAP
UCEX9Xx7vzyEOk/ShGm7IFfQQz8vlY3Apj7HQ9Bde3+cLXAP+sxj6YRrZzqNxecK
sQ/mUqSHbaNPP6hhltleH5+IzvGYI4WdhulvnUzdLNqfN1fBg+fm0k267ZfSm76D
Th6jTRVfaUSWv2kuaZtw
=M1sl
-----END PGP SIGNATURE-----

--TDVcAd+kFgbLxwBe--
