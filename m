Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44911 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaHSU7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 16:59:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "media-workshop@linuxtv.org" <media-workshop@linuxtv.org>,
	dev@lists.tizen.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	gstreamer-announce@lists.freedesktop.org
Subject: Re: [media-workshop] [ANNOUNCE] Linux Kernel Media mini-summit on Oct, 16-17 in =?UTF-8?B?RMO8c3NlbGRvcmYs?= Germany
Date: Tue, 19 Aug 2014 23:00:34 +0200
Message-ID: <2415405.eYkoJgdMtI@avalon>
In-Reply-To: <CAPybu_02Mksi53EwsNwebGPcEhGf+TDYcyD=nry1tN1Dz7OTqA@mail.gmail.com>
References: <20140813101411.15ca3a00.m.chehab@samsung.com> <1535351.AjE5s3odp7@avalon> <CAPybu_02Mksi53EwsNwebGPcEhGf+TDYcyD=nry1tN1Dz7OTqA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 19 August 2014 18:29:08 Ricardo Ribalda Delgado wrote:
> Hello Laurent
> 
> > Could you elaborate a bit on that last point ? What kind of timestamps
> > would you need, and what are the use cases ?
> 
> Right now we only have one timestamp field on the buffer structure, it
> might be a good idea to leave space for some more.
> 
> My user case is a camera that is recording a conveyor belt at a very
> high frame rate. Instead of tracking the objects on the image with I
> use one or more encoders on the belt.  The encoder count  is read on
> vsync and kept it on a register(s). When an image is ready, the cpu
> starts the dma and read this "belt timestamps" registers.
> 
> It would be nice to have an standard way to expose this alternative
> timestamps or at least find out if I am the only one with this issue
> and/or how you have solve it :)

I have a similar use cases. UVC transmits a device clock timestamp to the 
host, as well as the corresponding USB SOF counter value. This can be used to 
translate the device clock timestamp to a host timestamp. The uvcvideo driver 
is currently performing that translation in the kernel, but moving it to 
userspace would allow more accurate host timestamp computation by using 
floating-point math.

In a similar fashion CSI2 cameras transmit a 16-bit frame number to the 
receiver. That number is currently expanded to 32-bits by the driver and 
passed to userspace in the v4l2_buffer sequence number. That's fine from a 
kernel point of view, but in userspace the sequence number is lost when using 
the gstreamer v4l2src element.

Have you thought about how you would like to implement those advanced 
timestamps ? Reusing the v4l2_buffer timecode field might be an option, but 
I'm not sure whether it would be the best one. Using a metadata plane also 
comes to mind.

-- 
Regards,

Laurent Pinchart

