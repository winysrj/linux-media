Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:3301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab0LaLBX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 06:01:23 -0500
Message-ID: <4D1DB7FD.1040601@redhat.com>
Date: Fri, 31 Dec 2010 09:01:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/10] [RFC] Prio handling and v4l2_device release callback
References: <cover.1293657717.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1293657717.git.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 29-12-2010 19:43, Hans Verkuil escreveu:
> This patch series adds two new features to the V4L2 framework.
> 
> The first 5 patches add support for VIDIOC_G/S_PRIORITY. All prio handling
> will be done in the core for any driver that either uses struct v4l2_fh
> (ivtv only at the moment) or has no open and release file operations (true
> for many simple (radio) drivers). In all other cases the driver will have
> to do the work.

It doesn't make sense to implement this at core, and for some this will happen
automatically, while, for others, drivers need to do something.

> Eventually all drivers should either use v4l2_fh or never set filp->private_data.

I made a series of patches, due to BKL stuff converting the core to always
use v4l2_fh on all drivers. This seems to be the right solution for it.

> All drivers that use the control framework must also use core-prio handling
> since control handling is no longer done through v4l2_ioctl_ops, so the driver
> doesn't have an easy way of checking the priority before changing a control.
> 
> By default all device nodes use the same priority state in v4l2_device, but
> drivers can assign the prio field in video_device to a different priority state,
> allowing e.g. all capture device nodes to use a different priority from all
> the display device nodes.
> 
> The v4l2_ioctl.c code will check the ioctls whether or not they are allowed
> based on the current priority. The vidioc_default callback has a new argument
> that just tells the driver whether the prio is OK or not. The driver can use
> this argument to return -EBUSY for those commands that modify state of the driver.
> 
> The following three patches implement this in ivtv and update the documentation.
> 
> The last two patches add a release callback in v4l2_device which will be called
> when the last registered device node is removed. This is very useful for
> implementing the hotplug disconnect functionality as it provides a single clean
> up callback when the last user of any of the unregistered device nodes has
> closed its filehandle. For drivers with just a single device node this is not
> very relevant since the video_device release() does the same job, but for
> drivers that create multiple device nodes (e.g. usbvision) this is a must-have.
> 
> An example of how this would be used can be found in the dsbr100 patches in
> this branch:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git?a=shortlog;h=refs/heads/usbvision
> 
> Comments?
> 
> Regards,
> 
> 	Hans
> 
> Hans Verkuil (10):
>   v4l2_prio: move from v4l2-common to v4l2-dev.
>   v4l2: add v4l2_prio_state to v4l2_device and video_device
>   v4l2-fh: implement v4l2_priority support.
>   v4l2-dev: add and support flag V4L2_FH_USE_PRIO.
>   v4l2-ioctl: add priority handling support.
>   ivtv: convert to core priority handling.
>   ivtv: use core-assisted locking.
>   v4l2-framework: update documentation for new prio field
>   v4l2-device: add kref and a release function
>   v4l2-framework.txt: document new v4l2_device release() callback
> 
>  Documentation/video4linux/v4l2-framework.txt |   34 ++++++++-
>  drivers/media/radio/radio-si4713.c           |    3 +-
>  drivers/media/video/cx18/cx18-ioctl.c        |    3 +-
>  drivers/media/video/davinci/vpfe_capture.c   |    2 +-
>  drivers/media/video/ivtv/ivtv-driver.h       |    2 -
>  drivers/media/video/ivtv/ivtv-fileops.c      |   17 +----
>  drivers/media/video/ivtv/ivtv-ioctl.c        |   77 +++++---------------
>  drivers/media/video/ivtv/ivtv-streams.c      |    1 +
>  drivers/media/video/meye.c                   |    3 +-
>  drivers/media/video/mxb.c                    |    3 +-
>  drivers/media/video/v4l2-common.c            |   63 ----------------
>  drivers/media/video/v4l2-dev.c               |  101 +++++++++++++++++++++++++-
>  drivers/media/video/v4l2-device.c            |   16 ++++
>  drivers/media/video/v4l2-fh.c                |    4 +
>  drivers/media/video/v4l2-ioctl.c             |   73 +++++++++++++++++--
>  include/media/v4l2-common.h                  |   15 ----
>  include/media/v4l2-dev.h                     |   24 ++++++
>  include/media/v4l2-device.h                  |   14 ++++
>  include/media/v4l2-fh.h                      |    1 +
>  include/media/v4l2-ioctl.h                   |    2 +-
>  20 files changed, 286 insertions(+), 172 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

