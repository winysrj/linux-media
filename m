Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53433 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbbJ1B7v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 21:59:51 -0400
Date: Wed, 28 Oct 2015 10:59:46 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 16/19] staging: omap4iss: Fix sub-device power
 management code
Message-ID: <20151028105946.2b2288b1@concha.lan>
In-Reply-To: <1445900510-1398-17-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-17-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:47 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> The same bug was present in the omap4iss driver as was in the omap3isp
> driver. The code got copied to the omap4iss driver while broken. Fix the
> omap4iss driver as well.

Looks ok.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/staging/media/omap4iss/iss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index 076ddd4..c097fd5 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -533,14 +533,14 @@ static int iss_pipeline_link_notify(struct media_link *link, u32 flags,
>  	int ret;
>  
>  	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> -	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
> +	    !(flags & MEDIA_LNK_FL_ENABLED)) {
>  		/* Powering off entities is assumed to never fail. */
>  		iss_pipeline_pm_power(source, -sink_use);
>  		iss_pipeline_pm_power(sink, -source_use);
>  		return 0;
>  	}
>  
> -	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
>  		(flags & MEDIA_LNK_FL_ENABLED)) {
>  		ret = iss_pipeline_pm_power(source, sink_use);
>  		if (ret < 0)


-- 

Cheers,
Mauro
