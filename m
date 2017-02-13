Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47513 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752142AbdBMTRH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:17:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Subject: Re: [PATCH 1/4] v4l: vsp1: Implement partition algorithm restrictions
Date: Mon, 13 Feb 2017 21:17:31 +0200
Message-ID: <5340678.0Q7rhtLIcs@avalon>
In-Reply-To: <1478283570-19688-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1478283570-19688-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

(CC'ing Morimoto-san)

Thank you for the patch.

On Friday 04 Nov 2016 18:19:27 Kieran Bingham wrote:
> The partition algorithm introduced to support scaling, and rotation on

s/,// if I'm not mistaken.

> Gen3 hardware has some restrictions on pipeline configuration.

Strictly speaking this shouldn't be a limitation of the partition algorithm, 
but a limitation of the Gen3 hardware. The limitations relate to image 
partitioning as partitions are needed when using the UDS or SRU in a pipeline, 
but as far as I understand, that's the whole extent of the relationship 
between the two.

> The UDS must not be connected after the SRU in a pipeline, and whilst an
> SRU can be connected before the UDS, it can only do so in identity mode.

I assume you mean after instead of before.

I've tested the SRU-UDS and UDS-SRU pipelines with all combinations for 
downscaling, identity and upscaling for the UDS and identity and upscaling for 
the UDS. On Gen2 everything works correctly.

On Gen3 the results are as follows:

Testing SRU-UDS scaling 768x576 - 768x576 - 640x480 in RGB24: fail
Testing SRU-UDS scaling 768x576 - 768x576 - 768x576 in RGB24: pass
Testing SRU-UDS scaling 768x576 - 768x576 - 1024x768 in RGB24: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 1280x960 in RGB24: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 1536x1152 in RGB24: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 2048x1536 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 640x480 - 640x480 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 640x480 - 1280x960 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 768x576 - 768x576 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 768x576 - 1536x1152 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 1024x768 - 1024x768 in RGB24: pass
Testing UDS-SRU scaling 768x576 - 1024x768 - 2048x1536 in RGB24: pass
Testing SRU-UDS scaling 768x576 - 768x576 - 640x480 in YUV444M: fail
Testing SRU-UDS scaling 768x576 - 768x576 - 768x576 in YUV444M: pass
Testing SRU-UDS scaling 768x576 - 768x576 - 1024x768 in YUV444M: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 1280x960 in YUV444M: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 1536x1152 in YUV444M: pass
Testing SRU-UDS scaling 768x576 - 1536x1152 - 2048x1536 in YUV444M: hangs
Testing UDS-SRU scaling 768x576 - 640x480 - 640x480 in YUV444M: pass
Testing UDS-SRU scaling 768x576 - 640x480 - 1280x960 in YUV444M: fail
Testing UDS-SRU scaling 768x576 - 768x576 - 768x576 in YUV444M: pass
Testing UDS-SRU scaling 768x576 - 768x576 - 1536x1152 in YUV444M: pass
Testing UDS-SRU scaling 768x576 - 1024x768 - 1024x768 in YUV444M: pass
Testing UDS-SRU scaling 768x576 - 1024x768 - 2048x1536 in YUV444M: hangs

Two of the tests hang the VSP completely, for a reason I don't understand yet. 
Among the three tests that fail, the "UDS-SRU scaling 768x576 - 640x480 - 
1280x960 in YUV444M" tests is a false positives due to differences in scaling 
algorithms between the VSP and gen-image.

The only two tests that really fail are thus "SRU-UDS scaling 768x576 - 
768x576 - 640x480" in RGB24 and YUV444M.

The "20151116_VSP-IMG_Image_Partition_Information.pptx" document mentions the 
following restrictions:

- double-scaled super resolution and UDS cannot be used at same time.
- UDS cannot be connected after SRU.

However, from the above tests it looks like the hardware can live with more 
relaxed restrictions than the ones implemented here. I haven't tested all UDS 
scaling ratios, and certainly not under all memory bus load conditions, I 
might thus be too optimistic. Morimoto-san, would it be possible to get more 
information about this from the hardware team, to check whether the above two 
restrictions need to be honoured, or whether they come from an older hardware 
version ?

> On Gen3 hardware, the use of an SRU will always engage the partition
> algorithm, therefore we must always ensure the restrictions are met on
> Gen3 hardware utilising an SRU in the pipeline.
> 
> A pipeline with an SRU connected after the UDS will disable any scaling
> features of the SRU.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_sru.c   |  7 +++++--
>  drivers/media/platform/vsp1/vsp1_sru.h   |  1 +
>  drivers/media/platform/vsp1/vsp1_video.c | 29 ++++++++++++++++++++++++++++-
> 3 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index b4e568a3b4ed..42a3ed6d9461
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -152,7 +152,8 @@ static int sru_enum_frame_size(struct v4l2_subdev
> *subdev, fse->min_width = format->width;
>  		fse->min_height = format->height;
>  		if (format->width <= SRU_MAX_SIZE / 2 &&
> -		    format->height <= SRU_MAX_SIZE / 2) {
> +		    format->height <= SRU_MAX_SIZE / 2 &&
> +		    sru->force_identity_mode == false) {

This won't work, as force_identity_mode is set when starting the pipeline, 
while sru_enum_frame_size() and sru_try_format() are called before, when 
configuring the pipeline. I see no other option than failing pipeline 
validation instead of trying to report the problem to the user when setting 
formats (but feel free to prove me wrong).

>  			fse->max_width = format->width * 2;
>  			fse->max_height = format->height * 2;
>  		} else {
> @@ -203,7 +204,8 @@ static void sru_try_format(struct vsp1_sru *sru,
> 
>  		if (fmt->width <= SRU_MAX_SIZE / 2 &&
>  		    fmt->height <= SRU_MAX_SIZE / 2 &&
> -		    output_area > input_area * 9 / 4) {
> +		    output_area > input_area * 9 / 4 &&
> +		    sru->force_identity_mode == false) {
>  			fmt->width = format->width * 2;
>  			fmt->height = format->height * 2;
>  		} else {
> @@ -355,6 +357,7 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device
> *vsp1) v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
> 
>  	sru->intensity = 1;
> +	sru->force_identity_mode = false;
> 
>  	sru->entity.subdev.ctrl_handler = &sru->ctrls;
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.h
> b/drivers/media/platform/vsp1/vsp1_sru.h index 85e241457af2..f8652c04268e
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.h
> +++ b/drivers/media/platform/vsp1/vsp1_sru.h
> @@ -30,6 +30,7 @@ struct vsp1_sru {
>  	struct v4l2_ctrl_handler ctrls;
> 
>  	unsigned int intensity;
> +	bool force_identity_mode;
>  };
> 
>  static inline struct vsp1_sru *to_sru(struct v4l2_subdev *subdev)
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index f19d879ce5ee..d1d3413c6fdf
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -35,6 +35,7 @@
>  #include "vsp1_hgt.h"
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
> +#include "vsp1_sru.h"
>  #include "vsp1_uds.h"
>  #include "vsp1_video.h"
> 
> @@ -458,10 +459,12 @@ static int vsp1_video_pipeline_build_branch(struct
> vsp1_pipeline *pipe, struct vsp1_rwpf *input,
>  					    struct vsp1_rwpf *output)
>  {
> +	struct vsp1_device *vsp1 = output->entity.vsp1;
>  	struct media_entity_enum ent_enum;
>  	struct vsp1_entity *entity;
>  	struct media_pad *pad;
>  	bool bru_found = false;
> +	bool sru_found = false;
>  	int ret;
> 
>  	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1-
>media_dev);
> @@ -512,13 +515,37 @@ static int vsp1_video_pipeline_build_branch(struct
> vsp1_pipeline *pipe, goto out;
>  		}
> 
> -		/* UDS can't be chained. */
> +		if (entity->type == VSP1_ENTITY_SRU) {
> +			struct vsp1_sru *sru = to_sru(&entity->subdev);
> +
> +			/*
> +			 * Gen3 partition algorithm restricts SRU double-
scaled
> +			 * resolution if it is connected after a UDS entity
> +			 */
> +			if (vsp1->info->gen == 3 && pipe->uds)
> +				sru->force_identity_mode = true;

force_identity_mode is never reset to false.

> +
> +			sru_found = true;
> +		}
> +
>  		if (entity->type == VSP1_ENTITY_UDS) {
> +			/* UDS can't be chained. */
>  			if (pipe->uds) {
>  				ret = -EPIPE;
>  				goto out;
>  			}
> 
> +			/*
> +			 * On Gen3 hardware using the partition algorithm, the
> +			 * UDS must not be connected after the SRU. Using the
> +			 * SRU on Gen3 will always engage the partition
> +			 * algorithm
> +			 */
> +			if (vsp1->info->gen == 3 && sru_found) {
> +				ret = -EPIPE;
> +				goto out;
> +			}
> +
>  			pipe->uds = entity;
>  			pipe->uds_input = bru_found ? pipe->bru
>  					: &input->entity;

-- 
Regards,

Laurent Pinchart
