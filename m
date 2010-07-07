Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46521 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab0GGToz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 15:44:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Wed, 7 Jul 2010 21:44:45 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com> <4C3495F9.4070507@redhat.com>
In-Reply-To: <4C3495F9.4070507@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007072144.46481.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the review.

On Wednesday 07 July 2010 16:58:01 Mauro Carvalho Chehab wrote:
> Em 07-07-2010 08:53, Laurent Pinchart escreveu:
> > Create a device node named subdevX for every registered subdev.
> > As the device node is registered before the subdev core::s_config
> > function is called, return -EGAIN on open until initialization
> > completes.

[snip]

> > diff --git a/drivers/media/video/v4l2-subdev.c
> > b/drivers/media/video/v4l2-subdev.c new file mode 100644
> > index 0000000..a048161
> > --- /dev/null
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -0,0 +1,65 @@

[snip]

> > +static int subdev_open(struct file *file)
> > +{
> > +	struct video_device *vdev = video_devdata(file);
> > +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> > +
> > +	if (!sd->initialized)
> > +		return -EAGAIN;
> 
> Those internal interfaces should not be used on normal
> devices/applications, as none of the existing drivers are tested or
> supposed to properly work if an external program is touching on its
> internal interfaces. So, please add:
> 
> 	if (!capable(CAP_SYS_ADMIN))
> 		return -EPERM;

As Hans pointed out, subdev device nodes should only be created if the subdev 
request it explicitly. I'll fix the patch accordingly. Existing subdevs will 
not have a device node by default anymore, so the CAP_SYS_ADMIN capability 
won't be required (new subdevs that explicitly ask for a device node are 
supposed to handle the calls properly, otherwise it's a bit pointless :-)).

> > +
> > +	return 0;
> > +}

[snip]

> > +static long subdev_ioctl(struct file *file, unsigned int cmd,
> > +	unsigned long arg)
> > +{
> > +	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
> 
> This is a legacy call. Please, don't use it.

What should I use instead then ? I need the functionality of video_usercopy. I 
could copy it to v4l2-subdev.c verbatim. As video_ioctl2 shares lots of code 
with video_usercopy I think video_usercopy should stay, and video_ioctl2 
should use it.

> Also, while the API doc says that only certain ioctls are supported on
> subdev, there's no code here preventing the usage of invalid ioctls. So,
> it is possible to do bad things, like changing the video standard format
> individually on each subdev, creating all sorts of problems.

Invalid (or rather unsupported) ioctls will be routed to the subdev 
core::ioctl operation. Formats will not be changed automagically just because 
a userspace application issues a VIDIOC_S_FMT ioctl.

As the device node creation will need to be requested explicitly this won't be 
an issue anyway.

-- 
Regards,

Laurent Pinchart
