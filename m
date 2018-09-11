Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:12518 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbeIKRR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 13:17:57 -0400
Subject: Re: [PATCH v2] vb2: check for sane values from queue_setup
To: Johan Fjeldtvedt <johfjeld@cisco.com>, linux-media@vger.kernel.org
References: <20180911115849.23446-1-johfjeld@cisco.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <4b46f41c-c764-8e0e-ff53-79f718113a82@cisco.com>
Date: Tue, 11 Sep 2018 14:18:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180911115849.23446-1-johfjeld@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few more comments:

On 09/11/18 13:58, Johan Fjeldtvedt wrote:
> Warn when driver sets 0 number of planes or 0 as plane sizes.

It should also return an error, since there is no point continuing
with garbage values.

Also add *why* this is useful to the commit. I know why, since I
suggested it to you, but others don't :-)

> 
> Signed-off-by: Johan Fjeldtvedt <johfjeld@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec7342ef0..6f903740d813 100644
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
> @@ -718,6 +719,12 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	if (ret)
>  		return ret;
>  
> +	/* Check that driver has set sane values */
> +	WARN_ON(!num_buffers);

Just return an error here. EINVAL is not unreasonable. So:

	if (WARN_ON(!num_buffers))
		return -EINVAL;

> +
> +	for (i = 0; i < num_buffers; i++)
> +		WARN_ON(!plane_sizes[i]);

Ditto.

> +
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers =
>  		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
> 

Regards,

	Hans
