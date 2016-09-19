Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:54141
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbcISRzt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 13:55:49 -0400
Date: Mon, 19 Sep 2016 14:55:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 06/13] v4l: vsp1: Disable cropping on WPF sink pad
Message-ID: <20160919145543.6fbdeadb@vento.lan>
In-Reply-To: <1473808626-19488-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
        <1473808626-19488-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Sep 2016 02:16:59 +0300
Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:

> Cropping on the WPF sink pad restricts the left and top coordinates to
> 0-255. The same result can be obtained by cropping on the RPF without
> any such restriction, this feature isn't useful. Disable it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_rwpf.c | 37 +++++++++++++++++----------------
>  drivers/media/platform/vsp1/vsp1_wpf.c  | 18 +++++++---------
>  2 files changed, 26 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
> index 8cb87e96b78b..a3ace8df7f4d 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -66,7 +66,6 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
>  	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
>  	struct v4l2_subdev_pad_config *config;
>  	struct v4l2_mbus_framefmt *format;
> -	struct v4l2_rect *crop;
>  	int ret = 0;
>  
>  	mutex_lock(&rwpf->entity.lock);
> @@ -103,12 +102,16 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
>  
>  	fmt->format = *format;
>  
> -	/* Update the sink crop rectangle. */
> -	crop = vsp1_rwpf_get_crop(rwpf, config);
> -	crop->left = 0;
> -	crop->top = 0;
> -	crop->width = fmt->format.width;
> -	crop->height = fmt->format.height;
> +	if (rwpf->entity.type == VSP1_ENTITY_RPF) {
> +		struct v4l2_rect *crop;
> +
> +		/* Update the sink crop rectangle. */
> +		crop = vsp1_rwpf_get_crop(rwpf, config);
> +		crop->left = 0;
> +		crop->top = 0;
> +		crop->width = fmt->format.width;
> +		crop->height = fmt->format.height;
> +	}
>  
>  	/* Propagate the format to the source pad. */
>  	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
> @@ -129,8 +132,10 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
>  	struct v4l2_mbus_framefmt *format;
>  	int ret = 0;
>  
> -	/* Cropping is implemented on the sink pad. */
> -	if (sel->pad != RWPF_PAD_SINK)
> +	/* Cropping is only supported on the RPF and is implemented on the sink
> +	 * pad.
> +	 */

Please read CodingStyle and run checkpatch before sending stuff upstream.

This violates the CodingStyle: it should be, instead:
	/*
	 * foo
	 * bar
	 */

This time, I'll fix it, but next time I might not have enough time, and
need to reject the patch series.

Thanks,
Mauro
