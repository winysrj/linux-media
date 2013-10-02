Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3112 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3JBOIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 10:08:01 -0400
Message-ID: <524C28B7.6080301@xs4all.nl>
Date: Wed, 02 Oct 2013 16:07:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 2/4] v4l: vb2: Only poll for events if the user is interested
 in them
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/13 15:45, Sakari Ailus wrote:
> Also poll_wait() before checking the events since otherwise it's possible to
> go to sleep and not getting woken up if the event arrives between the two
> operations.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 594c75e..79acf5e 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2003,13 +2003,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>   	unsigned int res = 0;
>   	unsigned long flags;
>
> -	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags) &&
> +	    req_events & POLLPRI) {

Can you add parenthesis around 'req_events & POLLPRI'? When mixing '&&' 
and '&' that makes it more readable.

>   		struct v4l2_fh *fh = file->private_data;
>
> +		poll_wait(file, &fh->wait, wait);
> +
>   		if (v4l2_event_pending(fh))
>   			res = POLLPRI;
> -		else if (req_events & POLLPRI)
> -			poll_wait(file, &fh->wait, wait);
>   	}
>
>   	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
>

After making that change you can add my:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
