Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58831 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755031AbbBTQx6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 11:53:58 -0500
Message-ID: <54E7668E.8050105@xs4all.nl>
Date: Fri, 20 Feb 2015 17:53:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com
Subject: Re: [PATCH v5 4/4] s5p-mfc: set allow_zero_bytesused flag for vb2_queue_init
References: <1424450288-26444-1-git-send-email-k.debski@samsung.com> <1424450288-26444-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1424450288-26444-4-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2015 05:38 PM, Kamil Debski wrote:
> The s5p-mfc driver interprets a buffer with bytesused equal to 0 as a
> special case indicating end-of-stream. After vb2: fix bytesused == 0
> handling (8a75ffb) patch videobuf2 modified the value of bytesused if it
> was 0. The allow_zero_bytesused flag was added to videobuf2 to keep
> backward compatibility.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 8e44a59..6b08488 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -843,6 +843,13 @@ static int s5p_mfc_open(struct file *file)
>  		ret = -ENOENT;
>  		goto err_queue_init;
>  	}
> +	/* One of means to indicate end-of-stream for MFC is to set the
> +	 * bytesused == 0. However by default videobuf2 handles videobuf

Same typos as in patch 3/4.

Regards,

	Hans

> +	 * equal to 0 as a special case and changes its value to the size
> +	 * of the buffer. Set the allow_zero_bytesused flag so that videobuf2
> +	 * will keep the value of bytesused intact.
> +	 */
> +	q->allow_zero_bytesused = 1;
>  	q->mem_ops = &vb2_dma_contig_memops;
>  	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	ret = vb2_queue_init(q);
> 

