Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58760 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3GYJJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:09:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: =?ISO-8859-1?Q?B=E5rd?= Eirik Winther <bwinther@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: UVC and V4L2_CAP_AUDIO
Date: Thu, 25 Jul 2013 11:10:15 +0200
Message-ID: <1530000.NI5gtVtkJY@avalon>
In-Reply-To: <201307251103.13456.hverkuil@xs4all.nl>
References: <201307251103.13456.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 25 July 2013 11:03:13 Hans Verkuil wrote:
> Hi Laurent,
> 
> While working on adding alsa streaming support to qv4l2 we noticed that uvc
> doesn't set this capability telling userspace that the webcam supports
> audio.
> 
> Is it possible at all in the uvc driver to determine whether or not a uvc
> webcam has a microphone?

Not without dirty hacks. The UVC interfaces don't report whether the device 
has an audio function, the driver would need to look at all the interfaces of 
the parent USB device and find out whether they match one of the USB audio 
drivers. That's not something I would be inclined to merge in the uvcvideo 
driver.

> If not, then it looks like the only way to find the associated alsa device
> is to use libmedia_dev (or its replacement, although I wonder if anyone is
> still working on that).

I need to post the code I have. I'll try to do that next week.

> And in particular, the presence of CAP_AUDIO cannot be used to determine
> whether the device has audio capabilities, it can only be used to determine
> if the V4L2 audio ioctls are supported. That would have to be clarified in
> the spec.

The V4L2 audio ioctls are definitely not supported by the uvcvideo driver :-)

-- 
Regards,

Laurent Pinchart

