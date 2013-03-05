Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEKSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 05:18:09 -0500
Date: Tue, 5 Mar 2013 11:18:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [REVIEW PATCH V4 07/12] [media] marvell-ccic: switch to resource
 managed allocation and request
In-Reply-To: <1360238687-15768-8-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1303051115560.25837@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-8-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yet one more nitpick

On Thu, 7 Feb 2013, Albert Wang wrote:

> This patch switchs to resource managed allocation and request in mmp-driver.
> It can remove free resource operations.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/platform/marvell-ccic/mmp-driver.c |   65 ++++++++--------------
>  1 file changed, 22 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
> index 818abf3..d355840 100755
> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c

[snip]

> @@ -374,14 +373,12 @@ static int mmpcam_probe(struct platform_device *pdev)
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (res == NULL) {
>  		dev_err(&pdev->dev, "no iomem resource!\n");
> -		ret = -ENODEV;
> -		goto out_free;
> +		return -ENODEV;
>  	}
> -	mcam->regs = ioremap(res->start, resource_size(res));
> +	mcam->regs = devm_request_and_ioremap(&pdev->dev, res);

Don't kill me, but they've recently invented devm_ioremap_resource(), 
which is essentially the same as devm_request_and_ioremap(), but also 
returns an error code and prints an error message, so, you wouldn't have 
to invent -ENODEV yourself and you don't need the dev_err() below.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
