Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:43690 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZERT67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 15:58:59 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: "figo.zhang" <figo.zhang@kolorific.com>
Subject: Re: [PATCH]saa7134-video.c: poll method lose race condition
Date: Mon, 18 May 2009 21:58:51 +0200
Cc: linux-media@vger.kernel.org, figo1802@126.com
References: <1242612794.3442.19.camel@myhost>
In-Reply-To: <1242612794.3442.19.camel@myhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905182158.51843.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Figo Zhang,

On Monday 18 of May 2009 at 04:13:13, figo.zhang wrote:
> saa7134-video.c: poll method lose race condition
>
>
> Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
> ---
> drivers/media/video/saa7134/saa7134-video.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/saa7134/saa7134-video.c
> b/drivers/media/video/saa7134/saa7134-video.c index 493cad9..95733df 100644
> --- a/drivers/media/video/saa7134/saa7134-video.c
> +++ b/drivers/media/video/saa7134/saa7134-video.c
> @@ -1423,11 +1423,13 @@ video_poll(struct file *file, struct
> poll_table_struct *wait) {
>  	struct saa7134_fh *fh = file->private_data;
>  	struct videobuf_buffer *buf = NULL;
> +	unsigned int rc = 0;
>
>  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
>  		return videobuf_poll_stream(file, &fh->vbi, wait);
>
>  	if (res_check(fh,RESOURCE_VIDEO)) {
> +		mutex_lock(&fh->cap.vb_lock);
>  		if (!list_empty(&fh->cap.stream))
>  			buf = list_entry(fh->cap.stream.next, struct videobuf_buffer, stream);
>  	} else {
> @@ -1446,13 +1448,14 @@ video_poll(struct file *file, struct
> poll_table_struct *wait) }
>
>  	if (!buf)
> -		return POLLERR;
> +		rc = POLLERR;

Just one note (I don't know the future and meaning of this patch). The line 
above will change the meaning of the buf==NULL check. It will not return 
immediately, but call poll_wait with buf->done instead - NULL pointer access.

Cheers,
Oldrich.

>
>  	poll_wait(file, &buf->done, wait);
>  	if (buf->state == VIDEOBUF_DONE ||
>  	    buf->state == VIDEOBUF_ERROR)
> -		return POLLIN|POLLRDNORM;
> -	return 0;
> +		rc = POLLIN|POLLRDNORM;
> +	mutex_unlock(&fh->cap.vb_lock);
> +	return rc;
>
>  err:
>  	mutex_unlock(&fh->cap.vb_lock);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
