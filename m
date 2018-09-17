Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53434 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726570AbeIQOn0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 10:43:26 -0400
Subject: Re: [PATCH v5] vb2: check for sane values from queue_setup
To: Johan Fjeldtvedt <johfjeld@cisco.com>, linux-media@vger.kernel.org
References: <20180917083647.6236-1-johfjeld@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3f68d7c9-49c4-36f8-9ab9-6d679493fff5@xs4all.nl>
Date: Mon, 17 Sep 2018 11:16:50 +0200
MIME-Version: 1.0
In-Reply-To: <20180917083647.6236-1-johfjeld@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/17/2018 10:36 AM, Johan Fjeldtvedt wrote:
> Warn and return error from the reqbufs ioctl when driver sets 0 number
> of planes or 0 as plane sizes, as these values don't make any sense.
> Checking this here stops obviously wrong values from propagating
> further and causing various problems that are hard to trace back to
> either of these values being 0.
> 
> Signed-off-by: Johan Fjeldtvedt <johfjeld@cisco.com>

FYI: next time when you post a new version of a patch don't forget to add
any Acked-by's or Reviewed-by's that others added to previous versions.

I'll add Sakari's Acked-by, so no need for a v6 :-)

Regards,

	Hans

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec7342ef0..14cedf42e907 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -661,6 +661,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  {
>  	unsigned int num_buffers, allocated_buffers, num_planes = 0;
>  	unsigned plane_sizes[VB2_MAX_PLANES] = { };
> +	unsigned int i;
>  	int ret;
>  
>  	if (q->streaming) {
> @@ -718,6 +719,14 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	if (ret)
>  		return ret;
>  
> +	/* Check that driver has set sane values */
> +	if (WARN_ON(!num_planes))
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_planes; i++)
> +		if (WARN_ON(!plane_sizes[i]))
> +			return -EINVAL;
> +
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers =
>  		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
> 
