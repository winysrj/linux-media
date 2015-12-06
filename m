Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56364 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbbLFDK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 22:10:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/5] [media] staging: omap4iss: separate links creation from entities init
Date: Sun, 06 Dec 2015 05:10:42 +0200
Message-ID: <2776235.DqjovJkOTH@avalon>
In-Reply-To: <1441296036-20727-2-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com> <1441296036-20727-2-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Thursday 03 September 2015 18:00:32 Javier Martinez Canillas wrote:
> The omap4iss driver initializes the entities and creates the pads links
> before the entities are registered with the media device. This does not
> work now that object IDs are used to create links so the media_device
> has to be set.
> 
> Split out the pads links creation from the entity initialization so are
> made after the entities registration.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
>  drivers/staging/media/omap4iss/iss.c         | 101 +++++++++++++++---------
>  drivers/staging/media/omap4iss/iss_csi2.c    |  35 +++++++---
>  drivers/staging/media/omap4iss/iss_csi2.h    |   1 +
>  drivers/staging/media/omap4iss/iss_ipipeif.c |  29 ++++----
>  drivers/staging/media/omap4iss/iss_ipipeif.h |   1 +
>  drivers/staging/media/omap4iss/iss_resizer.c |  29 ++++----
>  drivers/staging/media/omap4iss/iss_resizer.h |   1 +
>  7 files changed, 132 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss.c
> b/drivers/staging/media/omap4iss/iss.c index 44b88ff3ba83..076ddd412201
> 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -1272,6 +1272,68 @@ done:
>  	return ret;
>  }
> 
> +/*
> + * iss_create_pads_links() - Pads links creation for the subdevices

Could you please s/pads_links/links/ and s/pads links/links/ ?

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> + * @iss : Pointer to ISS device
> + *
> + * return negative error code or zero on success
> + */
> +static int iss_create_pads_links(struct iss_device *iss)
> +{
> +	int ret;
> +
> +	ret = omap4iss_csi2_create_pads_links(iss);
> +	if (ret < 0) {
> +		dev_err(iss->dev, "CSI2 pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	ret = omap4iss_ipipeif_create_pads_links(iss);
> +	if (ret < 0) {
> +		dev_err(iss->dev, "ISP IPIPEIF pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	ret = omap4iss_resizer_create_pads_links(iss);
> +	if (ret < 0) {
> +		dev_err(iss->dev, "ISP RESIZER pads links creation failed\n");
> +		return ret;
> +	}
> +
> +	/* Connect the submodules. */
> +	ret = media_create_pad_link(
> +			&iss->csi2a.subdev.entity, CSI2_PAD_SOURCE,
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&iss->csi2b.subdev.entity, CSI2_PAD_SOURCE,
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> +			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> +			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = media_create_pad_link(
> +			&iss->ipipe.subdev.entity, IPIPE_PAD_SOURCE_VP,
> +			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +};
> +
>  static void iss_cleanup_modules(struct iss_device *iss)
>  {
>  	omap4iss_csi2_cleanup(iss);
> @@ -1314,41 +1376,8 @@ static int iss_initialize_modules(struct iss_device
> *iss) goto error_resizer;
>  	}
> 
> -	/* Connect the submodules. */
> -	ret = media_create_pad_link(
> -			&iss->csi2a.subdev.entity, CSI2_PAD_SOURCE,
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
> -	ret = media_create_pad_link(
> -			&iss->csi2b.subdev.entity, CSI2_PAD_SOURCE,
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
> -	ret = media_create_pad_link(
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> -			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
> -	ret = media_create_pad_link(
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> -			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
> -	ret = media_create_pad_link(
> -			&iss->ipipe.subdev.entity, IPIPE_PAD_SOURCE_VP,
> -			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
>  	return 0;
> 
> -error_link:
> -	omap4iss_resizer_cleanup(iss);
>  error_resizer:
>  	omap4iss_ipipe_cleanup(iss);
>  error_ipipe:
> @@ -1461,10 +1490,16 @@ static int iss_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		goto error_modules;
> 
> +	ret = iss_create_pads_links(iss);
> +	if (ret < 0)
> +		goto error_entities;
> +
>  	omap4iss_put(iss);
> 
>  	return 0;
> 
> +error_entities:
> +	iss_unregister_entities(iss);
>  error_modules:
>  	iss_cleanup_modules(iss);
>  error_iss:
> diff --git a/drivers/staging/media/omap4iss/iss_csi2.c
> b/drivers/staging/media/omap4iss/iss_csi2.c index
> 50a24e8e8129..907e59edcb04 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.c
> +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> @@ -1295,16 +1295,8 @@ static int csi2_init_entities(struct iss_csi2_device
> *csi2, const char *subname) if (ret < 0)
>  		goto error_video;
> 
> -	/* Connect the CSI2 subdev to the video node. */
> -	ret = media_create_pad_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
> -				       &csi2->video_out.video.entity, 0, 0);
> -	if (ret < 0)
> -		goto error_link;
> -
>  	return 0;
> 
> -error_link:
> -	omap4iss_video_cleanup(&csi2->video_out);
>  error_video:
>  	media_entity_cleanup(&csi2->subdev.entity);
>  	return ret;
> @@ -1347,6 +1339,33 @@ int omap4iss_csi2_init(struct iss_device *iss)
>  }
> 
>  /*
> + * omap4iss_csi2_create_pads_links() - CSI2 pads links creation
> + * @iss: Pointer to ISS device
> + *
> + * return negative error code or zero on success
> + */
> +int omap4iss_csi2_create_pads_links(struct iss_device *iss)
> +{
> +	struct iss_csi2_device *csi2a = &iss->csi2a;
> +	struct iss_csi2_device *csi2b = &iss->csi2b;
> +	int ret;
> +
> +	/* Connect the CSI2a subdev to the video node. */
> +	ret = media_create_pad_link(&csi2a->subdev.entity, CSI2_PAD_SOURCE,
> +				    &csi2a->video_out.video.entity, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Connect the CSI2b subdev to the video node. */
> +	ret = media_create_pad_link(&csi2b->subdev.entity, CSI2_PAD_SOURCE,
> +				    &csi2b->video_out.video.entity, 0, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/*
>   * omap4iss_csi2_cleanup - Routine for module driver cleanup
>   */
>  void omap4iss_csi2_cleanup(struct iss_device *iss)
> diff --git a/drivers/staging/media/omap4iss/iss_csi2.h
> b/drivers/staging/media/omap4iss/iss_csi2.h index
> 3b37978a3bdf..ad9a02d2a576 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.h
> +++ b/drivers/staging/media/omap4iss/iss_csi2.h
> @@ -151,6 +151,7 @@ struct iss_csi2_device {
>  void omap4iss_csi2_isr(struct iss_csi2_device *csi2);
>  int omap4iss_csi2_reset(struct iss_csi2_device *csi2);
>  int omap4iss_csi2_init(struct iss_device *iss);
> +int omap4iss_csi2_create_pads_links(struct iss_device *iss);
>  void omap4iss_csi2_cleanup(struct iss_device *iss);
>  void omap4iss_csi2_unregister_entities(struct iss_csi2_device *csi2);
>  int omap4iss_csi2_register_entities(struct iss_csi2_device *csi2,
> diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c
> b/drivers/staging/media/omap4iss/iss_ipipeif.c index
> e46b2c07bd5d..36a570e60496 100644
> --- a/drivers/staging/media/omap4iss/iss_ipipeif.c
> +++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
> @@ -762,18 +762,7 @@ static int ipipeif_init_entities(struct
> iss_ipipeif_device *ipipeif) ipipeif->video_out.bpl_zero_padding = 1;
>  	ipipeif->video_out.bpl_max = 0x1ffe0;
> 
> -	ret = omap4iss_video_init(&ipipeif->video_out, "ISP IPIPEIF");
> -	if (ret < 0)
> -		return ret;
> -
> -	/* Connect the IPIPEIF subdev to the video node. */
> -	ret = media_create_pad_link(&ipipeif->subdev.entity,
> -				       IPIPEIF_PAD_SOURCE_ISIF_SF,
> -				       &ipipeif->video_out.video.entity, 0, 0);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return omap4iss_video_init(&ipipeif->video_out, "ISP IPIPEIF");
>  }
> 
>  void omap4iss_ipipeif_unregister_entities(struct iss_ipipeif_device
> *ipipeif) @@ -826,6 +815,22 @@ int omap4iss_ipipeif_init(struct iss_device
> *iss) }
> 
>  /*
> + * omap4iss_ipipeif_create_pads_links() - IPIPEIF pads links creation
> + * @iss: Pointer to ISS device
> + *
> + * return negative error code or zero on success
> + */
> +int omap4iss_ipipeif_create_pads_links(struct iss_device *iss)
> +{
> +	struct iss_ipipeif_device *ipipeif = &iss->ipipeif;
> +
> +	/* Connect the IPIPEIF subdev to the video node. */
> +	return media_create_pad_link(&ipipeif->subdev.entity,
> +				     IPIPEIF_PAD_SOURCE_ISIF_SF,
> +				     &ipipeif->video_out.video.entity, 0, 0);
> +}
> +
> +/*
>   * omap4iss_ipipeif_cleanup - IPIPEIF module cleanup.
>   * @iss: Device pointer specific to the OMAP4 ISS.
>   */
> diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.h
> b/drivers/staging/media/omap4iss/iss_ipipeif.h index
> cbdccb982eee..28357a65ae97 100644
> --- a/drivers/staging/media/omap4iss/iss_ipipeif.h
> +++ b/drivers/staging/media/omap4iss/iss_ipipeif.h
> @@ -78,6 +78,7 @@ struct iss_ipipeif_device {
>  struct iss_device;
> 
>  int omap4iss_ipipeif_init(struct iss_device *iss);
> +int omap4iss_ipipeif_create_pads_links(struct iss_device *iss);
>  void omap4iss_ipipeif_cleanup(struct iss_device *iss);
>  int omap4iss_ipipeif_register_entities(struct iss_ipipeif_device *ipipeif,
>  	struct v4l2_device *vdev);
> diff --git a/drivers/staging/media/omap4iss/iss_resizer.c
> b/drivers/staging/media/omap4iss/iss_resizer.c index
> bc5001002cc5..5de093715f98 100644
> --- a/drivers/staging/media/omap4iss/iss_resizer.c
> +++ b/drivers/staging/media/omap4iss/iss_resizer.c
> @@ -806,18 +806,7 @@ static int resizer_init_entities(struct
> iss_resizer_device *resizer) resizer->video_out.bpl_zero_padding = 1;
>  	resizer->video_out.bpl_max = 0x1ffe0;
> 
> -	ret = omap4iss_video_init(&resizer->video_out, "ISP resizer a");
> -	if (ret < 0)
> -		return ret;
> -
> -	/* Connect the RESIZER subdev to the video node. */
> -	ret = media_create_pad_link(&resizer->subdev.entity,
> -				       RESIZER_PAD_SOURCE_MEM,
> -				       &resizer->video_out.video.entity, 0, 0);
> -	if (ret < 0)
> -		return ret;
> -
> -	return 0;
> +	return omap4iss_video_init(&resizer->video_out, "ISP resizer a");
>  }
> 
>  void omap4iss_resizer_unregister_entities(struct iss_resizer_device
> *resizer) @@ -870,6 +859,22 @@ int omap4iss_resizer_init(struct iss_device
> *iss) }
> 
>  /*
> + * omap4iss_resizer_create_pads_links() - RESIZER pads links creation
> + * @iss: Pointer to ISS device
> + *
> + * return negative error code or zero on success
> + */
> +int omap4iss_resizer_create_pads_links(struct iss_device *iss)
> +{
> +	struct iss_resizer_device *resizer = &iss->resizer;
> +
> +	/* Connect the RESIZER subdev to the video node. */
> +	return media_create_pad_link(&resizer->subdev.entity,
> +				     RESIZER_PAD_SOURCE_MEM,
> +				     &resizer->video_out.video.entity, 0, 0);
> +}
> +
> +/*
>   * omap4iss_resizer_cleanup - RESIZER module cleanup.
>   * @iss: Device pointer specific to the OMAP4 ISS.
>   */
> diff --git a/drivers/staging/media/omap4iss/iss_resizer.h
> b/drivers/staging/media/omap4iss/iss_resizer.h index
> 3727498b06a3..00ecc151e511 100644
> --- a/drivers/staging/media/omap4iss/iss_resizer.h
> +++ b/drivers/staging/media/omap4iss/iss_resizer.h
> @@ -61,6 +61,7 @@ struct iss_resizer_device {
>  struct iss_device;
> 
>  int omap4iss_resizer_init(struct iss_device *iss);
> +int omap4iss_resizer_create_pads_links(struct iss_device *iss);
>  void omap4iss_resizer_cleanup(struct iss_device *iss);
>  int omap4iss_resizer_register_entities(struct iss_resizer_device *resizer,
>  	struct v4l2_device *vdev);

-- 
Regards,

Laurent Pinchart

