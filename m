Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39030 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab3CKV1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 17:27:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: vkalia@codeaurora.org
Cc: linux-media@vger.kernel.org, vrajesh@codeaurora.org
Subject: Re: Custom device names for v4l2 devices
Date: Mon, 11 Mar 2013 22:28:21 +0100
Message-ID: <1672808.rITBMNsUax@avalon>
In-Reply-To: <a6da9ec89bbf3e28549a4a25efe3f166.squirrel@www.codeaurora.org>
References: <3fe50e59b4f7baeda879f4f7b2e5cc1a.squirrel@www.codeaurora.org> <a6da9ec89bbf3e28549a4a25efe3f166.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinay,

On Monday 11 March 2013 10:55:37 vkalia@codeaurora.org wrote:
> > Names of V4L2 device nodes keep on varying depending on target, on some
> > targets, the device node assigned to my device is /dev/video21 and on some
> > it is /dev/video15. In order to determine my device, i am opening it,
> > reading the capabilities, enumerating its formats and then chose the one
> > matching my requirements. This is impacting start-up latency. One way to
> > resolve this without impacting start-up latency is to give custom name to
> > my V4L2 device node (/dev/custom_name instead of /dev/video21). This needs
> > following change in V4L2 framework. Please review this patch. If you have
> > faced similar problem please let me know.

Shouldn't this be implemented in userspace as udev rules instead ?

> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -676,7 +676,8 @@ int __video_register_device(struct video_device *vdev,
> > int type, int nr,
> > 
> >  	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
> >  	if (vdev->parent)
> >  	
> >  		vdev->dev.parent = vdev->parent;
> > 
> > -	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
> > +	if (!dev_name(&vdev->dev))
> > +		dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
> > 
> >  	ret = device_register(&vdev->dev);
> >  	if (ret < 0) {
> >  	
> >  		printk(KERN_ERR "%s: device_register failed\n", __func__);

-- 
Regards,

Laurent Pinchart

