Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26354 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbbFSMFT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 08:05:19 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NQ600HTAXKSDL80@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Jun 2015 13:05:16 +0100 (BST)
Subject: Re: [URGENT FOR v4.1] [PATCH v2] vb2: Don't WARN when
 v4l2_buffer.bytesused is 0 for multiplanar buffers
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1434715358-28325-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Kamil Debski <kamil@wypas.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <5584057B.2080504@samsung.com>
Date: Fri, 19 Jun 2015 14:05:15 +0200
MIME-version: 1.0
In-reply-to: <1434715358-28325-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-06-19 14:02, Laurent Pinchart wrote:
> Commit f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the
> vb2_queue struct") added a WARN_ONCE to catch usage of a deprecated API
> using a zero value for v4l2_buffer.bytesused.
>
> However, the condition is checked incorrectly, as the v4L2_buffer
> bytesused field is supposed to be ignored for multiplanar buffers. This
> results in spurious warnings when using the multiplanar API.
>
> Fix it by checking v4l2_buffer.bytesused for uniplanar buffers and
> v4l2_plane.bytesused for multiplanar buffers.
>
> Fixes: f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the vb2_queue struct")
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 33 ++++++++++++++++++++++----------
>   1 file changed, 23 insertions(+), 10 deletions(-)
>
> Changes since v1:
>
> - Rename __check_once to check_once
> - Drop __read_mostly on check_once
> - Use pr_warn instead of pr_warn_once
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index d835814a24d4..4eaf2f4f0294 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1242,6 +1242,23 @@ void vb2_discard_done(struct vb2_queue *q)
>   }
>   EXPORT_SYMBOL_GPL(vb2_discard_done);
>   
> +static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
> +{
> +	static bool check_once;
> +
> +	if (check_once)
> +		return;
> +
> +	check_once = true;
> +	__WARN();
> +
> +	pr_warn("use of bytesused == 0 is deprecated and will be removed in the future,\n");
> +	if (vb->vb2_queue->allow_zero_bytesused)
> +		pr_warn("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
> +	else
> +		pr_warn("use the actual size instead.\n");
> +}
> +
>   /**
>    * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
>    * v4l2_buffer by the userspace. The caller has already verified that struct
> @@ -1252,16 +1269,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>   {
>   	unsigned int plane;
>   
> -	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -		if (WARN_ON_ONCE(b->bytesused == 0)) {
> -			pr_warn_once("use of bytesused == 0 is deprecated and will be removed in the future,\n");
> -			if (vb->vb2_queue->allow_zero_bytesused)
> -				pr_warn_once("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
> -			else
> -				pr_warn_once("use the actual size instead.\n");
> -		}
> -	}
> -
>   	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>   		if (b->memory == V4L2_MEMORY_USERPTR) {
>   			for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -1302,6 +1309,9 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>   				struct v4l2_plane *pdst = &v4l2_planes[plane];
>   				struct v4l2_plane *psrc = &b->m.planes[plane];
>   
> +				if (psrc->bytesused == 0)
> +					vb2_warn_zero_bytesused(vb);
> +
>   				if (vb->vb2_queue->allow_zero_bytesused)
>   					pdst->bytesused = psrc->bytesused;
>   				else
> @@ -1336,6 +1346,9 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>   		}
>   
>   		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			if (b->bytesused == 0)
> +				vb2_warn_zero_bytesused(vb);
> +
>   			if (vb->vb2_queue->allow_zero_bytesused)
>   				v4l2_planes[0].bytesused = b->bytesused;
>   			else

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
