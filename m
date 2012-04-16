Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34505 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753920Ab2DPRDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 13:03:46 -0400
Message-ID: <4F8C50EE.5020102@iki.fi>
Date: Mon, 16 Apr 2012 20:03:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/9] omap3isp: preview: Optimize parameters setup for
 the common case
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com> <1334582994-6967-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch. Just one more comment.

Laurent Pinchart wrote:
> If no parameter needs to be modified, make preview_config() and
> preview_setup_hw() return immediately. This speeds up interrupt handling
> in the common case.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Acked-by: Sakari Ailus<sakari.ailus@iki.fi>
> ---
>   drivers/media/video/omap3isp/isppreview.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
> index cf5014f..4e803a3 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -890,6 +890,8 @@ static int preview_config(struct isp_prev_device *prev,
>   	int i, bit, rval = 0;
>
>   	params =&prev->params;
> +	if (cfg->update == 0)
> +		return 0;

You could do the check right at the beginning of the function, i.e. 
before settings params. Tiny issue, but it'd look better that way. :-)

>   	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
>   		unsigned long flags;
> @@ -944,6 +946,9 @@ static void preview_setup_hw(struct isp_prev_device *prev)
>   	int i, bit;
>   	void *param_ptr;
>
> +	if (prev->update == 0)
> +		return;
> +
>   	for (i = 0; i<  ARRAY_SIZE(update_attrs); i++) {
>   		attr =&update_attrs[i];
>


-- 
Sakari Ailus
sakari.ailus@iki.fi
