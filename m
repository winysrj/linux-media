Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52255 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaCKK4C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 06:56:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 27/48] v4l: Validate fields in the core code for subdev EDID ioctls
Date: Tue, 11 Mar 2014 11:57:36 +0100
Message-ID: <2554463.fAEmLWmTMl@avalon>
In-Reply-To: <531EE935.20201@xs4all.nl>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <1394493359-14115-28-git-send-email-laurent.pinchart@ideasonboard.com> <531EE935.20201@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 11 March 2014 11:45:09 Hans Verkuil wrote:
> On 03/11/14 00:15, Laurent Pinchart wrote:
> > The subdev EDID ioctls receive a pad field that must reference an
> > existing pad and an EDID field that must point to a buffer. Validate
> > both fields in the core code instead of duplicating validation in all
> > drivers.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/i2c/ad9389b.c           |  2 --
> >  drivers/media/i2c/adv7511.c           |  2 --
> >  drivers/media/i2c/adv7604.c           |  4 ----
> >  drivers/media/i2c/adv7842.c           |  4 ----
> >  drivers/media/v4l2-core/v4l2-subdev.c | 24 ++++++++++++++++++++----
> >  5 files changed, 20 insertions(+), 16 deletions(-)

[snip]

> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index 853fb84..9fff1eb 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -349,11 +349,27 @@ static long subdev_do_ioctl(struct file *file,
> > unsigned int cmd, void *arg)> 
> >  			sd, pad, set_selection, subdev_fh, sel);
> >  	}
> > 
> > -	case VIDIOC_SUBDEV_G_EDID:
> > -		return v4l2_subdev_call(sd, pad, get_edid, arg);
> > +	case VIDIOC_SUBDEV_G_EDID: {
> > +		struct v4l2_subdev_edid *edid = arg;
> > 
> > -	case VIDIOC_SUBDEV_S_EDID:
> > -		return v4l2_subdev_call(sd, pad, set_edid, arg);
> > +		if (edid->pad >= sd->entity.num_pads)
> > +			return -EINVAL;
> > +		if (edid->edid == NULL)
> > +			return -EINVAL;
> > +
> > +		return v4l2_subdev_call(sd, pad, get_edid, edid);
> > +	}
> > +
> > +	case VIDIOC_SUBDEV_S_EDID: {
> > +		struct v4l2_subdev_edid *edid = arg;
> > +
> > +		if (edid->pad >= sd->entity.num_pads)
> > +			return -EINVAL;
> > +		if (edid->edid == NULL)
> > +			return -EINVAL;
> 
> If edid->blocks == 0, then edid->edid may be NULL. So this should
> read:
> 
> 	if (edid->blocks && edid->edid == NULL)

OK, I'll fix that.

> This is true for both G and S_EDID ioctls.

What's the point of G_EDID with blocks == 0 ? Testing whether the ioctl is 
supported ?

> > +
> > +		return v4l2_subdev_call(sd, pad, set_edid, edid);
> > +	}
> > 
> >  	case VIDIOC_SUBDEV_DV_TIMINGS_CAP: {
> >  		struct v4l2_dv_timings_cap *cap = arg;

-- 
Regards,

Laurent Pinchart

