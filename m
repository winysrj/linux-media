Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37436 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3DLGDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 02:03:19 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML400KJUOSX0E40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Apr 2013 07:03:17 +0100 (BST)
Message-id: <5167A3A3.5090200@samsung.com>
Date: Fri, 12 Apr 2013 08:03:15 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com, pawel@osciak.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH] media: vb2: add length check for mmap
References: <1365739077-8740-1-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1365739077-8740-1-git-send-email-sw0312.kim@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 4/12/2013 5:57 AM, Seung-Woo Kim wrote:
> The length of mmap() can be bigger than length of vb2 buffer, so
> it should be checked.
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index db1235d..2c6ff2d 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1886,6 +1886,11 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>   
>   	vb = q->bufs[buffer];
>   
> +	if (vb->v4l2_planes[plane].length < (vma->vm_end - vma->vm_start)) {
> +		dprintk(1, "Invalid length\n");
> +		return -EINVAL;
> +	}
> +
>   	ret = call_memop(q, mmap, vb->planes[plane].mem_priv, vma);
>   	if (ret)
>   		return ret;

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


