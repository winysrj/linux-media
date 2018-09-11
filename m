Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:29475 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeIKQtE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 12:49:04 -0400
Subject: Re: [PATCH] vb2: check for sane values from queue_setup
To: Johan Fjeldtvedt <johfjeld@cisco.com>, linux-media@vger.kernel.org
References: <20180911112857.22783-1-johfjeld@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <65472727-ad97-14a9-6a0e-58240d77682e@cisco.com>
Date: Tue, 11 Sep 2018 13:50:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180911112857.22783-1-johfjeld@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johan,

Thank you for the patch, but I have some small comments:

On 09/11/18 13:28, Johan Fjeldtvedt wrote:
> Warn when driver sets 0 number of planes or 0 as plane sizes.
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec7342ef0..d3bc94477e6b 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -662,6 +662,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	unsigned int num_buffers, allocated_buffers, num_planes = 0;
>  	unsigned plane_sizes[VB2_MAX_PLANES] = { };
>  	int ret;
> +	int i;
>  
>  	if (q->streaming) {
>  		dprintk(1, "streaming active\n");
> @@ -718,6 +719,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	if (ret)
>  		return ret;
>  
> +	/* Check that driver has set sane values */
> +	WARN_ON(num_buffers == 0);
> +
> +	for (i = 0; i < num_buffers; i++) {

Linux coding style is not to use curly brackets around single statements.

> +		WARN_ON(plane_sizes[i] == 0);

There is a general preference in the kernel to use !foo instead of 'foo == 0'

You can (and should) run the patch against checkpatch:

git diff | scripts/checkpatch.pl --strict

> +	}
> +
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers =
>  		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
> 

Regards,

	Hans
