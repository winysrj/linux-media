Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18988 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2GEIrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 04:47:42 -0400
Received: from eusync1.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6O002RCJ4LBE40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 09:48:21 +0100 (BST)
Received: from [106.116.147.108] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6O00KPBJ3GGN20@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jul 2012 09:47:40 +0100 (BST)
Message-id: <4FF554A9.6070100@samsung.com>
Date: Thu, 05 Jul 2012 10:47:37 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, patches@linaro.org
Subject: Re: [PATCH 1/1] [media] s5p-tv: Use module_i2c_driver in sii9234_drv.c
 file
References: <1341383595-4386-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1341383595-4386-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for the patch.


On 07/04/2012 08:33 AM, Sachin Kamat wrote:
> module_i2c_driver makes the code simpler by eliminating module_init
> and module_exit calls.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

> ---
>  drivers/media/video/s5p-tv/sii9234_drv.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-tv/sii9234_drv.c b/drivers/media/video/s5p-tv/sii9234_drv.c
> index 0f31ecc..6d348f9 100644
> --- a/drivers/media/video/s5p-tv/sii9234_drv.c
> +++ b/drivers/media/video/s5p-tv/sii9234_drv.c
> @@ -419,14 +419,4 @@ static struct i2c_driver sii9234_driver = {
>  	.id_table = sii9234_id,
>  };
>  
> -static int __init sii9234_init(void)
> -{
> -	return i2c_add_driver(&sii9234_driver);
> -}
> -module_init(sii9234_init);
> -
> -static void __exit sii9234_exit(void)
> -{
> -	i2c_del_driver(&sii9234_driver);
> -}
> -module_exit(sii9234_exit);
> +module_i2c_driver(sii9234_driver);


