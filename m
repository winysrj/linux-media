Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42123 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbbBPUOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 15:14:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, isely@isely.net, pali.rohar@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/5] uvc gadget: switch to unlocked_ioctl.
Date: Mon, 16 Feb 2015 22:15:37 +0200
Message-ID: <2390343.jYF8yA1sby@avalon>
In-Reply-To: <54E208BB.9010804@xs4all.nl>
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl> <3185495.drmK3h6s8j@avalon> <54E208BB.9010804@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 16 February 2015 16:11:55 Hans Verkuil wrote:
> On 02/03/2015 02:55 PM, Laurent Pinchart wrote:
> > On Tuesday 03 February 2015 13:47:24 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Instead of .ioctl use unlocked_ioctl. While all the queue ops
> >> already use a lock, there was no lock to protect uvc_video, so
> >> add that one.
> > 
> > There's more. streamon and streamoff need to be protected by a lock for
> > instance. Wouldn't it be easier to just set vdev->lock for this driver
> > instead of adding manual locking ?
> 
> I could set vdev->lock to &video->mutex and remove the queue->mutex
> altogether since video->mutex will now be used for all locking. I only
> need to take the video->mutex in uvc_v4l2_release() as well.
> 
> If you agree with that, then I'll make that change.

That sounds good to me. I haven't really tried to optimize locking in the UVC 
gadget driver, so relying on core locking is fine. Could you split that in two 
patches, one that switches to core locking, and another that switches to 
unlocked_ioctl ?

> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >> 
> >>  drivers/usb/gadget/function/f_uvc.c    | 1 +
> >>  drivers/usb/gadget/function/uvc.h      | 1 +
> >>  drivers/usb/gadget/function/uvc_v4l2.c | 6 +++++-
> >>  3 files changed, 7 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/usb/gadget/function/f_uvc.c
> >> b/drivers/usb/gadget/function/f_uvc.c index 945b3bd..748a80c 100644
> >> --- a/drivers/usb/gadget/function/f_uvc.c
> >> +++ b/drivers/usb/gadget/function/f_uvc.c
> >> @@ -817,6 +817,7 @@ static struct usb_function *uvc_alloc(struct
> >> usb_function_instance *fi) if (uvc == NULL)
> >> 
> >>  		return ERR_PTR(-ENOMEM);
> >> 
> >> +	mutex_init(&uvc->video.mutex);
> > 
> > We need a corresponding mutex_destroy() somewhere.
> 
> Why? Few drivers do so. If you want it, then I'll do that, but it's not
> required to my knowledge.

I somehow thought mutex_destroy() was required to avoid leakages when mutex 
debugging is enabled, but it turns out I'm wrong. Omitting it thus seems fine.

-- 
Regards,

Laurent Pinchart

