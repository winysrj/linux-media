Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:57690 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbeCIOgf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 09:36:35 -0500
Message-ID: <1520606128.15946.22.camel@bootlin.com>
Subject: Re: [RFCv4,19/21] media: vim2m: add request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Date: Fri, 09 Mar 2018 15:35:28 +0100
In-Reply-To: <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
References: <20180220044425.169493-20-acourbot@chromium.org>
         <1520440654.1092.15.camel@bootlin.com>
         <CAPBb6MUeUaHZj9y1N7wJk9yS8QL+zTqWCGvujcKCY0YpdeiyWg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-2+w2VVM1aHj5IAvkAEh3"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-2+w2VVM1aHj5IAvkAEh3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-03-08 at 22:48 +0900, Alexandre Courbot wrote:
> Hi Paul!
>=20
> Thanks a lot for taking the time to try this! I am also working on
> getting it to work with an actual driver, but you apparently found
> rough edges that I missed.
>=20
> On Thu, Mar 8, 2018 at 1:37 AM, Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
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
> >=20
> > I have a few comments based on my experience integrating this
> > request
> > API with the Cedrus VPU driver (and the associated libva backend),
> > that
> > also concern the vim2m driver.
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
> > > +                             struct media_request_entity_data
> > > *_data)
> > > +{
> > > +     struct v4l2_request_entity_data *data;
> > > +
> > > +     data =3D to_v4l2_entity_data(_data);
> >=20
> > We need to call v4l2_m2m_try_schedule here so that m2m scheduling
> > can
> > happen when only 2 buffers were queued and no other action was taken
> > from usespace. In that scenario, m2m scheduling currently doesn't
> > happen.
>=20
> I don't think I understand the sequence of events that results in
> v4l2_m2m_try_schedule() not being called. Do you mean something like:
>=20
> *
> * QBUF on output queue with request set
> * QBUF on capture queue
> * SUBMIT_REQUEST
>=20
> ?
>=20
> The call to vb2_request_submit() right after should trigger
> v4l2_m2m_try_schedule(), since the buffers associated to the request
> will enter the vb2 queue and be passed to the m2m framework, which
> will then call v4l2_m2m_try_schedule(). Or maybe you are thinking
> about a different sequence of events?

This is indeed the sequence of events that I'm seeing, but the
scheduling call simply did not happen on vb2_request_submit. I suppose I wi=
ll need to investigate some more to find out exactly why.

IIRC, the m2m qbuf function is called (and fails to schedule) when the
ioctl happens, not when the task is submitted.

This issue is seen with vim2m as well as the rencently-submitted sunxi-
cedrus driver (with the in-driver calls to v4l2_m2m_try_schedule
removed, obviously). If needs be, I could provide a standalone test
program to reproduce it.

> > However, this requires access to the m2m context, which is not easy
> > to
> > get from req or _data. I'm not sure that some container_of magic
> > would
> > even do the trick here.
>=20
> data_->entity will give you a pointer to the media_request_entity,
> which is part of vim2m_ctx. You can thus get the m2m context by doing
> container_of(data_->entity, struct vim2m_ctx, req_entity). See
> vim2m_entity_data_alloc() for an example.

Excellent, that's exactly what I was looking for! Thanks a lot and see
the related patch I submitted earlier today.

> > > +     return vb2_request_submit(data);
> >=20
> > vb2_request_submit does not lock the associated request mutex
> > although
> > it accesses the associated queued buffers list, which I believe this
> > mutex is supposed to protect.
>=20
> After a request is submitted, the data protected by the mutex can only
> be accessed by the driver when it processes the request. It cannot be
> modified concurrently, so I think we are safe here.

Fait enough, that should be enough then. I've dropped this change.

Cheers,

Paul

> I am also wondering whether the ioctl locking doesn't make the request
> locking redundant. Request information can only be modified and
> accessed through ioctls until it is submitted, and after that there
> are no concurrent accesses. I need to think a bit more about it
> though.
>=20
> Cheers,
> Alex.
>=20
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
> > > +     .data_alloc     =3D vim2m_entity_data_alloc,
> > > +     .data_free      =3D v4l2_request_entity_data_free,
> > > +     .submit         =3D vim2m_request_submit,
> > > +};
> > > +
> > >  /*
> > >   * File operations
> > >   */
> > > @@ -900,6 +967,9 @@ static int vim2m_open(struct file *file)
> > >       ctx->dev =3D dev;
> > >       hdl =3D &ctx->hdl;
> > >       v4l2_ctrl_handler_init(hdl, 4);
> > > +     v4l2_request_entity_init(&ctx->req_entity,
> > > &vim2m_request_entity_ops,
> > > +                              &ctx->dev->vfd);
> > > +     ctx->fh.entity =3D &ctx->req_entity.base;
> > >       v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_HFLIP, 0,
> > > 1,
> > > 1, 0);
> > >       v4l2_ctrl_new_std(hdl, &vim2m_ctrl_ops, V4L2_CID_VFLIP, 0,
> > > 1,
> > > 1, 0);
> > >       v4l2_ctrl_new_custom(hdl, &vim2m_ctrl_trans_time_msec,
> > > NULL);
> > > @@ -999,6 +1069,9 @@ static int vim2m_probe(struct platform_device
> > > *pdev)
> > >       if (!dev)
> > >               return -ENOMEM;
> > >=20
> > > +     v4l2_request_mgr_init(&dev->req_mgr, &dev->vfd,
> > > +                           &v4l2_request_ops);
> > > +
> > >       spin_lock_init(&dev->irqlock);
> > >=20
> > >       ret =3D v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > > @@ -1012,6 +1085,7 @@ static int vim2m_probe(struct
> > > platform_device
> > > *pdev)
> > >       vfd =3D &dev->vfd;
> > >       vfd->lock =3D &dev->dev_mutex;
> > >       vfd->v4l2_dev =3D &dev->v4l2_dev;
> > > +     vfd->req_mgr =3D &dev->req_mgr.base;
> > >=20
> > >       ret =3D video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> > >       if (ret) {
> > > @@ -1054,6 +1128,7 @@ static int vim2m_remove(struct
> > > platform_device
> > > *pdev)
> > >       del_timer_sync(&dev->timer);
> > >       video_unregister_device(&dev->vfd);
> > >       v4l2_device_unregister(&dev->v4l2_dev);
> > > +     v4l2_request_mgr_free(&dev->req_mgr);
> > >=20
> > >       return 0;
> > >  }
> >=20
> > --
> > Paul Kocialkowski, Bootlin (formerly Free Electrons)
> > Embedded Linux and kernel engineering
> > https://bootlin.com
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-2+w2VVM1aHj5IAvkAEh3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlqim7AACgkQ3cLmz3+f
v9EBpwf9EvE7GHD70OTFOsHvqmYZIhlxNYh2eKoiBhyy+AWuEDwLtqjcZoGwbBge
bZrvJBxqT8GGRcIerX2WBEOG1mn4qLS1lVmuQ2r7plhO0N0XmBnaFCjW8ZDgE4CR
pAUR1ddQ467M3k+k9tXh+kYmeth3osEq37BTPAQtZU9rmkbDGH1CFPmUl6Vbapty
u2Ytmiq6yeEW4lGlwD9w0pKW04G67PPNaam7UFuKPk6Cgzb2bvMXKLUTt5C3IWOY
oc3KkW/gWdQvugs33Ccg7wSLgWNEaRsEqssWZfcfdTaz6adJUrbrPAwCvecnICuG
mb1G45zp9CtPBQ+wlVQNioTLYtLTzg==
=oart
-----END PGP SIGNATURE-----

--=-2+w2VVM1aHj5IAvkAEh3--
