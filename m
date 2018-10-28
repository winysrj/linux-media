Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32949 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJ2BzW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Oct 2018 21:55:22 -0400
Received: by mail-pg1-f193.google.com with SMTP id z2-v6so2751886pgp.0
        for <linux-media@vger.kernel.org>; Sun, 28 Oct 2018 10:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com>
 <1540045588-9091-4-git-send-email-akinobu.mita@gmail.com> <CAJCx=gm0+ZdPKed_w4yZv8+ohgHWh3bi+=7nqxTjazHFtfFQsQ@mail.gmail.com>
 <CAC5umyg4VSFS2v28h590aCx3Zn-F0PxHHx21YaoLik7b9pMG4g@mail.gmail.com>
In-Reply-To: <CAC5umyg4VSFS2v28h590aCx3Zn-F0PxHHx21YaoLik7b9pMG4g@mail.gmail.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Sun, 28 Oct 2018 10:09:57 -0700
Message-ID: <CAJCx=gnAdETWnqwx+SoKHScHP=nGYLAeKH2M3Hgxopt=Xq5HfQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] media: v4l2-common: add V4L2_FRACT_COMPARE
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Hans Verkuil <hansverk@cisco.com>, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 28, 2018 at 9:25 AM Akinobu Mita <akinobu.mita@gmail.com> wrote=
:
>
> 2018=E5=B9=B410=E6=9C=8828=E6=97=A5(=E6=97=A5) 12:49 Matt Ranostay <matt.=
ranostay@konsulko.com>:
> >
> > On Sat, Oct 20, 2018 at 7:26 AM Akinobu Mita <akinobu.mita@gmail.com> w=
rote:
> > >
> > > Add macro to compare two v4l2_fract values in v4l2 common internal AP=
I.
> > > The same macro FRACT_CMP() is used by vivid and bcm2835-camera.  This=
 just
> > > renames it to V4L2_FRACT_COMPARE in order to avoid namespace collisio=
n.
> > >
> > > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Hans Verkuil <hansverk@cisco.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > > * v4
> > > - No changes from v3
> > >
> > >  include/media/v4l2-common.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.=
h
> > > index cdc87ec..eafb8a3 100644
> > > --- a/include/media/v4l2-common.h
> > > +++ b/include/media/v4l2-common.h
> > > @@ -384,4 +384,9 @@ int v4l2_g_parm_cap(struct video_device *vdev,
> > >  int v4l2_s_parm_cap(struct video_device *vdev,
> > >                     struct v4l2_subdev *sd, struct v4l2_streamparm *a=
);
> > >
> > > +/* Compare two v4l2_fract structs */
> > > +#define V4L2_FRACT_COMPARE(a, OP, b)                   \
> > > +       ((u64)(a).numerator * (b).denominator OP        \
> > > +       (u64)(b).numerator * (a).denominator)
> > > +
> >
> > Noticed a few issues today when testing another thermal camera that
> > can do 0.5 fps to 64 fps with this macro..
>
> I expect your new thermal camera's frame_intervals will be something
> like below.
>
> static const struct v4l2_fract frame_intervals[] =3D {
>         { 1, 64 },      /* 64 fps */
>         { 1, 4 },       /* 4 fps */
>         { 1, 2 },       /* 2 fps */
>         { 2, 1 },       /* 0.5 fps */
> };
>
> > 1) This can have collision easily when numerator and denominators
> > multiplied have the same product, example is 0.5hz and 2hz have the
> > same output as 2
>
> I think V4L2_FRACT_COMPARE() can correctly compare with 0.5hz and 2hz.
>
> V4L2_FRACT_COMPARE({ 1, 2 }, <=3D, { 2, 1 }); // -->  true
> V4L2_FRACT_COMPARE({ 2, 1 }, <=3D, { 1, 2 }); //-->  false
>
> > 2) Also this doesn't reduce fractions so I am seeing 4000000 compared
> > with 4 for instance with a 4hz frame interval.
>
> I think this works fine, too.
>
> V4L2_FRACT_COMPARE({ 1, 4000000 }, <=3D, { 1, 4 }); //-->  true
> V4L2_FRACT_COMPARE({ 1, 4 }, <=3D, { 1, 4000000 }); //-->  false
>
> Or, do I misunderstand your problem?

Probably not! I didn't think of them having to be sorted in a certain
way, but will test and probably will work.

Couldn't hurt to have that noted in a comment some where as well.

- Matt
