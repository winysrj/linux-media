Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39173 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbaBJMwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 07:52:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 27/47] v4l: Add support for DV timings ioctls on subdev nodes
Date: Mon, 10 Feb 2014 13:53:48 +0100
Message-ID: <4536221.tW42ItNFuj@avalon>
In-Reply-To: <20140207110739.GM15635@valkosipuli.retiisi.org.uk>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-28-git-send-email-laurent.pinchart@ideasonboard.com> <20140207110739.GM15635@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 07 February 2014 13:07:40 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch.
> 
> On Wed, Feb 05, 2014 at 05:42:18PM +0100, Laurent Pinchart wrote:
> ...
> 
> > diff --git a/drivers/media/v4l2-core/v4l2-subdev.c
> > b/drivers/media/v4l2-core/v4l2-subdev.c index 996c248..0ccf9c8 100644
> > --- a/drivers/media/v4l2-core/v4l2-subdev.c
> > +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> > @@ -354,6 +354,21 @@ static long subdev_do_ioctl(struct file *file,
> > unsigned int cmd, void *arg)> 
> >  	case VIDIOC_SUBDEV_S_EDID:
> >  		return v4l2_subdev_call(sd, pad, set_edid, arg);
> > 
> > +
> > +	case VIDIOC_SUBDEV_DV_TIMINGS_CAP:
> > +		return v4l2_subdev_call(sd, pad, dv_timings_cap, arg);
> > +
> > +	case VIDIOC_SUBDEV_ENUM_DV_TIMINGS:
> > +		return v4l2_subdev_call(sd, pad, enum_dv_timings, arg);
> > +
> > +	case VIDIOC_SUBDEV_QUERY_DV_TIMINGS:
> > +		return v4l2_subdev_call(sd, video, query_dv_timings, arg);
> > +
> > +	case VIDIOC_SUBDEV_G_DV_TIMINGS:
> > +		return v4l2_subdev_call(sd, video, g_dv_timings, arg);
> > +
> > +	case VIDIOC_SUBDEV_S_DV_TIMINGS:
> > +		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
> 
> Please validate the fields of the argument structs above you can. The pad
> field at least can be validated.

I wonder how I've missed that :-) I'll fix this, and add pad validation for 
the [GS]_EDID ioctls while I'm at it.

-- 
Regards,

Laurent Pinchart

