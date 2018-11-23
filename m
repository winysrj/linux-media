Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50768 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388020AbeKWW4C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 17:56:02 -0500
Subject: Re: [PATCH] media: vb2: be sure to free on errors
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <e1b3d00067767ceb39da5e0014b320835b443908.1542974835.git.mchehab+samsung@kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <796f02da-07f9-da2a-afea-fc2d69d9150d@xs4all.nl>
Date: Fri, 23 Nov 2018 13:11:58 +0100
MIME-Version: 1.0
In-Reply-To: <e1b3d00067767ceb39da5e0014b320835b443908.1542974835.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2018 01:07 PM, Mauro Carvalho Chehab wrote:
> As reported by smatch:
> drivers/media/common/videobuf2/videobuf2-core.c: drivers/media/common/videobuf2/videobuf2-core.c:2159 vb2_mmap() warn: inconsistent returns 'mutex:&q->mmap_lock'.
>   Locked on:   line 2148
>   Unlocked on: line 2100
>                line 2108
>                line 2113
>                line 2118
>                line 2156
>                line 2159
> 
> There is one error condition that doesn't unlock a mutex.
> 
> Fixes: cd26d1c4d1bc ("media: vb2: vb2_mmap: move lock up")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Hmm, that's embarrassing... I should have seen that smatch warning.

Regards,

	Hans

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 04d1250747cf..0ca81d495bda 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -2145,7 +2145,8 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
>  	if (length < (vma->vm_end - vma->vm_start)) {
>  		dprintk(1,
>  			"MMAP invalid, as it would overflow buffer length\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto unlock;
>  	}
>  
>  	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
> 
