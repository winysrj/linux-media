Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58831 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbbBTQxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 11:53:34 -0500
Message-ID: <54E76675.70908@xs4all.nl>
Date: Fri, 20 Feb 2015 17:53:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com
Subject: Re: [PATCH v5 3/4] coda: set allow_zero_bytesused flag for vb2_queue_init
References: <1424450288-26444-1-git-send-email-k.debski@samsung.com> <1424450288-26444-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1424450288-26444-3-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2015 05:38 PM, Kamil Debski wrote:
> The coda driver interprets a buffer with bytesused equal to 0 as a special
> case indicating end-of-stream. After vb2: fix bytesused == 0 handling
> (8a75ffb) patch videobuf2 modified the value of bytesused if it was 0.
> The allow_zero_bytesused flag was added to videobuf2 to keep
> backward compatibility.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/platform/coda/coda-common.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index 6f32e6d..2d23f9a 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1541,6 +1541,13 @@ static int coda_queue_init(struct coda_ctx *ctx, struct vb2_queue *vq)
>  	vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
>  	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	vq->lock = &ctx->dev->dev_mutex;
> +	/* One of means to indicate end-of-stream for coda is to set the

s/One of means/One way/

> +	 * bytesused == 0. However by default videobuf2 handles videobuf

s/videobuf/bytesused/

> +	 * equal to 0 as a special case and changes its value to the size
> +	 * of the buffer. Set the allow_zero_bytesused flag, so
> +	 * that videobuf2 will keep the value of bytesused intact.
> +	 */
> +	vq->allow_zero_bytesused = 1;
>  
>  	return vb2_queue_init(vq);
>  }
> 

Regards,

	Hans
