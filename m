Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2668 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab1CEMEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 07:04:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sat, 5 Mar 2011 13:03:56 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103031125.06419.laurent.pinchart@ideasonboard.com> <4D71505C.1090604@redhat.com>
In-Reply-To: <4D71505C.1090604@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051303.56150.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, March 04, 2011 21:49:32 Mauro Carvalho Chehab wrote:
> Em 03-03-2011 07:25, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:
> > 
> >   [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/media.git media-2.6.39-0005-omap3isp
> ...
> > Laurent Pinchart (36):
> ...
> >       v4l: subdev: Generic ioctl supportFrom 57b36ef1b9733124f3e04e6e2c06cf358051e209 Mon Sep 17 00:00:00 2001
> 
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Date: Fri, 26 Feb 2010 16:23:10 +0100
> Subject: v4l: subdev: Generic ioctl support
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> Instead of returning an error when receiving an ioctl call with an
> unsupported command, forward the call to the subdev core::ioctl handler.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/video4linux/v4l2-framework.txt |    5 +++++
>  drivers/media/video/v4l2-subdev.c            |    2 +-
>  2 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
> index 77d96f4..f2df31b 100644
> --- a/Documentation/video4linux/v4l2-framework.txt
> +++ b/Documentation/video4linux/v4l2-framework.txt
> @@ -405,6 +405,11 @@ VIDIOC_UNSUBSCRIBE_EVENT
>  	To properly support events, the poll() file operation is also
>  	implemented.
>  
> +Private ioctls
> +
> +	All ioctls not in the above list are passed directly to the sub-device
> +	driver through the core::ioctl operation.
> +
>  
>  I2C sub-device drivers
>  ----------------------
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 6e76f73..0b80644 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -276,7 +276,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	}
>  #endif
>  	default:
> -		return -ENOIOCTLCMD;
> +		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
>  	}
>  
>  	return 0;
> -- 
> 1.7.1
> 
> I don't like to apply a patch like that without a very good explanation
> about why it is needed and where it is used. Private ioctls are generally
> a very bad idea, as they lack proper documentation.

Private ioctls are perfectly valid in sub-devices as they will only be used
by applications that are written specifically for that hardware. Provided of
course that they are documented reasonably well (the less public documentation
there is, the more detailed the documentation should be) and that it is possible
to still use the hardware (if in a more limited capability) without using them.

> Also, we may quickly loose the control about what ioctl's are valid for
> subdevs, as the same code could also be used to accept a video (or audio)
> ioctl directly into a subdev. 

That's why we do reviews. It's pretty easy to review: you just have to pay
special attention to the ioctl core op in the subdev driver.

> So, IMO, the better is to manually add ioctl's there as they're
> needed inside subdevs. I'll not apply this patch on my tree for now.

Yuck, then we pollute the core v4l2-subdev.c file with hardware-specific
ioctls and subdev ops.

We do the same for V4L2 drivers (vidioc_default), which works quite well.
Obviously, there are problems with private ioctls in some legacy drivers.
But in those days there was much less reviewing going on.

Regards,

	Hans

> Is it currently needed for omap3isp? If so, what are the used ioctls
> inside omap3isp?
> 
> > >       v4l: Add subdev sensor g_skip_frames operation
> >       v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
> >       v4l: Add remaining RAW10 patterns w DPCM pixel code variants
> >       v4l: Add missing 12 bits bayer media bus formats
> >       v4l: Add 12 bits bayer pixel formats
> 
> Had you document all those newly-added formats at the API? Is there a way
> to double check if something is missed there? With the V4L2 API, as we
> add videodev2.h header, and we create dynamic links between the .h file
> and the specs, DocBook warns if some FOURCC is missed. From our experience,
> it is common that people add stuff at the header files, but forget to add
> the corresponding documentation for it. We need something similar for
> MBUS formats, as I suspect that we'll also have lots of additions there.
> 
> Ok, I finished the review of the 36 media controller patches. I'll now
> start to dig into omap3isp patches.
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
