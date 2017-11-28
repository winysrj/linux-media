Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59046 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbdK1MwO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 07:52:14 -0500
Date: Tue, 28 Nov 2017 13:52:03 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Giulio Benetti <giulio.benetti@micronovasrl.com>
Cc: Thomas van Kleef <thomas@vitsch.nl>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171128125203.h7cnu3gkfmogqhxu@flea.home>
References: <1511868558-1962148761.366cc20c7e@prakkezator.vehosting.nl>
 <d8135c3d-7ba8-2b88-11cb-5b81dfa04be2@vitsch.nl>
 <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="m6tmdi5rkxxqjkdl"
Content-Disposition: inline
In-Reply-To: <f8cc0633-8c29-e3b0-0216-f8f5c69ebb34@micronovasrl.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--m6tmdi5rkxxqjkdl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 28, 2017 at 12:54:08PM +0100, Giulio Benetti wrote:
> > > > Should I be working in sunxi-next I wonder?
> > >=20
> > > Yes, this is the best way, cedrus is very specific to sunxi.
> > > So before working on mainline, I think the best is to work un sunxi-n=
ext branch.
> >
> > Is the requests2 api in sunxi-next?
>=20
> It should be there,
> take a look at latest commit of yesterday:
> https://github.com/linux-sunxi/linux-sunxi/commit/df7cacd062cd84c551d7e72=
f15b1af6d71abc198

No, it shouldn't. sunxi-next is about patches that are related to
sunxi that have been accepted in their respective maintainers'
branches.

While we could argue about the first criteria, the second one is not
respected.

And really, just develop against 4.14. sunxi-next is rebased, and it's
just not something you can base some work on.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--m6tmdi5rkxxqjkdl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlodW+8ACgkQ0rTAlCFN
r3Syzw/8DUBEkwdKCZmNouH15B01DNZn63q0o8UBmgOngccpjcufnkxt0cX9jqJ4
RQ/tqN4TtYfuPirob3XEHcHHcdqrkAu6FAN0EG6+fQjbDLYwcfZdml4uz+kB6Kcb
TvONni9dh+5oqJRFzARVho/b3XNRyrRfCPIvtkCfZ0mlNgonrxNJThfomJvolA3a
oTism1M9N4zhuvyHTogi7RdmXJCLUyY6G8B1pb5i0uQJhXytzQvjhXEPhFPFpml1
kuZ4luH44siLj5apS5U2wPn+dVKUzzBz3lMEsXWjcyAj64sA6hQjkbpHQO0lUQlX
xU/wwjFEFha5Kj+DGvxnd3i32H1X1GUxCFh8Fp7nkx27hHPUQyuEaewWktbMC59s
+S0ggtnPwOAAZ29OHcHYq4fBaQLnu1A/4YUTG84F7iBfOPfTOrdfqmoWEwy4EL62
Mc+r4Ecu4NUJ8cQsv8QEomzk+L7xbv17TsTXKexwAIG6aL1pLkH+BQpHBz8O9k6k
XZQdkPD7dqrVH71M3LLd/V29SCM/G13VETmeFhSDa9DmDxJAt4i6KFXRZWB6HJl8
NpxCJiGnZ41FIzqxSODW4CMLBnREZoIzY7esYqjjQFwaM6V/nnSviUAFge3vsS8J
9j3o+OSintpwWo739HNRzOoXwMenxscy895N1rxEb6d91kS5hY4=
=VENF
-----END PGP SIGNATURE-----

--m6tmdi5rkxxqjkdl--
