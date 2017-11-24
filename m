Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46013 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdKXSlB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Nov 2017 13:41:01 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH] v4l: vsp1: Fix function declaration/definition mismatch
To: Eugeniu Rosca <roscaeugeniu@gmail.com>,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Eugeniu Rosca <erosca@de.adit-jv.com>
References: <20170820124006.4256-1-rosca.eugeniu@gmail.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <85aabc6e-b332-1f9e-3fbf-87f0d7bcf9f3@ideasonboard.com>
Date: Fri, 24 Nov 2017 18:40:57 +0000
MIME-Version: 1.0
In-Reply-To: <20170820124006.4256-1-rosca.eugeniu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eugeniu,

Thankyou for the patch,

Laurent - Any comments on this? Otherwise I'll bundle this in with my
suspend/resume patch for a pull request.

On 20/08/17 13:40, Eugeniu Rosca wrote:
> From: Eugeniu Rosca <erosca@de.adit-jv.com>
> 
> Cppcheck v1.81 complains that the parameter names of certain vsp1
> functions don't match between declaration and definition. Fix this.
> No functional change is confirmed by the empty delta between the
> disassembled object files before and after the change.
> 
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_entity.h | 5 +++--
>  drivers/media/platform/vsp1/vsp1_hgo.h    | 2 +-
>  drivers/media/platform/vsp1/vsp1_hgt.h    | 2 +-
>  drivers/media/platform/vsp1/vsp1_uds.h    | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index c169a060b6d2..1087d7e5c126 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -161,7 +161,8 @@ int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
>  int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
>  				struct v4l2_subdev_pad_config *cfg,
>  				struct v4l2_subdev_frame_size_enum *fse,
> -				unsigned int min_w, unsigned int min_h,
> -				unsigned int max_w, unsigned int max_h);
> +				unsigned int min_width, unsigned int min_height,
> +				unsigned int max_width,
> +				unsigned int max_height);

This is fine.

>  
>  #endif /* __VSP1_ENTITY_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_hgo.h b/drivers/media/platform/vsp1/vsp1_hgo.h
> index c6c0b7a80e0c..76a9cf97b9d3 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgo.h
> +++ b/drivers/media/platform/vsp1/vsp1_hgo.h
> @@ -40,6 +40,6 @@ static inline struct vsp1_hgo *to_hgo(struct v4l2_subdev *subdev)
>  }
>  
>  struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1);
> -void vsp1_hgo_frame_end(struct vsp1_entity *hgo);
> +void vsp1_hgo_frame_end(struct vsp1_entity *entity);

I was going to say: We know the object is an entity by it's type. Isn't hgo more
descriptive for it's name ?

However to answer my own question - The implementation function goes on to
define a struct vsp1_hgo *hgo, so no ... the Entity object shouldn't be hgo.

So this looks reasonable to me, and the same logic applies to the other instances.



>  
>  #endif /* __VSP1_HGO_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.h b/drivers/media/platform/vsp1/vsp1_hgt.h
> index 83f2e130942a..37139d54b6c8 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgt.h
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.h
> @@ -37,6 +37,6 @@ static inline struct vsp1_hgt *to_hgt(struct v4l2_subdev *subdev)
>  }
>  
>  struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1);
> -void vsp1_hgt_frame_end(struct vsp1_entity *hgt);
> +void vsp1_hgt_frame_end(struct vsp1_entity *entity);
>  
>  #endif /* __VSP1_HGT_H__ */
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
> index 7bf3cdcffc65..9c7f8497b5da 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.h
> +++ b/drivers/media/platform/vsp1/vsp1_uds.h
> @@ -35,7 +35,7 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
>  
>  struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
>  
> -void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_list *dl,
> +void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_list *dl,
>  			unsigned int alpha);
>  
>  #endif /* __VSP1_UDS_H__ */
> 
