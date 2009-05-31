Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:54324 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZEaV3v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 17:29:51 -0400
Date: Sun, 31 May 2009 14:29:52 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: "Figo.zhang" <figo1802@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Subject: Re: [PATCH] bttv-driver.c :poll method lose race condition for
 capture video
In-Reply-To: <1243751538.3425.6.camel@myhost>
Message-ID: <Pine.LNX.4.58.0905311417040.32713@shell2.speakeasy.net>
References: <1243751538.3425.6.camel@myhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 31 May 2009, Figo.zhang wrote:

> bttv-driver.c,cx23885-video.c,cx88-video.c: poll method lose race condition for capture video.

Please use patch titles that are not so long.  It would be nice if you
could describe this race condition.

>
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
>  drivers/media/video/bt8xx/bttv-driver.c     |    7 +++++--
>  drivers/media/video/cx23885/cx23885-video.c |   15 +++++++++++----
>  drivers/media/video/cx88/cx88-video.c       |   13 ++++++++++---
>  3 files changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index 23b7499..9cadfcc 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -3152,6 +3152,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	struct bttv_fh *fh = file->private_data;
>  	struct bttv_buffer *buf;
>  	enum v4l2_field field;
> +	unsigned int rc = 0;
>
>  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
>  		if (!check_alloc_btres(fh->btv,fh,RESOURCE_VBI))
> @@ -3160,6 +3161,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	}
>
>  	if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
> +		mutex_lock(&fh->cap.vb_lock);
>  		/* streaming capture */
>  		if (list_empty(&fh->cap.stream))
>  			return POLLERR;

Won't you return with the mutex held here?

> @@ -3191,8 +3193,9 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
>  	poll_wait(file, &buf->vb.done, wait);
>  	if (buf->vb.state == VIDEOBUF_DONE ||
>  	    buf->vb.state == VIDEOBUF_ERROR)
> -		return POLLIN|POLLRDNORM;
> -	return 0;
> +		rc = POLLIN|POLLRDNORM;
> +	mutex_unlock(&fh->cap.vb_lock);
> +	return rc;
>  err:
>  	mutex_unlock(&fh->cap.vb_lock);
>  	return POLLERR;

I think the logic for these changes will be cleaner to do something like this:

{
	unsigned int rc = POLLERR;

	if (some error);
		goto done;
	if (other error)
		goto done;

	if (buf->vb.state == VIDEOBUF_DONE ||
            buf->vb.state == VIDEOBUF_ERROR)
		rc = POLLIN|POLLRDNORM;
	else
		rc = 0;

done:
	mutex_unlock(&fh->vidq.vb_lock);
	return rc;
}
