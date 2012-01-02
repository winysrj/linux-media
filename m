Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:59567 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab2ABUFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 15:05:47 -0500
Date: Mon, 2 Jan 2012 22:05:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: vkalia@codeaurora.org
Cc: linux-media@vger.kernel.org
Subject: Re: V4L2 subdevice query
Message-ID: <20120102200537.GK3677@valkosipuli.localdomain>
References: <0b74e810498a96ccced9cec9ea75f2f7.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b74e810498a96ccced9cec9ea75f2f7.squirrel@www.codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vinay,

On Mon, Dec 19, 2011 at 12:08:31PM -0800, vkalia@codeaurora.org wrote:
> Hi
> 
> I am trying to implement a video encoder v4l2 device and
> need your help to find answers to some of the questions.
> There is one hardware core which can do multiple sessions
> (multiple file handles) of encode simultaneously.
> The encode functionalty needs to be exposed to userspace
> as well as kernel through standard set of APIs. Userspace
> should be able to use this functionality through V4l2 interface
> and another kernel module should be able to use encoder
> as a subdevice. I am trying to explore the framework to achieve this
> and have following questions:

Is there a physical link (a bus) between the device which the another kernel
module drives, and the video encoder? Memory does not count. I have never
seen a video encoder which would be connected to somewhere else, e.g. an
ISP.

Typically video encoders will have to access the image data in tiles that do
not match with the linear read of the sensor's pixel array, which is the
same order as the output of ISPs. This requires an intermediate buffer, at
least, which is typically the system memory.

Any further technical information on the encoder, its connections to the
rest of the SoC and the SoC itself would be helpful.

> 1. I am planning to create a V4L2 device and also initializing
>    it as a subdev in the probe function i.e the probe function
>    of this driver will have:
>    struct venc_device {
>                 struct v4l2_device v4l2_dev;
>                 struct v4l2_subdev sd;
>    };
> 
>    struct venc_device *vdev;
>    v4l2_device_register(&vdev->v4l2_dev);
>    v4l2_subdev_init(&vdev->sd, venc_sd_ops);
> 
>    How do other modules discover this subdevice. Is there an API
>    I can use to find module by name?
> 
> 2. Most of the subdevice interface functions have input parameters
>    as "struct v4l2_subdev *sd" and another API specific structure.
>    How do I distinguish between different instances (file handles)
>    of a subdevice. Do I always need to pass file handle/instance
>    specific information in "void *arg" of the ioctl subdev core ops.

The subdev API, as it stands currently, is intended for configuring hardware
devices which only can have a single, global configuration.

If you implement your video encoder as a memory-to-memory device, I think
the interface has exactly what you'll need. By default everything in
memory-to-memory devices is file handle specific.

> 3. Controls are instance specific, eg: one encoder application might
>    encode at bitrate of 4Mbps and another at 128kbps, so I want controls
>    to be specific to file handles. I see that the control handler has been
>    moved to v4l2_fh structure for this purpose. How do I do it for  
> subdevices
>    so that the v4l2 device using this subdevice inherits the instance
>    specific controls defined by the subdevice.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
