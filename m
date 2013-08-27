Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9557 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3H0I7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 04:59:36 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MS600NAQMAS3H70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 27 Aug 2013 09:59:34 +0100 (BST)
Message-id: <521C6A74.1050008@samsung.com>
Date: Tue, 27 Aug 2013 10:59:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.chehab@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] vb2: Add debug print for the output buffer planes lengths
 checks
References: <1377532073-12864-1-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1377532073-12864-1-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/26/2013 5:47 PM, Sylwester Nawrocki wrote:
> Add debug print so it's easier to find any errors resulting from
> the planes' configuration checks added in commit 8023ed09cb278004a2
> "videobuf2-core: Verify planes lengths for output buffers".
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index de0e87f..6bffc96 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1205,8 +1205,11 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>   	int ret;
>   
>   	ret = __verify_length(vb, b);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dprintk(1, "%s(): plane parameters verification failed: %d\n",
> +			__func__, ret);
>   		return ret;
> +	}
>   
>   	switch (q->memory) {
>   	case V4L2_MEMORY_MMAP:

Best regards
-- 
Marek Szyprowski
Samsung R&D Institute Poland


