Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39092 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbeIFOkZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 10:40:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dorodnic@gmail.com, linux-media@vger.kernel.org,
        evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: Re: [PATCH 2/2] CNF4 pixel format for media subsystem
Date: Thu, 06 Sep 2018 13:05:49 +0300
Message-ID: <2501244.sk8HRnkooG@avalon>
In-Reply-To: <25f8e48c-24ff-7577-2f83-7cf25993e9c8@xs4all.nl>
References: <1536220267-22347-1-git-send-email-sergey.dorodnicov@intel.com> <1536220267-22347-3-git-send-email-sergey.dorodnicov@intel.com> <25f8e48c-24ff-7577-2f83-7cf25993e9c8@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sergey,

On Thursday, 6 September 2018 12:37:36 EEST Hans Verkuil wrote:
> On 09/06/18 09:51, dorodnic@gmail.com wrote:
> > From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> > 
> > Registering new GUID used by Intel RealSense depth cameras with fourcc
> > CNF4, encoding sensor confidence information for every pixel.

s/confidence/depth confidence/

> > 
> > Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
> > Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>

Could you please send me the output of lsusb -v (ideally run as root, or 
through sudo) for a camera that uses this format ?

> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 5 +++++
> >  drivers/media/usb/uvc/uvcvideo.h   | 3 +++
> >  2 files changed, 8 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index d46dc43..c8d40a4 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -214,6 +214,11 @@ static struct uvc_format_desc uvc_fmts[] = {
> >  		.guid		= UVC_GUID_FORMAT_INZI,
> >  		.fcc		= V4L2_PIX_FMT_INZI,
> >  	},
> > +	{
> > +		.name		= "Confidence 4-bit Packed (CNF4)",
> 
> The name should correspond to what is set in v4l2-ioctl.c.

And should even be removed as it duplicates the names in v4l2-ioctl.c. I have 
a half-baked patch to do so, I'll try to resurrect it. This isn't a blocking 
issue, I'll rebase my patch on top of this one.

> > +		.guid		= UVC_GUID_FORMAT_CNF4,
> > +		.fcc		= V4L2_PIX_FMT_CNF4,
> > +	},
> >  };
> >  
> >  /* ----------------------------------------------------------------------
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index e5f5d84..779bab2 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -154,6 +154,9 @@
> >  #define UVC_GUID_FORMAT_INVI \
> >  	{ 'I',  'N',  'V',  'I', 0xdb, 0x57, 0x49, 0x5e, \
> >  	 0x8e, 0x3f, 0xf4, 0x79, 0x53, 0x2b, 0x94, 0x6f}
> > +#define UVC_GUID_FORMAT_CNF4 \
> > +	{ 'C',  ' ',  ' ',  ' ', 0x00, 0x00, 0x10, 0x00, \
> > +	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
> > 
> >  #define UVC_GUID_FORMAT_D3DFMT_L8 \
> >  	{0x32, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, \

-- 
Regards,

Laurent Pinchart
