Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36260 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752925AbcCOMkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2016 08:40:37 -0400
Date: Tue, 15 Mar 2016 14:40:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philippe De Muyter <phdm@macq.eu>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: subdev sensor driver and
 V4L2_FRMIVAL_TYPE_CONTINUOUS/V4L2_FRMIVAL_TYPE_STEPWISE
Message-ID: <20160315124033.GU11084@valkosipuli.retiisi.org.uk>
References: <20160315101417.GA31990@frolo.macqel>
 <20160315110608.GT11084@valkosipuli.retiisi.org.uk>
 <56E7F7EE.10308@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56E7F7EE.10308@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

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
> 
> My suggestion would be to add step_width and step_height fields to
> struct v4l2_subdev_frame_size_enum, that way you have the same functionality
> back.
> 
> I.e. for discrete formats the min values equal the max values, for continuous
> formats the step values are both 1 (or 0 for compability's sake) and the
> remainder maps to a stepwise range.

On frame intervals... I'm not against changing it if there's a need to.

Cc'ing Laurent who I believe wrote the original API. I probably acked it.

We just needed to add the type field (snatch one from the reserved array),
DISCRETE translates to zero so there are on compatibility issues either.
struct v4l2_frmival_stepwise will consume all remaining reserved entries
with the exception of one, but there is still room for it.

Documentation is needed as well.

I don't think it'd be very pretty but I guess there's no way around that at
this point. We should have had the which field before the interval field.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
