Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2B0Itc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 03:49:32 -0500
Date: Mon, 27 Feb 2012 09:49:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	mchehab@infradead.org
Subject: Re: [PATCH v2 2/6] media: i.MX27 camera: Use list_first_entry()
 whenever possible.
In-Reply-To: <1329908374-19769-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1202270945210.32434@axis700.grange>
References: <1329908374-19769-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Wed, 22 Feb 2012, Javier Martin wrote:

> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  Changes since v1:
>  - Adapt to [PATCH v4 4/4] media i.MX27 camera: handle overflows properly.
> 
> ---
>  drivers/media/video/mx2_camera.c |   26 ++++++++++++--------------
>  1 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 0ade14e..7793264 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c

[snip]

> @@ -1314,7 +1312,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>  		       pcdev->base_emma + PRP_CNTL);
>  		writel(cntl, pcdev->base_emma + PRP_CNTL);
>  
> -		buf = list_entry(pcdev->active_bufs.next,
> +		buf = list_first_entry(pcdev->active_bufs.next,

This is the only hunk, that you've changed. I'll fix this to be

+		buf = list_first_entry(&pcdev->active_bufs,

>  			struct mx2_buffer, queue);
>  		mx27_camera_frame_done_emma(pcdev,
>  					buf->bufnum, true);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
