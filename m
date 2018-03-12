Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45517 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750752AbeCLILn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 04:11:43 -0400
Message-ID: <1520842245.1513.5.camel@bootlin.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Dmitry Osipenko <digetx@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Mon, 12 Mar 2018 09:10:45 +0100
In-Reply-To: <6470b45d-e9dc-0a22-febc-cd18ae1092be@gmail.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
         <1520440654.1092.15.camel@bootlin.com>
         <6470b45d-e9dc-0a22-febc-cd18ae1092be@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-nCN24A6UFPZKFV8sAZLz"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-nCN24A6UFPZKFV8sAZLz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2018-03-11 at 22:42 +0300, Dmitry Osipenko wrote:
> Hello,
>=20
> On 07.03.2018 19:37, Paul Kocialkowski wrote:
> > Hi,
> >=20
> > First off, I'd like to take the occasion to say thank-you for your
> > work.
> > This is a major piece of plumbing that is required for me to add
> > support
> > for the Allwinner CedarX VPU hardware in upstream Linux. Other
> > drivers,
> > such as tegra-vde (that was recently merged in staging) are also
> > badly
> > in need of this API.
>=20
> Certainly it would be good to have a common UAPI. Yet I haven't got my
> hands on
> trying to implement the V4L interface for the tegra-vde driver, but
> I've taken a
> look at Cedrus driver and for now I've one question:
>=20
> Would it be possible (or maybe already is) to have a single IOCTL that
> takes input/output buffers with codec parameters, processes the
> request(s) and returns to userspace when everything is done? Having 5
> context switches for a single frame decode (like Cedrus VAAPI driver
> does) looks like a bit of overhead.

The V4L2 interface exposes ioctls for differents actions and I don't
think there's a combined ioctl for this. The request API was introduced
precisely because we need to have consistency between the various ioctls
needed for each frame. Maybe one single (atomic) ioctl would have worked
too, but that's apparently not how the V4L2 API was designed.

I don't think there is any particular overhead caused by having n ioctls
instead of a single one. At least that would be very surprising IMHO.

> > I have a few comments based on my experience integrating this
> > request API with the Cedrus VPU driver (and the associated libva
> > backend), that also concern the vim2m driver.
> >=20
> > On Tue, 2018-02-20 at 13:44 +0900, Alexandre Courbot wrote:
> > > Set the necessary ops for supporting requests in vim2m.
> > >=20
> > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > > ---
> > >  drivers/media/platform/Kconfig |  1 +
> > >  drivers/media/platform/vim2m.c | 75
> > > ++++++++++++++++++++++++++++++++++
> > >  2 files changed, 76 insertions(+)
> > >=20
> > > diff --git a/drivers/media/platform/Kconfig
> > > b/drivers/media/platform/Kconfig
> > > index 614fbef08ddc..09be0b5f9afe 100644
> > > --- a/drivers/media/platform/Kconfig
> > > +++ b/drivers/media/platform/Kconfig
> >=20
> > [...]
> >=20
> > > +static int vim2m_request_submit(struct media_request *req,
> > > +				struct media_request_entity_data
> > > *_data)
> > > +{
> > > +	struct v4l2_request_entity_data *data;
> > > +
> > > +	data =3D to_v4l2_entity_data(_data);
> >=20
> > We need to call v4l2_m2m_try_schedule here so that m2m scheduling
> > can
> > happen when only 2 buffers were queued and no other action was taken
> > from usespace. In that scenario, m2m scheduling currently doesn't
> > happen.
> >=20
> > However, this requires access to the m2m context, which is not easy
> > to
> > get from req or _data. I'm not sure that some container_of magic
> > would
> > even do the trick here.
> >=20
> > > +	return vb2_request_submit(data);
> >=20
> > vb2_request_submit does not lock the associated request mutex
> > although
> > it accesses the associated queued buffers list, which I believe this
> > mutex is supposed to protect.
> >=20
> > We could either wrap this call with media_request_lock(req) and
> > media_request_unlock(req) or have the lock in the function itself,
> > which
> > would require passing it the req pointer.
> >=20
> > The latter would probably be safer for future use of the function.
> >=20
> > > +}
> > > +
> > > +static const struct media_request_entity_ops
> > > vim2m_request_entity_ops
> > > =3D {
> > > +	.data_alloc	=3D vim2m_entity_data_alloc,
> > > +	.data_free	=3D v4l2_request_entity_data_free,
> > > +	.submit		=3D vim2m_request_submit,
> > > +};
> > > +
> > >  /*
> > >   * File operations
> > >   */
> > > @@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
> > >  	ctx->dev =3D dev;
> > >  	hdl =3D &ctx->hdl;
> > >  	v4l2_ctrl_handler_init(hdl, 4);
> > > +	v4l2_request_entity_init(&ctx->req_entity,
> > > &vim2m_request_entity_ops,
> > > +				 &ctx->dev->vfd);
> > > +	ctx->fh.entity =3D &ctx->req_entity.base;
> > >  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP,
> > > 0, 1,
> > > 1, 0);
> > >  	v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP,
> > > 0, 1,
> > > 1, 0);
> > >  	v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec,
> > > NULL);
> > > @@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device
> > > *pdev)
> > >  	if (!dev)
> > >  		return -ENOMEM;
> > > =20
> > > +	v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
> > > +			      &v4l2_request_ops);
> > > +
> > >  	spin_lock_init(&dev->irqlock);
> > > =20
> > >  	ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > > @@ -1012,6 +1085,7 @@ static int vim2m_probe(struct
> > > platform_device
> > > *pdev)
> > >  	vfd =3D &dev->vfd;
> > >  	vfd->lock =3D &dev->dev_mutex;
> > >  	vfd->v4l2_dev =3D &dev->v4l2_dev;
> > > +	vfd->req_mgr =3D &dev->req_mgr.base;
> > > =20
> > >  	ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > >  	if (ret) {
> > > @@ -1054,6 +1128,7 @@ static int vim2m_remove(struct
> > > platform_device
> > > *pdev)
> > >  	del_timer_sync(&dev->timer);
> > >  	video_unregister_device(&dev->vfd);
> > >  	v4l2_device_unregister(&dev->v4l2_dev);
> > > +	v4l2_request_mgr_free(&dev->req_mgr);
> > > =20
> > >  	return 0;
> > >  }
>=20
>=20
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-nCN24A6UFPZKFV8sAZLz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqmNgUACgkQ3cLmz3+f
v9ERJQgAnMVWv7/K+npf2jX8Gznljiv0VN+zRdzTGbWN+EP5pKH9xLjVx0Pb+UoI
Oo9Ltu+AI3GEckcdSxjOIwWupyDPOY0g3nzrZ8AzjLGYICsq8mNC4HlgwqtB3Hkb
PtgkYPbP3Fis8UkuvTQHPtyPMNJQGPfGvSb8Bx8SyBgPFDsAAfCrm/ic/2kdwGQA
zYlaTBcUdfXULOVT2uU1v5s3YGtBeRQ4qH0ogOhlBY64GJjkDcyu5sEElCCnpQ/L
eRYqCmrjXRI/kAZrB3hpGDsEWoVYsWSXsOojqw3RCei9bP8kDfnT77Auj7HkfCRN
EdiG6QfHnN/zXeuKGCee9CA1lhgHzw==
=Xl00
-----END PGP SIGNATURE-----

--=-nCN24A6UFPZKFV8sAZLz--
