Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35996 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaH1Oja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 10:39:30 -0400
Message-id: <53FF3F1F.6090806@samsung.com>
Date: Thu, 28 Aug 2014 16:39:27 +0200
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_uvc fix transition to video_ioctl2
References: <1408381577-31901-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <1409152598-21046-1-git-send-email-andrzej.p@samsung.com>
 <3446993.TiqE0KXHj7@avalon>
In-reply-to: <3446993.TiqE0KXHj7@avalon>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 28.08.2014 o 13:28, Laurent Pinchart pisze:

<snip>

>> diff --git a/drivers/usb/gadget/function/f_uvc.c
>> b/drivers/usb/gadget/function/f_uvc.c index 5209105..95dc1c6 100644
>> --- a/drivers/usb/gadget/function/f_uvc.c
>> +++ b/drivers/usb/gadget/function/f_uvc.c
>> @@ -411,6 +411,7 @@ uvc_register_video(struct uvc_device *uvc)
>>   	video->fops = &uvc_v4l2_fops;
>>   	video->ioctl_ops = &uvc_v4l2_ioctl_ops;
>>   	video->release = video_device_release;
>> +	video->vfl_dir = VFL_DIR_TX;
>
> Do you have any objection against squashing this patch into "usb: gadget:
> f_uvc: Move to video_ioctl2" ?
>
Not at all. Feel free to squash it.

AP

