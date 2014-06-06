Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41924 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFFOBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 10:01:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vitaly Osipov <vitaly.osipov@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: omap4iss: copy paste error in iss_get_clocks
Date: Fri, 06 Jun 2014 16:01:53 +0200
Message-ID: <3364146.FdJiqskeeF@avalon>
In-Reply-To: <20140605070748.GA651@witts-MacBook-Pro.local>
References: <20140605070748.GA651@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vitaly,

Thank you for the patch.

On Thursday 05 June 2014 17:07:48 Vitaly Osipov wrote:
> It makes more sense to return PTR_ERR(iss->iss_ctrlclk) here. The
> current code looks like an oversight in pasting the block just above
> this one.
> 
> Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/staging/media/omap4iss/iss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index 2e422dd..4a9e444 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -1029,7 +1029,7 @@ static int iss_get_clocks(struct iss_device *iss)
>  	if (IS_ERR(iss->iss_ctrlclk)) {
>  		dev_err(iss->dev, "Unable to get iss_ctrlclk clock info\n");
>  		iss_put_clocks(iss);
> -		return PTR_ERR(iss->iss_fck);
> +		return PTR_ERR(iss->iss_ctrlclk);
>  	}
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart

