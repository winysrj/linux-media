Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207AbZFJOjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 10:39:22 -0400
Date: Wed, 10 Jun 2009 11:39:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "figo.zhang" <figo.zhang@kolorific.com>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH]V4L:some v4l drivers have error for
 video_register_device
Message-ID: <20090610113917.0684b09f@pedra.chehab.org>
In-Reply-To: <1244107250.3445.32.camel@myhost>
References: <1243394739.3384.16.camel@myhost>
	<1244089207.3445.31.camel@myhost>
	<200906041118.01025.laurent.pinchart@skynet.be>
	<1244107250.3445.32.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Jun 2009 17:20:50 +0800
"figo.zhang" <figo.zhang@kolorific.com> escreveu:

> On Thu, 2009-06-04 at 11:18 +0200, Laurent Pinchart wrote:
> > Hi,
> > 
> > On Thursday 04 June 2009 06:20:07 figo.zhang wrote:
> > > The function video_register_device() will call the
> > > video_register_device_index(). In this function, firtly it will do some
> > > argments check , if failed,it will return a negative number such as
> > > -EINVAL, and then do cdev_alloc() and device_register(), if success return
> > > zero. so video_register_device_index() canot return a a positive number.
> > >
> > > for example, see the drivers/media/video/stk-webcam.c (line 1325):
> > >
> > > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> > > 	if (err)
> > > 		STK_ERROR("v4l registration failed\n");
> > > 	else
> > > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> > > 			" /dev/video%d\n", dev->vdev.num);
> > >
> > > in my opinion, it will be cleaner to do something like this:
> > >
> > > err = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
> > > 	if (err != 0)
> > > 		STK_ERROR("v4l registration failed\n");
> > > 	else
> > > 		STK_INFO("Syntek USB2.0 Camera is now controlling video device"
> > > 			" /dev/video%d\n", dev->vdev.num);
> > 
> > What's the difference ? (err != 0) and (err) are identical.
> > 
> > Best regards,
> > 
> > Laurent Pinchart
> 
> yes, it is the same, but it is easy for reading.

if (err) is easier for reading, since it is closer to the natural language.

Also, as CodingStyle says, "C is a Spartan language". So, using just if (err)
is better than if (err != 0).

Also, since positive values don't indicate errors (on Linux, all errors are
negative values), using err != 0 looks wrong. Yet, changing they to err < 0
would require a careful review of the returned values by each function.

In summary, for newer code, the better is to always use if (err < 0), being
sure that the called function will return a negative value. However, I don't
see much sense on changing the current code.




Cheers,
Mauro
