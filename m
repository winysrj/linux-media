Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37799 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbeILOcF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 10:32:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so1244271wrr.4
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2018 02:28:24 -0700 (PDT)
Subject: Re: [PATCH v3] vb2: check for sane values from queue_setup
To: Johan Fjeldtvedt <johfjeld@cisco.com>, linux-media@vger.kernel.org
Cc: hansverk@cisco.com
References: <20180911124608.31749-1-johfjeld@cisco.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <83c067dc-5d5b-d4ec-af69-5e0ca967329f@linaro.org>
Date: Wed, 12 Sep 2018 12:28:21 +0300
MIME-Version: 1.0
In-Reply-To: <20180911124608.31749-1-johfjeld@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/11/2018 03:46 PM, Johan Fjeldtvedt wrote:
> Warn and return error from the reqbufs ioctl when driver sets 0 number
> of planes or 0 as plane sizes, as these values don't make any sense.

typo: planes -> buffers

> Checking this here stops obviously wrong values from propagating
> further and causing various problems that are hard to trace back to
> either of these values being 0.
> 
> Signed-off-by: Johan Fjeldtvedt <johfjeld@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec7342ef0..5741e95e6af1 100644
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
> @@ -718,6 +719,14 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	if (ret)
>  		return ret;
>  
> +	/* Check that driver has set sane values */
> +	if (WARN_ON(!num_buffers))
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_buffers; i++)
> +		if (WARN_ON(!plane_sizes[i]))
> +			return -EINVAL;
> +
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers =
>  		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
> 

-- 
regards,
Stan
