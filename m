Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:40144 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbbBPPMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 10:12:15 -0500
Message-ID: <54E208BB.9010804@xs4all.nl>
Date: Mon, 16 Feb 2015 16:11:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, isely@isely.net, pali.rohar@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/5] uvc gadget: switch to unlocked_ioctl.
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl> <1422967646-12223-4-git-send-email-hverkuil@xs4all.nl> <3185495.drmK3h6s8j@avalon>
In-Reply-To: <3185495.drmK3h6s8j@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/2015 02:55 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Tuesday 03 February 2015 13:47:24 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Instead of .ioctl use unlocked_ioctl. While all the queue ops
>> already use a lock, there was no lock to protect uvc_video, so
>> add that one.
> 
> There's more. streamon and streamoff need to be protected by a lock for 
> instance. Wouldn't it be easier to just set vdev->lock for this driver instead 
> of adding manual locking ?

I could set vdev->lock to &video->mutex and remove the queue->mutex
altogether since video->mutex will now be used for all locking. I only
need to take the video->mutex in uvc_v4l2_release() as well.

If you agree with that, then I'll make that change.

> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/usb/gadget/function/f_uvc.c    | 1 +
>>  drivers/usb/gadget/function/uvc.h      | 1 +
>>  drivers/usb/gadget/function/uvc_v4l2.c | 6 +++++-
>>  3 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/gadget/function/f_uvc.c
>> b/drivers/usb/gadget/function/f_uvc.c index 945b3bd..748a80c 100644
>> --- a/drivers/usb/gadget/function/f_uvc.c
>> +++ b/drivers/usb/gadget/function/f_uvc.c
>> @@ -817,6 +817,7 @@ static struct usb_function *uvc_alloc(struct
>> usb_function_instance *fi) if (uvc == NULL)
>>  		return ERR_PTR(-ENOMEM);
>>
>> +	mutex_init(&uvc->video.mutex);
> 
> We need a corresponding mutex_destroy() somewhere.

Why? Few drivers do so. If you want it, then I'll do that, but it's not
required to my knowledge.

Regards,

	Hans
