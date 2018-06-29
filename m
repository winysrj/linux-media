Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:38984 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752633AbeF2HEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 03:04:23 -0400
Subject: Re: [PATCH 2/2] v4l-helpers: Fix EXPBUF queue type
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
References: <20180628192557.22966-1-ezequiel@collabora.com>
 <20180628192557.22966-2-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f292603-60b8-be4b-96fd-2e8725c327a0@xs4all.nl>
Date: Fri, 29 Jun 2018 09:04:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180628192557.22966-2-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2018 09:25 PM, Ezequiel Garcia wrote:
> v4l_queue_export_bufs uses the v4l_fd type when calling
> EXPBUF ioctl. However, this doesn't work on mem2mem
> where there are one capture queue and one output queue
> associated to the device.
> 
> The current code calls v4l_queue_export_bufs with the
> wrong type, failing as:
> 
> fail: v4l2-test-buffers.cpp(544): q_.export_bufs(node)
> test VIDIOC_EXPBUF: FAIL
> 
> Fix this by using the queue type instead.

I changed this by requiring that the exp_type is provided by the caller.

Thanks for reporting this!

Regards,

	Hans

> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  utils/common/v4l-helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
> index 83d8d7d9c073..d6866f04e23a 100644
> --- a/utils/common/v4l-helpers.h
> +++ b/utils/common/v4l-helpers.h
> @@ -1633,7 +1633,7 @@ static inline int v4l_queue_export_bufs(struct v4l_fd *f, struct v4l_queue *q,
>  	unsigned b, p;
>  	int ret = 0;
>  
> -	expbuf.type = exp_type ? : f->type;
> +	expbuf.type = exp_type ? : q->type;
>  	expbuf.flags = O_RDWR;
>  	memset(expbuf.reserved, 0, sizeof(expbuf.reserved));
>  	for (b = 0; b < v4l_queue_g_buffers(q); b++) {
> 
