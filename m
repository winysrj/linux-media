Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55964 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaCMOiN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:38:13 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
 <1394711056-10878-2-git-send-email-archit@ti.com>
In-reply-to: <1394711056-10878-2-git-send-email-archit@ti.com>
Subject: RE: [PATCH v4 01/14] v4l: ti-vpe: Make sure in job_ready that we have
 the needed number of dst_bufs
Date: Thu, 13 Mar 2014 15:38:10 +0100
Message-id: <000e01cf3ec9$dc01d550$94057ff0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Thursday, March 13, 2014 12:44 PM
> 
> VPE has a ctrl parameter which decides how many mem to mem transactions
> the active job from the job queue can perform.
> 
> The driver's job_ready() made sure that the number of ready source
> buffers are sufficient for the job to execute successfully. But it
> didn't make sure if there are sufficient ready destination buffers in
> the capture queue for the VPE output.
> 
> If the time taken by VPE to process a single frame is really slow, then
> it's possible that we don't need to imply such a restriction on the dst
> queue, but really fast transactions(small resolution, no de-interlacing)
> may cause us to hit the condition where we don't have any free buffers
> for the VPE to write on.
> 
> Add the extra check in job_ready() to make sure we have the sufficient
> amount of destination buffers.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/ti-vpe/vpe.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c
> b/drivers/media/platform/ti-vpe/vpe.c
> index 7a77a5b..f3143ac 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -887,6 +887,9 @@ static int job_ready(void *priv)
>  	if (v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) < needed)
>  		return 0;
> 
> +	if (v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) < needed)
> +		return 0;
> +
>  	return 1;
>  }
> 
> --
> 1.8.3.2

