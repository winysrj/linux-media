Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:45816 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbdLDVZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 16:25:16 -0500
Date: Mon, 4 Dec 2017 22:25:13 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Message-ID: <20171204212512.6aml52cmzbul423v@ninjato>
References: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tfawbpbm3ykihde2"
Content-Disposition: inline
In-Reply-To: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tfawbpbm3ykihde2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 04, 2017 at 09:20:00PM +0100, Wolfram Sang wrote:
> So, after revisiting old mail threads, taking part in a similar discussio=
n on
> the USB list, and implementing a not-convincing solution before, here is =
what I
> cooked up to document and ease DMA handling for I2C within Linux. Please =
have a
> look at the documentation introduced in patch 7 for details. And to make =
it
> clear again: The stuff below is opt-in. If host drivers are not updated, =
they
> will continue to work like before.
>=20
> While previous versions until v3 tried to magically apply bounce buffers =
when
> needed, it became clear that detecting DMA safe buffers is too fragile. T=
his
> approach is now opt-in, a DMA_SAFE flag needs to be set on an i2c_msg. The
> outcome so far is very convincing IMO. The core additions are simple and =
easy
> to understand. The driver changes for the Renesas IP cores became easy to
> understand, too.
>=20
> Of course, we must now whitelist DMA safe buffers. This series implements=
 it
> for core functionality:
>=20
> a) for the I2C_RDWR when messages come from userspace
> b) for i2c_smbus_xfer_emulated(), DMA safe buffers are now allocated for
>    block transfers
> c) i2c_master_{send|recv} have now a *_dmasafe variant
>=20
> I am still not sure how we can teach regmap this new flag. regmap is a he=
avy
> user of I2C, so broonie's opinion here would be great to have. The rest s=
hould
> mostly be updating individual drivers which can be done when needed.
>=20
> All patches have been tested with a Renesas Salvator-X board (r8a7796/M3-=
W) and
> Renesas Lager board (r8a7790/H2). But more testing is really really welco=
me.
>=20
> The branch can be found here:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/topic=
/i2c-core-dma-v6
>=20
> It is planned to land upstream in v4.16 and I want to push it to linux-ne=
xt
> early after v4.15 to get lots of testing for the core changes.
>=20
> Big kudos to Renesas Electronics for funding this work, thank you very mu=
ch!
>=20
> Regards,
>=20
>    Wolfram

Applied to for-next after fixing some cosmetic checkpatch issues!


--tfawbpbm3ykihde2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlolvTgACgkQFA3kzBSg
KbY1qg//T/ASuI1lCy+YMIjLfcTXYGW+lw9thHUN8OIzDxy02s8yv2pIQr2iCjeJ
qHQh9uOwDi9HF69+XDrLDy5xOycvMXjbeJtk7iinK6i3rIRVEwwezUw335Vv4Hrk
7I2P2xq/prU2U7aA+xhvG7ATBOKebFxT0T33/9gXEkOQcFsG9HbKja2WKopZU154
vjeBP0NeAQVyznhwx/DQ/ASa8dCg44ReJaGzCAwhIFaD5GdS8LohCQkrl9GF3Mex
/HNgWkDl/VBBZ/u9WjD8pF4kPyRCWncHHyeOTULV+13YyVCMP2p73HyObGu/Ji3O
OgK8nBwgdx+f00K7rKSiE8OxUfF5ceuut3OUkFWy4wZvmU7JZMtFwKiFwS4lN1Dq
NCuNeawc4h72Pc6Obt/Yg/vSaAvdKuzO2Uzc3tCJryMBPQkwZlE05qQ1uuevQVm5
RLmPC9WF9hAz9OMH6FsNZac5FhOVcQ/xIyGVoW/vD2GyZ8CJBfme3qaP3vUhIlVg
zYTfetzfSuwZ33tirdzvrV3BJa9oonTLSdFoULI2sFgn4DullYmWOmsxNKzQWMhD
cHgTVA+YzFBjlvhBTwxgg33KqcaUZ7aaouoWKfWNe5qhUjPk9rlNuz0DlNl+FxEr
UHJ1MVMo+Zee7lnsYsXs4kp8nuGOhU0j35opRhpE4yboQkfITMM=
=xQCx
-----END PGP SIGNATURE-----

--tfawbpbm3ykihde2--
