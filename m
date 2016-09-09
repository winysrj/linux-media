Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24515 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbcIIJsl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2016 05:48:41 -0400
Subject: Re: [PATCH] [media] platform: constify vb2_ops structures
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Fabien Dessenne <fabien.dessenne@st.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benoit Parrot <bparrot@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=c3=b6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <fe79a710-f524-a161-2211-3b536c9da255@samsung.com>
Date: Fri, 09 Sep 2016 11:48:34 +0200
MIME-version: 1.0
In-reply-to: <1473379150-17315-1-git-send-email-Julia.Lawall@lip6.fr>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

On 09/09/2016 01:59 AM, Julia Lawall wrote:
> Check for vb2_ops structures that are only stored in the ops field of a
> vb2_queue structure.  That field is declared const, so vb2_ops structures
> that have this property can be declared as const also.
>
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
>
[...]

> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 785e693..d9c07b8 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2538,7 +2538,7 @@ static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
>  	pm_runtime_put(ctx->jpeg->dev);
>  }
>
> -static struct vb2_ops s5p_jpeg_qops = {
> +static const struct vb2_ops s5p_jpeg_qops = {
>  	.queue_setup		= s5p_jpeg_queue_setup,
>  	.buf_prepare		= s5p_jpeg_buf_prepare,
>  	.buf_queue		= s5p_jpeg_buf_queue,
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index e967fcf..44323cb 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1379,7 +1379,7 @@ static void cal_stop_streaming(struct vb2_queue *vq)
>  	cal_runtime_put(ctx->dev);
>  }

Thanks for the patch.

For s5p-jpeg driver:

Reviewed-by: Jacek Anaszewski <j.anaszewski@samsung.com>

-- 
Best regards,
Jacek Anaszewski
