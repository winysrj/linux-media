Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37606 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3EXM2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 08:28:46 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNA0014LYNEXI50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 24 May 2013 13:28:45 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	sylvester.nawrocki@gmail.com, patches@linaro.org
References: <1369284679-14716-1-git-send-email-sachin.kamat@linaro.org>
 <1369284679-14716-2-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1369284679-14716-2-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 2/2] [media] s5p-mfc: Remove redundant use of of_match_ptr
 macro
Date: Fri, 24 May 2013 14:28:38 +0200
Message-id: <01b401ce587a$38902bf0$a9b083d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thank you for your patch.

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Thursday, May 23, 2013 6:51 AM
> To: linux-media@vger.kernel.org
> Cc: s.nawrocki@samsung.com; sylvester.nawrocki@gmail.com;
> sachin.kamat@linaro.org; patches@linaro.org; Kamil Debski
> Subject: [PATCH 2/2] [media] s5p-mfc: Remove redundant use of
> of_match_ptr macro
> 
> 'exynos_mfc_match' is always compiled in. Hence of_match_ptr is
> unnecessary.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Kamil Debski <k.debski@samsung.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 01f9ae0..5d0419b 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1426,7 +1426,7 @@ static void *mfc_get_drv_data(struct
> platform_device *pdev)
> 
>  	if (pdev->dev.of_node) {
>  		const struct of_device_id *match;
> -		match = of_match_node(of_match_ptr(exynos_mfc_match),
> +		match = of_match_node(exynos_mfc_match,
>  				pdev->dev.of_node);
>  		if (match)
>  			driver_data = (struct s5p_mfc_variant *)match->data;
> --
> 1.7.9.5


