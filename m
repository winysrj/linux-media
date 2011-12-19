Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34189 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1LSUIb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 15:08:31 -0500
Message-ID: <0b74e810498a96ccced9cec9ea75f2f7.squirrel@www.codeaurora.org>
Date: Mon, 19 Dec 2011 12:08:31 -0800 (PST)
Subject: V4L2 subdevice query
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I am trying to implement a video encoder v4l2 device and
need your help to find answers to some of the questions.
There is one hardware core which can do multiple sessions
(multiple file handles) of encode simultaneously.
The encode functionalty needs to be exposed to userspace
as well as kernel through standard set of APIs. Userspace
should be able to use this functionality through V4l2 interface
and another kernel module should be able to use encoder
as a subdevice. I am trying to explore the framework to achieve this
and have following questions:

1. I am planning to create a V4L2 device and also initializing
   it as a subdev in the probe function i.e the probe function
   of this driver will have:
   struct venc_device {
                struct v4l2_device v4l2_dev;
                struct v4l2_subdev sd;
   };

   struct venc_device *vdev;
   v4l2_device_register(&vdev->v4l2_dev);
   v4l2_subdev_init(&vdev->sd, venc_sd_ops);

   How do other modules discover this subdevice. Is there an API
   I can use to find module by name?

2. Most of the subdevice interface functions have input parameters
   as "struct v4l2_subdev *sd" and another API specific structure.
   How do I distinguish between different instances (file handles)
   of a subdevice. Do I always need to pass file handle/instance
   specific information in "void *arg" of the ioctl subdev core ops.

3. Controls are instance specific, eg: one encoder application might
   encode at bitrate of 4Mbps and another at 128kbps, so I want controls
   to be specific to file handles. I see that the control handler has been
   moved to v4l2_fh structure for this purpose. How do I do it for  
subdevices
   so that the v4l2 device using this subdevice inherits the instance
   specific controls defined by the subdevice.


Thanks
Vinay


