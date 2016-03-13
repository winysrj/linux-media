Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53494 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbcCMLu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 07:50:27 -0400
Date: Sun, 13 Mar 2016 08:50:14 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: kyungmin.park@samsung.com, a.hajda@samsung.com,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com, kgene@kernel.org,
	k.kozlowski@samsung.com, laurent.pinchart@ideasonboard.com,
	hyun.kwon@xilinx.com, soren.brinkmann@xilinx.com,
	gregkh@linuxfoundation.org, perex@perex.cz, tiwai@suse.com,
	hans.verkuil@cisco.com, lixiubo@cmss.chinamobile.com,
	javier@osg.samsung.com, g.liakhovetski@gmx.de,
	chehabrafael@gmail.com, crope@iki.fi, tommi.franttila@intel.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	hamohammed.sa@gmail.com, der.herr@hofr.at, navyasri.tech@gmail.com,
	Julia.Lawall@lip6.fr, amitoj1606@gmail.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org,
	alsa-devel@alsa-project.org
Subject: Re: [PATCH] media: add GFP flag to media_*() that could get called
 in atomic context
Message-ID: <20160313085014.1383b355@recife.lan>
In-Reply-To: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
References: <1457833689-4926-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Mar 2016 18:48:09 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add GFP flags to media_create_pad_link(), media_create_intf_link(),
> media_devnode_create(), and media_add_link() that could get called
> in atomic context to allow callers to pass in the right flags for
> memory allocation.
> 
> tree-wide driver changes for media_*() GFP flags change:
> Change drivers to add gfpflags to interffaces, media_create_pad_link(),
> media_create_intf_link() and media_devnode_create().
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Patches look OK to me[1], provided that a followup patch is
changes some of the callers to use GFP_ATOMIC.

I'll wait for such patch before merging this one.

Regards,
Mauro

[1] but see Nicholas comments about indentation.

> ---
> Ran through kbuild-all compile testing.
> Tested the changes in Win-TV HVR-950Q device
> 
>  drivers/media/dvb-core/dvbdev.c                    | 26 +++++++-----
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |  6 ++-
>  drivers/media/i2c/s5k5baf.c                        |  3 +-
>  drivers/media/i2c/smiapp/smiapp-core.c             |  3 +-
>  drivers/media/i2c/tvp5150.c                        |  3 +-
>  drivers/media/media-entity.c                       | 30 ++++++++------
>  drivers/media/platform/exynos4-is/media-dev.c      | 19 +++++----
>  drivers/media/platform/omap3isp/isp.c              | 47 ++++++++++++++--------
>  drivers/media/platform/s3c-camif/camif-core.c      |  4 +-
>  drivers/media/platform/vsp1/vsp1_drm.c             |  6 +--
>  drivers/media/platform/vsp1/vsp1_drv.c             |  9 +++--
>  drivers/media/platform/xilinx/xilinx-vipp.c        |  4 +-
>  drivers/media/usb/au0828/au0828-core.c             |  3 +-
>  drivers/media/usb/uvc/uvc_entity.c                 |  2 +-
>  drivers/media/v4l2-core/v4l2-dev.c                 |  5 ++-
>  drivers/media/v4l2-core/v4l2-device.c              |  3 +-
>  drivers/media/v4l2-core/v4l2-mc.c                  | 25 +++++++-----
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  3 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    |  2 +-
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 10 +++--
>  .../staging/media/davinci_vpfe/vpfe_mc_capture.c   | 10 ++---
>  drivers/staging/media/omap4iss/iss.c               | 17 +++++---
>  drivers/staging/media/omap4iss/iss_csi2.c          |  6 ++-
>  drivers/staging/media/omap4iss/iss_ipipeif.c       |  3 +-
>  drivers/staging/media/omap4iss/iss_resizer.c       |  3 +-
>  include/media/media-entity.h                       |  9 +++--
>  sound/usb/media.c                                  | 15 ++++---
>  27 files changed, 170 insertions(+), 106 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index e1684c5..57f3e1e 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -399,7 +399,8 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
>  
>  	dvbdev->intf_devnode = media_devnode_create(dvbdev->adapter->mdev,
>  						    intf_type, 0,
> -						    DVB_MAJOR, minor);
> +						    DVB_MAJOR, minor,
> +						    GFP_KERNEL);
>  
>  	if (!dvbdev->intf_devnode)
>  		return -ENOMEM;
> @@ -416,7 +417,7 @@ static int dvb_register_media_device(struct dvb_device *dvbdev,
>  		return 0;
>  
>  	link = media_create_intf_link(dvbdev->entity, &dvbdev->intf_devnode->intf,
> -				      MEDIA_LNK_FL_ENABLED);
> +				      MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  	if (!link)
>  		return -ENOMEM;
>  #endif
> @@ -558,7 +559,8 @@ static int dvb_create_io_intf_links(struct dvb_adapter *adap,
>  			if (strncmp(entity->name, name, strlen(name)))
>  				continue;
>  			link = media_create_intf_link(entity, intf,
> -						      MEDIA_LNK_FL_ENABLED);
> +						      MEDIA_LNK_FL_ENABLED,
> +						      GFP_KERNEL);
>  			if (!link)
>  				return -ENOMEM;
>  		}
> @@ -680,7 +682,8 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>  	}
>  	if (demux && ca) {
>  		ret = media_create_pad_link(demux, 1, ca,
> -					    0, MEDIA_LNK_FL_ENABLED);
> +					    0, MEDIA_LNK_FL_ENABLED,
> +					    GFP_KERNEL);
>  		if (ret)
>  			return -ENOMEM;
>  	}
> @@ -693,7 +696,8 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>  				    strlen(DVR_TSOUT))) {
>  					ret = media_create_pad_link(demux,
>  								++dvr_pad,
> -							    entity, 0, 0);
> +							    entity, 0, 0,
> +								GFP_KERNEL);
>  					if (ret)
>  						return ret;
>  				}
> @@ -701,7 +705,8 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>  				    strlen(DEMUX_TSOUT))) {
>  					ret = media_create_pad_link(demux,
>  							      ++demux_pad,
> -							    entity, 0, 0);
> +							    entity, 0, 0,
> +								GFP_KERNEL);
>  					if (ret)
>  						return ret;
>  				}
> @@ -713,14 +718,16 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>  	media_device_for_each_intf(intf, mdev) {
>  		if (intf->type == MEDIA_INTF_T_DVB_CA && ca) {
>  			link = media_create_intf_link(ca, intf,
> -						      MEDIA_LNK_FL_ENABLED);
> +						      MEDIA_LNK_FL_ENABLED,
> +						      GFP_KERNEL);
>  			if (!link)
>  				return -ENOMEM;
>  		}
>  
>  		if (intf->type == MEDIA_INTF_T_DVB_FE && tuner) {
>  			link = media_create_intf_link(tuner, intf,
> -						      MEDIA_LNK_FL_ENABLED);
> +						      MEDIA_LNK_FL_ENABLED,
> +						      GFP_KERNEL);
>  			if (!link)
>  				return -ENOMEM;
>  		}
> @@ -732,7 +739,8 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
>  		 */
>  		if (intf->type == MEDIA_INTF_T_DVB_DVR && demux) {
>  			link = media_create_intf_link(demux, intf,
> -						      MEDIA_LNK_FL_ENABLED);
> +						      MEDIA_LNK_FL_ENABLED,
> +						      GFP_KERNEL);
>  			if (!link)
>  				return -ENOMEM;
>  		}
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index 08af58f..dd994f1 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1484,11 +1484,13 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
>  
>  	ret = media_create_pad_link(&state->sensor_sd.entity,
>  			S5C73M3_ISP_PAD, &state->oif_sd.entity, OIF_ISP_PAD,
> -			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
> +			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED,
> +			GFP_KERNEL);
>  
>  	ret = media_create_pad_link(&state->sensor_sd.entity,
>  			S5C73M3_JPEG_PAD, &state->oif_sd.entity, OIF_JPEG_PAD,
> -			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
> +			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED,
> +			GFP_KERNEL);
>  
>  	return ret;
>  }
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index db82ed0..3692bec 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -1759,7 +1759,8 @@ static int s5k5baf_registered(struct v4l2_subdev *sd)
>  		ret = media_create_pad_link(&state->cis_sd.entity, PAD_CIS,
>  					       &state->sd.entity, PAD_CIS,
>  					       MEDIA_LNK_FL_IMMUTABLE |
> -					       MEDIA_LNK_FL_ENABLED);
> +					       MEDIA_LNK_FL_ENABLED,
> +					       GFP_KERNEL);
>  	return ret;
>  }
>  
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index a215efe..8c2e9ad 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2508,7 +2508,8 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
>  					     &last->sd.entity,
>  					     last->sink_pad,
>  					     MEDIA_LNK_FL_ENABLED |
> -					     MEDIA_LNK_FL_IMMUTABLE);
> +					     MEDIA_LNK_FL_IMMUTABLE,
> +					     GFP_KERNEL);
>  		if (rval) {
>  			dev_err(&client->dev,
>  				"media_create_pad_link failed\n");
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index ff18444..fd99683 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1197,7 +1197,8 @@ static int tvp5150_registered_async(struct v4l2_subdev *sd)
>  			return ret;
>  
>  		ret = media_create_pad_link(input, 0, &sd->entity,
> -					    DEMOD_PAD_IF_INPUT, 0);
> +					    DEMOD_PAD_IF_INPUT, 0,
> +					    GFP_KERNEL);
>  		if (ret < 0) {
>  			media_device_unregister_entity(input);
>  			return ret;
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 66a5392..115435b 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -566,14 +566,14 @@ EXPORT_SYMBOL_GPL(media_entity_put);
>   * Links management
>   */
>  
> -static struct media_link *media_add_link(struct list_head *head)
> +static struct media_link *media_add_link(struct list_head *head, gfp_t gfpflags)
>  {
>  	struct media_link *link;
>  
>  	if (in_atomic())
>  		dump_stack();
>  
> -	link = kzalloc(sizeof(*link), GFP_KERNEL);
> +	link = kzalloc(sizeof(*link), gfpflags);
>  	if (link == NULL)
>  		return NULL;
>  
> @@ -615,7 +615,8 @@ static void __media_entity_remove_link(struct media_entity *entity,
>  
>  int
>  media_create_pad_link(struct media_entity *source, u16 source_pad,
> -			 struct media_entity *sink, u16 sink_pad, u32 flags)
> +		      struct media_entity *sink, u16 sink_pad, u32 flags,
> +		      gfp_t gfpflags)
>  {
>  	struct media_link *link;
>  	struct media_link *backlink;
> @@ -624,7 +625,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	BUG_ON(source_pad >= source->num_pads);
>  	BUG_ON(sink_pad >= sink->num_pads);
>  
> -	link = media_add_link(&source->links);
> +	link = media_add_link(&source->links, gfpflags);
>  	if (link == NULL)
>  		return -ENOMEM;
>  
> @@ -639,7 +640,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	/* Create the backlink. Backlinks are used to help graph traversal and
>  	 * are not reported to userspace.
>  	 */
> -	backlink = media_add_link(&sink->links);
> +	backlink = media_add_link(&sink->links, gfpflags);
>  	if (backlink == NULL) {
>  		__media_entity_remove_link(source, link);
>  		return -ENOMEM;
> @@ -682,7 +683,7 @@ int media_create_pad_links(const struct media_device *mdev,
>  	/* Trivial case: 1:1 relation */
>  	if (source && sink)
>  		return media_create_pad_link(source, source_pad,
> -					     sink, sink_pad, flags);
> +					     sink, sink_pad, flags, GFP_KERNEL);
>  
>  	/* Worse case scenario: n:n relation */
>  	if (!source && !sink) {
> @@ -696,7 +697,7 @@ int media_create_pad_links(const struct media_device *mdev,
>  					continue;
>  				ret = media_create_pad_link(source, source_pad,
>  							    sink, sink_pad,
> -							    flags);
> +							    flags, GFP_KERNEL);
>  				if (ret)
>  					return ret;
>  				flags &= ~(MEDIA_LNK_FL_ENABLED |
> @@ -718,10 +719,12 @@ int media_create_pad_links(const struct media_device *mdev,
>  
>  		if (source)
>  			ret = media_create_pad_link(source, source_pad,
> -						    entity, sink_pad, flags);
> +						    entity, sink_pad, flags,
> +						    GFP_KERNEL);
>  		else
>  			ret = media_create_pad_link(entity, source_pad,
> -						    sink, sink_pad, flags);
> +						    sink, sink_pad, flags,
> +						    GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  		flags &= ~(MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> @@ -890,14 +893,15 @@ static void media_interface_init(struct media_device *mdev,
>  
>  struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
>  						u32 type, u32 flags,
> -						u32 major, u32 minor)
> +						u32 major, u32 minor,
> +						gfp_t gfpflags)
>  {
>  	struct media_intf_devnode *devnode;
>  
>  	if (in_atomic())
>  		dump_stack();
>  
> -	devnode = kzalloc(sizeof(*devnode), GFP_KERNEL);
> +	devnode = kzalloc(sizeof(*devnode), gfpflags);
>  	if (!devnode)
>  		return NULL;
>  
> @@ -921,11 +925,11 @@ EXPORT_SYMBOL_GPL(media_devnode_remove);
>  
>  struct media_link *media_create_intf_link(struct media_entity *entity,
>  					    struct media_interface *intf,
> -					    u32 flags)
> +					    u32 flags, gfp_t gfpflags)
>  {
>  	struct media_link *link;
>  
> -	link = media_add_link(&intf->links);
> +	link = media_add_link(&intf->links, gfpflags);
>  	if (link == NULL)
>  		return NULL;
>  
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index feb521f..145d90e 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -798,7 +798,8 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
>  
>  		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
>  		ret = media_create_pad_link(source, pad, sink,
> -					      FIMC_SD_PAD_SINK_CAM, flags);
> +					      FIMC_SD_PAD_SINK_CAM, flags,
> +					    GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  
> @@ -818,7 +819,8 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
>  
>  		sink = &fmd->fimc_lite[i]->subdev.entity;
>  		ret = media_create_pad_link(source, pad, sink,
> -					       FLITE_SD_PAD_SINK, 0);
> +					       FLITE_SD_PAD_SINK, 0,
> +					    GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  
> @@ -850,13 +852,13 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
>  		sink = &fimc->ve.vdev.entity;
>  		/* FIMC-LITE's subdev and video node */
>  		ret = media_create_pad_link(source, FLITE_SD_PAD_SOURCE_DMA,
> -					       sink, 0, 0);
> +					       sink, 0, 0, GFP_KERNEL);
>  		if (ret)
>  			break;
>  		/* Link from FIMC-LITE to IS-ISP subdev */
>  		sink = &fmd->fimc_is->isp.subdev.entity;
>  		ret = media_create_pad_link(source, FLITE_SD_PAD_SOURCE_ISP,
> -					       sink, 0, 0);
> +					       sink, 0, 0, GFP_KERNEL);
>  		if (ret)
>  			break;
>  	}
> @@ -880,7 +882,8 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
>  		/* Link from FIMC-IS-ISP subdev to FIMC */
>  		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
>  		ret = media_create_pad_link(source, FIMC_ISP_SD_PAD_SRC_FIFO,
> -					       sink, FIMC_SD_PAD_SINK_FIFO, 0);
> +					       sink, FIMC_SD_PAD_SINK_FIFO, 0,
> +					    GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  	}
> @@ -893,7 +896,7 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
>  		return 0;
>  
>  	return media_create_pad_link(source, FIMC_ISP_SD_PAD_SRC_DMA,
> -					sink, 0, 0);
> +					sink, 0, 0, GFP_KERNEL);
>  }
>  
>  /**
> @@ -944,7 +947,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
>  			ret = media_create_pad_link(&sensor->entity, pad,
>  					      &csis->entity, CSIS_PAD_SINK,
>  					      MEDIA_LNK_FL_IMMUTABLE |
> -					      MEDIA_LNK_FL_ENABLED);
> +					      MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  
> @@ -996,7 +999,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
>  		sink = &fmd->fimc[i]->vid_cap.ve.vdev.entity;
>  
>  		ret = media_create_pad_link(source, FIMC_SD_PAD_SOURCE,
> -					      sink, 0, flags);
> +					      sink, 0, flags, GFP_KERNEL);
>  		if (ret)
>  			break;
>  	}
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index 5d54e2c..f8d9c84 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -1669,7 +1669,7 @@ static int isp_link_entity(
>  		return -EINVAL;
>  	}
>  
> -	return media_create_pad_link(entity, i, input, pad, flags);
> +	return media_create_pad_link(entity, i, input, pad, flags, GFP_KERNEL);
>  }
>  
>  static int isp_register_entities(struct isp_device *isp)
> @@ -1748,43 +1748,50 @@ static int isp_create_links(struct isp_device *isp)
>  	/* Create links between entities and video nodes. */
>  	ret = media_create_pad_link(
>  			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
> -			&isp->isp_csi2a.video_out.video.entity, 0, 0);
> +			&isp->isp_csi2a.video_out.video.entity, 0, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccp2.video_in.video.entity, 0,
> -			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SINK, 0);
> +			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
> -			&isp->isp_ccdc.video_out.video.entity, 0, 0);
> +			&isp->isp_ccdc.video_out.video.entity, 0, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_prev.video_in.video.entity, 0,
> -			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
> +			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
> -			&isp->isp_prev.video_out.video.entity, 0, 0);
> +			&isp->isp_prev.video_out.video.entity, 0, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_res.video_in.video.entity, 0,
> -			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_res.subdev.entity, RESZ_PAD_SOURCE,
> -			&isp->isp_res.video_out.video.entity, 0, 0);
> +			&isp->isp_res.video_out.video.entity, 0, 0,
> +			GFP_KERNEL);
>  
>  	if (ret < 0)
>  		return ret;
> @@ -1792,52 +1799,60 @@ static int isp_create_links(struct isp_device *isp)
>  	/* Create links between entities. */
>  	ret = media_create_pad_link(
>  			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
> -			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
> -			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
> +			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
> -			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
> +			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
> -			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
> -			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
> +			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>  			&isp->isp_aewb.subdev.entity, 0,
> -			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>  			&isp->isp_af.subdev.entity, 0,
> -			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
>  			&isp->isp_hist.subdev.entity, 0,
> -			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
> +			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
> index 0b44b9a..a49b4c3 100644
> --- a/drivers/media/platform/s3c-camif/camif-core.c
> +++ b/drivers/media/platform/s3c-camif/camif-core.c
> @@ -266,7 +266,7 @@ static int camif_create_media_links(struct camif_dev *camif)
>  	ret = media_create_pad_link(&camif->sensor.sd->entity, 0,
>  				&camif->subdev.entity, CAMIF_SD_PAD_SINK,
>  				MEDIA_LNK_FL_IMMUTABLE |
> -				MEDIA_LNK_FL_ENABLED);
> +				MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  	if (ret)
>  		return ret;
>  
> @@ -274,7 +274,7 @@ static int camif_create_media_links(struct camif_dev *camif)
>  		ret = media_create_pad_link(&camif->subdev.entity, i,
>  				&camif->vp[i - 1].vdev.entity, 0,
>  				MEDIA_LNK_FL_IMMUTABLE |
> -				MEDIA_LNK_FL_ENABLED);
> +				MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  	}
>  
>  	return ret;
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 021fe57..f868dec 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -525,7 +525,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  		ret = media_create_pad_link(&rpf->entity.subdev.entity,
>  					    RWPF_PAD_SOURCE,
>  					    &vsp1->bru->entity.subdev.entity,
> -					    i, flags);
> +					    i, flags, GFP_KERNEL);
>  		if (ret < 0)
>  			return ret;
>  
> @@ -536,7 +536,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  	ret = media_create_pad_link(&vsp1->bru->entity.subdev.entity,
>  				    vsp1->bru->entity.source_pad,
>  				    &vsp1->wpf[0]->entity.subdev.entity,
> -				    RWPF_PAD_SINK, flags);
> +				    RWPF_PAD_SINK, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -546,7 +546,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  	ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
>  				    RWPF_PAD_SOURCE,
>  				    &vsp1->lif->entity.subdev.entity,
> -				    LIF_PAD_SINK, flags);
> +				    LIF_PAD_SINK, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 25750a0..7295587 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -125,7 +125,8 @@ static int vsp1_create_sink_links(struct vsp1_device *vsp1,
>  
>  			ret = media_create_pad_link(&source->subdev.entity,
>  						       source->source_pad,
> -						       entity, pad, flags);
> +						       entity, pad, flags,
> +						    GFP_KERNEL);
>  			if (ret < 0)
>  				return ret;
>  
> @@ -157,7 +158,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
>  		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
>  					    RWPF_PAD_SOURCE,
>  					    &vsp1->lif->entity.subdev.entity,
> -					    LIF_PAD_SINK, 0);
> +					    LIF_PAD_SINK, 0, GFP_KERNEL);
>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -169,7 +170,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
>  					    &rpf->entity.subdev.entity,
>  					    RWPF_PAD_SINK,
>  					    MEDIA_LNK_FL_ENABLED |
> -					    MEDIA_LNK_FL_IMMUTABLE);
> +					    MEDIA_LNK_FL_IMMUTABLE, GFP_KERNEL);
>  		if (ret < 0)
>  			return ret;
>  	}
> @@ -188,7 +189,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
>  		ret = media_create_pad_link(&wpf->entity.subdev.entity,
>  					    RWPF_PAD_SOURCE,
>  					    &wpf->video->video.entity, 0,
> -					    flags);
> +					    flags, GFP_KERNEL);
>  		if (ret < 0)
>  			return ret;
>  	}
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> index e795a45..b444db4 100644
> --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -158,7 +158,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
>  
>  		ret = media_create_pad_link(local, local_pad->index,
>  					       remote, remote_pad->index,
> -					       link_flags);
> +					       link_flags, GFP_KERNEL);
>  		if (ret < 0) {
>  			dev_err(xdev->dev,
>  				"failed to create %s:%u -> %s:%u link\n",
> @@ -272,7 +272,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
>  
>  		ret = media_create_pad_link(source, source_pad->index,
>  					       sink, sink_pad->index,
> -					       link_flags);
> +					       link_flags, GFP_KERNEL);
>  		if (ret < 0) {
>  			dev_err(xdev->dev,
>  				"failed to create %s:%u -> %s:%u link\n",
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index 552ac58..de9ab11 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -251,7 +251,8 @@ create_link:
>  		ret = media_create_pad_link(decoder,
>  					    DEMOD_PAD_AUDIO_OUT,
>  					    mixer, 0,
> -					    MEDIA_LNK_FL_ENABLED);
> +					    MEDIA_LNK_FL_ENABLED,
> +					    GFP_KERNEL);
>  		if (ret)
>  			dev_err(&dev->usbdev->dev,
>  				"Mixer Pad Link Create Error: %d\n", ret);
> diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
> index ac386bb..d9555dc 100644
> --- a/drivers/media/usb/uvc/uvc_entity.c
> +++ b/drivers/media/usb/uvc/uvc_entity.c
> @@ -53,7 +53,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
>  
>  		remote_pad = remote->num_pads - 1;
>  		ret = media_create_pad_link(source, remote_pad,
> -					       sink, i, flags);
> +					       sink, i, flags, GFP_KERNEL);
>  		if (ret < 0)
>  			return ret;
>  	}
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index d8e5994..b0f53a2 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -786,7 +786,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  	vdev->intf_devnode = media_devnode_create(vdev->v4l2_dev->mdev,
>  						  intf_type,
>  						  0, VIDEO_MAJOR,
> -						  vdev->minor);
> +						  vdev->minor, GFP_KERNEL);
>  	if (!vdev->intf_devnode) {
>  		media_device_unregister_entity(&vdev->entity);
>  		return -ENOMEM;
> @@ -797,7 +797,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
>  
>  		link = media_create_intf_link(&vdev->entity,
>  					      &vdev->intf_devnode->intf,
> -					      MEDIA_LNK_FL_ENABLED);
> +					      MEDIA_LNK_FL_ENABLED,
> +					      GFP_KERNEL);
>  		if (!link) {
>  			media_devnode_remove(vdev->intf_devnode);
>  			media_device_unregister_entity(&vdev->entity);
> diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
> index 06fa5f1..c7514e7 100644
> --- a/drivers/media/v4l2-core/v4l2-device.c
> +++ b/drivers/media/v4l2-core/v4l2-device.c
> @@ -266,7 +266,8 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  
>  			link = media_create_intf_link(&sd->entity,
>  						      &vdev->intf_devnode->intf,
> -						      MEDIA_LNK_FL_ENABLED);
> +						      MEDIA_LNK_FL_ENABLED,
> +						      GFP_KERNEL);
>  			if (!link) {
>  				err = -ENOMEM;
>  				goto clean_up;
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 40ee864..b1652f9 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -92,7 +92,8 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  				continue;
>  			ret = media_create_pad_link(entity, 0,
>  						    io_v4l, 0,
> -						    MEDIA_LNK_FL_ENABLED);
> +						    MEDIA_LNK_FL_ENABLED,
> +						    GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  		}
> @@ -110,18 +111,21 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
>  						    if_vid,
>  						    IF_VID_DEC_PAD_IF_INPUT,
> -						    MEDIA_LNK_FL_ENABLED);
> +						    MEDIA_LNK_FL_ENABLED,
> +						    GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
>  						decoder, DEMOD_PAD_IF_INPUT,
> -						MEDIA_LNK_FL_ENABLED);
> +						MEDIA_LNK_FL_ENABLED,
> +						    GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  		} else {
>  			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
>  						decoder, DEMOD_PAD_IF_INPUT,
> -						MEDIA_LNK_FL_ENABLED);
> +						MEDIA_LNK_FL_ENABLED,
> +						GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  		}
> @@ -130,7 +134,8 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
>  						    if_aud,
>  						    IF_AUD_DEC_PAD_IF_INPUT,
> -						    MEDIA_LNK_FL_ENABLED);
> +						    MEDIA_LNK_FL_ENABLED,
> +						    GFP_KERNEL);
>  			if (ret)
>  				return ret;
>  		} else {
> @@ -143,7 +148,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  	if (io_v4l) {
>  		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
>  					io_v4l, 0,
> -					MEDIA_LNK_FL_ENABLED);
> +					MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  	}
> @@ -151,7 +156,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  	if (io_swradio) {
>  		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
>  					io_swradio, 0,
> -					MEDIA_LNK_FL_ENABLED);
> +					MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  	}
> @@ -159,7 +164,7 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  	if (io_vbi) {
>  		ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
>  					    io_vbi, 0,
> -					    MEDIA_LNK_FL_ENABLED);
> +					    MEDIA_LNK_FL_ENABLED, GFP_KERNEL);
>  		if (ret)
>  			return ret;
>  	}
> @@ -174,13 +179,13 @@ int v4l2_mc_create_media_graph(struct media_device *mdev)
>  
>  			ret = media_create_pad_link(entity, 0, tuner,
>  						    TUNER_PAD_RF_INPUT,
> -						    flags);
> +						    flags, GFP_KERNEL);
>  			break;
>  		case MEDIA_ENT_F_CONN_SVIDEO:
>  		case MEDIA_ENT_F_CONN_COMPOSITE:
>  			ret = media_create_pad_link(entity, 0, decoder,
>  						    DEMOD_PAD_IF_INPUT,
> -						    flags);
> +						    flags, GFP_KERNEL);
>  			break;
>  		default:
>  			continue;
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> index 633d645..d1442b9 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> @@ -977,7 +977,8 @@ vpfe_ipipeif_register_entities(struct vpfe_ipipeif_device *ipipeif,
>  
>  	flags = 0;
>  	ret = media_create_pad_link(&ipipeif->video_in.video_dev.entity, 0,
> -					&ipipeif->subdev.entity, 0, flags);
> +					&ipipeif->subdev.entity, 0, flags,
> +				    GFP_KERNEL);
>  	if (ret < 0)
>  		goto fail;
>  
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> index 9905789..2470655 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> @@ -1824,7 +1824,7 @@ int vpfe_isif_register_entities(struct vpfe_isif_device *isif,
>  	/* connect isif to video node */
>  	ret = media_create_pad_link(&isif->subdev.entity, 1,
>  				       &isif->video_out.video_dev.entity,
> -				       0, flags);
> +				       0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_create_link;
>  	return 0;
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> index a91395c..067f699 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -1833,26 +1833,28 @@ int vpfe_resizer_register_entities(struct vpfe_resizer_device *resizer,
>  	/* create link between Resizer Crop----> Resizer A*/
>  	ret = media_create_pad_link(&resizer->crop_resizer.subdev.entity, 1,
>  				&resizer->resizer_a.subdev.entity,
> -				0, flags);
> +				0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_create_link;
>  
>  	/* create link between Resizer Crop----> Resizer B*/
>  	ret = media_create_pad_link(&resizer->crop_resizer.subdev.entity, 2,
>  				&resizer->resizer_b.subdev.entity,
> -				0, flags);
> +				0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_create_link;
>  
>  	/* create link between Resizer A ----> video out */
>  	ret = media_create_pad_link(&resizer->resizer_a.subdev.entity, 1,
> -		&resizer->resizer_a.video_out.video_dev.entity, 0, flags);
> +		&resizer->resizer_a.video_out.video_dev.entity, 0, flags,
> +		GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_create_link;
>  
>  	/* create link between Resizer B ----> video out */
>  	ret = media_create_pad_link(&resizer->resizer_b.subdev.entity, 1,
> -		&resizer->resizer_b.video_out.video_dev.entity, 0, flags);
> +		&resizer->resizer_b.video_out.video_dev.entity, 0, flags,
> +		GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_create_link;
>  
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> index ec46f36..bee9f5c 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> @@ -447,32 +447,32 @@ static int vpfe_register_entities(struct vpfe_device *vpfe_dev)
>  		if (vpfe_dev->sd[i]->entity.num_pads) {
>  			ret = media_create_pad_link(&vpfe_dev->sd[i]->entity,
>  				0, &vpfe_dev->vpfe_isif.subdev.entity,
> -				0, flags);
> +				0, flags, GFP_KERNEL);
>  			if (ret < 0)
>  				goto out_resizer_register;
>  		}
>  
>  	ret = media_create_pad_link(&vpfe_dev->vpfe_isif.subdev.entity, 1,
>  				       &vpfe_dev->vpfe_ipipeif.subdev.entity,
> -				       0, flags);
> +				       0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_resizer_register;
>  
>  	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
>  				       &vpfe_dev->vpfe_ipipe.subdev.entity,
> -				       0, flags);
> +				       0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_resizer_register;
>  
>  	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipe.subdev.entity,
>  			1, &vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
> -			0, flags);
> +			0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_resizer_register;
>  
>  	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
>  			&vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
> -			0, flags);
> +			0, flags, GFP_KERNEL);
>  	if (ret < 0)
>  		goto out_resizer_register;
>  
> diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
> index fb80d2b..933c8a7 100644
> --- a/drivers/staging/media/omap4iss/iss.c
> +++ b/drivers/staging/media/omap4iss/iss.c
> @@ -1065,7 +1065,7 @@ static int iss_register_entities(struct iss_device *iss)
>  		}
>  
>  		ret = media_create_pad_link(&sensor->entity, 0, input, pad,
> -					       flags);
> +					       flags, GFP_KERNEL);
>  		if (ret < 0)
>  			goto done;
>  	}
> @@ -1110,31 +1110,36 @@ static int iss_create_links(struct iss_device *iss)
>  	/* Connect the submodules. */
>  	ret = media_create_pad_link(
>  			&iss->csi2a.subdev.entity, CSI2_PAD_SOURCE,
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&iss->csi2b.subdev.entity, CSI2_PAD_SOURCE,
> -			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
> +			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> -			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> +			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
> -			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0);
> +			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = media_create_pad_link(
>  			&iss->ipipe.subdev.entity, IPIPE_PAD_SOURCE_VP,
> -			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
> +			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0,
> +			GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
> index aaca39d..4b40132 100644
> --- a/drivers/staging/media/omap4iss/iss_csi2.c
> +++ b/drivers/staging/media/omap4iss/iss_csi2.c
> @@ -1352,13 +1352,15 @@ int omap4iss_csi2_create_links(struct iss_device *iss)
>  
>  	/* Connect the CSI2a subdev to the video node. */
>  	ret = media_create_pad_link(&csi2a->subdev.entity, CSI2_PAD_SOURCE,
> -				    &csi2a->video_out.video.entity, 0, 0);
> +				    &csi2a->video_out.video.entity, 0, 0,
> +				    GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
>  	/* Connect the CSI2b subdev to the video node. */
>  	ret = media_create_pad_link(&csi2b->subdev.entity, CSI2_PAD_SOURCE,
> -				    &csi2b->video_out.video.entity, 0, 0);
> +				    &csi2b->video_out.video.entity, 0, 0,
> +				    GFP_KERNEL);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
> index 23de833..2f124b0 100644
> --- a/drivers/staging/media/omap4iss/iss_ipipeif.c
> +++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
> @@ -827,7 +827,8 @@ int omap4iss_ipipeif_create_links(struct iss_device *iss)
>  	/* Connect the IPIPEIF subdev to the video node. */
>  	return media_create_pad_link(&ipipeif->subdev.entity,
>  				     IPIPEIF_PAD_SOURCE_ISIF_SF,
> -				     &ipipeif->video_out.video.entity, 0, 0);
> +				     &ipipeif->video_out.video.entity, 0, 0,
> +				     GFP_KERNEL);
>  }
>  
>  /*
> diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
> index f1d352c..8d5766a 100644
> --- a/drivers/staging/media/omap4iss/iss_resizer.c
> +++ b/drivers/staging/media/omap4iss/iss_resizer.c
> @@ -869,7 +869,8 @@ int omap4iss_resizer_create_links(struct iss_device *iss)
>  	/* Connect the RESIZER subdev to the video node. */
>  	return media_create_pad_link(&resizer->subdev.entity,
>  				     RESIZER_PAD_SOURCE_MEM,
> -				     &resizer->video_out.video.entity, 0, 0);
> +				     &resizer->video_out.video.entity, 0, 0,
> +				     GFP_KERNEL);
>  }
>  
>  /*
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 6dc9e4e..0665c2d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -595,6 +595,7 @@ static inline void media_entity_cleanup(struct media_entity *entity) {};
>   * @sink:	pointer to &media_entity of the sink pad.
>   * @sink_pad:	number of the sink pad in the pads array.
>   * @flags:	Link flags, as defined in include/uapi/linux/media.h.
> + * @gfpflags:	Get Free Page (GFP) flags, as defined in include/linux/gfp.h
>   *
>   * Valid values for flags:
>   * A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can be
> @@ -613,7 +614,7 @@ static inline void media_entity_cleanup(struct media_entity *entity) {};
>   */
>  __must_check int media_create_pad_link(struct media_entity *source,
>  			u16 source_pad, struct media_entity *sink,
> -			u16 sink_pad, u32 flags);
> +			u16 sink_pad, u32 flags, gfp_t gfpflags);
>  
>  /**
>   * media_create_pad_links() - creates a link between two entities.
> @@ -883,11 +884,12 @@ void __media_entity_pipeline_stop(struct media_entity *entity);
>  struct media_intf_devnode *
>  __must_check media_devnode_create(struct media_device *mdev,
>  				  u32 type, u32 flags,
> -				  u32 major, u32 minor);
> +				  u32 major, u32 minor, gfp_t gfpflags);
>  /**
>   * media_devnode_remove() - removes a device node interface
>   *
>   * @devnode:	pointer to &media_intf_devnode to be freed.
> + * @gfpflags:	Get Free Page (GFP) flags, as defined in include/linux/gfp.h
>   *
>   * When a device node interface is removed, all links to it are automatically
>   * removed.
> @@ -901,6 +903,7 @@ struct media_link *
>   * @entity:	pointer to %media_entity
>   * @intf:	pointer to %media_interface
>   * @flags:	Link flags, as defined in include/uapi/linux/media.h.
> + * @gfpflags:	Get Free Page (GFP) flags, as defined in include/linux/gfp.h
>   *
>   *
>   * Valid values for flags:
> @@ -921,7 +924,7 @@ struct media_link *
>   */
>  __must_check media_create_intf_link(struct media_entity *entity,
>  				    struct media_interface *intf,
> -				    u32 flags);
> +				    u32 flags, gfp_t gfpflags);
>  /**
>   * __media_remove_intf_link() - remove a single interface link
>   *
> diff --git a/sound/usb/media.c b/sound/usb/media.c
> index 93a50d01..f5ac038 100644
> --- a/sound/usb/media.c
> +++ b/sound/usb/media.c
> @@ -88,14 +88,16 @@ int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
>  
>  	mctl->intf_devnode = media_devnode_create(mdev, intf_type, 0,
>  						  MAJOR(pcm_dev->devt),
> -						  MINOR(pcm_dev->devt));
> +						  MINOR(pcm_dev->devt),
> +						  GFP_KERNEL);
>  	if (!mctl->intf_devnode) {
>  		ret = -ENOMEM;
>  		goto unregister_entity;
>  	}
>  	mctl->intf_link = media_create_intf_link(&mctl->media_entity,
>  						 &mctl->intf_devnode->intf,
> -						 MEDIA_LNK_FL_ENABLED);
> +						 MEDIA_LNK_FL_ENABLED,
> +						 GFP_KERNEL);
>  	if (!mctl->intf_link) {
>  		ret = -ENOMEM;
>  		goto devnode_remove;
> @@ -107,7 +109,8 @@ int media_snd_stream_init(struct snd_usb_substream *subs, struct snd_pcm *pcm,
>  		case MEDIA_ENT_F_AUDIO_MIXER:
>  			ret = media_create_pad_link(entity, mixer_pad,
>  						    &mctl->media_entity, 0,
> -						    MEDIA_LNK_FL_ENABLED);
> +						    MEDIA_LNK_FL_ENABLED,
> +						    GFP_KERNEL);
>  			if (ret)
>  				goto remove_intf_link;
>  			break;
> @@ -180,7 +183,8 @@ int media_snd_mixer_init(struct snd_usb_audio *chip)
>  	if (!ctl_intf) {
>  		ctl_intf = media_devnode_create(mdev, intf_type, 0,
>  						MAJOR(ctl_dev->devt),
> -						MINOR(ctl_dev->devt));
> +						MINOR(ctl_dev->devt),
> +						GFP_KERNEL);
>  		if (!ctl_intf)
>  			return -ENOMEM;
>  		chip->ctl_intf_media_devnode = ctl_intf;
> @@ -213,7 +217,8 @@ int media_snd_mixer_init(struct snd_usb_audio *chip)
>  
>  		mctl->intf_link = media_create_intf_link(&mctl->media_entity,
>  							 &ctl_intf->intf,
> -							 MEDIA_LNK_FL_ENABLED);
> +							 MEDIA_LNK_FL_ENABLED,
> +							 GFP_KERNEL);
>  		if (!mctl->intf_link) {
>  			media_device_unregister_entity(&mctl->media_entity);
>  			media_entity_cleanup(&mctl->media_entity);


-- 
Thanks,
Mauro
