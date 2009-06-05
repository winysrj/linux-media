Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:28152 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZFECvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 22:51:42 -0400
Received: by rv-out-0506.google.com with SMTP id f9so558284rvb.1
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2009 19:51:44 -0700 (PDT)
Subject: Re: [PATCH]V4L:some v4l drivers have error for
 video_register_device
From: "Figo.zhang" <figo1802@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	akpm@linux-foundation.org
In-Reply-To: <5143.62.70.2.252.1244107655.squirrel@webmail.xs4all.nl>
References: <5143.62.70.2.252.1244107655.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 10:51:36 +0800
Message-Id: <1244170296.4603.17.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-04 at 11:27 +0200, Hans Verkuil wrote:
> > On Thu, 2009-06-04 at 11:18 +0200, Laurent Pinchart wrote:
> >> Hi,
> >>
> >> On Thursday 04 June 2009 06:20:07 figo.zhang wrote:
> >> > The function video_register_device() will call the
> >> > video_register_device_index(). In this function, firtly it will do
> >> some
> >> > argments check , if failed,it will return a negative number such as
> >> > -EINVAL, and then do cdev_alloc() and device_register(), if success
> >> return
> >> > zero. so video_register_device_index() canot return a a positive
> >> number.
> >> >
> >> > for example, see the drivers/media/video/stk-webcam.c (line 1325):
> >> >
> >> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> >> > 	if (err)
> >> > 		STK_ERROR("v4l registration failed\n");
> >> > 	else
> >> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> >> > 			" /dev/video%d\n", dev->vdev.num);
> >> >
> >> > in my opinion, it will be cleaner to do something like this:
> >> >
> >> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> >> > 	if (err != 0)
> >> > 		STK_ERROR("v4l registration failed\n");
> >> > 	else
> >> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> >> > 			" /dev/video%d\n", dev->vdev.num);
> >>
> >> What's the difference ? (err != 0) and (err) are identical.
> >>
> >> Best regards,
> >>
> >> Laurent Pinchart
> >
> > yes, it is the same, but it is easy for reading.
> 
> To be honest, I think '(err)' is easier to read. Unless there is some new
> CodingStyle rule I'm not aware of I see no reason for applying these
> changes.
> 
> Regards,
> 
>         Hans
> 

yes, but i found the the kernel code using the '(err != 0) or (err == 0)' is
more popular,in v4l code for example:

v4l1-compat.c  line 507
v4l2-int-device.c  line 52
arv.c   line 333
arv.c   line 844,856

videobuf-core.c  line 529,766,984,1002,1053
videobuf-dma-sg.c  line 211,222,248,350,456,671,

.....

so i dont know which style is recommended for kernel code?

Best Regards,

Figo.zhang


