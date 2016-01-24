Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33603 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbcAYGVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 01:21:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH] V4L: fix ov9650 control clusters
Date: Sun, 24 Jan 2016 23:14:40 +0200
Message-ID: <161527698.XeG1cnYavA@avalon>
In-Reply-To: <Pine.LNX.4.64.1601191211300.15265@axis700.grange>
References: <Pine.LNX.4.64.1601191211300.15265@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Tuesday 19 January 2016 12:12:48 Guennadi Liakhovetski wrote:
> Auto-gain and auto-exposure clusters in the ov9650 driver have both a
> size of 2, not 3 controls. Fix this.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I'd change the subject to "v4l: ov9650: Fix control clusters" though.

> ---
>  drivers/media/i2c/ov9650.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 9fe9006..2baa528 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -1046,8 +1046,8 @@ static int ov965x_initialize_controls(struct ov965x
> *ov965x) ctrls->exposure->flags |= V4L2_CTRL_FLAG_VOLATILE;
> 
>  	v4l2_ctrl_auto_cluster(3, &ctrls->auto_wb, 0, false);
> -	v4l2_ctrl_auto_cluster(3, &ctrls->auto_gain, 0, true);
> -	v4l2_ctrl_auto_cluster(3, &ctrls->auto_exp, 1, true);
> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_gain, 0, true);
> +	v4l2_ctrl_auto_cluster(2, &ctrls->auto_exp, 1, true);
>  	v4l2_ctrl_cluster(2, &ctrls->hflip);
> 
>  	ov965x->sd.ctrl_handler = hdl;

-- 
Regards,

Laurent Pinchart

