Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41387 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbbBXHzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 02:55:15 -0500
MIME-Version: 1.0
In-Reply-To: <1796599.ux1YsIdsDy@avalon>
References: <1424722773-20131-1-git-send-email-prabhakar.csengg@gmail.com>
 <1424722773-20131-4-git-send-email-prabhakar.csengg@gmail.com> <1796599.ux1YsIdsDy@avalon>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 24 Feb 2015 07:54:42 +0000
Message-ID: <CA+V-a8uBcajKQzy9JNo1xxsr1L7H7XhGw6c4_pAwoTCLU97eEA@mail.gmail.com>
Subject: Re: [PATCH 3/3] media: omap3isp: ispvideo: use vb2_fop_mmap/poll
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review.

On Tue, Feb 24, 2015 at 12:23 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Monday 23 February 2015 20:19:33 Lad Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> No need to reinvent the wheel. Just use the already existing
>> functions provided v4l-core.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/omap3isp/ispvideo.c | 30  ++++----------------------
>>  1 file changed, 4 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/ispvideo.c
>> b/drivers/media/platform/omap3isp/ispvideo.c index b648176..5dd5ffc 100644
>> --- a/drivers/media/platform/omap3isp/ispvideo.c
>> +++ b/drivers/media/platform/omap3isp/ispvideo.c
>> @@ -1277,37 +1277,13 @@ static int isp_video_release(struct file *file)
>>       return ret;
>>  }
>>
>> -static unsigned int isp_video_poll(struct file *file, poll_table *wait)
>> -{
>> -     struct isp_video *video = video_drvdata(file);
>> -     int ret;
>> -
>> -     mutex_lock(&video->queue_lock);
>> -     ret = vb2_poll(&video->queue, file, wait);
>> -     mutex_unlock(&video->queue_lock);
>> -
>> -     return ret;
>> -}
>
> This depends on patch 2/3, which can't be accepted as-is for now.
>
>> -static int isp_video_mmap(struct file *file, struct vm_area_struct *vma)
>> -{
>> -     struct isp_video *video = video_drvdata(file);
>> -     int ret;
>> -
>> -     mutex_lock(&video->queue_lock);
>> -     ret = vb2_mmap(&video->queue, vma);
>> -     mutex_unlock(&video->queue_lock);
>> -
>> -     return ret;
>> -}
>
> This should be good but has the side effect of removing locking in
> isp_video_mmap(). Now, I think that's the right thing to do, but it should be
> done in a separate patch first with a proper explanation. I can do so, or you
> can submit an additional patch.
>
I am fine you can go ahead posting the patch.

Cheers,
--Prabhakar Lad

>>  static struct v4l2_file_operations isp_video_fops = {
>>       .owner = THIS_MODULE,
>>       .unlocked_ioctl = video_ioctl2,
>>       .open = isp_video_open,
>>       .release = isp_video_release,
>> -     .poll = isp_video_poll,
>> -     .mmap = isp_video_mmap,
>> +     .poll = vb2_fop_poll,
>> +     .mmap = vb2_fop_mmap,
>>  };
>>
>>  /* ------------------------------------------------------------------------
>>  @@ -1389,6 +1365,8 @@ int omap3isp_video_register(struct isp_video
>> *video, struct v4l2_device *vdev)
>>
>>       video->video.v4l2_dev = vdev;
>>
>> +     /* queue isnt initalized */
>> +     video->video.queue = &video->queue;
>>       ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
>>       if (ret < 0)
>>               dev_err(video->isp->dev,
>
> --
> Regards,
>
> Laurent Pinchart
>
