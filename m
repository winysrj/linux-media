Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36540 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1LUAaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 19:30:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: vkalia@codeaurora.org
Subject: Re: V4L2 subdevice query
Date: Wed, 21 Dec 2011 01:30:08 +0100
Cc: linux-media@vger.kernel.org
References: <0b74e810498a96ccced9cec9ea75f2f7.squirrel@www.codeaurora.org>
In-Reply-To: <0b74e810498a96ccced9cec9ea75f2f7.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112210130.08581.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinay,

On Monday 19 December 2011 21:08:31 vkalia@codeaurora.org wrote:
> 
> I am trying to implement a video encoder v4l2 device and need your help to
> find answers to some of the questions. There is one hardware core which can
> do multiple sessions (multiple file handles) of encode simultaneously. The
> encode functionalty needs to be exposed to userspace as well as kernel
> through standard set of APIs. Userspace should be able to use this
> functionality through V4l2 interface and another kernel module should be
> able to use encoder as a subdevice. I am trying to explore the framework to
> achieve this and have following questions:
> 
> 1. I am planning to create a V4L2 device and also initializing it as a
>    subdev in the probe function i.e the probe function of this driver will
>    have:
>    struct venc_device {
>                 struct v4l2_device v4l2_dev;
>                 struct v4l2_subdev sd;
>    };
> 
>    struct venc_device *vdev;
>    v4l2_device_register(&vdev->v4l2_dev);
>    v4l2_subdev_init(&vdev->sd, venc_sd_ops);
> 
>    How do other modules discover this subdevice. Is there an API I can use
>    to find module by name?
> 
> 2. Most of the subdevice interface functions have input parameters as
>    "struct v4l2_subdev *sd" and another API specific structure. How do I
>    distinguish between different instances (file handles) of a subdevice.

The short answer is that you don't.

If your hardware block can encode a fixed number of streams separately, one 
possible solution would be to create N subdevices, or to create a single 
subdevice with N input pads and N output pads, where N is the number of 
logical streams. Input and output pads could then be connected to video nodes 
or to other subdevices in the system.

Another solution is to use the mem-to-mem framework, which allows streams 
multiplexing through multiple opens. However, there is no clear mapping to 
subdevs (that I'm aware of) at the moment.

Can you share a bit more information about your hardware ? A block diagram 
would be useful.

>    Do I always need to pass file handle/instance specific information in
>    "void *arg" of the ioctl subdev core ops.
>
> 3. Controls are instance specific, eg: one encoder application might encode
>    at bitrate of 4Mbps and another at 128kbps, so I want controls to be
>    specific to file handles. I see that the control handler has been moved
>    to v4l2_fh structure for this purpose. How do I do it for subdevices so
>    that the v4l2 device using this subdevice inherits the instance specific
>    controls defined by the subdevice.

-- 
Regards,

Laurent Pinchart
