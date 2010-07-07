Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab0GGUxn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jul 2010 16:53:43 -0400
Message-ID: <4C34E954.5090907@redhat.com>
Date: Wed, 07 Jul 2010 17:53:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com> <4C3495F9.4070507@redhat.com> <201007072144.46481.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201007072144.46481.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-07-2010 16:44, Laurent Pinchart escreveu:
> Hi Mauro,
> 
> Thanks for the review.
>
> On Wednesday 07 July 2010 16:58:01 Mauro Carvalho Chehab wrote:
>> Em 07-07-2010 08:53, Laurent Pinchart escreveu:
>>> Create a device node named subdevX for every registered subdev.
>>> As the device node is registered before the subdev core::s_config
>>> function is called, return -EGAIN on open until initialization
>>> completes.
> 
> [snip]
> 
>>> diff --git a/drivers/media/video/v4l2-subdev.c
>>> b/drivers/media/video/v4l2-subdev.c new file mode 100644
>>> index 0000000..a048161
>>> --- /dev/null
>>> +++ b/drivers/media/video/v4l2-subdev.c
>>> @@ -0,0 +1,65 @@
> 
> [snip]
> 
>>> +static int subdev_open(struct file *file)
>>> +{
>>> +	struct video_device *vdev = video_devdata(file);
>>> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>>> +
>>> +	if (!sd->initialized)
>>> +		return -EAGAIN;
>>
>> Those internal interfaces should not be used on normal
>> devices/applications, as none of the existing drivers are tested or
>> supposed to properly work if an external program is touching on its
>> internal interfaces. So, please add:
>>
>> 	if (!capable(CAP_SYS_ADMIN))
>> 		return -EPERM;
> 
> As Hans pointed out, subdev device nodes should only be created if the subdev 
> request it explicitly. I'll fix the patch accordingly. Existing subdevs will 
> not have a device node by default anymore, so the CAP_SYS_ADMIN capability 
> won't be required (new subdevs that explicitly ask for a device node are 
> supposed to handle the calls properly, otherwise it's a bit pointless :-)).

It should be not requested by the subdev, but by the bridge driver (or maybe
by both).

On several drivers, the bridge is connected to more than one subdev, and some
changes need to go to both subdevs, in order to work. As the glue logic is at
the bridge driver, creating subdev interfaces will not make sense on those devices.

>>> +
>>> +	return 0;
>>> +}
> 
> [snip]
> 
>>> +static long subdev_ioctl(struct file *file, unsigned int cmd,
>>> +	unsigned long arg)
>>> +{
>>> +	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
>>
>> This is a legacy call. Please, don't use it.
> 
> What should I use instead then ? I need the functionality of video_usercopy. I 
> could copy it to v4l2-subdev.c verbatim. As video_ioctl2 shares lots of code 
> with video_usercopy I think video_usercopy should stay, and video_ioctl2 
> should use it.

The bad thing of video_usercopy() is that it has a "compat" code, to fix broken
definitions of some iotls (see video_fix_command()), and that a few drivers still
use it, instead of video_ioctl2. For sure, we don't need the "compat" code for
subdev interface. Also, as time goes by, we'll eventually have different needs at
the subdev interface, as some types of ioctl's may be specific to subdevs and may
require different copy logic.

IMO, the better is to use the same logic inside the subdev stuff, of course
removing that "old ioctl" fix logic:

#ifdef __OLD_VIDIOC_
	cmd = video_fix_command(cmd);
#endif

And replacing the call to:
	err = func(file, cmd, parg);

By the proper subdev handling.

>> Also, while the API doc says that only certain ioctls are supported on
>> subdev, there's no code here preventing the usage of invalid ioctls. So,
>> it is possible to do bad things, like changing the video standard format
>> individually on each subdev, creating all sorts of problems.
> 
> Invalid (or rather unsupported) ioctls will be routed to the subdev 
> core::ioctl operation. Formats will not be changed automagically just because 
> a userspace application issues a VIDIOC_S_FMT ioctl.
> 
> As the device node creation will need to be requested explicitly this won't be 
> an issue anyway.
> 

Ok. It helps if you add the proper ioctl logic, instead of a stub.

Cheers,
Mauro



