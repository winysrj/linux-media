Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1285 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaISIOO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 04:14:14 -0400
Message-ID: <541BE5C5.5040205@xs4all.nl>
Date: Fri, 19 Sep 2014 10:13:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/3] vb2: Buffers returned to videobuf2 from start_streaming
 in QUEUED state
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi> <1411077469-29178-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1411077469-29178-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/18/2014 11:57 PM, Sakari Ailus wrote:
> Patch "[media] v4l: vb2: Fix stream start and buffer completion race" has a
> sets q->start_streaming_called before calling queue op start_streaming() in
> order to fix a bug. This has the side effect that buffers returned to
> videobuf2 in VB2_BUF_STATE_QUEUED will cause a WARN_ON() to be called.
> 
> Add a new field called done_buffers_queued_state to struct vb2_queue, which
> must be set if the new state of buffers returned to videobuf2 must be
> VB2_BUF_STATE_QUEUED, i.e. buffers returned in start_streaming op.

I posted a fix for this over a month ago:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg77871.html

Unfortunately, the pull request with that patch (https://patchwork.linuxtv.org/patch/25162/)
fell through the cracks as I discovered yesterday. Hopefully Mauro will pick
up that pull request quickly.

I prefer my patch since that avoids introducing yet another state variable.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |    5 +++--
>  include/media/videobuf2-core.h           |    4 ++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7e6aff6..202e2a5 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1174,7 +1174,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>  		return;
>  
> -	if (!q->start_streaming_called) {
> +	if (q->done_buffers_queued_state) {
>  		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
>  			state = VB2_BUF_STATE_QUEUED;
>  	} else if (WARN_ON(state != VB2_BUF_STATE_DONE &&
> @@ -1742,9 +1742,10 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  		__enqueue_in_driver(vb);
>  
>  	/* Tell the driver to start streaming */
> -	q->start_streaming_called = 1;
> +	q->done_buffers_queued_state = q->start_streaming_called = 1;
>  	ret = call_qop(q, start_streaming, q,
>  		       atomic_read(&q->owned_by_drv_count));
> +	q->done_buffers_queued_state = 0;
>  	if (!ret)
>  		return 0;
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 5a10d8d..7c0dac6 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -380,6 +380,9 @@ struct v4l2_fh;
>   * @streaming:	current streaming state
>   * @start_streaming_called: start_streaming() was called successfully and we
>   *		started streaming.
> + * @done_buffers_queued_state: buffers returned to videobuf2 must go
> + *		to VB2_BUF_STATE_QUEUED state. This is the case whilst
> + *		the driver's start_streaming op is called.
>   * @error:	a fatal error occurred on the queue
>   * @fileio:	file io emulator internal data, used only if emulator is active
>   * @threadio:	thread io internal data, used only if thread is active
> @@ -418,6 +421,7 @@ struct vb2_queue {
>  
>  	unsigned int			streaming:1;
>  	unsigned int			start_streaming_called:1;
> +	unsigned int			done_buffers_queued_state:1;
>  	unsigned int			error:1;
>  
>  	struct vb2_fileio_data		*fileio;
> 

