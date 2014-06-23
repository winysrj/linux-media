Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1661 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaFWHzP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 03:55:15 -0400
Message-ID: <53A7DD59.4060401@xs4all.nl>
Date: Mon, 23 Jun 2014 09:55:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nikhil Devshatwar <nikhil.nd@ti.com>, linux-media@vger.kernel.org
Subject: Re: [[PATCH]] vb2: verify data_offset only if nonzero bytesused
References: <1403434065-22994-1-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1403434065-22994-1-git-send-email-nikhil.nd@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/2014 12:47 PM, Nikhil Devshatwar wrote:
> verify_planes would fail if the user space fills up the data_offset field
> and bytesused is left as zero. Correct this.
> 
> Checking for data_offset > bytesused is not correct as it might fail some of
> the valid use cases. e.g. when working with SEQ_TB buffers, for bottom field,
> data_offset can be high but it can have less bytesused.
> 
> The real check should be to verify that all the bytesused after data_offset
> fit withing the length of the plane.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7c4489c..9a0ccb6 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -587,12 +587,9 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  			       ? b->m.planes[plane].length
>  			       : vb->v4l2_planes[plane].length;
>  
> -			if (b->m.planes[plane].bytesused > length)
> -				return -EINVAL;
> -
> -			if (b->m.planes[plane].data_offset > 0 &&
> -			    b->m.planes[plane].data_offset >=
> -			    b->m.planes[plane].bytesused)
> +			if (b->m.planes[plane].bytesused > 0 &&
> +			    b->m.planes[plane].data_offset +
> +			    b->m.planes[plane].bytesused > length)

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

bytesused *includes* data_offset. So the effective payload is
'bytesused - data_offset' starting at offset 'data_offset' from the
start of the buffer.

So your new condition is wrong.

Regards,

	Hans

>  				return -EINVAL;
>  		}
>  	} else {
> 

