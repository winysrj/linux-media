Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab1F2OeE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 10:34:04 -0400
Message-ID: <4E0B3818.5060200@redhat.com>
Date: Wed, 29 Jun 2011 16:35:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: RFC: poll behavior
References: <201106291326.47527.hansverk@cisco.com> <201106291442.30210.hansverk@cisco.com> <4E0B2382.4090409@redhat.com> <201106291543.51271.hansverk@cisco.com>
In-Reply-To: <201106291543.51271.hansverk@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/29/2011 03:43 PM, Hans Verkuil wrote:
> On Wednesday, June 29, 2011 15:07:14 Hans de Goede wrote:

<snip>

>> Ok, yet more reason to go with my proposal, but then simplified to:
>>
>> When streaming has not started return POLLIN or POLLOUT (or-ed with
>> POLLPRI if events are pending).
>
> So would this be what you are looking for:
>

Yes, although I do have some comments:

> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6ba1461..a3ce5a3 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1371,35 +1371,37 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
>    */
>   unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>   {
> +	struct video_device *vfd = video_devdata(file);
>   	unsigned long flags;
>   	unsigned int ret;
>   	struct vb2_buffer *vb = NULL;
> +	bool have_events = false;
> +	unsigned int res = 0;
> +
> +	if (test_bit(V4L2_FL_USES_V4L2_FH,&vfd->flags)) {
> +		struct v4l2_fh *fh = file->private_data;
> +
> +		/* Is this file handle subscribed to any events? */
> +		have_events = fh->events != NULL;
> +		if (have_events && v4l2_event_pending(fh))
> +			res = POLLPRI;
> +	}
>
>   	/*
>   	 * Start file I/O emulator only if streaming API has not been used yet.
>   	 */

Comment needs to be changed to match the new code.

>   	if (q->num_buffers == 0&&  q->fileio == NULL) {
> -		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ)) {
> -			ret = __vb2_init_fileio(q, 1);
> -			if (ret)
> -				return POLLERR;
> -		}
> -		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE)) {
> -			ret = __vb2_init_fileio(q, 0);
> -			if (ret)
> -				return POLLERR;
> -			/*
> -			 * Write to OUTPUT queue can be done immediately.
> -			 */
> -			return POLLOUT | POLLWRNORM;
> -		}
> +		if (!V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_READ))
> +			return res | POLLIN | POLLRDNORM;
> +		if (V4L2_TYPE_IS_OUTPUT(q->type)&&  (q->io_modes&  VB2_WRITE))
> +			return res | POLLOUT | POLLWRNORM;
>   	}
>
>   	/*
>   	 * There is nothing to wait for if no buffers have already been queued.
>   	 */
>   	if (list_empty(&q->queued_list))
> -		return POLLERR;
> +		return have_events ? res : POLLERR;
>

This seems more accurate to me, given that in case of select the 2 influence
different fd sets:

		return res | POLLERR;

>   	poll_wait(file,&q->done_wq, wait);
>
> @@ -1414,10 +1416,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>
>   	if (vb&&  (vb->state == VB2_BUF_STATE_DONE
>   			|| vb->state == VB2_BUF_STATE_ERROR)) {
> -		return (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
> +		return res | (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
>   			POLLIN | POLLRDNORM;

I would prefer to see this as:
		res |= (V4L2_TYPE_IS_OUTPUT(q->type)) ? POLLOUT | POLLWRNORM :
			POLLIN | POLLRDNORM;


>   	}
> -	return 0;
> +	return res;
>   }
>   EXPORT_SYMBOL_GPL(vb2_poll);
>
>
> One note: the only time POLLERR is now returned is if no buffers have been queued
> and no events have been subscribed to. I think that qualifies as an error condition.
> I am not 100% certain, though.

I think it would be better to simply wait (iow return 0) then. I know that
gstreamer for example uses separate consumer and producer threads, so it is
possible for the producer thread to wait in select while all buffers have been
handed to the (lagging) consumer thread, once the consumer thread has consumed
a buffer it will queue it, and once filled the select will return it to
the producer thread, who shoves it into the pipeline again, etc.

Regards,

Hans
