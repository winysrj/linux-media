Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59575
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752367AbdDCS1u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 14:27:50 -0400
Subject: Re: [RFC 03/10] [media] vb2: add in-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170313192035.29859-1-gustavo@padovan.org>
 <20170313192035.29859-4-gustavo@padovan.org>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Message-ID: <e961f869-9a4c-b68f-6379-1aea277648de@osg.samsung.com>
Date: Mon, 3 Apr 2017 14:27:42 -0400
MIME-Version: 1.0
In-Reply-To: <20170313192035.29859-4-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Gustavo,

On 03/13/2017 04:20 PM, Gustavo Padovan wrote:

[snip]

>  
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  {
> +	struct dma_fence *fence = NULL;
>  	int ret;
>  
>  	if (vb2_fileio_is_active(q)) {
> @@ -565,7 +567,17 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>  	}
>  
>  	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +
> +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> +		if (b->memory != VB2_MEMORY_DMABUF)
> +			return -EINVAL;
> +

I wonder if is correct to check this. Only one side of the pipeline uses
V4L2_MEMORY_DMABUF while the other uses V4L2_MEMORY_MMAP + VIDIOC_EXPBUF.

So that means that fences can only be used in one direction?

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
