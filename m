Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:55219 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaK0UDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 15:03:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Takanari Hayama <taki@igel.co.jp>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: vsp1: Always enable virtual RPF when BRU is in use
Date: Thu, 27 Nov 2014 22:03:41 +0200
Message-ID: <6244918.ULpQcsacKi@avalon>
In-Reply-To: <1417051502-30169-3-git-send-email-taki@igel.co.jp>
References: <1417051502-30169-1-git-send-email-taki@igel.co.jp> <1417051502-30169-3-git-send-email-taki@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hayama-san,

Thank you for the patch.

On Thursday 27 November 2014 10:25:02 Takanari Hayama wrote:
> Regardless of a number of inputs, we should always enable virtual RPF
> when BRU is used. This allows the case when there's only one input to
> BRU, and a size of the input is smaller than a size of an output of BRU.
> 
> Signed-off-by: Takanari Hayama <taki@igel.co.jp>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patch to my tree. I'll wait for your reply regarding my 
comments to the first patch and will then send a pull request for both.

> ---
>  drivers/media/platform/vsp1/vsp1_wpf.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index 6e05776..cb17c4d 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -92,19 +92,20 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int
> enable) return 0;
>  	}
> 
> -	/* Sources. If the pipeline has a single input configure it as the
> -	 * master layer. Otherwise configure all inputs as sub-layers and
> -	 * select the virtual RPF as the master layer.
> +	/* Sources. If the pipeline has a single input and BRU is not used,
> +	 * configure it as the master layer. Otherwise configure all
> +	 * inputs as sub-layers and select the virtual RPF as the master
> +	 * layer.
>  	 */
>  	for (i = 0; i < pipe->num_inputs; ++i) {
>  		struct vsp1_rwpf *input = pipe->inputs[i];
> 
> -		srcrpf |= pipe->num_inputs == 1
> +		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
>  			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
> 
>  			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
> 
>  	}
> 
> -	if (pipe->num_inputs > 1)
> +	if (pipe->bru || pipe->num_inputs > 1)
>  		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
> 
>  	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);

-- 
Regards,

Laurent Pinchart

