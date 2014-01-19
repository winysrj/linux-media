Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45253 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaASK4y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 05:56:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] omap3isp: preview: Fix the crop margins
Date: Sun, 19 Jan 2014 11:57:36 +0100
Message-ID: <2311228.FujT41VdLF@avalon>
In-Reply-To: <1389987458-7174-1-git-send-email-florian.vaussard@epfl.ch>
References: <1389987458-7174-1-git-send-email-florian.vaussard@epfl.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

Thank you for the patch.

On Friday 17 January 2014 20:37:38 Florian Vaussard wrote:
> Commit 3fdfedaaa "[media] omap3isp: preview: Lower the crop margins"
> accidentally changed the previewer's cropping, causing the previewer
> to miss four pixels on each line, thus corrupting the final image.
> Restored the removed setting.
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied this to my tree and will send a pull request.

> ---
>  drivers/media/platform/omap3isp/isppreview.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isppreview.c
> b/drivers/media/platform/omap3isp/isppreview.c index cd8831a..e2e4610
> 100644
> --- a/drivers/media/platform/omap3isp/isppreview.c
> +++ b/drivers/media/platform/omap3isp/isppreview.c
> @@ -1079,6 +1079,7 @@ static void preview_config_input_format(struct
> isp_prev_device *prev, */
>  static void preview_config_input_size(struct isp_prev_device *prev, u32
> active) {
> +	const struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
>  	struct isp_device *isp = to_isp_device(prev);
>  	unsigned int sph = prev->crop.left;
>  	unsigned int eph = prev->crop.left + prev->crop.width - 1;
> @@ -1086,6 +1087,14 @@ static void preview_config_input_size(struct
> isp_prev_device *prev, u32 active) unsigned int elv = prev->crop.top +
> prev->crop.height - 1;
>  	u32 features;
> 
> +	if (format->code != V4L2_MBUS_FMT_Y8_1X8 &&
> +	    format->code != V4L2_MBUS_FMT_Y10_1X10) {
> +		sph -= 2;
> +		eph += 2;
> +		slv -= 2;
> +		elv += 2;
> +	}
> +
>  	features = (prev->params.params[0].features & active)
> 
>  		 | (prev->params.params[1].features & ~active);
-- 
Regards,

Laurent Pinchart

