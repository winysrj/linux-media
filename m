Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51337 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1BHMwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Feb 2011 07:52:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v6 05/11] v4l: Create v4l2 subdev file handle structure
Date: Tue, 8 Feb 2011 13:52:14 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131456-30000-6-git-send-email-laurent.pinchart@ideasonboard.com> <201102041140.42596.hverkuil@xs4all.nl>
In-Reply-To: <201102041140.42596.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081352.15545.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the review.

On Friday 04 February 2011 11:40:42 Hans Verkuil wrote:
> On Thursday, January 27, 2011 13:30:50 Laurent Pinchart wrote:
> > From: Stanimir Varbanov <svarbanov@mm-sol.com>
> > 
> > Used for storing subdev information per file handle and hold V4L2 file
> > handle.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Antti Koskipaa <antti.koskipaa@nokia.com>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/Kconfig             |    9 ++++
> >  drivers/media/video/v4l2-subdev.c |   85
> >  +++++++++++++++++++++++++------------ include/media/v4l2-subdev.h      
> >  |   29 +++++++++++++
> >  3 files changed, 96 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> > index 6b946e6..eaf4734 100644
> > --- a/drivers/media/Kconfig
> > +++ b/drivers/media/Kconfig
> > @@ -82,6 +82,15 @@ config VIDEO_V4L1_COMPAT
> > 
> >  	  If you are unsure as to whether this is required, answer Y.
> > 
> > +config VIDEO_V4L2_SUBDEV_API
> > +	bool "V4L2 sub-device userspace API (EXPERIMENTAL)"
> > +	depends on VIDEO_DEV && MEDIA_CONTROLLER && EXPERIMENTAL
> > +	---help---
> > +	  Enables the V4L2 sub-device pad-level userspace API used to configure
> > +	  video format, size and frame rate between hardware blocks.
> > +
> > +	  This API is mostly used by camera interfaces in embedded platforms.
> > +
> 
> Is it also marked experimental in the documentation?

Now it is :-)

> As we discussed earlier I think we should have a brainstorm meeting once
> this is merged to hammer out the finer details of how to set up a pipeline.

Agreed.

-- 
Regards,

Laurent Pinchart
