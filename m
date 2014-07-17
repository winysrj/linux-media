Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2453 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaGQJTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 05:19:55 -0400
Message-ID: <53C79532.5020900@xs4all.nl>
Date: Thu, 17 Jul 2014 11:19:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nikhil Devshatwar <nikhil.nd@ti.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: vb2: verify data_offset only if nonzero bytesused
References: <1403516750-22084-1-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1403516750-22084-1-git-send-email-nikhil.nd@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikhil,

First of all, sorry for the delay in answering. I needed some time to really look at
this.

Anyway, this patch as is is not good enough since it does not handle the case where
data_offset is > length and bytesused == 0.

However, I think the solution should be done differently. I'll prepare a patch for
this and CC it to you so you can take a look at it.

Regards,

	Hans

On 06/23/2014 11:45 AM, Nikhil Devshatwar wrote:
> verify_length would fail if the user space fills up the data_offset field
> and bytesused is left as zero. Correct this.
> 
> If bytesused is not populated, it means bytesused is same as length.
> Checking data offset >= bytesused makes sense only if bytesused is valid.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7c4489c..369a155 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -590,7 +590,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  			if (b->m.planes[plane].bytesused > length)
>  				return -EINVAL;
>  
> -			if (b->m.planes[plane].data_offset > 0 &&
> +			if (b->m.planes[plane].bytesused > 0 &&
>  			    b->m.planes[plane].data_offset >=
>  			    b->m.planes[plane].bytesused)
>  				return -EINVAL;
> 

