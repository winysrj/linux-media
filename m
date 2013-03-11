Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36918 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3CKPBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 11:01:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
Subject: Re: omap3isp: iommu register problem.
Date: Mon, 11 Mar 2013 16:01:57 +0100
Message-ID: <2233212.n9eBIia8fu@avalon>
In-Reply-To: <CACKLOr3ueVjDMf8zDmdJ=mYucczsDq4X2sbn0mRKz+hvZFTZZw@mail.gmail.com>
References: <CACKLOr0DGrULZmrzRuEqdm_Ec0hroCAXrnqLUFrc37YKpQ-Vpw@mail.gmail.com> <CACKLOr3ueVjDMf8zDmdJ=mYucczsDq4X2sbn0mRKz+hvZFTZZw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Monday 11 March 2013 13:18:12 javier Martin wrote:
> I've just found the following thread where te problem is explained:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/086364.h
> tml
> 
> The problem is related with the order iommu and omap3isp are probed
> when both are built-in. If I load omap3isp as a module the problem is
> gone.
> 
> However, according to the previous thread, omap3isp register should
> return error but an oops should not be generated. So I think there is
> a bug here anyway.

Does the following patch (compile-tested only) fix the issue ?

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 6e5ad8e..4d889be 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2123,6 +2123,7 @@ static int isp_probe(struct platform_device *pdev)
 	ret = iommu_attach_device(isp->domain, &pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "can't attach iommu device: %d\n", ret);
+		ret = -EPROBE_DEFER;
 		goto free_domain;
 	}
 
@@ -2161,6 +2162,7 @@ detach_dev:
 	iommu_detach_device(isp->domain, &pdev->dev);
 free_domain:
 	iommu_domain_free(isp->domain);
+	isp->domain = NULL;
 error_isp:
 	omap3isp_put(isp);
 error:

-- 
Regards,

Laurent Pinchart

