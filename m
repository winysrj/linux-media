Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37394 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaFFFYl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 01:24:41 -0400
Received: by mail-vc0-f175.google.com with SMTP id lc6so2345655vcb.20
        for <linux-media@vger.kernel.org>; Thu, 05 Jun 2014 22:24:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401970991-4421-2-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401970991-4421-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1401970991-4421-2-git-send-email-laurent.pinchart@ideasonboard.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 6 Jun 2014 14:15:41 +0900
Message-ID: <CAMm-=zABUWU03pMVEWO25C8sT7ih_HKZ0=uvLNAjgU5N9=wxKQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 1/2] v4l: vb2: Don't return POLLERR during
 transient buffer underruns
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 5, 2014 at 9:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
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
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 349e659..fd428e0 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2533,9 +2533,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>         }
>
>         /*
> -        * There is nothing to wait for if no buffers have already been queued.
> +        * There is nothing to wait for if the queue isn't streaming.
>          */
> -       if (list_empty(&q->queued_list))
> +       if (!vb2_is_streaming(q))
>                 return res | POLLERR;
>
>         if (list_empty(&q->done_list))
> --
> 1.8.5.5
>
