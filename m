Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52624 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbbHSWSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 18:18:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3 02/19] media/v4l2-core: add new ioctl VIDIOC_G_DEF_EXT_CTRLS
Date: Thu, 20 Aug 2015 01:19:38 +0300
Message-ID: <1822611.kBQQQkHzQk@avalon>
In-Reply-To: <55AD063A.1030705@xs4all.nl>
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <CAPybu_2a+z6ZVY=-ZXE6Usmoe0nsLjUzw3AE5=K9vQ6OCDgKaw@mail.gmail.com> <55AD063A.1030705@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I like your proposal, and especially how it would integrate with the requests 
API. Should we give the requests API a try to make sure your proposal works 
fine with it ?

As a side note, I'll need to requests API for Renesas. The current schedule is 
to have a first RFC implementation by the end of October.

On Monday 20 July 2015 16:31:22 Hans Verkuil wrote:
> On 07/20/2015 03:52 PM, Ricardo Ribalda Delgado wrote:
> > Hello
> > 
> > I have no preference over the two implementations, but I see an issue
> > with this suggestion.
> > 
> > What happens to out out tree drivers, or drivers that don't support
> > this functionality?
> > 
> > With the ioctl, the user receives a -ENOTTY. So he knows there is
> > something wrong with the driver.
> > 
> > With this class, the driver might interpret this a simple G_VAL and
> > return he current value with no way for the user to know what is going
> > on.
> 
> Drivers that implement the current API correctly will return an error
> if V4L2_CTRL_WHICH_DEF_VAL was specified. Such drivers will interpret
> the value as a control class, and no control classes in that range exist.
> See also class_check() in v4l2-ctrls.c.
> 
> The exception here is uvc which doesn't have this class check and it will
> just return the current value :-(
> 
> I don't see a way around this, unfortunately.

The rationale for implementing VIDIOC_G_DEF_EXT_CTRLS was to get the default 
value of controls that don't fit in 32 bits. uvcvideo doesn't have any such 
control, so I don't think we really need to care. Of course newer versions of 
the uvcvideo driver should implement the new API.

> Out-of-tree drivers that use the control framework are fine, and I don't
> really care about drivers (out-of-tree or otherwise) that do not use the
> control framework.
> 
> > Regarding the new implementation.... I can make some code next week,
> > this week I am 120% busy :)
> 
> Wait until there is a decision first :-)
> 
> It's not a lot of work, I think.

I think I like your proposal better than VIDIOC_G_DEF_EXT_CTRLS, so seeing an 
implementation would be nice.

-- 
Regards,

Laurent Pinchart

