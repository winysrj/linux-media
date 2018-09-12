Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34844 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbeILOzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 10:55:32 -0400
Date: Wed, 12 Sep 2018 12:51:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Johan Fjeldtvedt <johfjeld@cisco.com>
Cc: linux-media@vger.kernel.org, hansverk@cisco.com
Subject: Re: [PATCH v4] vb2: check for sane values from queue_setup
Message-ID: <20180912095144.7irpd26sztxsdmzg@valkosipuli.retiisi.org.uk>
References: <20180911144604.32616-1-johfjeld@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180911144604.32616-1-johfjeld@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 11, 2018 at 04:46:04PM +0200, Johan Fjeldtvedt wrote:
> Warn and return error from the reqbufs ioctl when driver sets 0 number
> of planes or 0 as plane sizes, as these values don't make any sense.
> Checking this here stops obviously wrong values from propagating
> further and causing various problems that are hard to trace back to
> either of these values being 0.
> 
> v4: check num_planes, not num_buffers
> 
> Signed-off-by: Johan Fjeldtvedt <johfjeld@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f32ec7342ef0..cf2f93462a54 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -662,6 +662,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	unsigned int num_buffers, allocated_buffers, num_planes = 0;
>  	unsigned plane_sizes[VB2_MAX_PLANES] = { };
>  	int ret;
> +	int i;

unsigned int i;

And arrange the line above ret declaration. With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  
>  	if (q->streaming) {
>  		dprintk(1, "streaming active\n");
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

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
