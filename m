Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739D7C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3852520842
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 19:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="ZTFNQHqG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfCETxz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 14:53:55 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:40928 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfCETxz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 14:53:55 -0500
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id D76F324A;
        Tue,  5 Mar 2019 20:53:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551815634;
        bh=cFPRPrrQshXkQ7ki/Py4D9dyqb27GZXVMMg8NZqQkyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZTFNQHqGaMYmLy+iSOoucZqZ7BYrmflbmJpiZp1eRkVoUAWEM7LP9dQ2xUIsxXIvM
         CVMMYMPPiWuAg+OFCXamXiYlj4ndBRtUyXJDOZSrtVjuNWxyzrBP3nfrMM+r0gk2EA
         dNyk5X5UzGWcji/rae9GHSD436Wu23iL89L0Iz3o=
Date:   Tue, 5 Mar 2019 21:53:47 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCHv2 9/9] vimc: use new release op
Message-ID: <20190305195347.GI14928@pendragon.ideasonboard.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-10-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190305095847.21428-10-hverkuil-cisco@xs4all.nl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

Thank you for the patch.

On Tue, Mar 05, 2019 at 10:58:47AM +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Use the new v4l2_subdev_internal_ops release op to free the
> subdev memory only once the last user closed the file handle.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/platform/vimc/vimc-common.c  |  2 ++
>  drivers/media/platform/vimc/vimc-common.h  |  2 ++
>  drivers/media/platform/vimc/vimc-debayer.c | 15 +++++++++++++--
>  drivers/media/platform/vimc/vimc-scaler.c  | 15 +++++++++++++--
>  drivers/media/platform/vimc/vimc-sensor.c  | 19 +++++++++++++++----
>  5 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
> index c1a74bb2df58..0adbfd8fd26d 100644
> --- a/drivers/media/platform/vimc/vimc-common.c
> +++ b/drivers/media/platform/vimc/vimc-common.c
> @@ -380,6 +380,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  			 u32 function,
>  			 u16 num_pads,
>  			 const unsigned long *pads_flag,
> +			 const struct v4l2_subdev_internal_ops *sd_int_ops,
>  			 const struct v4l2_subdev_ops *sd_ops)
>  {
>  	int ret;
> @@ -394,6 +395,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  
>  	/* Initialize the subdev */
>  	v4l2_subdev_init(sd, sd_ops);
> +	sd->internal_ops = sd_int_ops;
>  	sd->entity.function = function;
>  	sd->entity.ops = &vimc_ent_sd_mops;
>  	sd->owner = THIS_MODULE;
> diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
> index 84539430b5e7..07987eab988f 100644
> --- a/drivers/media/platform/vimc/vimc-common.h
> +++ b/drivers/media/platform/vimc/vimc-common.h
> @@ -187,6 +187,7 @@ const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
>   * @function:	media entity function defined by MEDIA_ENT_F_* macros
>   * @num_pads:	number of pads to initialize
>   * @pads_flag:	flags to use in each pad
> + * @sd_int_ops:	pointer to &struct v4l2_subdev_internal_ops.

Nitpicking, most of the lines here don't have a period at the end.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>   * @sd_ops:	pointer to &struct v4l2_subdev_ops.
>   *
>   * Helper function initialize and register the struct vimc_ent_device and struct
> @@ -199,6 +200,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>  			 u32 function,
>  			 u16 num_pads,
>  			 const unsigned long *pads_flag,
> +			 const struct v4l2_subdev_internal_ops *sd_int_ops,
>  			 const struct v4l2_subdev_ops *sd_ops);
>  
>  /**
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> index 7d77c63b99d2..eaed4233ad1b 100644
> --- a/drivers/media/platform/vimc/vimc-debayer.c
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -489,6 +489,18 @@ static void *vimc_deb_process_frame(struct vimc_ent_device *ved,
>  
>  }
>  
> +static void vimc_deb_release(struct v4l2_subdev *sd)
> +{
> +	struct vimc_deb_device *vdeb =
> +				container_of(sd, struct vimc_deb_device, sd);
> +
> +	kfree(vdeb);
> +}
> +
> +static const struct v4l2_subdev_internal_ops vimc_deb_int_ops = {
> +	.release = vimc_deb_release,
> +};
> +
>  static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
>  				 void *master_data)
>  {
> @@ -497,7 +509,6 @@ static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
>  						    ved);
>  
>  	vimc_ent_sd_unregister(ved, &vdeb->sd);
> -	kfree(vdeb);
>  }
>  
>  static int vimc_deb_comp_bind(struct device *comp, struct device *master,
> @@ -519,7 +530,7 @@ static int vimc_deb_comp_bind(struct device *comp, struct device *master,
>  				   MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV, 2,
>  				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
>  				   MEDIA_PAD_FL_SOURCE},
> -				   &vimc_deb_ops);
> +				   &vimc_deb_int_ops, &vimc_deb_ops);
>  	if (ret) {
>  		kfree(vdeb);
>  		return ret;
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index 39b2a73dfcc1..2028afa4ef7a 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -348,6 +348,18 @@ static void *vimc_sca_process_frame(struct vimc_ent_device *ved,
>  	return vsca->src_frame;
>  };
>  
> +static void vimc_sca_release(struct v4l2_subdev *sd)
> +{
> +	struct vimc_sca_device *vsca =
> +				container_of(sd, struct vimc_sca_device, sd);
> +
> +	kfree(vsca);
> +}
> +
> +static const struct v4l2_subdev_internal_ops vimc_sca_int_ops = {
> +	.release = vimc_sca_release,
> +};
> +
>  static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
>  				 void *master_data)
>  {
> @@ -356,7 +368,6 @@ static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
>  						    ved);
>  
>  	vimc_ent_sd_unregister(ved, &vsca->sd);
> -	kfree(vsca);
>  }
>  
>  
> @@ -379,7 +390,7 @@ static int vimc_sca_comp_bind(struct device *comp, struct device *master,
>  				   MEDIA_ENT_F_PROC_VIDEO_SCALER, 2,
>  				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
>  				   MEDIA_PAD_FL_SOURCE},
> -				   &vimc_sca_ops);
> +				   &vimc_sca_int_ops, &vimc_sca_ops);
>  	if (ret) {
>  		kfree(vsca);
>  		return ret;
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 59195f262623..d7891d3bbeaa 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -301,6 +301,20 @@ static const struct v4l2_ctrl_ops vimc_sen_ctrl_ops = {
>  	.s_ctrl = vimc_sen_s_ctrl,
>  };
>  
> +static void vimc_sen_release(struct v4l2_subdev *sd)
> +{
> +	struct vimc_sen_device *vsen =
> +				container_of(sd, struct vimc_sen_device, sd);
> +
> +	v4l2_ctrl_handler_free(&vsen->hdl);
> +	tpg_free(&vsen->tpg);
> +	kfree(vsen);
> +}
> +
> +static const struct v4l2_subdev_internal_ops vimc_sen_int_ops = {
> +	.release = vimc_sen_release,
> +};
> +
>  static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
>  				 void *master_data)
>  {
> @@ -309,9 +323,6 @@ static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
>  				container_of(ved, struct vimc_sen_device, ved);
>  
>  	vimc_ent_sd_unregister(ved, &vsen->sd);
> -	v4l2_ctrl_handler_free(&vsen->hdl);
> -	tpg_free(&vsen->tpg);
> -	kfree(vsen);
>  }
>  
>  /* Image Processing Controls */
> @@ -371,7 +382,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  				   pdata->entity_name,
>  				   MEDIA_ENT_F_CAM_SENSOR, 1,
>  				   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
> -				   &vimc_sen_ops);
> +				   &vimc_sen_int_ops, &vimc_sen_ops);
>  	if (ret)
>  		goto err_free_hdl;
>  

-- 
Regards,

Laurent Pinchart
