Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39139 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbbEAW64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 18:58:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: omap4iss: Constify platform_device_id
Date: Sat, 02 May 2015 01:59:18 +0300
Message-ID: <5656464.AXyQi80ZiG@avalon>
In-Reply-To: <1430494987-31013-1-git-send-email-k.kozlowski.k@gmail.com>
References: <1430494987-31013-1-git-send-email-k.kozlowski.k@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

Thank you for the patch.

On Saturday 02 May 2015 00:43:07 Krzysztof Kozlowski wrote:
> The platform_device_id is not modified by the driver and core uses it as
> const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I'll send a pull request for v4.2.

> ---
>  drivers/staging/media/omap4iss/iss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index e0ad5e520e2d..68867f286afd
> 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -1478,7 +1478,7 @@ static int iss_remove(struct platform_device *pdev)
>  	return 0;
>  }
> 
> -static struct platform_device_id omap4iss_id_table[] = {
> +static const struct platform_device_id omap4iss_id_table[] = {
>  	{ "omap4iss", 0 },
>  	{ },
>  };

-- 
Regards,

Laurent Pinchart

