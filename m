Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52257 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZJ1Mkc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 08:40:32 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 28 Oct 2009 18:10:30 +0530
Subject: RE: [PATCH 1/4] V4L2: Added New V4L2 CIDs
 VIDIOC_S/G_COLOR_SPACE_CONV
Message-ID: <19F8576C6E063C45BE387C64729E73940436EEAE1B@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
 <1255688360-6278-1-git-send-email-hvaibhav@ti.com>
 <200910161426.52344.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910161426.52344.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, October 16, 2009 5:57 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org
> Subject: Re: [PATCH 1/4] V4L2: Added New V4L2 CIDs
> VIDIOC_S/G_COLOR_SPACE_CONV
> 
> Hi,
> 
> On Friday 16 October 2009 12:19:20 hvaibhav@ti.com wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  drivers/media/video/v4l2-ioctl.c |   19 +++++++++++++++++++
> >  include/linux/videodev2.h        |   14 ++++++++++++++
> >  include/media/v4l2-ioctl.h       |    4 ++++
> >  3 files changed, 37 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/video/v4l2-ioctl.c
> >  b/drivers/media/video/v4l2-ioctl.c index 30cc334..d3140e0 100644
> > --- a/drivers/media/video/v4l2-ioctl.c
> > +++ b/drivers/media/video/v4l2-ioctl.c
> > @@ -284,6 +284,8 @@ static const char *v4l2_ioctls[] = {
> >  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] =
> "VIDIOC_DBG_G_CHIP_IDENT",
> >  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
> >  #endif
> > +	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   =
> "VIDIOC_S_COLOR_SPACE_CONV",
> > +	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   =
> "VIDIOC_G_COLOR_SPACE_CONV",
> >  };
> >  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
> >
> 
> This should go through a control, not an ioctl. Strings control have
> recently
> been introduced, it should be fairly easy to create binary controls
> for such
> cases.
> 
[Hiremath, Vaibhav] I am really not sure how we can fit this into string control.

Atleast from OMAP3 point of view we need nine 11 bit signed coeff. We can not use string control here but we can leverage same mechanism.

I can have __s32 * in v4l2_ext_control which will point to array of nine 11 bit coeff.

Again there is control over full or limited range conversion.

Thanks,
Vaibhav
> --
> Regards,
> 
> Laurent Pinchart

