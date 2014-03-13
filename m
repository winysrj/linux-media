Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61974 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaCMOoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:44:24 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
 <1394711056-10878-9-git-send-email-archit@ti.com>
In-reply-to: <1394711056-10878-9-git-send-email-archit@ti.com>
Subject: RE: [PATCH v4 08/14] v4l: ti-vpe: Rename csc memory resource name
Date: Thu, 13 Mar 2014 15:44:22 +0100
Message-id: <000f01cf3eca$b947cc80$2bd76580$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Thursday, March 13, 2014 12:44 PM
> 
> Rename the memory block resource "vpe_csc" to "csc" since it also
> exists within the VIP IP block. This would make the name more generic,
> and both VPE and VIP DT nodes in the future can use it.

I understand that this is not yet used in any public dts files. Right?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/ti-vpe/csc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/csc.c
> b/drivers/media/platform/ti-vpe/csc.c
> index acfea50..0333339 100644
> --- a/drivers/media/platform/ti-vpe/csc.c
> +++ b/drivers/media/platform/ti-vpe/csc.c
> @@ -180,7 +180,7 @@ struct csc_data *csc_create(struct platform_device
> *pdev)
>  	csc->pdev = pdev;
> 
>  	csc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> -			"vpe_csc");
> +			"csc");
>  	if (csc->res == NULL) {
>  		dev_err(&pdev->dev, "missing platform resources data\n");
>  		return ERR_PTR(-ENODEV);
> --
> 1.8.3.2

