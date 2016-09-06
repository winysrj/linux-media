Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50377 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936449AbcIFSGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 14:06:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Move subdev operations from HGO to common histogram code
Date: Tue, 06 Sep 2016 21:07:08 +0300
Message-ID: <2299755.6RU5rO9Jvq@avalon>
In-Reply-To: <20160906102759.GG27014@bigcity.dyn.berto.se>
References: <1473088419-2800-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20160906102759.GG27014@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Tuesday 06 Sep 2016 12:28:00 Niklas S=F6derlund wrote:
> On 2016-09-05 18:13:39 +0300, Laurent Pinchart wrote:
> > The code will be shared with the HGT entity, move it to the generic=

> > histogram implementation.
> >=20
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >=20
> >  drivers/media/platform/vsp1/vsp1_drv.c   |   7 +-
> >  drivers/media/platform/vsp1/vsp1_hgo.c   | 308 ++-----------------=
------
> >  drivers/media/platform/vsp1/vsp1_hgo.h   |   7 +-
> >  drivers/media/platform/vsp1/vsp1_histo.c | 334 +++++++++++++++++++=
++++--
> >  drivers/media/platform/vsp1/vsp1_histo.h |  25 ++-
> >  5 files changed, 355 insertions(+), 326 deletions(-)

[snip]

> > @@ -268,7 +559,16 @@ int vsp1_histogram_init(struct vsp1_device *vs=
p1,
> > struct vsp1_histogram *histo,>=20
> >  =09INIT_LIST_HEAD(&histo->irqqueue);
> >  =09init_waitqueue_head(&histo->wait_queue);
> >=20
> > -=09/* Initialize the media entity... */
> > +=09/* Initialize the VSP entity... */
> > +=09histo->entity.ops =3D ops;
> > +=09histo->entity.type =3D type;
> > +
> > +=09ret =3D vsp1_entity_init(vsp1, &histo->entity, name, 2, &histo_=
ops,
> > +=09=09=09       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
> > +=09if (ret < 0)
> > +=09=09return ret;
> > +
> > +=09/* ... and the media entity... */
> >  =09ret =3D media_entity_pads_init(&histo->video.entity, 1, &histo-=
>pad);
> >  =09if (ret < 0)
> >  =09=09return ret;
>=20
> You forgot to update the histo video device name to match the subdevi=
ce
> name here. Something like this makes vsp-tests work for me again.
>=20
> @@ -577,7 +577,7 @@ int vsp1_histogram_init(struct vsp1_device *vsp1,=
 struct
> vsp1_histogram *histo, histo->video.v4l2_dev =3D &vsp1->v4l2_dev;
>         histo->video.fops =3D &histo_v4l2_fops;
>         snprintf(histo->video.name, sizeof(histo->video.name),
> -                "%s histo", name);
> +                "%s histo", histo->entity.subdev.name);
>         histo->video.vfl_type =3D VFL_TYPE_GRABBER;
>         histo->video.release =3D video_device_release_empty;
>         histo->video.ioctl_ops =3D &histo_v4l2_ioctl_ops;
>=20
> Without this fix the names listed using media-ctl -p show:
>=20
> - entity 1: hgo histo (1 pad, 1 link)
>=20
> Instead as it did before:
>=20
> - entity 1: fe928000.vsp1 hgo histo (1 pad, 1 link)
>=20
> Other then that
>=20
> Tested-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>=


Thank you. I'll fix that in the next version.

--=20
Regards,

Laurent Pinchart

