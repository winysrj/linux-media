Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaFFJuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jun 2014 05:50:35 -0400
Message-ID: <53918EDB.3090908@redhat.com>
Date: Fri, 06 Jun 2014 11:50:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during transient
 buffer underruns
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com> <1401970991-4421-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401970991-4421-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/05/2014 02:23 PM, Laurent Pinchart wrote:
> The V4L2 specification states that
> 
> "When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet
> the poll() function succeeds, but sets the POLLERR flag in the revents
> field."
> 
> The vb2_poll() function sets POLLERR when the queued buffers list is
> empty, regardless of whether this is caused by the stream not being
> active yet, or by a transient buffer underrun.
> 
> Bring the implementation in line with the specification by returning
> POLLERR only when the queue is not streaming. Buffer underruns during
> streaming are not treated specially anymore and just result in poll()
> blocking until the next event.

After your patch the implementation is still not inline with the spec,
queuing buffers, then starting a thread doing the poll, then doing the
streamon in the main thread will still cause the poll to return POLLERR,
even though buffers are queued, which according to the spec should be enough
for the poll to block.

The correct check would be:

if (list_empty(&q->queued_list) && !vb2_is_streaming(q))
	eturn res | POLLERR;

Regards,

Hans


> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 349e659..fd428e0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2533,9 +2533,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	}
>  
>  	/*
> -	 * There is nothing to wait for if no buffers have already been queued.
> +	 * There is nothing to wait for if the queue isn't streaming.
>  	 */
> -	if (list_empty(&q->queued_list))
> +	if (!vb2_is_streaming(q))
>  		return res | POLLERR;
>  
>  	if (list_empty(&q->done_list))
> 
