Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8425 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3H0JAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:00:12 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS600L22M8ON970@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Aug 2013 10:00:09 +0100 (BST)
Message-id: <521C6A98.8000508@samsung.com>
Date: Tue, 27 Aug 2013 11:00:08 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.chehab@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'
References: <1377532029-12777-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1377532029-12777-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/26/2013 5:47 PM, Sylwester Nawrocki wrote:
> Modify the bytesused/data_offset check to not fail if both bytesused
> and data_offset is set to 0. This should minimize possible issues in
> existing applications which worked before we enforced the plane lengths
> for output buffers checks introduced in commit 8023ed09cb278004a2
> "videobuf2-core: Verify planes lengths for output buffers"
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 594c75e..de0e87f 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -353,7 +353,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>   
>   			if (b->m.planes[plane].bytesused > length)
>   				return -EINVAL;
> -			if (b->m.planes[plane].data_offset >=
> +
> +			if (b->m.planes[plane].data_offset > 0 &&
> +			    b->m.planes[plane].data_offset >=
>   			    b->m.planes[plane].bytesused)
>   				return -EINVAL;
>   		}

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


