Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1163 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3JBOAH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 10:00:07 -0400
Message-ID: <524C26D5.10606@xs4all.nl>
Date: Wed, 02 Oct 2013 15:59:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 3/4] v4l: vb2: Return POLLERR when polling for events
 and none are subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1380721516-488-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/02/13 15:45, Sakari Ailus wrote:
> The current implementation allowed polling for events even if none were
> subscribed. This may be troublesome in multi-threaded applications where the
> thread handling the subscription is different from the one that handles the
> events.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 79acf5e..c5dc903 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2011,6 +2011,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>
>   		if (v4l2_event_pending(fh))
>   			res = POLLPRI;
> +
> +		if (!v4l2_event_has_subscribed(fh))
> +			return POLLERR | POLLPRI;

What should happen if you poll for both POLLPRI and POLLIN and one of 
the two would normally return POLLERR? Should that error condition be 
ignored?

I'm not sure, frankly.

Regards,

	Hans

>   	}
>
>   	if (!V4L2_TYPE_IS_OUTPUT(q->type) && !(req_events & (POLLIN | POLLRDNORM)))
>

