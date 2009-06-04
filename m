Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44645 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZFDJSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 05:18:04 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "figo.zhang" <figo.zhang@kolorific.com>
Subject: Re: [PATCH]V4L:some v4l drivers have error for video_register_device
Date: Thu, 4 Jun 2009 11:18:00 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	kraxel@bytesex.org, Hans Verkuil <hverkuil@xs4all.nl>,
	alan@lxorguk.ukuu.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	akpm@linux-foundation.org
References: <1243394739.3384.16.camel@myhost> <1244089207.3445.31.camel@myhost>
In-Reply-To: <1244089207.3445.31.camel@myhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041118.01025.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Thursday 04 June 2009 06:20:07 figo.zhang wrote:
> The function video_register_device() will call the
> video_register_device_index(). In this function, firtly it will do some
> argments check , if failed,it will return a negative number such as
> -EINVAL, and then do cdev_alloc() and device_register(), if success return
> zero. so video_register_device_index() canot return a a positive number.
>
> for example, see the drivers/media/video/stk-webcam.c (line 1325):
>
> err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> 	if (err)
> 		STK_ERROR("v4l registration failed\n");
> 	else
> 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> 			" /dev/video%d\n", dev->vdev.num);
>
> in my opinion, it will be cleaner to do something like this:
>
> err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> 	if (err != 0)
> 		STK_ERROR("v4l registration failed\n");
> 	else
> 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> 			" /dev/video%d\n", dev->vdev.num);

What's the difference ? (err != 0) and (err) are identical.

Best regards,

Laurent Pinchart

