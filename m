Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4022 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaCMVID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 17:08:03 -0400
Message-ID: <53221E25.5070307@xs4all.nl>
Date: Thu, 13 Mar 2014 22:07:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: vkalia@codeaurora.org, linux-media@vger.kernel.org
Subject: Re: Query: Reqbufs returning without calling queue_setup.
References: <a3c1810c827b9bc02af572caaa231c9a.squirrel@www.codeaurora.org>
In-Reply-To: <a3c1810c827b9bc02af572caaa231c9a.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/13/2014 09:13 PM, vkalia@codeaurora.org wrote:
> Hi
> 
> There is a check in __reqbufs in videobuf2-core.c in which if the count is
> same then the function returns immediately. __reqbufs also calls
> queue_setup callback into driver which updates the plane counts and sizes
> of vb2 queue.  The count and size can be affected/changed by S_FMT and
> G_FMT ioctl calls. This causes an issue with following call flow:
> 
> 1. reqbufs.count = 8;
>    ioctl(fd, VIDIOC_REQBUFS, &reqbufs);
> 2. ioctl(fd, VIDIOC_S_FMT, &format)  --> update format with differen
> height/width etc which effect the sizeofimage
> 3. reqbufs.count = 8;
>    ioctl(fd, VIDIOC_REQBUFS, &reqbufs); to update the vb2_queue num planes
> and size of each plane. But this call never goes to the driver since
> the count is same.
> 
> Shouldn't we query the driver for any change in plane count/size before
> deciding to return from reqbufs? Following is the code. This is just a
> temporary patch to point the issue.
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c
> index e42eb0d..57e18c2 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -590,13 +590,6 @@ static int __reqbufs(struct vb2_queue *q, struct
> v4l2_requestbuffers *req)
>                 return -EBUSY;
>         }
> 
> -       /*
> -        * If the same number of buffers and memory access method is
> requested
> -        * then return immediately.
> -        */
> -       if (q->memory == req->memory && req->count == q->num_buffers)
> -               return 0;
> -

What strange kernel version are you using? This obviously wrong code was part of
the first videobuf2 appearance in kernel 2.6.39 and was fixed in 3.0. Furthermore,
in 2.6.39 videobuf2-core.c was in the video directory, not v4l2-core, and the
__reqbufs function didn't exist yet.

It seems someone made a Frankenstein version of videobuf2-core.c for whatever
kernel you are using. A Qualcomm kernel perhaps?

Regards,

	Hans

>         if (req->count == 0 || q->num_buffers != 0 || q->memory !=
> req->memory) {
>                 /*
>                  * We already have buffers allocated, so first check if they
> 
> Thanks
> Vinay
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

