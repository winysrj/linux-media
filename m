Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59149 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754441AbdLGOx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 09:53:29 -0500
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [PATCH] media: s5p-jpeg: Fix off-by-one problem
To: Flavio Ceolin <flavio.ceolin@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT"
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT"
        <linux-media@vger.kernel.org>
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <67ddf04e-2f0f-c14b-90ce-0f29a3647e16@samsung.com>
Date: Thu, 07 Dec 2017 15:53:23 +0100
In-reply-to: <20171206163746.8456-1-flavio.ceolin@intel.com>
Content-language: en-US
Content-transfer-encoding: 8bit
References: <CGME20171206163802epcas1p3527bd6a922fd31aa80cf349a510a71eb@epcas1p3.samsung.com>
        <20171206163746.8456-1-flavio.ceolin@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 06.12.2017 o 17:37, Flavio Ceolin pisze:
> s5p_jpeg_runtime_resume() does not call clk_disable_unprepare() for
> jpeg->clocks[0] when one of the clk_prepare_enable() fails.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Flavio Ceolin <flavio.ceolin@intel.com>

Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>


> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index faac816..79b63da 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -3086,7 +3086,7 @@ static int s5p_jpeg_runtime_resume(struct device *dev)
>   	for (i = 0; i < jpeg->variant->num_clocks; i++) {
>   		ret = clk_prepare_enable(jpeg->clocks[i]);
>   		if (ret) {
> -			while (--i > 0)
> +			while (--i >= 0)
>   				clk_disable_unprepare(jpeg->clocks[i]);
>   			return ret;
>   		}
> 
