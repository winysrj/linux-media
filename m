Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:40698 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0L2PVm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 10:21:42 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Wed, 29 Dec 2010 16:21:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance
 enhancement
In-reply-to: <1293609059-692-1-git-send-email-khw0178.kim@samsung.com>
To: Hyunwoong Kim <khw0178.kim@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Message-id: <4D1B5203.8040900@samsung.com>
References: <1293609059-692-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 12/29/2010 08:50 AM, Hyunwoong Kim wrote:
> This patch fixes the value of FIFO_CTRL in MSCTRL.
> Main-scaler has the value to specify a basis FIFO control of input DMA.
> 
> The description of FIFO_CTRL has been changed as below.
> 0 = FIFO Empty (Next burst transaction is possible when FIFO is empty)
> 1 = FIFO Full (Next burst transaction is possible except Full FIFO)
> 
> Value '1' is recommended to enhance the FIMC operation performance.
> 
> Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
> Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
> ---
> This patch is depended on Hyunwoong Kim's last patch.
> - [PATCH v2] [media] s5p-fimc: Support stop_streaming and job_abort 
> 
>  drivers/media/video/s5p-fimc/fimc-reg.c  |    4 +++-
>  drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
> index 88951b8..0eb9319 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -457,7 +457,9 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
>  		| S5P_MSCTRL_C_INT_IN_MASK
>  		| S5P_MSCTRL_2P_IN_ORDER_MASK);
>  
> -	cfg |= (S5P_MSCTRL_FRAME_COUNT(1) | S5P_MSCTRL_INPUT_MEMORY);
> +	cfg |= (S5P_MSCTRL_FRAME_COUNT(1)
> +		| S5P_MSCTRL_INPUT_MEMORY
> +		| S5P_MSCTRL_FIFO_CTRL_FULL);
>  
>  	switch (frame->fmt->color) {
>  	case S5P_FIMC_RGB565:
> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
> index 28bd2fb..a984e81 100644
> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
> @@ -226,6 +226,7 @@
>  #define S5P_MSCTRL_FLIP_X_MIRROR	(1 << 13)
>  #define S5P_MSCTRL_FLIP_Y_MIRROR	(2 << 13)
>  #define S5P_MSCTRL_FLIP_180		(3 << 13)
> +#define S5P_MSCTRL_FIFO_CTRL_FULL	(1 << 12)
>  #define S5P_MSCTRL_ORDER422_SHIFT	4
>  #define S5P_MSCTRL_ORDER422_YCBYCR	(0 << 4)
>  #define S5P_MSCTRL_ORDER422_CBYCRY	(1 << 4)

Applied. Thanks!

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
