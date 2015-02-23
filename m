Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49259 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbbBWQnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 11:43:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 5/7] v4l2-subdev: add support for the new enum_frame_size 'which' field.
Date: Mon, 23 Feb 2015 18:44:39 +0200
Message-ID: <1477074.hT2BHRMHFc@avalon>
In-Reply-To: <1423827006-32878-6-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 13 February 2015 12:30:04 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Support the new 'which' field in the enum_frame_size ops. Most drivers do
> not need to be changed since they always returns the same enumeration
> regardless of the 'which' field.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

For everything except s5c73m3, 

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Please see below for a small note.

> ---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 23 +++++++++++++++----
>  drivers/media/platform/omap3isp/ispccdc.c          |  4 ++--
>  drivers/media/platform/omap3isp/ispccp2.c          |  4 ++--
>  drivers/media/platform/omap3isp/ispcsi2.c          |  4 ++--
>  drivers/media/platform/omap3isp/isppreview.c       |  4 ++--
>  drivers/media/platform/omap3isp/ispresizer.c       |  4 ++--
>  drivers/media/platform/vsp1/vsp1_hsit.c            |  4 +++-
>  drivers/media/platform/vsp1/vsp1_lif.c             |  4 +++-
>  drivers/media/platform/vsp1/vsp1_lut.c             |  4 +++-
>  drivers/media/platform/vsp1/vsp1_rwpf.c            |  3 ++-
>  drivers/media/platform/vsp1/vsp1_sru.c             |  4 +++-
>  drivers/media/platform/vsp1/vsp1_uds.c             |  4 +++-
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  6 ++----
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  6 ++----
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    |  4 ++--
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 ++----
>  drivers/staging/media/omap4iss/iss_csi2.c          |  4 ++--
>  drivers/staging/media/omap4iss/iss_ipipe.c         |  4 ++--
>  drivers/staging/media/omap4iss/iss_ipipeif.c       |  6 ++----
>  drivers/staging/media/omap4iss/iss_resizer.c       |  6 ++----
>  20 files changed, 62 insertions(+), 46 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c
> b/drivers/media/platform/vsp1/vsp1_hsit.c index d226b3f..8ffb817 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> @@ -76,9 +76,11 @@ static int hsit_enum_frame_size(struct v4l2_subdev
> *subdev, struct v4l2_subdev_pad_config *cfg,
>  				struct v4l2_subdev_frame_size_enum *fse)
>  {
> +	struct vsp1_hsit *hsit = to_hsit(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
> +	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, fse->pad,
> +					    fse->which);

You could also have used to_vsp1_entity(subdev) to cast to an entity pointer 
directly, but both are fine with me. Same comment for the rest of the driver.

> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c
> b/drivers/media/platform/vsp1/vsp1_lif.c index 60f1bd8..39fa5ef 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -109,9 +109,11 @@ static int lif_enum_frame_size(struct v4l2_subdev
> *subdev, struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_frame_size_enum *fse)
>  {
> +	struct vsp1_lif *lif = to_lif(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, LIF_PAD_SINK);
> +	format = vsp1_entity_get_pad_format(&lif->entity, cfg, LIF_PAD_SINK,
> +					    fse->which);
> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c
> b/drivers/media/platform/vsp1/vsp1_lut.c index 8aa8c11..656ec27 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -117,9 +117,11 @@ static int lut_enum_frame_size(struct v4l2_subdev
> *subdev, struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_frame_size_enum *fse)
>  {
> +	struct vsp1_lut *lut = to_lut(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
> +	format = vsp1_entity_get_pad_format(&lut->entity, cfg,
> +					    fse->pad, fse->which);
> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c
> b/drivers/media/platform/vsp1/vsp1_rwpf.c index a083d85..fa71f46 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> @@ -48,7 +48,8 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
>  	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
> +	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, fse->pad,
> +					    fse->which);
> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index 554340d..6310aca 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -200,9 +200,11 @@ static int sru_enum_frame_size(struct v4l2_subdev
> *subdev, struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_frame_size_enum *fse)
>  {
> +	struct vsp1_sru *sru = to_sru(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, SRU_PAD_SINK);
> +	format = vsp1_entity_get_pad_format(&sru->entity, cfg,
> +					    SRU_PAD_SINK, fse->which);
> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index ef4d307..ccc8243 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -204,9 +204,11 @@ static int uds_enum_frame_size(struct v4l2_subdev
> *subdev, struct v4l2_subdev_pad_config *cfg,
>  			       struct v4l2_subdev_frame_size_enum *fse)
>  {
> +	struct vsp1_uds *uds = to_uds(subdev);
>  	struct v4l2_mbus_framefmt *format;
> 
> -	format = v4l2_subdev_get_try_format(subdev, cfg, UDS_PAD_SINK);
> +	format = vsp1_entity_get_pad_format(&uds->entity, cfg,
> +					    UDS_PAD_SINK, fse->which);
> 
>  	if (fse->index || fse->code != format->code)
>  		return -EINVAL;

-- 
Regards,

Laurent Pinchart

