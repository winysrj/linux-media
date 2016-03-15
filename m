Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:57218 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbcCOL6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 07:58:09 -0400
Date: Tue, 15 Mar 2016 12:58:03 +0100
From: Philippe De Muyter <phdm@macq.eu>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: subdev sensor driver and
	V4L2_FRMIVAL_TYPE_CONTINUOUS/V4L2_FRMIVAL_TYPE_STEPWISE
Message-ID: <20160315115803.GA13448@frolo.macqel>
References: <20160315101417.GA31990@frolo.macqel> <20160315110608.GT11084@valkosipuli.retiisi.org.uk> <56E7F7EE.10308@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E7F7EE.10308@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My post is about framerate, not framesize :)  I agree the macro's
names are misleading.

On Tue, Mar 15, 2016 at 12:54:22PM +0100, Hans Verkuil wrote:
> On 03/15/16 12:06, Sakari Ailus wrote:
> > Hi Philippe,
> > 
> > On Tue, Mar 15, 2016 at 11:14:17AM +0100, Philippe De Muyter wrote:
> >> Hi,
> >>
> >> Sorry if you read the following twice, but the subject of my previous post
> >> was not precise enough :(
> >>
> >> I am in the process of converting a sensor driver compatible with the imx6
> >> freescale linux kernel, to a subdev driver compatible with a current kernel
> >> and Steve Longerbeam's work.
> >>
> >> My sensor can work at any fps (even fractional) up to 60 fps with its default
> >> frame size or even higher when using crop or "binning'.  That fact is reflected
> >> in my previous implemetation of VIDIOC_ENUM_FRAMEINTERVALS, which answered
> >> with a V4L2_FRMIVAL_TYPE_CONTINUOUS-type reply.
> >>
> >> This seem not possible anymore because of the lack of the needed fields
> >> in the 'struct v4l2_subdev_frame_interval_enum' used to delegate the question
> >> to the subdev driver.  V4L2_FRMIVAL_TYPE_STEPWISE does not seem possible
> >> anymore either.  Has that been replaced by something else or is that
> >> functionality not considered relevant anymorea ?
> > 
> > I think the issue was that the CONTINUOUS and STEPWISE were considered too
> > clumsy for applications and practically no application was using them, or at
> > least the need for these was not seen to be there. They were not added to
> > the V4L2 sub-device implementation of the interface as a result.
> 
> It never made sense to me why the two APIs weren't kept the same.

I agree completely with that.

> 
> My suggestion would be to add step_width and step_height fields to
> struct v4l2_subdev_frame_size_enum, that way you have the same functionality
> back.
> 
> I.e. for discrete formats the min values equal the max values, for continuous
> formats the step values are both 1 (or 0 for compability's sake) and the
> remainder maps to a stepwise range.
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Cc Hans.
> > 
> > The smiapp driver uses horizontal and vertical blanking controls for
> > changing the frame rate. That's a bit lower level interface than most
> > drivers use, but then you have to provide enough other information to the
> > user space as well, including the pixel rate.
> > 

Philippe
