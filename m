Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51689 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbaJaOnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 10:43:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/11] uvcvideo: Add V4L2 debug module parameter
Date: Fri, 31 Oct 2014 16:43:43 +0200
Message-ID: <7612779.HqLMMLZQzl@avalon>
In-Reply-To: <54539F08.3000104@xs4all.nl>
References: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com> <1414763697-21166-4-git-send-email-laurent.pinchart@ideasonboard.com> <54539F08.3000104@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 31 October 2014 15:39:04 Hans Verkuil wrote:
> On 10/31/2014 02:54 PM, Laurent Pinchart wrote:
> > Add a new debug module parameter and use it to initialize the V4L2 debug
> > level for all video devices.
> 
> This patch is unnecessary and can be dropped. You can dynamically set it
> through echo 1 >/sys/class/video4linux/videoX/debug.
> 
> Drivers shouldn't touch debug themselves.

Good point and sorry for the noise. I'll drop the patch.

> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 30163432..1cae974 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -34,6 +34,7 @@
> > 
> >  unsigned int uvc_clock_param = CLOCK_MONOTONIC;
> >  unsigned int uvc_no_drop_param;
> >  static unsigned int uvc_quirks_param = -1;
> > 
> > +static unsigned int uvc_debug_param;
> > 
> >  unsigned int uvc_trace_param;
> >  unsigned int uvc_timeout_param = UVC_CTRL_STREAMING_TIMEOUT;
> > 
> > @@ -1763,6 +1764,7 @@ static int uvc_register_video(struct uvc_device
> > *dev,
> > 
> >  	vdev->ioctl_ops = &uvc_ioctl_ops;
> >  	vdev->release = uvc_release;
> >  	vdev->prio = &stream->chain->prio;
> > 
> > +	vdev->debug = uvc_debug_param;
> > 
> >  	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> >  	
> >  		vdev->vfl_dir = VFL_DIR_TX;
> >  	
> >  	strlcpy(vdev->name, dev->name, sizeof vdev->name);
> > 
> > @@ -2080,6 +2082,8 @@ static int uvc_clock_param_set(const char *val,
> > struct kernel_param *kp)> 
> >  module_param_call(clock, uvc_clock_param_set, uvc_clock_param_get,
> >  
> >  		  &uvc_clock_param, S_IRUGO|S_IWUSR);
> >  
> >  MODULE_PARM_DESC(clock, "Video buffers timestamp clock");
> > 
> > +module_param_named(debug, uvc_debug_param, uint, S_IRUGO);
> > +MODULE_PARM_DESC(debug, "V4L2 debug level");
> > 
> >  module_param_named(nodrop, uvc_no_drop_param, uint, S_IRUGO|S_IWUSR);
> >  MODULE_PARM_DESC(nodrop, "Don't drop incomplete frames");
> >  module_param_named(quirks, uvc_quirks_param, uint, S_IRUGO|S_IWUSR);

-- 
Regards,

Laurent Pinchart

