Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41489C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 10:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088AB2184E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 10:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="cA9oxUFd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfCMKgm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:36:42 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:50614 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfCMKgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 06:36:41 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 10AFF31C;
        Wed, 13 Mar 2019 11:36:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552473398;
        bh=niY/UY1E8fEECLXDvzt4N5Qsfza7rXamCMTu7ZJrsYM=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cA9oxUFdVZ5dvIQu2nn4tKGsc02pFc1JFqKDPhim0+Yp/0SSghRqVCEhuyR3Mf9PY
         WOq8oUdYFH6ts4GrEQWR7ZuyOw85HvFqzCmryd9oZ4JiVN7LIIAHYNSXq+dR420lFH
         CNfR34ELD56Em4N92xrvoq3d6MmLJXaOirBjOf/k=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 06/18] media: vsp1: Add vsp1_dl_list argument to
 .configure_stream() operation
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-7-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <cbc85e93-a701-e482-8f53-1f2f8440ef30@ideasonboard.com>
Date:   Wed, 13 Mar 2019 10:36:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-7-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> The WPF needs access to the current display list to configure writeback.
> Add a display list pointer to the VSP1 entity .configure_stream()
> operation.
> 
> Only display pipelines can make use of the display list there as
> mem-to-mem pipelines don't have access to a display list at stream
> configuration time. This is not an issue as writeback is only used for
> display pipelines.


As we purposefully inject NULL DL variables, Do we need to add NULL
checks in to these functions

I think I'm happy leaving the null-checks out - because as you state
above - the only time this variable is used, it will not be NULL, and it
is documented as such in the code.

So,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_brx.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_clu.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_drm.c    | 2 +-
>  drivers/media/platform/vsp1/vsp1_entity.c | 3 ++-
>  drivers/media/platform/vsp1/vsp1_entity.h | 7 +++++--
>  drivers/media/platform/vsp1/vsp1_hgo.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_hsit.c   | 1 +
>  drivers/media/platform/vsp1/vsp1_lif.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_lut.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_sru.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_uds.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_uif.c    | 1 +
>  drivers/media/platform/vsp1/vsp1_video.c  | 3 ++-
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 1 +
>  16 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_brx.c b/drivers/media/platform/vsp1/vsp1_brx.c
> index 5e50178b057d..43468bc8fb56 100644
> --- a/drivers/media/platform/vsp1/vsp1_brx.c
> +++ b/drivers/media/platform/vsp1/vsp1_brx.c
> @@ -283,6 +283,7 @@ static const struct v4l2_subdev_ops brx_ops = {
>  
>  static void brx_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_brx *brx = to_brx(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
> index 942fc14c19d1..a47b23bf5abf 100644
> --- a/drivers/media/platform/vsp1/vsp1_clu.c
> +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> @@ -171,6 +171,7 @@ static const struct v4l2_subdev_ops clu_ops = {
>  
>  static void clu_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_clu *clu = to_clu(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 89773d3a916c..4f1bc51d1ef4 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -558,7 +558,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  		}
>  
>  		vsp1_entity_route_setup(entity, pipe, dlb);
> -		vsp1_entity_configure_stream(entity, pipe, dlb);
> +		vsp1_entity_configure_stream(entity, pipe, dl, dlb);
>  		vsp1_entity_configure_frame(entity, pipe, dl, dlb);
>  		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
>  	}
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index a54ab528b060..aa9d2286056e 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -71,10 +71,11 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  
>  void vsp1_entity_configure_stream(struct vsp1_entity *entity,
>  				  struct vsp1_pipeline *pipe,
> +				  struct vsp1_dl_list *dl,
>  				  struct vsp1_dl_body *dlb)
>  {
>  	if (entity->ops->configure_stream)
> -		entity->ops->configure_stream(entity, pipe, dlb);
> +		entity->ops->configure_stream(entity, pipe, dl, dlb);
>  }
>  
>  void vsp1_entity_configure_frame(struct vsp1_entity *entity,
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index 97acb7795cf1..a1ceb37bb837 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -67,7 +67,9 @@ struct vsp1_route {
>   * struct vsp1_entity_operations - Entity operations
>   * @destroy:	Destroy the entity.
>   * @configure_stream:	Setup the hardware parameters for the stream which do
> - *			not vary between frames (pipeline, formats).
> + *			not vary between frames (pipeline, formats). Note that
> + *			the vsp1_dl_list argument is only valid for display
> + *			pipeline and will be NULL for mem-to-mem pipelines.
>   * @configure_frame:	Configure the runtime parameters for each frame.
>   * @configure_partition: Configure partition specific parameters.
>   * @max_width:	Return the max supported width of data that the entity can
> @@ -78,7 +80,7 @@ struct vsp1_route {
>  struct vsp1_entity_operations {
>  	void (*destroy)(struct vsp1_entity *);
>  	void (*configure_stream)(struct vsp1_entity *, struct vsp1_pipeline *,
> -				 struct vsp1_dl_body *);
> +				 struct vsp1_dl_list *, struct vsp1_dl_body *);
>  	void (*configure_frame)(struct vsp1_entity *, struct vsp1_pipeline *,
>  				struct vsp1_dl_list *, struct vsp1_dl_body *);
>  	void (*configure_partition)(struct vsp1_entity *,
> @@ -155,6 +157,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  
>  void vsp1_entity_configure_stream(struct vsp1_entity *entity,
>  				  struct vsp1_pipeline *pipe,
> +				  struct vsp1_dl_list *dl,
>  				  struct vsp1_dl_body *dlb);
>  
>  void vsp1_entity_configure_frame(struct vsp1_entity *entity,
> diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
> index 827373c25351..bf3f981f93a1 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgo.c
> +++ b/drivers/media/platform/vsp1/vsp1_hgo.c
> @@ -131,6 +131,7 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
>  
>  static void hgo_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
> index bb6ce6fdd5f4..aa1c718e0453 100644
> --- a/drivers/media/platform/vsp1/vsp1_hgt.c
> +++ b/drivers/media/platform/vsp1/vsp1_hgt.c
> @@ -127,6 +127,7 @@ static const struct v4l2_ctrl_config hgt_hue_areas = {
>  
>  static void hgt_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
> index 39ab2e0c7c18..d5ebd9d08c8a 100644
> --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> @@ -129,6 +129,7 @@ static const struct v4l2_subdev_ops hsit_ops = {
>  
>  static void hsit_configure_stream(struct vsp1_entity *entity,
>  				  struct vsp1_pipeline *pipe,
> +				  struct vsp1_dl_list *dl,
>  				  struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
> index 8b0a26335d70..14ed5d7bd061 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -84,6 +84,7 @@ static const struct v4l2_subdev_ops lif_ops = {
>  
>  static void lif_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	const struct v4l2_mbus_framefmt *format;
> diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
> index 64c48d9459b0..9f88842d7048 100644
> --- a/drivers/media/platform/vsp1/vsp1_lut.c
> +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> @@ -147,6 +147,7 @@ static const struct v4l2_subdev_ops lut_ops = {
>  
>  static void lut_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_lut *lut = to_lut(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
> index 616afa7e165f..85587c1b6a37 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -57,6 +57,7 @@ static const struct v4l2_subdev_ops rpf_ops = {
>  
>  static void rpf_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
> index b1617cb1f2b9..2b65457ee12f 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -269,6 +269,7 @@ static const struct v4l2_subdev_ops sru_ops = {
>  
>  static void sru_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	const struct vsp1_sru_param *param;
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
> index 27012af973b2..5fc04c082d1a 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -257,6 +257,7 @@ static const struct v4l2_subdev_ops uds_ops = {
>  
>  static void uds_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_uds *uds = to_uds(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_uif.c b/drivers/media/platform/vsp1/vsp1_uif.c
> index 4b58d51df231..467d1072577b 100644
> --- a/drivers/media/platform/vsp1/vsp1_uif.c
> +++ b/drivers/media/platform/vsp1/vsp1_uif.c
> @@ -192,6 +192,7 @@ static const struct v4l2_subdev_ops uif_ops = {
>  
>  static void uif_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_uif *uif = to_uif(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 9ae20982604a..fd98e483b2f4 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -825,7 +825,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>  
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>  		vsp1_entity_route_setup(entity, pipe, pipe->stream_config);
> -		vsp1_entity_configure_stream(entity, pipe, pipe->stream_config);
> +		vsp1_entity_configure_stream(entity, pipe, NULL,
> +					     pipe->stream_config);
>  	}
>  
>  	return 0;
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 18c49e3a7875..fc5c1b0f6633 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -234,6 +234,7 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
>  
>  static void wpf_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
> +				 struct vsp1_dl_list *dl,
>  				 struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
> 

-- 
Regards
--
Kieran
