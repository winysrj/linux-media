Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39688 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZJTMVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 08:21:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/4] V4L2: Added New V4L2 CIDs VIDIOC_S/G_COLOR_SPACE_CONV
Date: Tue, 20 Oct 2009 14:22:03 +0200
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org
References: <hvaibhav@ti.com> <200910161426.52344.laurent.pinchart@ideasonboard.com> <200910162226.54573.hverkuil@xs4all.nl>
In-Reply-To: <200910162226.54573.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910201422.03987.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 October 2009 22:26:53 Hans Verkuil wrote:
> On Friday 16 October 2009 14:26:52 Laurent Pinchart wrote:
> > Hi,
> >
> > On Friday 16 October 2009 12:19:20 hvaibhav@ti.com wrote:
> > > From: Vaibhav Hiremath <hvaibhav@ti.com>
> > >
> > >
> > > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > > ---
> > >  drivers/media/video/v4l2-ioctl.c |   19 +++++++++++++++++++
> > >  include/linux/videodev2.h        |   14 ++++++++++++++
> > >  include/media/v4l2-ioctl.h       |    4 ++++
> > >  3 files changed, 37 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/drivers/media/video/v4l2-ioctl.c
> > >  b/drivers/media/video/v4l2-ioctl.c index 30cc334..d3140e0 100644
> > > --- a/drivers/media/video/v4l2-ioctl.c
> > > +++ b/drivers/media/video/v4l2-ioctl.c
> > > @@ -284,6 +284,8 @@ static const char *v4l2_ioctls[] = {
> > >  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
> > >  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
> > >  #endif
> > > +	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   = "VIDIOC_S_COLOR_SPACE_CONV",
> > > +	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   = "VIDIOC_G_COLOR_SPACE_CONV",
> > >  };
> > >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> >
> > This should go through a control, not an ioctl. Strings control have
> > recently been introduced, it should be fairly easy to create binary
> > controls for such cases.
> 
> I'm not sure whether this should be seen as a control. That feels like an
> abuse of the control framework to me.
> 
> Actually, shouldn't this be something for a subdev node? I.e. an omap2/3
> specific ioctl?

I would see it as a subdev control. Even though this is a complex control that 
uses a matrix instead of a simple integer value, I believe this kind of use 
cases qualify for the control API. They're really controls, i.e. values that 
apply to a block in the video pipeline to tune its behavior.
 
> It might be good to refresh our memory of how this is supposed to be used.

-- 
Regards,

Laurent Pinchart
