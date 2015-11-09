Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45190 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbKIUQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 15:16:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/19] v4l: omap3isp: fix handling platform_get_irq result
Date: Mon, 09 Nov 2015 22:16:47 +0200
Message-ID: <5373820.hJbPzosF9i@avalon>
In-Reply-To: <1443103227-25612-5-git-send-email-a.hajda@samsung.com>
References: <1443103227-25612-1-git-send-email-a.hajda@samsung.com> <1443103227-25612-5-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for the patch.

On Thursday 24 September 2015 16:00:12 Andrzej Hajda wrote:
> The function can return negative value.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2046107
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> ---
> Hi,
> 
> To avoid problems with too many mail recipients I have sent whole
> patchset only to LKML. Anyway patches have no dependencies.
> 
> Regards
> Andrzej
> ---
>  drivers/media/platform/omap3isp/isp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 56e683b..df9d2c2 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2442,12 +2442,13 @@ static int isp_probe(struct platform_device *pdev)
>  	}
> 
>  	/* Interrupt */
> -	isp->irq_num = platform_get_irq(pdev, 0);
> -	if (isp->irq_num <= 0) {
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret <= 0) {

Looking at platform_get_irq() all error values are negative. You could just 
test for ret < 0 here, and remove the ret = -ENODEV assignment below to keep 
the error code returned by platform_get_irq().

If you're fine with that modification there's no need to resubmit, just let me 
know and I'll fix it when applying it to my tree.

>  		dev_err(isp->dev, "No IRQ resource\n");
>  		ret = -ENODEV;
>  		goto error_iommu;
>  	}
> +	isp->irq_num = ret;
> 
>  	if (devm_request_irq(isp->dev, isp->irq_num, isp_isr, IRQF_SHARED,
>  			     "OMAP3 ISP", isp)) {

-- 
Regards,

Laurent Pinchart

