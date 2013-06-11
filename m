Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:14668 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3FKMNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 08:13:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [REVIEW PATCH 8/9] f_uvc: use v4l2_dev instead of the deprecated parent field.
Date: Tue, 11 Jun 2013 14:13:33 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl> <1370868518-19831-9-git-send-email-hverkuil@xs4all.nl> <2686318.IXVlVQf2B1@avalon>
In-Reply-To: <2686318.IXVlVQf2B1@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306111413.34031.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 10 June 2013 20:50:42 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Monday 10 June 2013 14:48:37 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/usb/gadget/f_uvc.c |    8 +++++++-
> >  drivers/usb/gadget/uvc.h   |    2 ++
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
> > index 38dcedd..762e82f 100644
> > --- a/drivers/usb/gadget/f_uvc.c
> > +++ b/drivers/usb/gadget/f_uvc.c
> > @@ -413,7 +413,7 @@ uvc_register_video(struct uvc_device *uvc)
> >  	if (video == NULL)
> >  		return -ENOMEM;
> > 
> > -	video->parent = &cdev->gadget->dev;
> > +	video->v4l2_dev = &uvc->v4l2_dev;
> >  	video->fops = &uvc_v4l2_fops;
> >  	video->release = video_device_release;
> >  	strlcpy(video->name, cdev->gadget->name, sizeof(video->name));
> > @@ -570,6 +570,7 @@ uvc_function_unbind(struct usb_configuration *c, struct
> > usb_function *f) INFO(cdev, "uvc_function_unbind\n");
> > 
> >  	video_unregister_device(uvc->vdev);
> > +	v4l2_device_unregister(&uvc->v4l2_dev);
> >  	uvc->control_ep->driver_data = NULL;
> >  	uvc->video.ep->driver_data = NULL;
> > 
> > @@ -697,6 +698,11 @@ uvc_function_bind(struct usb_configuration *c, struct
> > usb_function *f) if ((ret = usb_function_deactivate(f)) < 0)
> >  		goto error;
> > 
> > +	if (v4l2_device_register(&cdev->gadget->dev, &uvc->v4l2_dev)) {
> > +		printk(KERN_INFO "v4l2_device_register failed\n");
> > +		goto error;
> > +	}
> > +
> >  	/* Initialise video. */
> >  	ret = uvc_video_init(&uvc->video);
> >  	if (ret < 0)
> 
> Shouldn't you add the corresponding cleanup code in the error path at the end 
> of the function ?

Not really necessary as long as there are no subdevices registered. Still, it
is probably safer to do it anyway.

Regards,

	Hans

> 
> > diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> > index 817e9e1..7a9111d 100644
> > --- a/drivers/usb/gadget/uvc.h
> > +++ b/drivers/usb/gadget/uvc.h
> > @@ -57,6 +57,7 @@ struct uvc_event
> >  #include <linux/videodev2.h>
> >  #include <linux/version.h>
> >  #include <media/v4l2-fh.h>
> > +#include <media/v4l2-device.h>
> > 
> >  #include "uvc_queue.h"
> > 
> > @@ -145,6 +146,7 @@ enum uvc_state
> >  struct uvc_device
> >  {
> >  	struct video_device *vdev;
> > +	struct v4l2_device v4l2_dev;
> >  	enum uvc_state state;
> >  	struct usb_function func;
> >  	struct uvc_video video;
> 
