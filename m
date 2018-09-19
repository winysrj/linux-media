Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33375 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbeISUlp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 16:41:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id d4-v6so2859762pfn.0
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 08:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <1537200191-17956-1-git-send-email-akinobu.mita@gmail.com>
 <1537200191-17956-4-git-send-email-akinobu.mita@gmail.com> <20180919111840.7pxd2lnxcnlm3t63@paasikivi.fi.intel.com>
In-Reply-To: <20180919111840.7pxd2lnxcnlm3t63@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 20 Sep 2018 00:03:13 +0900
Message-ID: <CAC5umyig3bjO2x7TpECmy82VL4PjR5y1LOKbCjJMjuJMRW6nuQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] media: v4l2-common: add v4l2_find_closest_fract()
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B49=E6=9C=8819=E6=97=A5(=E6=B0=B4) 20:18 Sakari Ailus <sakari.ai=
lus@linux.intel.com>:
>
> Hi Mita-san,
>
> On Tue, Sep 18, 2018 at 01:03:09AM +0900, Akinobu Mita wrote:
> > Add a function to locate the closest element in a sorted v4l2_fract arr=
ay.
> >
> > The implementation is based on find_closest() macro in linux/util_macro=
s.h
> > and the way to compare two v4l2_fract in vivid_vid_cap_s_parm in
> > drivers/media/platform/vivid/vivid-vid-cap.c.
> >
> > Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Cc: Hans Verkuil <hansverk@cisco.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-common.c | 26 ++++++++++++++++++++++++++
> >  include/media/v4l2-common.h           | 12 ++++++++++++
> >  2 files changed, 38 insertions(+)
> >
> > diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2=
-core/v4l2-common.c
> > index b518b92..91bd460 100644
> > --- a/drivers/media/v4l2-core/v4l2-common.c
> > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > @@ -387,6 +387,32 @@ __v4l2_find_nearest_size(const void *array, size_t=
 array_size,
> >  }
> >  EXPORT_SYMBOL_GPL(__v4l2_find_nearest_size);
> >
> > +#define FRACT_CMP(a, OP, b)                          \
> > +     ((u64)(a).numerator * (b).denominator OP        \
> > +      (u64)(b).numerator * (a).denominator)
> > +
> > +int v4l2_find_closest_fract(struct v4l2_fract x, const struct v4l2_fra=
ct *array,
>
> unsigned int ?

As you noticed below, this function may lead to an overflow.  So I planned
to make it return -EOVERFLOW with help of linux/overflow.h.

But now I'm start thinking that finding closest (rounding) value is
overkill.  Instead finding smallest (ceiling) or largest (floor) value is
enough just like in vivid_vid_cap_s_parm() in vivid-vid-cap.c and we don't
need to be bothered with overflows.

> > +                         size_t num)
> > +{
> > +     int i;
> > +
> > +     for (i =3D 0; i < num - 1; i++) {
> > +             struct v4l2_fract a =3D array[i];
> > +             struct v4l2_fract b =3D array[i + 1];
> > +             struct v4l2_fract midpoint =3D {
> > +                     .numerator =3D a.numerator * b.denominator +
> > +                                  b.numerator * a.denominator,
>
> Assuming the entire range could be in use, this may lead to an overflow.
> Same on the line below.
>
> I also wonder if e.g. a binary search would be more effective than going
> through the entire list.

The video-i2c driver will use this function with an array of 2 objects
and the vivid driver may also use this function with an array of 5 objects.
So simple linear search is enough for now, but it can be changed to
bsearch without changing external interface if needed sometime.

> > +                     .denominator =3D 2 * a.denominator * b.denominato=
r,
> > +             };
> > +
> > +             if (FRACT_CMP(x, <=3D, midpoint))
> > +                     break;
> > +     }
> > +
> > +     return i;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_find_closest_fract);
> > +
> >  void v4l2_get_timestamp(struct timeval *tv)
> >  {
> >       struct timespec ts;
> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > index cdc87ec..e388f4e 100644
> > --- a/include/media/v4l2-common.h
> > +++ b/include/media/v4l2-common.h
> > @@ -350,6 +350,18 @@ __v4l2_find_nearest_size(const void *array, size_t=
 array_size,
> >                        size_t height_offset, s32 width, s32 height);
> >
> >  /**
> > + * v4l2_find_closest_fract - locate the closest element in a sorted ar=
ray
> > + * @x: The reference value.
> > + * @array: The array in which to look for the closest element. Must be=
 sorted
> > + *  in ascending order.
> > + * @num: number of elements in 'array'.
> > + *
> > + * Returns the index of the element closest to 'x'.
> > + */
> > +int v4l2_find_closest_fract(struct v4l2_fract x, const struct v4l2_fra=
ct *array,
> > +                         size_t num);
> > +
> > +/**
> >   * v4l2_get_timestamp - helper routine to get a timestamp to be used w=
hen
> >   *   filling streaming metadata. Internally, it uses ktime_get_ts(),
> >   *   which is the recommended way to get it.
>
> --
> Regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com
