Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34231 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbeJDFEe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 01:04:34 -0400
Date: Thu, 4 Oct 2018 01:14:15 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>, jacopo@jmondi.org
Subject: Re: [PATCH v5 2/2] [media] imx214: Add imx214 camera sensor driver
Message-ID: <20181003221415.jgpeea5ligm7oyr6@kekkonen.localdomain>
References: <20181003130951.19140-1-ricardo.ribalda@gmail.com>
 <20181003194658.zj6jkfmpbrkmnlen@kekkonen.localdomain>
 <CAPybu_0Og50WhkO2hHmg5cLQ6a2sx+KEp3_DOTKS=AJ2Shf3YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_0Og50WhkO2hHmg5cLQ6a2sx+KEp3_DOTKS=AJ2Shf3YQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 03, 2018 at 10:24:17PM +0200, Ricardo Ribalda Delgado wrote:
...
> > > +static int imx214_enum_frame_size(struct v4l2_subdev *subdev,
> > > +                               struct v4l2_subdev_pad_config *cfg,
> > > +                               struct v4l2_subdev_frame_size_enum *fse)
> > > +{
> > > +     if (fse->code != IMX214_MBUS_CODE)
> > > +             return -EINVAL;
> > > +
> > > +     if (fse->index >= ARRAY_SIZE(imx214_modes))
> >
> > array_index_nospec() ?? I find it scary that you'd need that in drivers.
> > :-o

Uh... not needed. 

The value is just sent back to the user as such so this is fine AFAICT.

> >
> > > +             return -EINVAL;
> > > +
> > > +     fse->min_width = fse->max_width = imx214_modes[fse->index].width;
> > > +     fse->min_height = fse->max_height = imx214_modes[fse->index].height;
> > > +
> > > +     return 0;
> > > +}

...

> > > +     /*
> > > +      * WARNING!
> > > +      * Values obtained reverse engineering blobs and/or devices.
> > > +      * Ranges and functionality might be wrong.
> > > +      *
> > > +      * Sony, please release some register set documentation for the
> > > +      * device.
> > > +      *
> > > +      * Yours sincerely, Ricardo.
> > > +      */
> > > +     imx214->exposure = v4l2_ctrl_new_std(&imx214->ctrls, &imx214_ctrl_ops,
> > > +                                          V4L2_CID_EXPOSURE,
> > > +                                          0, 0xffff, 1, 0x0c70);
> >
> > The exposure is in lines so it can't exceed frame height + blanking.
> > There's a marginal, too. I don't know what it might be for this sensor
> > though. Usually it's small, such as 8 or 16. The image will almost
> > certainly be garbled if you exceed the allowed value.
> >Seems that this sensor
> 
> On this sensor what I am experiencing instead of garbage is that the
> fps gets reduced. So I believe it is fine to
> set it up this way.

That's rather confusing as well. The user should explicitly need to change
fps first, rather than it happening as a side effect of a seemingly
unrelated control.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
