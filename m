Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39009 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaCQLrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 07:47:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH for v3.15 1/4] v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
Date: Mon, 17 Mar 2014 12:49:32 +0100
Message-ID: <23252843.iazmjIIJeH@avalon>
In-Reply-To: <5326E04C.5050808@xs4all.nl>
References: <1394888883-46850-1-git-send-email-hverkuil@xs4all.nl> <2510988.dElkAvpb7d@avalon> <5326E04C.5050808@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 17 March 2014 12:45:16 Hans Verkuil wrote:
> On 03/17/2014 12:44 PM, Laurent Pinchart wrote:
> > On Saturday 15 March 2014 14:08:00 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> The notify function is a void function, yet the v4l2_subdev_notify
> >> define uses it in a ? : construction, which causes sparse warnings.
> >> 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> 
> >>  include/media/v4l2-subdev.h | 8 +++++---
> >>  1 file changed, 5 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >> index 28f4d8c..0fbf669 100644
> >> --- a/include/media/v4l2-subdev.h
> >> +++ b/include/media/v4l2-subdev.h
> >> @@ -692,9 +692,11 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
> >> 
> >>  		(sd)->ops->o->f((sd) , ##args) : -ENOIOCTLCMD))
> >>  
> >>  /* Send a notification to v4l2_device. */
> >> 
> >> -#define v4l2_subdev_notify(sd, notification, arg)			   \
> >> -	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
> >> -	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
> >> +#define v4l2_subdev_notify(sd, notification, arg)				\
> >> +	do {									\
> >> +		if ((sd) && (sd)->v4l2_dev && (sd)->v4l2_dev->notify)		\
> >> +			(sd)->v4l2_dev->notify((sd), (notification), (arg));	\
> >> +	} while (0)
> > 
> > The construct would prevent using v4l2_subdev_notify() as an expression.
> > What about turning the macro into an inline function instead ?
> 
> How can you use a void function in an expression anyway? That was the whole
> point of the sparse error.

In a for loop for instance ?

	for (i = 0; i < n; v4l2_subdev_notify(), ++i)

I agree it's a bit far-fetched, but as we need to modify the macro, I'd take 
that as an opportunity to turn it into an inline function.

> >>  #define v4l2_subdev_has_op(sd, o, f) \
> >>  
> >>  	((sd)->ops->o && (sd)->ops->o->f)

-- 
Regards,

Laurent Pinchart

