Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4083 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaJPIXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 04:23:44 -0400
Message-ID: <543F8069.8020005@xs4all.nl>
Date: Thu, 16 Oct 2014 10:23:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] usbvision-video: two use after frees
References: <20141016075721.GC29096@mwanda> <1494643.LQNyJpdPt6@avalon>
In-Reply-To: <1494643.LQNyJpdPt6@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/16/2014 10:09 AM, Laurent Pinchart wrote:
> On Thursday 16 October 2014 10:57:21 Dan Carpenter wrote:
>> The lock has been freed in usbvision_release() so there is no need to
>> call mutex_unlock() here.
> 
> Yuck :-/
> 
> The driver should really be converted to use video_device::release. That might 
> be out of scope for this fix though. Is usbvision maintained ?

I have hardware, and at some point I plan to convert it to modern frameworks.
But ENOTIME for now. So I guess I might be the closest to a being a maintainer.

Regards,

	Hans

> 
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/media/usb/usbvision/usbvision-video.c
>> b/drivers/media/usb/usbvision/usbvision-video.c index 68bc961..9bfa041
>> 100644
>> --- a/drivers/media/usb/usbvision/usbvision-video.c
>> +++ b/drivers/media/usb/usbvision/usbvision-video.c
>> @@ -446,6 +446,7 @@ static int usbvision_v4l2_close(struct file *file)
>>  	if (usbvision->remove_pending) {
>>  		printk(KERN_INFO "%s: Final disconnect\n", __func__);
>>  		usbvision_release(usbvision);
>> +		return 0;
>>  	}
>>  	mutex_unlock(&usbvision->v4l2_lock);
>>
>> @@ -1221,6 +1222,7 @@ static int usbvision_radio_close(struct file *file)
>>  	if (usbvision->remove_pending) {
>>  		printk(KERN_INFO "%s: Final disconnect\n", __func__);
>>  		usbvision_release(usbvision);
>> +		return err_code;
>>  	}
>>
>>  	mutex_unlock(&usbvision->v4l2_lock);
> 
