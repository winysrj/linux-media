Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49464 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764328AbcINTt4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 15:49:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 02/13] v4l: vsp1: Protect against race conditions between get and set format
Date: Wed, 14 Sep 2016 22:50:37 +0300
Message-ID: <2486540.vxE6uRc2v9@avalon>
In-Reply-To: <20160914182317.GG739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1473808626-19488-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160914182317.GG739@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the review.

On Wednesday 14 Sep 2016 20:23:18 Niklas S=F6derlund wrote:
> On 2016-09-14 02:16:55 +0300, Laurent Pinchart wrote:
> > The subdev userspace API isn't serialized in the core, serialize ac=
cess
> > to formats and selection rectangles in the driver.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >=20
> >  drivers/media/platform/vsp1/vsp1_bru.c    | 28 +++++++++++++++----=
-
> >  drivers/media/platform/vsp1/vsp1_clu.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_entity.c | 22 +++++++++++++---
> >  drivers/media/platform/vsp1/vsp1_entity.h |  4 ++-
> >  drivers/media/platform/vsp1/vsp1_hsit.c   | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_lif.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_lut.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_rwpf.c   | 44 +++++++++++++++++++=
-------
> >  drivers/media/platform/vsp1/vsp1_sru.c    | 26 +++++++++++++-----
> >  drivers/media/platform/vsp1/vsp1_uds.c    | 26 +++++++++++++-----
> >  10 files changed, 161 insertions(+), 49 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/vsp1/vsp1_bru.c
> > b/drivers/media/platform/vsp1/vsp1_bru.c index 8268b87727a7..26b9e2=
282a41
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_bru.c
> > +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> > @@ -142,10 +142,15 @@ static int bru_set_format(struct v4l2_subdev
> > *subdev,
> >=20
> >  =09struct vsp1_bru *bru =3D to_bru(subdev);
> >  =09struct v4l2_subdev_pad_config *config;
> >  =09struct v4l2_mbus_framefmt *format;
> >=20
> > +=09int ret =3D 0;
> > +
> > +=09mutex_lock(&bru->entity.lock);
> >=20
> >  =09config =3D vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->w=
hich);
> >=20
> > -=09if (!config)
> > -=09=09return -EINVAL;
> > +=09if (!config) {
> > +=09=09goto done;
> > +=09=09ret =3D -EINVAL;
>=20
> This looks funny to me, you probably intended to do that in the other=

> order right?

Oops, good catch !

> If you fix this feel free to add my:
>=20
> Acked-by: Niklas S=F6derlund <niklas.soderlund@ragnatech.se>

Fixed and applied your ack (with +renesas as mentioned in your other em=
ail).

> > +=09}
> >=20
> >  =09bru_try_format(bru, config, fmt->pad, &fmt->format);

--=20
Regards,

Laurent Pinchart

