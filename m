Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17132 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2KHMNy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 07:13:54 -0500
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MD6004TH4NK2800@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Nov 2012 12:14:09 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync2.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MD600GLO4N2UU00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Nov 2012 12:13:52 +0000 (GMT)
Message-id: <509BA1FE.9010301@samsung.com>
Date: Thu, 08 Nov 2012 13:13:50 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 27/26] v4l: vb2: Set data_offset to 0 for single-plane
 buffers
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1352376336-5404-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1352376336-5404-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 11/8/2012 1:05 PM, Laurent Pinchart wrote:
> Single-planar V4L2 buffers are converted to multi-planar vb2 buffers
> with a single plane when queued. The plane data_offset field is not
> available in the single-planar API and must be set to 0 for dmabuf
> buffers and all output buffers.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b0402f2..3eae3d8 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -931,6 +931,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>   		 */
>   		if (V4L2_TYPE_IS_OUTPUT(b->type))
>   			v4l2_planes[0].bytesused = b->bytesused;
> +			v4l2_planes[0].data_offset = 0;
>   
>   		if (b->memory == V4L2_MEMORY_USERPTR) {
>   			v4l2_planes[0].m.userptr = b->m.userptr;
> @@ -940,6 +941,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
>   		if (b->memory == V4L2_MEMORY_DMABUF) {
>   			v4l2_planes[0].m.fd = b->m.fd;
>   			v4l2_planes[0].length = b->length;
> +			v4l2_planes[0].data_offset = 0;
>   		}
>   
>   	}

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


