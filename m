Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44867 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbeKNTMI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 14:12:08 -0500
Received: by mail-yb1-f195.google.com with SMTP id p144-v6so6582690yba.11
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 01:09:45 -0800 (PST)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id x127-v6sm5600897ywf.28.2018.11.14.01.09.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 01:09:44 -0800 (PST)
Received: by mail-yw1-f43.google.com with SMTP id z72-v6so7032654ywa.0
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 01:09:43 -0800 (PST)
MIME-Version: 1.0
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
 <20180925101434.20327-3-sakari.ailus@linux.intel.com> <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
In-Reply-To: <ed5a453b-41d3-6ab5-2bc2-8cab309ac749@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 18:09:31 +0900
Message-ID: <CAAFQd5Dv8ZREnYJwHpDYrNWhaRh=0aPPatx6XPenOQbnRN4aDA@mail.gmail.com>
Subject: Re: [PATCH 2/5] v4l: controls: Add support for exponential bases,
 prefixes and units
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Grant Grundler <grundler@chromium.org>,
        ping-chung.chen@intel.com, "Yeh, Andy" <andy.yeh@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>, helmut.grohne@intenta.de,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        snawrocki@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, Sep 28, 2018 at 11:00 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/25/2018 12:14 PM, Sakari Ailus wrote:
> > Add support for exponential bases, prefixes as well as units for V4L2
> > controls. This makes it possible to convey information on the relation
> > between the control value and the hardware feature being controlled.
> >

Sorry for being late to the party.

Thanks for the series. I think it has a potential to be very useful.

Please see my comments below.

> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/uapi/linux/videodev2.h | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index ae083978988f1..23b02f2db85a1 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1652,6 +1652,32 @@ struct v4l2_queryctrl {
> >       __u32                reserved[2];
> >  };
> >
> > +/* V4L2 control exponential bases */
> > +#define V4L2_CTRL_BASE_UNDEFINED     0
> > +#define V4L2_CTRL_BASE_LINEAR                1
>
> I'm not really sure you need BASE_LINEAR. That is effectively the same
> as UNDEFINED since what else can you do? It's also weird to have this
> as 'base' if the EXPONENTIAL flag is set.
>
> I don't see why you need the EXPONENTIAL flag at all: if this is non-0,
> then you know the exponential base.

Or vice versa, we could remove UNDEFINED and LINEAR altogether and
have the EXPONENTIAL flag actually signify the presence of a valid
base? Besides that, "linear exponential base" just doesn't sound right
or am I missing some basic maths? ;)

Then we could actually have a LOGARITHMIC flag and it could reuse the
same bases enum.

>
> > +#define V4L2_CTRL_BASE_2             2
> > +#define V4L2_CTRL_BASE_10            10
> > +
> > +/* V4L2 control unit prefixes */
> > +#define V4L2_CTRL_PREFIX_NANO                -9
> > +#define V4L2_CTRL_PREFIX_MICRO               -6
> > +#define V4L2_CTRL_PREFIX_MILLI               -3
> > +#define V4L2_CTRL_PREFIX_1           0
>
> I would prefer PREFIX_NONE, since there is no prefix in this case.
>
> I assume this prefix is only valid if the unit is not UNDEFINED and not
> NONE?
>
> Is 'base' also dependent on a valid unit? (it doesn't appear to be)
>
> > +#define V4L2_CTRL_PREFIX_KILO                3
> > +#define V4L2_CTRL_PREFIX_MEGA                6
> > +#define V4L2_CTRL_PREFIX_GIGA                9
> > +
> > +/* V4L2 control units */
> > +#define V4L2_CTRL_UNIT_UNDEFINED     0
> > +#define V4L2_CTRL_UNIT_NONE          1

Hmm, what's the meaning of NONE? How does it differ from UNDEFINED?

> > +#define V4L2_CTRL_UNIT_SECOND                2
> > +#define V4L2_CTRL_UNIT_AMPERE                3
> > +#define V4L2_CTRL_UNIT_LINE          4
> > +#define V4L2_CTRL_UNIT_PIXEL         5
> > +#define V4L2_CTRL_UNIT_PIXELS_PER_SEC        6
> > +#define V4L2_CTRL_UNIT_HZ            7
> > +
> > +
> >  /*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
> >  struct v4l2_query_ext_ctrl {
> >       __u32                id;
> > @@ -1666,7 +1692,10 @@ struct v4l2_query_ext_ctrl {
> >       __u32                elems;
> >       __u32                nr_of_dims;
> >       __u32                dims[V4L2_CTRL_MAX_DIMS];
> > -     __u32                reserved[32];
> > +     __u8                 base;
> > +     __s8                 prefix;

Should we make those bigger just in case, or leave some reserved
fields around so we can make them bigger when we need it?

Best regards,
Tomasz
