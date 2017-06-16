Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48504 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdFPPbF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 11:31:05 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH v2 6/6] [media] s5p-jpeg: Add stream error handling for
 Exynos5420
To: Thierry Escande <thierry.escande@collabora.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <2d6c7d4c-f2f5-495a-70c3-7768654ce8c7@samsung.com>
Date: Fri, 16 Jun 2017 17:30:58 +0200
MIME-version: 1.0
In-reply-to: <1497287605-20074-7-git-send-email-thierry.escande@collabora.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
 <CGME20170612171542epcas2p48e0dda270d604107546f590105f20e70@epcas2p4.samsung.com>
 <1497287605-20074-7-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

Thank you for the patch. Please see inline.

W dniu 12.06.2017 o 19:13, Thierry Escande pisze:
> From: henryhsu <henryhsu@chromium.org>
> 
> On Exynos5420, the STREAM_STAT bit raised on the JPGINTST register means
> there is a syntax error or an unrecoverable error on compressed file
> when ERR_INT_EN is set to 1.
> 
> Fix this case and report BUF_STATE_ERROR to videobuf2.
> 
> Signed-off-by: Henry-Ruey Hsu <henryhsu@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 3d90a63..1a07a82 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2790,6 +2790,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
>   	unsigned long payload_size = 0;
>   	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
>   	bool interrupt_timeout = false;
> +	bool stream_error = false;
>   	u32 irq_status;
>   
>   	spin_lock(&jpeg->slock);
> @@ -2806,6 +2807,11 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
>   
>   	jpeg->irq_status |= irq_status;
>   
> +	if (irq_status & EXYNOS3250_STREAM_STAT) {

If the problem which is supposed to be fixed happens on 5420,
then why the 3250 variant is also affected by this patch?

Shouldn't jpeg->variant->version be checked and equal SJPEG_EXYNOS5420?

Andrzej
