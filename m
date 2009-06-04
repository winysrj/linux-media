Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:37150 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZFDJbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 05:31:22 -0400
Subject: Re: [PATCH]V4L:some v4l drivers have error for
 video_register_device
From: "figo.zhang" <figo.zhang@kolorific.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kraxel@bytesex.org, Hans Verkuil <hverkuil@xs4all.nl>,
	alan@lxorguk.ukuu.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	akpm@linux-foundation.org
In-Reply-To: <200906041118.01025.laurent.pinchart@skynet.be>
References: <1243394739.3384.16.camel@myhost>
	 <1244089207.3445.31.camel@myhost>
	 <200906041118.01025.laurent.pinchart@skynet.be>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 17:31:23 +0800
Message-Id: <1244107883.3445.38.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-04 at 11:18 +0200, Laurent Pinchart wrote:
> Hi,
> 
> On Thursday 04 June 2009 06:20:07 figo.zhang wrote:
> > The function video_register_device() will call the
> > video_register_device_index(). In this function, firtly it will do some
> > argments check , if failed,it will return a negative number such as
> > -EINVAL, and then do cdev_alloc() and device_register(), if success return
> > zero. so video_register_device_index() canot return a a positive number.
> >
> > for example, see the drivers/media/video/stk-webcam.c (line 1325):
> >
> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> > 	if (err)
> > 		STK_ERROR("v4l registration failed\n");
> > 	else
> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> > 			" /dev/video%d\n", dev->vdev.num);
> >
> > in my opinion, it will be cleaner to do something like this:
> >
> > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> > 	if (err != 0)
> > 		STK_ERROR("v4l registration failed\n");
> > 	else
> > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> > 			" /dev/video%d\n", dev->vdev.num);
> 
> What's the difference ? (err != 0) and (err) are identical.
> 
> Best regards,
> 
> Laurent Pinchart

yes, it is the same, but it is easy for reading.

btw, see driver/media/video/ov511.c (line 5853):
	if (video_register_device(ov->vdev, VFL_TYPE_GRABBER,
			unit_video[i]) >= 0) {
			break;
		}

it would not return a positive number,i think. pls see my other path:
http://www.spinics.net/lists/linux-media/msg06140.html



