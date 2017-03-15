Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33582 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751509AbdCOJ3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 05:29:38 -0400
Received: by mail-lf0-f49.google.com with SMTP id a6so4345602lfa.0
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 02:29:32 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 15 Mar 2017 10:29:30 +0100
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 03/16] rcar-vin: fix how pads are handled for v4l2
 subdevice operations
Message-ID: <20170315092930.GU20587@bigcity.dyn.berto.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314185957.25253-4-niklas.soderlund+renesas@ragnatech.se>
 <1fcdfc89-6c85-3863-6fd0-e6db4ec9072c@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fcdfc89-6c85-3863-6fd0-e6db4ec9072c@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Thanks for your feedback.

On 2017-03-15 12:12:21 +0300, Sergei Shtylyov wrote:
> Hello!
> 
> On 3/14/2017 9:59 PM, Niklas Söderlund wrote:
> 
> > The rcar-vin driver only uses one pad, pad number 0.
> > 
> > - All v4l2 operations that did not check that the requested operation
> >   was for pad 0 have been updated with a check to enforce this.
> > 
> > - All v4l2 operations that stored (and later restore) the requested pad
> 
>    Restored?

Will update for v2.

> 
> >   before substituting it for the subdevice pad number have been updated
> >   to not store the incoming pad and simply restore it to 0 after the
> >   subdevice operation is complete.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 26 ++++++++++++++------------
> >  1 file changed, 14 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > index 7ca27599b9982ffc..610f59e2a9142622 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -550,14 +550,16 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> >  	struct v4l2_subdev *sd = vin_to_source(vin);
> > -	int pad, ret;
> > +	int ret;
> > +
> > +	if (timings->pad)
> > +		return -EINVAL;
> > 
> > -	pad = timings->pad;
> >  	timings->pad = vin->sink_pad_idx;
> > 
> >  	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
> 
>    Does this still compile after you removed 'pad'?

Yes, the pad in v4l2_subdev_call() do not refer to the pad variable but 
the pad operations of the subdevice ops struct, the macro is defined as:

#define v4l2_subdev_call(sd, o, f, args...)                     \
        (!(sd) ? -ENODEV : (((sd)->ops->o && (sd)->ops->o->f) ? \
                (sd)->ops->o->f((sd), ##args) : -ENOIOCTLCMD))

So if you expand the macro it looks like:

sd->ops->pad->enum_dv_timings(timings);

I agree it's confusing and I had the same thought the first times I 
looked at it too :-)

> 
> > 
> > -	timings->pad = pad;
> > +	timings->pad = 0;
> > 
> >  	return ret;
> >  }
> > @@ -600,14 +602,16 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> >  	struct v4l2_subdev *sd = vin_to_source(vin);
> > -	int pad, ret;
> > +	int ret;
> > +
> > +	if (cap->pad)
> > +		return -EINVAL;
> > 
> > -	pad = cap->pad;
> >  	cap->pad = vin->sink_pad_idx;
> > 
> >  	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
> 
>    And this?
> 
> > 
> > -	cap->pad = pad;
> > +	cap->pad = 0;
> > 
> >  	return ret;
> >  }
> [...]
> 
> MBR, Sergei
> 

-- 
Regards,
Niklas Söderlund
