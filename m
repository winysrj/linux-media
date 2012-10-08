Return-path: <linux-media-owner@vger.kernel.org>
Received: from co202.xi-lite.net ([149.6.83.202]:46620 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab2JHPlQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 11:41:16 -0400
Message-ID: <5072F3A2.10501@parrot.com>
Date: Mon, 8 Oct 2012 17:39:14 +0200
From: Andrei Mandychev <andrei.mandychev@parrot.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "Taneja, Archit" <archit@ti.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Fixed list_del corruption in videobuf-core.c : videobuf_queue_cancel()
References: <1349451865-26678-1-git-send-email-andrei.mandychev@parrot.com> <79CD15C6BA57404B839C016229A409A83EB38F54@DBDE01.ent.ti.com>
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EB38F54@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

 From time to time I get a backtrace listed below when I switch video 
from LCD to TV and vice versa. The video is switched without any problem 
but the kernel sometimes generates this trace. I decided to investigate 
it and discovered that it happens when you call VIDIOC_STREAMOFF ioctl 
and there are some buffers in the queue with VIDEOBUF_QUEUE state. I 
don't think it's a big issue but it generates annoying trace in the log.

<4>[  252.661529] list_del corruption. next->prev should be d1fe56ac, 
but was df49458c
<4>[  252.661529] Modules linked in: blackberry cdc_acm sierra option 
usb_wwan hso omap3_isp atmel_mxt_ts cp210x pl2303 usbserial 88w8688_wlan 
tun omap_hsmmc
<4>[  252.661590] [<c013e604>] (unwind_backtrace+0x0/0xf0) from 
[<c016f730>] (warn_slowpath_common+0x4c/0x64)
<4>[  252.661621] [<c016f730>] (warn_slowpath_common+0x4c/0x64) from 
[<c016f7c8>] (warn_slowpath_fmt+0x2c/0x3c)
<4>[  252.661621] [<c016f7c8>] (warn_slowpath_fmt+0x2c/0x3c) from 
[<c0295ec8>] (list_del+0x58/0x8c)
<4>[  252.661651] [<c0295ec8>] (list_del+0x58/0x8c) from [<c03ac538>] 
(videobuf_queue_cancel+0x7c/0x120)
<4>[  252.661682] [<c03ac538>] (videobuf_queue_cancel+0x7c/0x120) from 
[<c03ac630>] (videobuf_streamoff+0x54/0x64)
<4>[  252.661682] [<c03ac630>] (videobuf_streamoff+0x54/0x64) from 
[<c03b00c8>] (vidioc_streamoff+0x12c/0x148)
<4>[  252.661712] [<c03b00c8>] (vidioc_streamoff+0x12c/0x148) from 
[<c039f3f0>] (__video_do_ioctl+0x1a08/0x4698)
<4>[  252.661743] [<c039f3f0>] (__video_do_ioctl+0x1a08/0x4698) from 
[<c039d858>] (video_usercopy+0x35c/0x488)
<4>[  252.661743] [<c039d858>] (video_usercopy+0x35c/0x488) from 
[<c039c8e8>] (v4l2_ioctl+0x7c/0x12c)
<4>[  252.661773] [<c039c8e8>] (v4l2_ioctl+0x7c/0x12c) from [<c01f1954>] 
(vfs_ioctl+0x2c/0xac)
<4>[  252.661804] [<c01f1954>] (vfs_ioctl+0x2c/0xac) from [<c01f2008>] 
(do_vfs_ioctl+0x540/0x5a0)
<4>[  252.661804] [<c01f2008>] (do_vfs_ioctl+0x540/0x5a0) from 
[<c01f209c>] (sys_ioctl+0x34/0x54)
<4>[  252.661834] [<c01f209c>] (sys_ioctl+0x34/0x54) from [<c0138f40>] 
(ret_fast_syscall+0x0/0x30)


BR,
Andrei

On 10/08/2012 04:50 PM, Hiremath, Vaibhav wrote:
> On Fri, Oct 05, 2012 at 21:14:25, Andrei Mandychev wrote:
>> If there is a buffer with VIDEOBUF_QUEUED state it won't be deleted properly
>> because the head of queue loses its elements by calling INIT_LIST_HEAD()
>> before videobuf_streamoff().
> "dma_queue" is driver internal queue and videobuf_streamoff() function
> will end up into buf_release() callback, which in our case doesn't do
> anything with dmaqueue.
>
>
> Did you face any runtime issues with this? I still did not understand
> about this corruption thing.
>
> Thanks,
> Vaibhav
>> ---
>>   drivers/media/video/omap/omap_vout.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
>> index 409da0f..f02eb8e 100644
>> --- a/drivers/media/video/omap/omap_vout.c
>> +++ b/drivers/media/video/omap/omap_vout.c
>> @@ -1738,8 +1738,8 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
>>   		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode in"
>>   				" streamoff\n");
>>   
>> -	INIT_LIST_HEAD(&vout->dma_queue);
>>   	ret = videobuf_streamoff(&vout->vbq);
>> +	INIT_LIST_HEAD(&vout->dma_queue);
>>   
>>   	return ret;
>>   }
>> -- 
>> 1.7.9.5
>>
>>

