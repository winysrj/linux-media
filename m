Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45455 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161248AbdDUOuW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 10:50:22 -0400
Date: Fri, 21 Apr 2017 16:41:25 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Order the Makefile alphabetically
Message-ID: <20170421144125.dnahmsnsjj2h6drv@lukather>
References: <20170406144051.13008-1-maxime.ripard@free-electrons.com>
 <20170419081538.38272ae6@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gxv4bfmmjsm5ttkf"
Content-Disposition: inline
In-Reply-To: <20170419081538.38272ae6@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gxv4bfmmjsm5ttkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2017 at 08:15:45AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu,  6 Apr 2017 16:40:51 +0200
> Maxime Ripard <maxime.ripard@free-electrons.com> escreveu:
>=20
> > The Makefiles were a free for all without a clear order defined. Sort a=
ll the
> > options based on the Kconfig symbol.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >=20
> > ---
> >=20
> > Hi Mauro,
> >=20
> > Here is my makefile ordering patch again, this time with all the Makefi=
les
> > in drivers/media that needed ordering.
> >=20
> > Since we're already pretty late in the release period, I guess there wo=
n't
> > be any major conflicts between now and the merge window.
> >=20
>=20
> The thing with patches like that is that they almost never apply fine.
> By the time I review such patches, it was already broken. Also,
> once applied, it breaks for everybody that have pending work to merge.
>=20
> This patch is broken (see attached).
>=20
> So, I prefer not applying stuff like that.

I had the feeling that now would have been a good time to merge it,
since all the PR should be merged I guess. But ok.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--gxv4bfmmjsm5ttkf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJY+hoVAAoJEBx+YmzsjxAgLL8QAKbhzoCtku4r+Zt9hP8Jkxo7
ku3tmgLDJF7qFcYAu1rMn21yXKtcwyCsbxlnlbEwYI/JFF1WRazh//R1SRAy0QQ2
HtgiEpXEcbfmr9gYVc3gfuSexFV9NGTFIi8whGj/ZKihkQjNbYc0s1P/+xhgsUCF
UJu3pG+C2iB5M7KI9ayWLdfSZrkXDD8BwxSxo01KArw7h9SHFx8e7xhlgntxRGp3
PJ3eOKVHIHO7/kflZ/jbcZIlaRSd0OofDRj5+Y9o7rR/abKsh67D6eMClMt17BZQ
Bdt+PIahKu8hZAS+By8GwQX8SqqJ6iPfHbDitF5H3Ok3pFsURdUSbZOFop8pMNkz
n5sqE9qIEonlPQ3+mWyHv0zPpdP3ENFSuAxd+v59AFBKcwWpVvUKpIL8cJd50Uw7
ZVO8uPe5JwS5lKx8GkcwS+3r3Z3W83USqrRNDdfl/gWZvpirbKdf3ma5KA5SzOc+
Dph4paC2cBJfrUuYsZGkgoq/nEL+xcZhYvftmehFmN6afToWAoEWl81w1LRbTSOj
nDxyP9gtHyyZcqVXLxomf+ACQOMt68Z2oHVI1ehKlTCLStrOOHVQBpsJwSKnmq8B
rCdQzw8u3gCXWR+oUE+IawewnJNiM9hj1OuZlmmCEgXhN573x70tg4Mx1uMXtdzo
KwAxP27hWC8sITJxs6zv
=4ubt
-----END PGP SIGNATURE-----

--gxv4bfmmjsm5ttkf--
