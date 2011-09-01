Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:65493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1IAFIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 01:08:41 -0400
Date: Thu, 1 Sep 2011 07:08:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 06/21] [staging] tm6000: Increase maximum I2C packet size.
Message-ID: <20110901050836.GA18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-7-git-send-email-thierry.reding@avionic-design.de>
 <4E5E8F54.8000106@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <4E5E8F54.8000106@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 04-08-2011 04:14, Thierry Reding escreveu:
> > The TM6010 supports much larger I2C transfers than currently specified.
> > In fact the Windows driver seems to use 81 bytes per packet by default.
> > This commit improves the speed of firmware loading a bit.
> > ---
> >  drivers/staging/tm6000/tm6000-cards.c |    1 +
> >  drivers/staging/tm6000/tm6000-i2c.c   |    2 +-
> >  2 files changed, 2 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm=
6000/tm6000-cards.c
> > index c3b84c9..a5d2a71 100644
> > --- a/drivers/staging/tm6000/tm6000-cards.c
> > +++ b/drivers/staging/tm6000/tm6000-cards.c
> > @@ -929,6 +929,7 @@ static void tm6000_config_tuner(struct tm6000_core =
*dev)
> >  		memset(&ctl, 0, sizeof(ctl));
> > =20
> >  		ctl.demod =3D XC3028_FE_ZARLINK456;
> > +		ctl.max_len =3D 81;
> > =20
> >  		xc2028_cfg.tuner =3D TUNER_XC2028;
> >  		xc2028_cfg.priv  =3D &ctl;
> > diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm60=
00/tm6000-i2c.c
> > index 21cd9f8..2cb7573 100644
> > --- a/drivers/staging/tm6000/tm6000-i2c.c
> > +++ b/drivers/staging/tm6000/tm6000-i2c.c
> > @@ -50,7 +50,7 @@ static int tm6000_i2c_send_regs(struct tm6000_core *d=
ev, unsigned char addr,
> >  	unsigned int i2c_packet_limit =3D 16;
> > =20
> >  	if (dev->dev_type =3D=3D TM6010)
> > -		i2c_packet_limit =3D 64;
> > +		i2c_packet_limit =3D 256;
>=20
> This shouldn't work fine. As said at USB 2.0 specification:
>=20
> 	An endpoint for control transfers specifies the maximum data payload siz=
e that the endpoint can accept from
> 	or transmit to the bus. The allowable maximum control transfer data payl=
oad sizes for full-speed devices is
> 	8, 16, 32, or 64 bytes; for high-speed devices, it is 64 bytes and for l=
ow-speed devices, it is 8 bytes. This
> 	maximum applies to the data payloads of the Data packets following a Set=
up; i.e., the size specified is for
> 	the data field of the packet as defined in Chapter 8, not including othe=
r information that is required by the
> 	protocol. A Setup packet is always eight bytes. A control pipe (includin=
g the Default Control Pipe) always
> 	uses its wMaxPacketSize value for data payloads.
> 	(Item 5.5.3 Control Transfer Packet Size Constraints).
>=20
> Using a value higher than 64 may cause troubles with some USB devices
> (hubs, USB adapters, etc).

Okay, fine by me. I was basically just copying what the Windows driver was
doing here, but I've tested with smaller sizes as well and if my memory
serves me well that also worked. As I hinted at in the commit message this
was mostly for performance improvement.

Thierry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fE1QACgkQZ+BJyKLjJp984gCfWIVMjqX9+MkVJSF3DUm8ptrT
5NkAn2UMT5nqVvgNYEYzy9GIJ4+LnhcQ
=v4Tp
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
