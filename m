Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55034 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbdCDTFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 14:05:10 -0500
Date: Sat, 4 Mar 2017 20:05:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170304190505.GA31766@amd>
References: <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
 <20170304085551.GA19769@amd>
 <20170304123010.GT3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20170304123010.GT3220@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-03-04 14:30:11, Sakari Ailus wrote:
> On Sat, Mar 04, 2017 at 09:55:51AM +0100, Pavel Machek wrote:
> > Dobry den! :-)
>=20
> Huomenta! :-)

Dobry vecer! :-).

> > > Good point. Still there may be other ways to move the lens than the v=
oice
> > > coil (which sure is cheap), so how about "flash" and "lens-focus"?
> >=20
> > Ok, so something like this? (Yes, needs binding documentation and you
> > wanted it in the core.. can fix.)
> >=20
> > BTW, fwnode_handle_put() seems to be missing in the success path of
> > isp_fwnodes_parse() -- can you check that?
>=20
> Where exactly? I noticed that if notifier->num_subdevs hits the limit the
> last node isn't put properly. I'll fix that. Is that what you meant?

I guess I'm confused. I see no put on the success path. Maybe it is
put somewhere out of the function where I did not look... is the
reference held while the driver is running

> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2114,7 +2114,7 @@ static int isp_fwnode_parse(struct device *dev, s=
truct fwnode_handle *fwn,
> >  			buscfg->bus.ccp2.lanecfg.data[0].pol =3D
> >  				vfwn.bus.mipi_csi1.lane_polarity[1];
> > =20
> > -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> > +			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", 0,
>=20
> Why?

I was printing uninitialized / unused variable, which is a no-no (and
gcc complains). I guess I should do a separate patch.

> >  				buscfg->bus.ccp2.lanecfg.data[0].pol,
> >  				buscfg->bus.ccp2.lanecfg.data[0].pos);
> > =20
> > @@ -2162,10 +2162,64 @@ static int isp_fwnode_parse(struct device *dev,=
 struct fwnode_handle *fwn,
> >  	return 0;
> >  }
> > =20
> > +static int camera_subdev_parse(struct device *dev, struct v4l2_async_n=
otifier *notifier,
> > +			       const char *key)
> > +{
> > +	struct device_node *node;
> > +	struct isp_async_subdev *isd;
> > +
> > +	printk("Looking for %s\n", key);
> > +=09
> > +	node =3D of_parse_phandle(dev->of_node, key, 0);
>=20
> There may be more than one flash associated with a sensor. Speaking of wh=
ich
> --- how is it associated to the sensors?

Ok, more then one flash I can understand (will fix).=20

> One way to do this could be to simply move the flash property to the sens=
or
> OF node. We could have it here, too, if the flash was not associated with
> any sensor, but I doubt that will ever be needed.
>=20
> This really calls fork moving this part to the framework away from
> drivers.

The rest I don't get :-(. The flash is likely connected over i2c, so
it should not become child node of omap3isp.

And yes, I agree we want to move it into the framework. Lets agree on
how it should work and where to put it, I'll debug it here then move it...=
=20

> > +	if (!node)
> > +		return 0;
> > +
> > +	printk("Having subdevice: %p\n", node);
> > +	=09
> > +	isd =3D devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> > +	if (!isd)
> > +		return -ENOMEM;
> > +
> > +	notifier->subdevs[notifier->num_subdevs] =3D &isd->asd;
> > +
> > +	isd->asd.match.of.node =3D node;
> > +	if (!isd->asd.match.of.node) {
>=20
> You should check node here first.

Umm. I did, above. This can't happen, AFAICT.

> > +		dev_warn(dev, "bad remote port parent\n");
> > +		return -EIO;
> > +	}
> > +
>=20
> And then assign it here.
>=20
> isd->asd.match.fwnode.fwn =3D of_fwnode_handle(node);
>=20
> > +	isd->asd.match_type =3D V4L2_ASYNC_MATCH_OF;
>=20
> V4L2_ASYNC_MATCH_FWNODE, please.

Ok. Lets see if it still works after the changes :-)... it does, good.

> > +static int camera_subdevs_parse(struct device *dev, struct v4l2_async_=
notifier *notifier,
> > +				int max)
> > +{
> > +	int res =3D 0;
>=20
> No need to assign res here.

Ok.

Thanks and best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli7D+EACgkQMOfwapXb+vKTLACeJ7KfZs+gikF93OHsCpQxd6oN
wdAAn2f5pOpPIv4AWaTduTuDh+1fEFq3
=72mt
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
