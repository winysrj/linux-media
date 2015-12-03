Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52477 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbLCOFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2015 09:05:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Matteo Foppiano <matteo.foppy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: PROBLEM: UVC ioctl() freeze after device disconnection
Date: Thu, 03 Dec 2015 16:05:52 +0200
Message-ID: <21316155.qk4MC33b9a@avalon>
In-Reply-To: <20151202142444.GB1580@8bit.pyg>
References: <20151202142444.GB1580@8bit.pyg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matteo,

On Wednesday 02 December 2015 15:24:44 Matteo Foppiano wrote:
> Hi,
>  working with raspberry and UVC I've found this issue:
> 	https://github.com/raspberrypi/linux/issues/1211
> 
> As you can see in the post, the problem seems to be upstream, so I'm
> writing directly to you. Hope this is correct.

That's fine. I've additionally CC'ed the linux-media mailing list.

When the device is disconnected the USB host controller driver is supposed to 
disable all endpoints, resulting in the URB completion handler 
uvc_video_complete() being called with the status set to -ESHUTDOWN. The 
driver will then call uvc_queue_cancel() to return all queued buffers to 
userspace. VIDIOC_DQBUF should then wake up and return.

>From the above link I assume you use an RPi kernel. The RPi USB host 
controller driver is known to be pretty unstable and buggy (at least the last 
time I checked) so it might not handle device disconnection properly.

The first step to debug this would be to check whether uvc_video_complete() 
gets called with a URB error status when you disconnect the device.

-- 
Regards,

Laurent Pinchart

