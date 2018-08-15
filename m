Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51374 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeHOOn1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 10:43:27 -0400
Date: Wed, 15 Aug 2018 08:51:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 18/35] videobuf2-v4l2: replace if by switch in
 __fill_vb2_buffer()
Message-ID: <20180815085128.7a3a3711@coco.lan>
In-Reply-To: <20180814142047.93856-19-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-19-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:30 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Replace 'if' statements by a switch in __fill_vb2_buffer()
> in preparation of the next patch.
> 
> No other changes.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 21 ++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 408fd7ce9c09..57848ddc584f 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -190,21 +190,25 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  	vbuf->sequence = 0;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> -		if (b->memory == VB2_MEMORY_USERPTR) {
> +		switch (b->memory) {
> +		case VB2_MEMORY_USERPTR:
>  			for (plane = 0; plane < vb->num_planes; ++plane) {
>  				planes[plane].m.userptr =
>  					b->m.planes[plane].m.userptr;
>  				planes[plane].length =
>  					b->m.planes[plane].length;
>  			}
> -		}
> -		if (b->memory == VB2_MEMORY_DMABUF) {
> +			break;
> +		case VB2_MEMORY_DMABUF:
>  			for (plane = 0; plane < vb->num_planes; ++plane) {
>  				planes[plane].m.fd =
>  					b->m.planes[plane].m.fd;
>  				planes[plane].length =
>  					b->m.planes[plane].length;
>  			}
> +			break;
> +		default:
> +			break;
>  		}
>  
>  		/* Fill in driver-provided information for OUTPUT types */
> @@ -255,14 +259,17 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  		 * the driver should use the allow_zero_bytesused flag to keep
>  		 * old userspace applications working.
>  		 */
> -		if (b->memory == VB2_MEMORY_USERPTR) {
> +		switch (b->memory) {
> +		case VB2_MEMORY_USERPTR:
>  			planes[0].m.userptr = b->m.userptr;
>  			planes[0].length = b->length;
> -		}
> -
> -		if (b->memory == VB2_MEMORY_DMABUF) {
> +			break;
> +		case VB2_MEMORY_DMABUF:
>  			planes[0].m.fd = b->m.fd;
>  			planes[0].length = b->length;
> +			break;
> +		default:
> +			break;
>  		}
>  
>  		if (V4L2_TYPE_IS_OUTPUT(b->type)) {



Thanks,
Mauro
