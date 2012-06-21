Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760650Ab2FUXSp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 19:18:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: no semicolon after switch
Date: Fri, 22 Jun 2012 01:18:56 +0200
Message-ID: <1845170.Tl4RnTQjcc@avalon>
In-Reply-To: <1340297165-4018-1-git-send-email-pmeerw@pmeerw.net>
References: <1340297165-4018-1-git-send-email-pmeerw@pmeerw.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

Thanks for the patch. I've applied it to my tree.

On Thursday 21 June 2012 18:46:05 Peter Meerwald wrote:
> From: Peter Meerwald <p.meerwald@bct-electronic.com>
> 
> Signed-off-by: Peter Meerwald <pmeerw@pmeerw.net>
> ---
>  drivers/media/video/omap3isp/ispccdc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c index 7e32331..b74f7e9 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -835,7 +835,7 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
> case 13:
>  		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
>  		break;
> -	};
> +	}
> 
>  	if (pipe->input)
>  		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
> @@ -991,7 +991,7 @@ static void ccdc_config_sync_if(struct isp_ccdc_device
> *ccdc, case 12:
>  		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
>  		break;
> -	};
> +	}
> 
>  	if (syncif->fldmode)
>  		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;

-- 
Regards,

Laurent Pinchart

