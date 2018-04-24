Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36112 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755970AbeDXKzT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:55:19 -0400
Subject: Re: [PATCH] staging: media: use relevant lock
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1501763212-1394-1-git-send-email-Julia.Lawall@lip6.fr>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <b8a26008-f8d5-43d6-b93d-0f3d20074ac0@ideasonboard.com>
Date: Tue, 24 Apr 2018 11:55:14 +0100
MIME-Version: 1.0
In-Reply-To: <1501763212-1394-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia

Thank you for the patch.

On 03/08/17 13:26, Julia Lawall wrote:
> The data protected is video_out2 and the lock that is released is
> &video_out2->dma_queue_lock, so it seems that that lock should be
> taken as well.

I agree - this certainly looks like there was a copy/paste error perhaps and is
locking the wrong video.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>




> ---
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> index 857b0e8..4910cb7 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -1059,7 +1059,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
>  	/* If resizer B is enabled */
>  	if (pipe->output_num > 1 && resizer->resizer_b.output ==
>  	    RESIZER_OUTPUT_MEMORY) {
> -		spin_lock(&video_out->dma_queue_lock);
> +		spin_lock(&video_out2->dma_queue_lock);
>  		vpfe_video_process_buffer_complete(video_out2);
>  		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
>  		vpfe_video_schedule_next_buffer(video_out2);
> 
