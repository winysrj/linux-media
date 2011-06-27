Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:55702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab1F0Vwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 17:52:40 -0400
Message-ID: <4E08FBA5.5080006@redhat.com>
Date: Mon, 27 Jun 2011 18:52:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 PATCH 12/18] vb2_poll: don't start DMA, leave that to
 the first read().
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <f1a14e0985ddaa053e45522fe7bbdfae56057ec2.1307458245.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-06-2011 12:05, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The vb2_poll function would start read-DMA if called without any streaming
> in progress. This unfortunately does not work if the application just wants
> to poll for exceptions. This information of what the application is polling
> for is sadly unavailable in the driver.
> 
> Andy Walls suggested to just return POLLIN | POLLRDNORM and let the first
> call to read() start the DMA. This initial read() call will return EAGAIN
> since no actual data is available yet, but it does start the DMA.
> 
> Applications must handle EAGAIN in any case since there can be other reasons
> for EAGAIN as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/videobuf2-core.c |   17 +++--------------
>  1 files changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6ba1461..ad75c95 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1372,27 +1372,16 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  {
>  	unsigned long flags;
> -	unsigned int ret;
>  	struct vb2_buffer *vb = NULL;
>  
>  	/*
>  	 * Start file I/O emulator only if streaming API has not been used yet.
>  	 */
>  	if (q->num_buffers == 0 && q->fileio == NULL) {
> -		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
> -			ret = __vb2_init_fileio(q, 1);
> -			if (ret)
> -				return POLLERR;
> -		}
> -		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
> -			ret = __vb2_init_fileio(q, 0);
> -			if (ret)
> -				return POLLERR;
> -			/*
> -			 * Write to OUTPUT queue can be done immediately.
> -			 */
> +		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
> +			return POLLIN | POLLRDNORM;
> +		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
>  			return POLLOUT | POLLWRNORM;
> -		}
>  	}

There is one behavior change on this patchset:  __vb2_init_fileio() checks for some
troubles that may happen during device streaming initialization, returning POLLERR
if there is a problem there.

By moving this code to be called only at read, it means the poll() will not fail
anymore, but the first read() will fail. The man page for read() doesn't tell that
-EBUSY or -ENOMEM could happen there. The same happens with V4L2 specs. So, it is
clearly violating kernel ABI.

NACK.

Mauro.
