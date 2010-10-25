Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40813 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0JYARb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Oct 2010 20:17:31 -0400
Received: by fxm16 with SMTP id 16so2390603fxm.19
        for <linux-media@vger.kernel.org>; Sun, 24 Oct 2010 17:17:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287556873-23179-2-git-send-email-m.szyprowski@samsung.com>
References: <1287556873-23179-1-git-send-email-m.szyprowski@samsung.com> <1287556873-23179-2-git-send-email-m.szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 24 Oct 2010 17:17:09 -0700
Message-ID: <AANLkTinaYuwHci++fDRB7c1Lzbcew2Hzzect=GZqOpEL@mail.gmail.com>
Subject: Re: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek,
Thanks for your patches, I went through your changes. Minor comments below.

On Tue, Oct 19, 2010 at 23:41, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> From: Pawel Osciak <p.osciak@samsung.com>

> +/**
> + * __vb2_queue_cancel() - cancel and stop (pause) streaming
> + *
> + * Removes all queued buffers from driver's queue and all buffers queued by
> + * userspace from videobuf's queue. Returns to state after reqbufs.
> + */
> +static void __vb2_queue_cancel(struct vb2_queue *q)
> +{
> +       /*
> +        * Tell driver to stop all dma transactions and release all queued
> +        * buffers
> +        */

Just being picky, but those doesn't neccesarily are "dma" transactions.

> +       if (q->streaming && q->ops->stop_streaming)
> +               q->ops->stop_streaming(q);
> +       q->streaming = 0;
> +
> +       /*
> +        * Remove all buffers from videobuf's list...
> +        */
> +       INIT_LIST_HEAD(&q->queued_list);
> +       /*
> +        * ...and done list; userspace will not receive any buffers it
> +        * has not already dequeued before initiating cancel.
> +        */
> +       INIT_LIST_HEAD(&q->done_list);
> +       wake_up_all(&q->done_wq);

Any reason for replacing wake_up_interruptible_all with wake_up_all?



-- 
Best regards,
Pawel Osciak
