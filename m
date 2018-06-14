Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:52048 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755027AbeFNPm1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:42:27 -0400
Date: Fri, 15 Jun 2018 00:41:41 +0900
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Message-ID: <20180614154139.eu7fznytzf4rkt4g@ninjato>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
 <843b1253-67ec-883f-9683-134528320791@axentia.se>
 <be2c81ed-c37a-c178-0c8e-7029474ff316@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bktzqqdwzlhnx4l6"
Content-Disposition: inline
In-Reply-To: <be2c81ed-c37a-c178-0c8e-7029474ff316@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bktzqqdwzlhnx4l6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> So, maybe the easier thing to do is change i2c_lock_adapter to only
> lock the segment, and then have the callers beneath drivers/i2c/
> (plus the above mlx90614 driver) that really want to lock the root
> adapter instead of the segment adapter call a new function named
> i2c_lock_root (or something like that). Admittedly, that will be
> a few more trivial changes, but all but one will be under the I2C
> umbrella and thus require less interaction.
>=20
> Wolfram, what do you think?

It sounds tempting, yet I am concerned about regressions. From that
point of view, it is safer to introduce i2c_lock_segment() and convert the
users which would benefit from that. How many drivers would be affected?


--bktzqqdwzlhnx4l6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsijLMACgkQFA3kzBSg
KbaHEBAAn5dWhy2SH0rtS+E/cIfIfxPyONehowScGbnqGRBPWSpjcFQnuam48VKk
NqDGbckDAr0AugcqEMDsd/IHiZ1GYgmgd+7LtmfAn8auBeZc/U6cLliBqFCnccwC
RE0Ra6fq9SQy7v7TU62lzaimlEl2JAnAlew0vh3YD9b5skB/kN6k0FJlJdGWe+iK
Apoex5r81Gk5msDTMrErvEyQejfu8ABVlKNc3Br0MjL3wqzbBMCKtJh8sehDrU1S
WHsfpOhy3J/Dk31Uw/pzVNQ46jy00KcZu7vdVdg8Un5fcMGh2CG+h2MIjoleg5VL
m96wA3BdkyU1IiqacGvxpAbun17ffR2VbbTpQfukWdyAYBV6x6Q1YuyRtE3sdWGA
GHC84wmo/u00u8vD7TmmcV9v0XkTH7WsIuABB/v5xWjaF+5kQ5TqDZCIkehp1q0O
TAeURff+/Pwoj1sP/FMReNZePby3DD7aEXLomkpvnM8CP93yQHblejg2knA5jALP
QdzII/oq48RVfJKDP2Xg6NVZcpXR3TT/IUonGDGRvvncwQNho0rjOX406ghBBilp
snmPFg5jjRx+2p9+IJGwFArY27jm1RP/43Bb4ni3mUoBIshFBYoxyppoocFYvdkd
nzdv2ewYH99BLE7sLgVun2uBKekLfITQP+ZpvIU84oeueQDNucU=
=kWpM
-----END PGP SIGNATURE-----

--bktzqqdwzlhnx4l6--
