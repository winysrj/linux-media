Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45272 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbbKIVRu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 16:17:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 25/38] staging: media: davinci_vpfe: fix ipipe_mode type
Date: Mon, 09 Nov 2015 23:18 +0200
Message-ID: <2336989.CDC8Z195j7@avalon>
In-Reply-To: <1442842450-29769-26-git-send-email-a.hajda@samsung.com>
References: <1442842450-29769-1-git-send-email-a.hajda@samsung.com> <1442842450-29769-26-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for the patch.

On Monday 21 September 2015 15:33:57 Andrzej Hajda wrote:
> The variable can take negative values.
> 
> The problem has been detected using proposed semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci [1].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2038576
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c index
> 2a3a56b..b1d5e23 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
> @@ -254,7 +254,7 @@ int config_ipipe_hw(struct vpfe_ipipe_device *ipipe)
>  	void __iomem *ipipe_base = ipipe->base_addr;
>  	struct v4l2_mbus_framefmt *outformat;
>  	u32 color_pat;
> -	u32 ipipe_mode;
> +	int ipipe_mode;
>  	u32 data_path;
> 
>  	/* enable clock to IPIPE */

-- 
Regards,

Laurent Pinchart

