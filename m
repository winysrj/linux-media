Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44958 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKINcr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 08:32:47 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] mt9v032: Do not unset master_mode
Date: Mon, 09 Nov 2015 14:32:42 +0100
Message-ID: <1705584.DjrTFzEFXW@adelgunde>
In-Reply-To: <1542250.4NFmqc20qx@avalon>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de> <1446815625-18413-2-git-send-email-mpa@pengutronix.de> <1542250.4NFmqc20qx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2141150.UvXHX27rcF"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2141150.UvXHX27rcF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

Hi Laurent,

On Monday 09 November 2015 14:46:42 Laurent Pinchart wrote:
> Hi Markus,
>=20
> Thank you for the patch.
>=20
> On Friday 06 November 2015 14:13:44 Markus Pargmann wrote:
> > The power_on function of the driver resets the chip and sets the
> > CHIP_CONTROL register to 0. This switches the operating mode to sla=
ve.
> > The s_stream function sets the correct mode. But this caused proble=
ms on
> > a board where the camera chip is operated as master. The camera sta=
rted
> > after a random amount of time streaming an image, I observed betwee=
n 10
> > and 300 seconds.
> >=20
> > The STRFM_OUT and STLN_OUT pins are not connected on this board whi=
ch
> > may cause some issues in slave mode. I could not find any documenta=
tion
> > about this.
> >=20
> > Keeping the chip in master mode after the reset helped to fix this
> > issue for me.
> >=20
> > Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> > ---
> >  drivers/media/i2c/mt9v032.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v03=
2.c
> > index 4aefde9634f5..943c3f39ea73 100644
> > --- a/drivers/media/i2c/mt9v032.c
> > +++ b/drivers/media/i2c/mt9v032.c
> > @@ -344,7 +344,8 @@ static int mt9v032_power_on(struct mt9v032 *mt9=
v032)
> >  =09if (ret < 0)
> >  =09=09return ret;
> >=20
> > -=09return regmap_write(map, MT9V032_CHIP_CONTROL, 0);
> > +=09return regmap_write(map, MT9V032_CHIP_CONTROL,
> > +=09=09=09    MT9V032_CHIP_CONTROL_MASTER_MODE);
>=20
> This makes sense, but shouldn't you also fix the mt9v032_s_stream() f=
unction=20
> then ? It clears the MT9V032_CHIP_CONTROL_MASTER_MODE bit when turnin=
g the=20
> stream off.

Oh yes, thanks. Will fix it for the next version.

Best Regards,

Markus

=2D-=20
Pengutronix e.K.                           |                           =
  |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0  =
  |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-555=
5 |

--nextPart2141150.UvXHX27rcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWQKB6AAoJEEpcgKtcEGQQWtgQAIz8EghM3Dx6wvJxwlsgIxHG
V6sNuVi1nK2zU+1gLgGs9VwYpG2R95hH3WM90RjJmXebc7zyb2WxyQE9HL8yaq1U
Vjub4Pvbka2Uaa+iG8DTyCr1iFh20Q8LCKeEqYoyfCUzLZi1UoQtk5UcxLYIiGqD
r6bZvEJPP2qi8VCUfa4o5FQ1ZeUB3m0maLWoOi/HSIBkIZkK0k9raZQJk2eG10q8
0dEkbkLnhdffphU80aMtWPPzUGSGT0TnJSHrm5hrBb6kHFiO+zJlcUutORwBwAYV
qiMmMOvdoczcDc8a2N0sa1Fwg89TFPAhdgcO07eurf8OcqdqFuHsuKzcTecaimAq
ED5o/4utSn1U2YiCWXanZe9J12M/jw4ZRxFufKYN/jCU7m1eApyLd+1thScN1NRh
02AcBOYszP1J8TDD7wP3QXXyVbSmVDKYtWO2x3jHhKqyoGHtVlhc7KdIwwBr4XgE
1L4Qv2B8apXy0CkPSj0ZaT4PlTW47rdRBA0hMIoheBbuV8/4IZ70FPtSnRUab5dJ
/5QKWqNyeN2D6AAdN81LS5r7vJl9w4Q1QSjhap/0B49SkXVcO5OaSNNznW7Uo5Jz
BHUZ/LQNe/H89VyECdn/jMKXeBLAc0eGGx+uDZjbNoko9epEwOQG9Nj1Q9qPgmFr
b23P962mIagLI91eSpsZ
=JFwC
-----END PGP SIGNATURE-----

--nextPart2141150.UvXHX27rcF--

