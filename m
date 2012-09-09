Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50796 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754609Ab2IIWiQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Sep 2012 18:38:16 -0400
Message-ID: <1347230281.5134.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [patch v2] [media] rc-core: prevent divide by zero bug in
 s_tx_carrier()
From: Ben Hutchings <ben@decadent.org.uk>
To: Sean Young <sean@mess.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 09 Sep 2012 23:38:01 +0100
In-Reply-To: <20120909222629.GA28355@pequod.mess.org>
References: <20120909203142.GA12296@elgon.mountain>
	 <20120909222629.GA28355@pequod.mess.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-34PVV3Bggk5EDdtCKdHa"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-34PVV3Bggk5EDdtCKdHa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-09-09 at 23:26 +0100, Sean Young wrote:
> On Sun, Sep 09, 2012 at 11:31:42PM +0300, Dan Carpenter wrote:
> > Several of the drivers use carrier as a divisor in their s_tx_carrier()
> > functions.  We should do a sanity check here like we do for
> > LIRC_SET_REC_CARRIER.
> >=20
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > v2: Ben Hutchings pointed out that my first patch was not a complete
> >     fix.
> >=20
> > diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lir=
c-codec.c
> > index 6ad4a07..28dc0f0 100644
> > --- a/drivers/media/rc/ir-lirc-codec.c
> > +++ b/drivers/media/rc/ir-lirc-codec.c
> > @@ -211,6 +211,9 @@ static long ir_lirc_ioctl(struct file *filep, unsig=
ned int cmd,
> >  		if (!dev->s_tx_carrier)
> >  			return -EINVAL;
>=20
> This should be ENOSYS.
>=20
> > =20
> > +		if (val <=3D 0)
> > +			return -EINVAL;
> > +
>=20
> 1) val is unsigned so it would never be less than zero.
>=20
> 2) A value of zero means disabling carrier modulation, which is used by=
=20
>    the mceusb driver.
>
> So the check belongs in the individual drivers, as in the original patch.

Oh well, sorry for pointing Dan in the wrong direction.  Is the special
case documented somewhere?

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-34PVV3Bggk5EDdtCKdHa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUE0aSee/yOyVhhEJAQpmvQ//U2NF2R1HNHjqKol0yb5NjV0qRcHLo8nD
ftpTHRpasx92ElSlVo4ARII77kwr1WnokYxHCYwS1DuNqpxVP7zRifp26NTDRjpz
c9hg1yzcVOEl/kCXLw0A4IiBKy3L+D9cNClEIFJfFcdKsejuM+8Md5r/gypUPfTf
cFAWDkCUXnWPEPB+/NQHB1R3cCHoolBR8lDRt3+XYo/QaV5Eb4A4KQPmcug6BKEX
Onby85KjthbOdLN4gShRdJ0P3Ud15WxeZyMLXUAHN/Zm8gcy6PnQ4cLCQeuknvyu
WdYzH69g8fby0aQbS0mdvGof3DzsA2sIA0SaVfW5uVIBd/d0BqdGX+4sTWE7ZU12
NoLBX37Xm+aSyp8rKjXgFY+y9yop6saRjHj0duVqWALl+nXDRkeo9XzRTVhLUAJs
xagNQ1cRrk9VD+BdU2TxKam6o5q17fhSaqELMiSDKwYwbiOabp4LtTWXPKW9xGZx
ap0KoPxMaxM70kxEMc/pR325ymZg/sGxNHqpzzI6Xum34wXHRq6jsTysLZbgenVQ
6k1CA/fBLSPbz0Kvi/LtH0b8p6m3S7456rCJL3frmAPxXudq+61DBZH9jFFeGp6S
4MlcxOseevPdz7ywUUlJB7jCMNqqcVP2cwP1Ch9LM00Dp1Kl/LgMJWB2FimCG6FI
AkbGYBTWfoA=
=jE1d
-----END PGP SIGNATURE-----

--=-34PVV3Bggk5EDdtCKdHa--
