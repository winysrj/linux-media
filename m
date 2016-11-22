Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48443 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932814AbcKVTRt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 14:17:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Saatvik Arya <aryasaatvik@gmail.com>
Cc: gregkh@linuxfoundation.org, mchehab@osg.samsung.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: media: davinci_vpfe: dm365_resizer: fixed some spelling mistakes
Date: Tue, 22 Nov 2016 21:18:05 +0200
Message-ID: <5085070.7aCI71b85W@avalon>
In-Reply-To: <20160203022642.GA6944@sinister>
References: <20160203022642.GA6944@sinister>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Saatvik,

Thank you for the patch, and sorry for the late reply.

On Wednesday 03 Feb 2016 07:56:42 Saatvik Arya wrote:
> fixed spelling mistakes which reffered to OUTPUT as OUPUT
> 
> Signed-off-by: Saatvik Arya <aryasaatvik@gmail.com>

I've picked the patch up and applied it to my tree. I will send a pull request 
to get it merged in the mainline kernel in v4.11.

> ---
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 22 +++++++++----------
>  drivers/staging/media/davinci_vpfe/dm365_resizer.h |  2 +-
>  2 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> b/drivers/staging/media/davinci_vpfe/dm365_resizer.c index acb293e..10f51f4
> 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -495,7 +495,7 @@ resizer_configure_in_continious_mode(struct
> vpfe_resizer_device *resizer) int line_len;
>  	int ret;
> 
> -	if (resizer->resizer_a.output != RESIZER_OUPUT_MEMORY) {
> +	if (resizer->resizer_a.output != RESIZER_OUTPUT_MEMORY) {
>  		dev_err(dev, "enable resizer - Resizer-A\n");
>  		return -EINVAL;
>  	}
> @@ -507,7 +507,7 @@ resizer_configure_in_continious_mode(struct
> vpfe_resizer_device *resizer) param->rsz_en[RSZ_B] = DISABLE;
>  	param->oper_mode = RESIZER_MODE_CONTINIOUS;
> 
> -	if (resizer->resizer_b.output == RESIZER_OUPUT_MEMORY) {
> +	if (resizer->resizer_b.output == RESIZER_OUTPUT_MEMORY) {
>  		struct v4l2_mbus_framefmt *outformat2;
> 
>  		param->rsz_en[RSZ_B] = ENABLE;
> @@ -1048,13 +1048,13 @@ static void resizer_ss_isr(struct
> vpfe_resizer_device *resizer) if (ipipeif_sink != IPIPEIF_INPUT_MEMORY)
>  		return;
> 
> -	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
> +	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
>  		val = vpss_dma_complete_interrupt();
>  		if (val != 0 && val != 2)
>  			return;
>  	}
> 
> -	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
> +	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
>  		spin_lock(&video_out->dma_queue_lock);
>  		vpfe_video_process_buffer_complete(video_out);
>  		video_out->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
> @@ -1064,7 +1064,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device
> *resizer)
> 
>  	/* If resizer B is enabled */
>  	if (pipe->output_num > 1 && resizer->resizer_b.output ==
> -	    RESIZER_OUPUT_MEMORY) {
> +	    RESIZER_OUTPUT_MEMORY) {
>  		spin_lock(&video_out->dma_queue_lock);
>  		vpfe_video_process_buffer_complete(video_out2);
>  		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
> @@ -1074,7 +1074,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device
> *resizer)
> 
>  	/* start HW if buffers are queued */
>  	if (vpfe_video_is_pipe_ready(pipe) &&
> -	    resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
> +	    resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
>  		resizer_enable(resizer, 1);
>  		vpfe_ipipe_enable(vpfe_dev, 1);
>  		vpfe_ipipeif_enable(vpfe_dev);
> @@ -1242,8 +1242,8 @@ static int resizer_do_hw_setup(struct
> vpfe_resizer_device *resizer) struct resizer_params *param =
> &resizer->config;
>  	int ret = 0;
> 
> -	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY ||
> -	    resizer->resizer_b.output == RESIZER_OUPUT_MEMORY) {
> +	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY ||
> +	    resizer->resizer_b.output == RESIZER_OUTPUT_MEMORY) {
>  		if (ipipeif_sink == IPIPEIF_INPUT_MEMORY &&
>  		    ipipeif_source == IPIPEIF_OUTPUT_RESIZER)
>  			ret = resizer_configure_in_single_shot_mode(resizer);
> @@ -1268,7 +1268,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd,
> int enable) if (&resizer->crop_resizer.subdev != sd)
>  		return 0;
> 
> -	if (resizer->resizer_a.output != RESIZER_OUPUT_MEMORY)
> +	if (resizer->resizer_a.output != RESIZER_OUTPUT_MEMORY)
>  		return 0;
> 
>  	switch (enable) {
> @@ -1722,7 +1722,7 @@ static int resizer_link_setup(struct media_entity
> *entity, }
>  			if (resizer->resizer_a.output != RESIZER_OUTPUT_NONE)
>  				return -EBUSY;
> -			resizer->resizer_a.output = RESIZER_OUPUT_MEMORY;
> +			resizer->resizer_a.output = RESIZER_OUTPUT_MEMORY;
>  			break;
> 
>  		default:
> @@ -1747,7 +1747,7 @@ static int resizer_link_setup(struct media_entity
> *entity, }
>  			if (resizer->resizer_b.output != RESIZER_OUTPUT_NONE)
>  				return -EBUSY;
> -			resizer->resizer_b.output = RESIZER_OUPUT_MEMORY;
> +			resizer->resizer_b.output = RESIZER_OUTPUT_MEMORY;
>  			break;
> 
>  		default:
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.h
> b/drivers/staging/media/davinci_vpfe/dm365_resizer.h index 93b0f44..00e64b0
> 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.h
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.h
> @@ -210,7 +210,7 @@ enum resizer_input_entity {
> 
>  enum resizer_output_entity {
>  	RESIZER_OUTPUT_NONE = 0,
> -	RESIZER_OUPUT_MEMORY = 1,
> +	RESIZER_OUTPUT_MEMORY = 1,
>  };
> 
>  struct dm365_resizer_device {

-- 
Regards,

Laurent Pinchart

