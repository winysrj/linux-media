Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36405 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbcE0RVZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 13:21:25 -0400
Received: by mail-wm0-f68.google.com with SMTP id q62so245905wmg.3
        for <linux-media@vger.kernel.org>; Fri, 27 May 2016 10:21:24 -0700 (PDT)
Subject: Re: [PATCH 1/4] fcp: Extend FCP compatible list to support the FDP
To: laurent.pinchart@ideasonboard.com,
	linux-renesas-soc@vger.kernel.org
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
 <1464369565-12259-2-git-send-email-kieran@bingham.xyz>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <57488212.2060704@bingham.xyz>
Date: Fri, 27 May 2016 18:21:22 +0100
MIME-Version: 1.0
In-Reply-To: <1464369565-12259-2-git-send-email-kieran@bingham.xyz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My apologies - I had a stale file in my patches folder :(
This one had the wrong commit-shortlog, please ignore.

--
Kieran

On 27/05/16 18:19, Kieran Bingham wrote:
> The FCP must be powered up for the FDP1 to function, even when the FDP1
> does not make use of the FCNL features. Extend the compatible list
> to allow us to use the power domain and runtime-pm support.
> 
> Signed-off-by: Kieran Bingham <kieran@bingham.xyz>
> ---
>  drivers/media/platform/rcar-fcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
> index 6a7bcc3028b1..0ff6b1edf1db 100644
> --- a/drivers/media/platform/rcar-fcp.c
> +++ b/drivers/media/platform/rcar-fcp.c
> @@ -160,6 +160,7 @@ static int rcar_fcp_remove(struct platform_device *pdev)
>  
>  static const struct of_device_id rcar_fcp_of_match[] = {
>  	{ .compatible = "renesas,fcpv" },
> +	{ .compatible = "renesas,fcpf" },
>  	{ },
>  };
>  
> 

-- 
Regards

Kieran Bingham
