Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33812 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbbFNKkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 06:40:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 1/1] omap3isp: Fix sub-device power management code
Date: Sun, 14 Jun 2015 13:40:53 +0300
Message-ID: <3552429.2UzJNcXoTA@avalon>
In-Reply-To: <1434150390-25898-1-git-send-email-sakari.ailus@iki.fi>
References: <1434096127.3f3fQLryEJ@avalon> <1434150390-25898-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 13 June 2015 02:06:23 Sakari Ailus wrote:
> Commit 813f5c0ac5cc ("media: Change media device link_notify behaviour")
> modified the media controller link setup notification API and updated the
> OMAP3 ISP driver accordingly. As a side effect it introduced a bug by
> turning power on after setting the link instead of before. This results in
> sub-devices not being powered down in some cases when they should be. Fix
> it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Fixes: 813f5c0ac5cc [media] media: Change media device link_notify behaviour
> Cc: stable@vger.kernel.org # since v3.10

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Applied to my tree, and pull request sent.

> ---
> Hi Laurent,
> 
> I amended the commit message a bit. Let me know if you're ok with it.
> 
>  drivers/media/platform/omap3isp/isp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 6bcab28..ce0556c 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -829,14 +829,14 @@ static int isp_pipeline_link_notify(struct media_link
> *link, u32 flags, int ret;
> 
>  	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> -	    !(link->flags & MEDIA_LNK_FL_ENABLED)) {
> +	    !(flags & MEDIA_LNK_FL_ENABLED)) {
>  		/* Powering off entities is assumed to never fail. */
>  		isp_pipeline_pm_power(source, -sink_use);
>  		isp_pipeline_pm_power(sink, -source_use);
>  		return 0;
>  	}
> 
> -	if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
> +	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
>  		(flags & MEDIA_LNK_FL_ENABLED)) {
> 
>  		ret = isp_pipeline_pm_power(source, sink_use);

-- 
Regards,

Laurent Pinchart
