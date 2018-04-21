Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:17005 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753192AbeDUT1p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Apr 2018 15:27:45 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr
Subject: Re: [PATCH 04/15] media: pxa_camera: remove the dmaengine compat need
References: <20180402142656.26815-1-robert.jarzmik@free.fr>
        <20180402142656.26815-5-robert.jarzmik@free.fr>
Date: Sat, 21 Apr 2018 21:27:43 +0200
In-Reply-To: <20180402142656.26815-5-robert.jarzmik@free.fr> (Robert Jarzmik's
        message of "Mon, 2 Apr 2018 16:26:45 +0200")
Message-ID: <871sf8z7f4.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> From: Robert Jarzmik <robert.jarzmik@renault.com>
>
> As the pxa architecture switched towards the dmaengine slave map, the
> old compatibility mechanism to acquire the dma requestor line number and
> priority are not needed anymore.
>
> This patch simplifies the dma resource acquisition, using the more
> generic function dma_request_slave_channel().
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/pxa_camera.c | 22 +++-------------------
>  1 file changed, 3 insertions(+), 19 deletions(-)
Hans, could I have your ack please ?

Cheers.

--
Robert

PS: The submitted patch
>
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index c71a00736541..4c82d1880753 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2357,8 +2357,6 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  		.src_maxburst = 8,
>  		.direction = DMA_DEV_TO_MEM,
>  	};
> -	dma_cap_mask_t mask;
> -	struct pxad_param params;
>  	char clk_name[V4L2_CLK_NAME_SIZE];
>  	int irq;
>  	int err = 0, i;
> @@ -2432,34 +2430,20 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->base = base;
>  
>  	/* request dma */
> -	dma_cap_zero(mask);
> -	dma_cap_set(DMA_SLAVE, mask);
> -	dma_cap_set(DMA_PRIVATE, mask);
> -
> -	params.prio = 0;
> -	params.drcmr = 68;
> -	pcdev->dma_chans[0] =
> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> -						 &params, &pdev->dev, "CI_Y");
> +	pcdev->dma_chans[0] = dma_request_slave_channel(&pdev->dev, "CI_Y");
>  	if (!pcdev->dma_chans[0]) {
>  		dev_err(&pdev->dev, "Can't request DMA for Y\n");
>  		return -ENODEV;
>  	}
>  
> -	params.drcmr = 69;
> -	pcdev->dma_chans[1] =
> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> -						 &params, &pdev->dev, "CI_U");
> +	pcdev->dma_chans[1] = dma_request_slave_channel(&pdev->dev, "CI_U");
>  	if (!pcdev->dma_chans[1]) {
>  		dev_err(&pdev->dev, "Can't request DMA for Y\n");
>  		err = -ENODEV;
>  		goto exit_free_dma_y;
>  	}
>  
> -	params.drcmr = 70;
> -	pcdev->dma_chans[2] =
> -		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> -						 &params, &pdev->dev, "CI_V");
> +	pcdev->dma_chans[2] = dma_request_slave_channel(&pdev->dev, "CI_V");
>  	if (!pcdev->dma_chans[2]) {
>  		dev_err(&pdev->dev, "Can't request DMA for V\n");
>  		err = -ENODEV;
