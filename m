Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:51222 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759010AbcCDJRR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 04:17:17 -0500
Subject: Re: [PATCH 1/2] [media] vb2-memops: Fix over allocation of frame
 vectors
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	albert@newtec.dk, Jan Kara <jack@suse.cz>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1457032369-10503-1-git-send-email-ricardo.ribalda@gmail.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <56D95299.5020401@samsung.com>
Date: Fri, 04 Mar 2016 10:17:13 +0100
MIME-version: 1.0
In-reply-to: <1457032369-10503-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2016-03-03 20:12, Ricardo Ribalda Delgado wrote:
> On page unaligned frames, create_framevec forces get_vaddr_frames to
> allocate an extra page at the end of the buffer. Under some
> circumstances, this leads to -EINVAL on VIDIOC_QBUF.
>
> E.g:
> We have vm_a that vm_area that goes from 0x1000 to 0x3000. And a
> frame that goes from 0x1800 to 0x2800, i.e. 2 pages.
>
> frame_vector_create will be called with the following params:
>
> get_vaddr_frames(0x1800 , 2, write, 1, vec);
>
> get_vaddr will allocate the first page after checking that the memory
> 0x1800-0x27ff is valid, but it will not allocate the second page because
> the range 0x2800-0x37ff is out of the vm_a range. This results in
> create_framevec returning -EFAULT
>
> Error Trace:
> [ 9083.793015] video0: VIDIOC_QBUF: 00:00:00.00000000 index=1,
> type=vid-cap, flags=0x00002002, field=any, sequence=0,
> memory=userptr, bytesused=0, offset/userptr=0x7ff2b023ca80, length=5765760
> [ 9083.793028] timecode=00:00:00 type=0, flags=0x00000000,
> frames=0, userbits=0x00000000
> [ 9083.793117] video0: VIDIOC_QBUF: error -22: 00:00:00.00000000
> index=2, type=vid-cap, flags=0x00000000, field=any, sequence=0,
> memory=userptr, bytesused=0, offset/userptr=0x7ff2b07bc500, length=5765760
>
> Fixes: 21fb0cb7ec65 ("[media] vb2: Provide helpers for mapping virtual addresses")
> Reported-by: Albert Antony <albert@newtec.dk>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
> Maybe we should cc stable.
>
> This error has not pop-out yet because userptr is usually called with memory
> on the heap and malloc usually overallocate. This error has been a pain to trace :).
>
> Regards!
>
>
>
>   drivers/media/v4l2-core/videobuf2-memops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
> index dbec5923fcf0..e4e4976c6849 100644
> --- a/drivers/media/v4l2-core/videobuf2-memops.c
> +++ b/drivers/media/v4l2-core/videobuf2-memops.c
> @@ -49,7 +49,7 @@ struct frame_vector *vb2_create_framevec(unsigned long start,
>   	vec = frame_vector_create(nr);
>   	if (!vec)
>   		return ERR_PTR(-ENOMEM);
> -	ret = get_vaddr_frames(start, nr, write, 1, vec);
> +	ret = get_vaddr_frames(start & PAGE_MASK, nr, write, 1, vec);
>   	if (ret < 0)
>   		goto out_destroy;
>   	/* We accept only complete set of PFNs */

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

