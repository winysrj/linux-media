Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41237 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdBEWQZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2017 17:16:25 -0500
Date: Sun, 5 Feb 2017 23:16:22 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Add video bus switch
Message-ID: <20170205221622.GA16107@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170112111731.GA27541@amd>
 <20170203222520.GE12291@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <20170203222520.GE12291@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I lost my original reply... so this will be slightly brief.

> > > + * This program is distributed in the hope that it will be useful, b=
ut
> > > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > > + * General Public License for more details.
> > > + */
> > > +
> > > +#define DEBUG
>=20
> Please remove.

Ok.

> > > +#include <linux/of_graph.h>
> > > +#include <linux/gpio/consumer.h>
>=20
> Alphabetical order, please.

Ok. (But let me make unhappy noise, because these rules are
inconsistent across kernel.)

> > > + * TODO:
> > > + * isp_subdev_notifier_complete() calls v4l2_device_register_subdev_=
nodes()
> > > + */
> > > +
> > > +#define CSI_SWITCH_SUBDEVS 2
> > > +#define CSI_SWITCH_PORTS 3
>=20
> This could go to the enum below.
>=20
> I guess the CSI_SWITCH_SUBDEVS could be (CSI_SWITCH_PORTS - 1).
>=20
> I'd just replace CSI_SWITCH by VBS. The bus could be called
> differently.

Ok.

> > > +static int vbs_registered(struct v4l2_subdev *sd)
> > > +{
> > > +	struct v4l2_device *v4l2_dev =3D sd->v4l2_dev;
> > > +	struct vbs_data *pdata;
> > > +	int err;
> > > +
> > > +	dev_dbg(sd->dev, "registered, init notifier...\n");
>=20
> Looks like a development time debug message. :-)

ex-development message ;-).

> > > +	gpiod_set_value(pdata->swgpio, local->index =3D=3D CSI_SWITCH_PORT_=
2);
> > > +	pdata->state =3D local->index;
> > > +
> > > +	sd =3D vbs_get_remote_subdev(sd);
> > > +	if (IS_ERR(sd))
> > > +		return PTR_ERR(sd);
> > > +
> > > +	pdata->subdev.ctrl_handler =3D sd->ctrl_handler;
>=20
> This is ugly. You're exposing all the controls through another sub-device.
>=20
> How does link validation work now?
>=20
> I wonder if it'd be less so if you just pass through the LINK_FREQ and
> PIXEL_RATE controls. It'll certainly be more code though.
>=20
> I think the link frequency could be something that goes to the frame
> descriptor as well. Then we wouldn't need to worry about the controls
> separately, just passing the frame descriptor would be enough.
>=20
> I apologise that I don't have patches quite ready for posting to the
> list.

(Plus of course question is "what is link validation".)

Ok, let me play with this one. Solution you are suggesting is to make
a custom harndler that only passes certain data through, right?

> > > +		dev_dbg(pdata->subdev.dev, "create link: %s[%d] -> %s[%d])\n",
> > > +			src->name, src_pad, sink->name, sink_pad);
> > > +	}
> > > +
> > > +	return v4l2_device_register_subdev_nodes(pdata->subdev.v4l2_dev);
>=20
> The ISP driver's complete() callback calls
> v4l2_device_register_subdev_nodes() already. Currently it cannot handle
> being called more than once --- that needs to be fixed.

I may have patches for that. Let me check.

> > > +}
> > > +
> > > +
>=20
> I'd say that's an extra newline.

Not any more.

> > > +	v4l2_subdev_init(&pdata->subdev, &vbs_ops);
> > > +	pdata->subdev.dev =3D &pdev->dev;
> > > +	pdata->subdev.owner =3D pdev->dev.driver->owner;
> > > +	strncpy(pdata->subdev.name, dev_name(&pdev->dev), V4L2_SUBDEV_NAME_=
SIZE);
>=20
> How about sizeof(pdata->subdev.name) ?

Ok.

> I'm not sure I like V4L2_SUBDEV_NAME_SIZE in general. It could be even
> removed. But not by this patch. :-)
>=20
> > > +	v4l2_set_subdevdata(&pdata->subdev, pdata);
> > > +	pdata->subdev.entity.function =3D MEDIA_ENT_F_SWITCH;
> > > +	pdata->subdev.entity.flags |=3D MEDIA_ENT_F_SWITCH;
>=20
> MEDIA_ENT_FL_*

Do we actually have a flag here? We already have .function, so this
looks like a duplicate.


> > > +	if (err < 0) {
> > > +		dev_err(&pdev->dev, "Failed to register v4l2 subdev: %d\n", err);
> > > +		media_entity_cleanup(&pdata->subdev.entity);
> > > +		return err;
> > > +	}
> > > +
> > > +	dev_info(&pdev->dev, "video-bus-switch registered\n");
>=20
> How about dev_dbg()?

Ok.

> > > +static int video_bus_switch_remove(struct platform_device *pdev)
> > > +{
> > > +	struct vbs_data *pdata =3D platform_get_drvdata(pdev);
> > > +
> > > +	v4l2_async_notifier_unregister(&pdata->notifier);
>=20
> Shouldn't you unregister the notifier in the .unregister() callback?

Ok, I guess we can do that for symetry.

> > >  /* generic v4l2_device notify callback notification values */
> > >  #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
> > > @@ -415,6 +416,8 @@ struct v4l2_subdev_video_ops {
> > >  			     const struct v4l2_mbus_config *cfg);
> > >  	int (*s_rx_buffer)(struct v4l2_subdev *sd, void *buf,
> > >  			   unsigned int *size);
> > > +	int (*g_endpoint_config)(struct v4l2_subdev *sd,
> > > +			    struct v4l2_of_endpoint *cfg);
>=20
> This should be in a separate patch --- assuming we'll add this one.

Hmm. I believe the rest of the driver is quite useful in understanding
this. Ok, lets get the discussion started.

> > > --- a/include/uapi/linux/media.h
> > > +++ b/include/uapi/linux/media.h
> > > @@ -147,6 +147,7 @@ struct media_device_info {
> > >   * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
> > >   */
> > >  #define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> > > +#define MEDIA_ENT_F_SWITCH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 6)
>=20
> I wonder if MEDIA_ENT_F_PROC_ would be a better prefix.
> We shouldn't have new entries in MEDIA_ENT_F_OLD_SUBDEV_BASE anymore.

Ok.
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliXpDYACgkQMOfwapXb+vLoCQCePsRS+V5jh+nyr8DUxqFtH67Q
/UwAn0sAeXpA0Xph22ky93Q9bT8sOhDJ
=PQ7V
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
