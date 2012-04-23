Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37492 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753640Ab2DWWBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 18:01:51 -0400
Message-ID: <4F95D14C.4020801@iki.fi>
Date: Tue, 24 Apr 2012 01:01:48 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: aptina-pll: Round up minimum multiplier factor value
 properly
References: <1335189565-23617-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335189565-23617-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> The mf_low value must be a multiple of mf_inc. Round it up to the
> nearest mf_inc multiple after computing it.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

> ---
>   drivers/media/video/aptina-pll.c |    5 ++---
>   1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/video/aptina-pll.c b/drivers/media/video/aptina-pll.c
> index 0bd3813..8153a44 100644
> --- a/drivers/media/video/aptina-pll.c
> +++ b/drivers/media/video/aptina-pll.c
> @@ -148,9 +148,8 @@ int aptina_pll_calculate(struct device *dev,
>   		unsigned int mf_high;
>   		unsigned int mf_low;
>
> -		mf_low = max(roundup(mf_min, mf_inc),
> -			     DIV_ROUND_UP(pll->ext_clock * p1,
> -			       limits->int_clock_max * div));
> +		mf_low = roundup(max(mf_min, DIV_ROUND_UP(pll->ext_clock * p1,
> +					limits->int_clock_max * div)), mf_inc);
>   		mf_high = min(mf_max, pll->ext_clock * p1 /
>   			      (limits->int_clock_min * div));
>


-- 
Sakari Ailus
sakari.ailus@iki.fi
