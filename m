Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4438 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbZFEKCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 06:02:49 -0400
Message-ID: <22928.62.70.2.252.1244196160.squirrel@webmail.xs4all.nl>
Date: Fri, 5 Jun 2009 12:02:40 +0200 (CEST)
Subject: Re: [PATCH] ivtv: Fix PCI direction
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> From: Alan Cox <alan@linux.intel.com>
>
> The ivtv stream buffers may be for receive or for send but the attached sg
> handle is always destined cpu->device. We flush it correctly but the
> allocation is wrongly done with the same type as the buffers.
>
> See bug: http://bugzilla.kernel.org/show_bug.cgi?id=13385
>
> (Note this doesn't close the bug - it fixes the ivtv part and in turn the
>  logging next shows up some rather alarming DMA sg list warnings in
> libata)
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

Thanks for looking at this! 'Real-life' has been seriously interfering
with my linux work lately so I didn't have the time to pick this up
myself.

Regards,

        Hans

> ---
>
>  drivers/media/video/ivtv/ivtv-queue.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/media/video/ivtv/ivtv-queue.c
> b/drivers/media/video/ivtv/ivtv-queue.c
> index ff7b7de..7fde36e 100644
> --- a/drivers/media/video/ivtv/ivtv-queue.c
> +++ b/drivers/media/video/ivtv/ivtv-queue.c
> @@ -230,7 +230,8 @@ int ivtv_stream_alloc(struct ivtv_stream *s)
>  		return -ENOMEM;
>  	}
>  	if (ivtv_might_use_dma(s)) {
> -		s->sg_handle = pci_map_single(itv->pdev, s->sg_dma, sizeof(struct
> ivtv_sg_element), s->dma);
> +		s->sg_handle = pci_map_single(itv->pdev, s->sg_dma,
> +				sizeof(struct ivtv_sg_element), PCI_DMA_TODEVICE);
>  		ivtv_stream_sync_for_cpu(s);
>  	}
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

