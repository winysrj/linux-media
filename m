Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751029AbcISVCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:02:35 -0400
Date: Mon, 19 Sep 2016 23:02:28 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 04/17] smiapp: Split off sub-device registration into
 two
Message-ID: <20160919210227.phnh2mtskevrbfka@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-5-git-send-email-sakari.ailus@linux.intel.com>
 <20160919203022.v4vih6stlfci5cft@earth>
 <57E04F7A.4080009@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="stolkl3m253nr2vs"
Content-Disposition: inline
In-Reply-To: <57E04F7A.4080009@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--stolkl3m253nr2vs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 19, 2016 at 11:50:02PM +0300, Sakari Ailus wrote:
> Hi Sebastian,
>=20
> Sebastian Reichel wrote:
> > Hi,
> >=20
> > On Thu, Sep 15, 2016 at 02:22:18PM +0300, Sakari Ailus wrote:
> > > Remove the loop in sub-device registration and create each sub-device
> > > explicitly instead.
> >=20
> > Reviewed-By: Sebastian Reichel <sre@kernel.org>
>=20
> Thanks!
>=20
> >=20
> > > +static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
> > > +{
> > > +	int rval;
> > > +
> > > +	if (sensor->scaler) {
> > > +		rval =3D smiapp_register_subdev(
> > > +			sensor, sensor->binner, sensor->scaler,
> > > +			SMIAPP_PAD_SRC, SMIAPP_PAD_SINK,
> > > +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> > > +		if (rval < 0)
> > >   			return rval;
> > > -		}
> > >   	}
> > >=20
> > > -	return 0;
> > > +	return smiapp_register_subdev(
> > > +		sensor, sensor->pixel_array, sensor->binner,
> > > +		SMIAPP_PA_PAD_SRC, SMIAPP_PAD_SINK,
> > > +		MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> > >   }
> >=20
> > I haven't looked at the remaining code, but is sensor->scaler
> > stuff being cleaned up properly if the binner part fails?
>=20
> That's a very good question. I don't think it is. But that's how
> the code has always been=20

Yes, it's not a regression introduced by this patch, that's why I
gave Reviewed-By ;)

> --- there are issues left to be resolved if registered() fails for
> a reason or another. For instance, removing and reloading the
> omap3-isp module will cause a failure in the smiapp driver unless
> it's unloaded as well.
>
> I think I prefer to fix that in a different patch(set) as this one
> is quite large already.

ok.

-- Sebastian

--stolkl3m253nr2vs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FJjAAoJENju1/PIO/qatGYP/3B+jmq1ngez4j7pkXeMFYmS
/3j1MxmW2ReDvpSvyzwgsS6mG5IY9CDAGRLp0uno9Kjdf2QSxxXTbZENHoZVlpj2
ns1CrWejfz5CG5Cp5TBXglOyCtvvKjrWQ0AWgrCt0tP6degKdOLvCk/5wjdHqxuJ
H48CHAcym9PD538VsrZhSTs1myHegPS/9mzrTNJQaoIaNJuaB3jnACZkutD4yMRb
gn6rhrua2OE42Cu+xm1Upmc9g1kEMZZcHK52jhml3FxABdt1+zwc6BteeCZXv05L
mG7hiPk3GyHblIpfovgNDKNtD5Iw/BUDCeDAxTkVddEkd8RfxxbihpQJCXe+2tg+
z/6t5rhKgeRV7oMgRnv9Go8IS0QIlUoWgQS1MAP2D/mR7bwSnuqqkge5VmMS2bYQ
s/ad8iacSKmKp23ppvvxRYyo/yPcgNlAlPJvHfSWQCdVZmoTcB+mu+3WHpgA9Rxr
1bl51dKbBokXiVGXdt4aYbKcQOfS1YqnzhZ9msU8a3xr5ZAQbSOk8FSUZlPQhK/o
ZktvcunlOMkKmcJo3zZxDPCKNklfL6Lh1OCkaG6bpB1mUUl6lqfCcTEwnTu4gR6a
gd6TH2jmzDsxEaXXpWjrOM51egq9pimhyqP++OOVtJj4+8MKbeWz4GeCAGLtY8uf
lYXLALhDcrEXK2C1zEtd
=3f2X
-----END PGP SIGNATURE-----

--stolkl3m253nr2vs--
