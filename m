Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60357 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaFKJow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 05:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140611073108.GE16443@mwanda>
References: <20140611073108.GE16443@mwanda>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Jun 2014 10:44:20 +0100
Message-ID: <CA+V-a8vhEyNdQRqNrzRV=t-D+uh6rCEY5-qLjTOWDfHwUai1Kg@mail.gmail.com>
Subject: Re: [patch] [media] davinci: vpif: missing unlocks on error
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thanks for the patch.

On Wed, Jun 11, 2014 at 8:31 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We recently changed some locking around so we need some new unlocks on
> the error paths.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Please review this one carefully.  I don't know if the unlock should go
> before or after the list_for_each_entry_safe() loop.
>
Yes the unlock should go after the list_for_each_entry_safe() loop
please respin another version fixing it.

Thanks,
--Prabhakar Lad

> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index a7ed164..2c08fbd 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -265,6 +265,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>
>  err:
> +       spin_unlock_irqrestore(&common->irqlock, flags);
> +
>         list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
>                 list_del(&buf->list);
>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
> diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> index 5bb085b..b7b2bdf 100644
> --- a/drivers/media/platform/davinci/vpif_display.c
> +++ b/drivers/media/platform/davinci/vpif_display.c
> @@ -229,6 +229,8 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>
>  err:
> +       spin_unlock_irqrestore(&common->irqlock, flags);
> +
>         list_for_each_entry_safe(buf, tmp, &common->dma_queue, list) {
>                 list_del(&buf->list);
>                 vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
