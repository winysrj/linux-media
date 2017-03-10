Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36468 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932880AbdCJLpc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:45:32 -0500
Subject: Re: [PATCH v5 17/39] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
 <1489121599-23206-18-git-send-email-steve_longerbeam@mentor.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5f999fec-5008-7092-1d7f-4c3d12120ace@xs4all.nl>
Date: Fri, 10 Mar 2017 12:45:18 +0100
MIME-Version: 1.0
In-Reply-To: <1489121599-23206-18-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/17 05:52, Steve Longerbeam wrote:
> v4l2_pipeline_inherit_controls() will add the v4l2 controls from
> all subdev entities in a pipeline to a given video device.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/v4l2-core/v4l2-mc.c | 48 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-mc.h           | 25 ++++++++++++++++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 303980b..09d4d97 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -22,6 +22,7 @@
>  #include <linux/usb.h>
>  #include <media/media-device.h>
>  #include <media/media-entity.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-mc.h>
>  #include <media/v4l2-subdev.h>
> @@ -238,6 +239,53 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>  
> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
> +				     struct media_entity *start_entity)
> +{
> +	struct media_device *mdev = start_entity->graph_obj.mdev;
> +	struct media_entity *entity;
> +	struct media_graph graph;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	ret = media_graph_walk_init(&graph, mdev);
> +	if (ret)
> +		return ret;
> +
> +	media_graph_walk_start(&graph, start_entity);
> +
> +	while ((entity = media_graph_walk_next(&graph))) {
> +		if (!is_media_entity_v4l2_subdev(entity))
> +			continue;
> +
> +		sd = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
> +					    sd->ctrl_handler,
> +					    NULL);
> +		if (ret)
> +			break;
> +	}
> +
> +	media_graph_walk_cleanup(&graph);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(__v4l2_pipeline_inherit_controls);
> +
> +int v4l2_pipeline_inherit_controls(struct video_device *vfd,
> +				   struct media_entity *start_entity)
> +{
> +	struct media_device *mdev = start_entity->graph_obj.mdev;
> +	int ret;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	ret = __v4l2_pipeline_inherit_controls(vfd, start_entity);
> +	mutex_unlock(&mdev->graph_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_pipeline_inherit_controls);
> +
>  /* -----------------------------------------------------------------------------
>   * Pipeline power management
>   *
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 2634d9d..9848e77 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -171,6 +171,17 @@ void v4l_disable_media_source(struct video_device *vdev);
>   */
>  int v4l_vb2q_enable_media_source(struct vb2_queue *q);
>  
> +/**
> + * v4l2_pipeline_inherit_controls - Add the v4l2 controls from all
> + *				    subdev entities in a pipeline to
> + *				    the given video device.
> + * @vfd: the video device
> + * @start_entity: Starting entity
> + */
> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
> +				     struct media_entity *start_entity);
> +int v4l2_pipeline_inherit_controls(struct video_device *vfd,
> +				   struct media_entity *start_entity);

Please document which is the unlocked variant and which lock the locked
variant takes.

Regards,

	Hans

>  
>  /**
>   * v4l2_pipeline_pm_use - Update the use count of an entity
> @@ -231,6 +242,20 @@ static inline int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>  	return 0;
>  }
>  
> +static inline int __v4l2_pipeline_inherit_controls(
> +	struct video_device *vfd,
> +	struct media_entity *start_entity)
> +{
> +	return 0;
> +}
> +
> +static inline int v4l2_pipeline_inherit_controls(
> +	struct video_device *vfd,
> +	struct media_entity *start_entity)
> +{
> +	return 0;
> +}
> +
>  static inline int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
>  {
>  	return 0;
> 
