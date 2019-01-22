Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E7AC282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9251620879
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 13:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbfAVNFf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:05:35 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:59606 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbfAVNFe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 08:05:34 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: koike)
        with ESMTPSA id B6D58260B10
Subject: Re: [PATCH v4] media: vimc: Add vimc-streamer for stream control
To:     "Lucas A. M. Magalhaes" <lucmaga@gmail.com>,
        linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20190122010501.15933-1-lucmaga@gmail.com>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <3466d3f1-9d12-b463-f6ec-9713a756664c@collabora.com>
Date:   Tue, 22 Jan 2019 11:05:23 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190122010501.15933-1-lucmaga@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Lucas,

On 1/21/19 11:05 PM, Lucas A. M. Magalhaes wrote:
> Add a linear pipeline logic for the stream control. It's created by
> walking backwards on the entity graph. When the stream starts it will
> simply loop through the pipeline calling the respective process_frame
> function of each entity.
> 
> Fixes: f2fe89061d797 ("vimc: Virtual Media Controller core, capture
> and sensor")
> Cc: stable@vger.kernel.org # for v4.20
> Signed-off-by: Lucas A. M. Magalhães <lucmaga@gmail.com>

lgtm, thanks for the patch.

Acked-by: Helen Koike <helen.koike@collabora.com>

Regards,
Helen

> ---
> 
> The actual approach for streaming frames on vimc uses a recursive
> logic[1]. This algorithm may cause problems as the stack usage
> increases a with the topology. For the actual topology almost 1Kb of
> stack is used if compiled with KASAN on a 64bit architecture. However
> the topology is fixed and hard-coded on vimc-core[2]. So it's a
> controlled situation if used as is.
> 
> [1]
> The stream starts on vim-sensor's thread
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-sensor.c#n204
> It proceeds calling successively vimc_propagate_frame
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-common.c#n210
> Then processes_frame on the next entity
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-scaler.c#n349
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-debayer.c#n483
> This goes until the loop ends on a vimc-capture device
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-capture.c#n358
> 
> [2]https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/vimc-core.c#n80
> 
> Thanks the review Helen. I've made the change you pointed out. There was really
> a bug for single entity pipelines.
> 
> Changed from v3:
> * Fix vimc_streamer_pipeline_init and vimc_streamer_pipeline_terminate for a
> single entity pipeline.
> * Remove unnecessary checks and comments.
> * Alignment and style.
> 
>  drivers/media/platform/vimc/Makefile        |   3 +-
>  drivers/media/platform/vimc/vimc-capture.c  |  18 +-
>  drivers/media/platform/vimc/vimc-common.c   |  35 ----
>  drivers/media/platform/vimc/vimc-common.h   |  15 +-
>  drivers/media/platform/vimc/vimc-debayer.c  |  26 +--
>  drivers/media/platform/vimc/vimc-scaler.c   |  28 +--
>  drivers/media/platform/vimc/vimc-sensor.c   |  56 ++----
>  drivers/media/platform/vimc/vimc-streamer.c | 188 ++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-streamer.h |  38 ++++
>  9 files changed, 260 insertions(+), 147 deletions(-)
>  create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
>  create mode 100644 drivers/media/platform/vimc/vimc-streamer.h
> 
> diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
> index 4b2e3de7856e..c4fc8e7d365a 100644
> --- a/drivers/media/platform/vimc/Makefile
> +++ b/drivers/media/platform/vimc/Makefile
> @@ -5,6 +5,7 @@ vimc_common-objs := vimc-common.o
>  vimc_debayer-objs := vimc-debayer.o
>  vimc_scaler-objs := vimc-scaler.o
>  vimc_sensor-objs := vimc-sensor.o
> +vimc_streamer-objs := vimc-streamer.o
>  
>  obj-$(CONFIG_VIDEO_VIMC) += vimc.o vimc_capture.o vimc_common.o vimc-debayer.o \
> -				vimc_scaler.o vimc_sensor.o
> +			    vimc_scaler.o vimc_sensor.o vimc_streamer.o
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> index aaeddf24b042..93837d9eecd2 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -24,6 +24,7 @@
>  #include <media/videobuf2-vmalloc.h>
>  
>  #include "vimc-common.h"
> +#include "vimc-streamer.h"
>  
>  #define VIMC_CAP_DRV_NAME "vimc-capture"
>  
> @@ -44,7 +45,7 @@ struct vimc_cap_device {
>  	spinlock_t qlock;
>  	struct mutex lock;
>  	u32 sequence;
> -	struct media_pipeline pipe;
> +	struct vimc_stream stream;
>  };
>  
>  static const struct v4l2_pix_format fmt_default = {
> @@ -248,14 +249,13 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	vcap->sequence = 0;
>  
>  	/* Start the media pipeline */
> -	ret = media_pipeline_start(entity, &vcap->pipe);
> +	ret = media_pipeline_start(entity, &vcap->stream.pipe);
>  	if (ret) {
>  		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
>  		return ret;
>  	}
>  
> -	/* Enable streaming from the pipe */
> -	ret = vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
> +	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
>  	if (ret) {
>  		media_pipeline_stop(entity);
>  		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> @@ -273,8 +273,7 @@ static void vimc_cap_stop_streaming(struct vb2_queue *vq)
>  {
>  	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
>  
> -	/* Disable streaming from the pipe */
> -	vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
> +	vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 0);
>  
>  	/* Stop the media pipeline */
>  	media_pipeline_stop(&vcap->vdev.entity);
> @@ -355,8 +354,8 @@ static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
>  	kfree(vcap);
>  }
>  
> -static void vimc_cap_process_frame(struct vimc_ent_device *ved,
> -				   struct media_pad *sink, const void *frame)
> +static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
> +				    const void *frame)
>  {
>  	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
>  						    ved);
> @@ -370,7 +369,7 @@ static void vimc_cap_process_frame(struct vimc_ent_device *ved,
>  					    typeof(*vimc_buf), list);
>  	if (!vimc_buf) {
>  		spin_unlock(&vcap->qlock);
> -		return;
> +		return ERR_PTR(-EAGAIN);
>  	}
>  
>  	/* Remove this entry from the list */
> @@ -391,6 +390,7 @@ static void vimc_cap_process_frame(struct vimc_ent_device *ved,
>  	vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
>  			      vcap->format.sizeimage);
>  	vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
> +	return NULL;
>  }
>  
>  static int vimc_cap_comp_bind(struct device *comp, struct device *master,
> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
> index 867e24dbd6b5..c1a74bb2df58 100644
> --- a/drivers/media/platform/vimc/vimc-common.c
> +++ b/drivers/media/platform/vimc/vimc-common.c
> @@ -207,41 +207,6 @@ const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
>  }
>  EXPORT_SYMBOL_GPL(vimc_pix_map_by_pixelformat);
>  
> -int vimc_propagate_frame(struct media_pad *src, const void *frame)
> -{
> -	struct media_link *link;
> -
> -	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
> -		return -EINVAL;
> -
> -	/* Send this frame to all sink pads that are direct linked */
> -	list_for_each_entry(link, &src->entity->links, list) {
> -		if (link->source == src &&
> -		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
> -			struct vimc_ent_device *ved = NULL;
> -			struct media_entity *entity = link->sink->entity;
> -
> -			if (is_media_entity_v4l2_subdev(entity)) {
> -				struct v4l2_subdev *sd =
> -					container_of(entity, struct v4l2_subdev,
> -						     entity);
> -				ved = v4l2_get_subdevdata(sd);
> -			} else if (is_media_entity_v4l2_video_device(entity)) {
> -				struct video_device *vdev =
> -					container_of(entity,
> -						     struct video_device,
> -						     entity);
> -				ved = video_get_drvdata(vdev);
> -			}
> -			if (ved && ved->process_frame)
> -				ved->process_frame(ved, link->sink, frame);
> -		}
> -	}
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL_GPL(vimc_propagate_frame);
> -
>  /* Helper function to allocate and initialize pads */
>  struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
>  {
> diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
> index f491c33c7c14..84539430b5e7 100644
> --- a/drivers/media/platform/vimc/vimc-common.h
> +++ b/drivers/media/platform/vimc/vimc-common.h
> @@ -115,23 +115,12 @@ struct vimc_pix_map {
>  struct vimc_ent_device {
>  	struct media_entity *ent;
>  	struct media_pad *pads;
> -	void (*process_frame)(struct vimc_ent_device *ved,
> -			      struct media_pad *sink, const void *frame);
> +	void * (*process_frame)(struct vimc_ent_device *ved,
> +				const void *frame);
>  	void (*vdev_get_format)(struct vimc_ent_device *ved,
>  			      struct v4l2_pix_format *fmt);
>  };
>  
> -/**
> - * vimc_propagate_frame - propagate a frame through the topology
> - *
> - * @src:	the source pad where the frame is being originated
> - * @frame:	the frame to be propagated
> - *
> - * This function will call the process_frame callback from the vimc_ent_device
> - * struct of the nodes directly connected to the @src pad
> - */
> -int vimc_propagate_frame(struct media_pad *src, const void *frame);
> -
>  /**
>   * vimc_pads_init - initialize pads
>   *
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> index 77887f66f323..7d77c63b99d2 100644
> --- a/drivers/media/platform/vimc/vimc-debayer.c
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -321,7 +321,6 @@ static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(struct vimc_deb_device *vdeb,
>  static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
> -	int ret;
>  
>  	if (enable) {
>  		const struct vimc_pix_map *vpix;
> @@ -351,22 +350,10 @@ static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
>  		if (!vdeb->src_frame)
>  			return -ENOMEM;
>  
> -		/* Turn the stream on in the subdevices directly connected */
> -		ret = vimc_pipeline_s_stream(&vdeb->sd.entity, 1);
> -		if (ret) {
> -			vfree(vdeb->src_frame);
> -			vdeb->src_frame = NULL;
> -			return ret;
> -		}
>  	} else {
>  		if (!vdeb->src_frame)
>  			return 0;
>  
> -		/* Disable streaming from the pipe */
> -		ret = vimc_pipeline_s_stream(&vdeb->sd.entity, 0);
> -		if (ret)
> -			return ret;
> -
>  		vfree(vdeb->src_frame);
>  		vdeb->src_frame = NULL;
>  	}
> @@ -480,9 +467,8 @@ static void vimc_deb_calc_rgb_sink(struct vimc_deb_device *vdeb,
>  	}
>  }
>  
> -static void vimc_deb_process_frame(struct vimc_ent_device *ved,
> -				   struct media_pad *sink,
> -				   const void *sink_frame)
> +static void *vimc_deb_process_frame(struct vimc_ent_device *ved,
> +				    const void *sink_frame)
>  {
>  	struct vimc_deb_device *vdeb = container_of(ved, struct vimc_deb_device,
>  						    ved);
> @@ -491,7 +477,7 @@ static void vimc_deb_process_frame(struct vimc_ent_device *ved,
>  
>  	/* If the stream in this node is not active, just return */
>  	if (!vdeb->src_frame)
> -		return;
> +		return ERR_PTR(-EINVAL);
>  
>  	for (i = 0; i < vdeb->sink_fmt.height; i++)
>  		for (j = 0; j < vdeb->sink_fmt.width; j++) {
> @@ -499,12 +485,8 @@ static void vimc_deb_process_frame(struct vimc_ent_device *ved,
>  			vdeb->set_rgb_src(vdeb, i, j, rgb);
>  		}
>  
> -	/* Propagate the frame through all source pads */
> -	for (i = 1; i < vdeb->sd.entity.num_pads; i++) {
> -		struct media_pad *pad = &vdeb->sd.entity.pads[i];
> +	return vdeb->src_frame;
>  
> -		vimc_propagate_frame(pad, vdeb->src_frame);
> -	}
>  }
>  
>  static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index b0952ee86296..39b2a73dfcc1 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -217,7 +217,6 @@ static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
>  static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
> -	int ret;
>  
>  	if (enable) {
>  		const struct vimc_pix_map *vpix;
> @@ -245,22 +244,10 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
>  		if (!vsca->src_frame)
>  			return -ENOMEM;
>  
> -		/* Turn the stream on in the subdevices directly connected */
> -		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 1);
> -		if (ret) {
> -			vfree(vsca->src_frame);
> -			vsca->src_frame = NULL;
> -			return ret;
> -		}
>  	} else {
>  		if (!vsca->src_frame)
>  			return 0;
>  
> -		/* Disable streaming from the pipe */
> -		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 0);
> -		if (ret)
> -			return ret;
> -
>  		vfree(vsca->src_frame);
>  		vsca->src_frame = NULL;
>  	}
> @@ -346,26 +333,19 @@ static void vimc_sca_fill_src_frame(const struct vimc_sca_device *const vsca,
>  			vimc_sca_scale_pix(vsca, i, j, sink_frame);
>  }
>  
> -static void vimc_sca_process_frame(struct vimc_ent_device *ved,
> -				   struct media_pad *sink,
> -				   const void *sink_frame)
> +static void *vimc_sca_process_frame(struct vimc_ent_device *ved,
> +				    const void *sink_frame)
>  {
>  	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
>  						    ved);
> -	unsigned int i;
>  
>  	/* If the stream in this node is not active, just return */
>  	if (!vsca->src_frame)
> -		return;
> +		return ERR_PTR(-EINVAL);
>  
>  	vimc_sca_fill_src_frame(vsca, sink_frame);
>  
> -	/* Propagate the frame through all source pads */
> -	for (i = 1; i < vsca->sd.entity.num_pads; i++) {
> -		struct media_pad *pad = &vsca->sd.entity.pads[i];
> -
> -		vimc_propagate_frame(pad, vsca->src_frame);
> -	}
> +	return vsca->src_frame;
>  };
>  
>  static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 32ca9c6172b1..93961a1e694f 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -16,8 +16,6 @@
>   */
>  
>  #include <linux/component.h>
> -#include <linux/freezer.h>
> -#include <linux/kthread.h>
>  #include <linux/module.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/platform_device.h>
> @@ -201,38 +199,27 @@ static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
>  	.set_fmt		= vimc_sen_set_fmt,
>  };
>  
> -static int vimc_sen_tpg_thread(void *data)
> +static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
> +				    const void *sink_frame)
>  {
> -	struct vimc_sen_device *vsen = data;
> -	unsigned int i;
> -
> -	set_freezable();
> -	set_current_state(TASK_UNINTERRUPTIBLE);
> -
> -	for (;;) {
> -		try_to_freeze();
> -		if (kthread_should_stop())
> -			break;
> -
> -		tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> +	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
> +						    ved);
> +	const struct vimc_pix_map *vpix;
> +	unsigned int frame_size;
>  
> -		/* Send the frame to all source pads */
> -		for (i = 0; i < vsen->sd.entity.num_pads; i++)
> -			vimc_propagate_frame(&vsen->sd.entity.pads[i],
> -					     vsen->frame);
> +	/* Calculate the frame size */
> +	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
> +	frame_size = vsen->mbus_format.width * vpix->bpp *
> +		     vsen->mbus_format.height;
>  
> -		/* 60 frames per second */
> -		schedule_timeout(HZ/60);
> -	}
> -
> -	return 0;
> +	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
> +	return vsen->frame;
>  }
>  
>  static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>  	struct vimc_sen_device *vsen =
>  				container_of(sd, struct vimc_sen_device, sd);
> -	int ret;
>  
>  	if (enable) {
>  		const struct vimc_pix_map *vpix;
> @@ -258,26 +245,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>  		/* configure the test pattern generator */
>  		vimc_sen_tpg_s_format(vsen);
>  
> -		/* Initialize the image generator thread */
> -		vsen->kthread_sen = kthread_run(vimc_sen_tpg_thread, vsen,
> -					"%s-sen", vsen->sd.v4l2_dev->name);
> -		if (IS_ERR(vsen->kthread_sen)) {
> -			dev_err(vsen->dev, "%s: kernel_thread() failed\n",
> -				vsen->sd.name);
> -			vfree(vsen->frame);
> -			vsen->frame = NULL;
> -			return PTR_ERR(vsen->kthread_sen);
> -		}
>  	} else {
> -		if (!vsen->kthread_sen)
> -			return 0;
> -
> -		/* Stop image generator */
> -		ret = kthread_stop(vsen->kthread_sen);
> -		if (ret)
> -			return ret;
>  
> -		vsen->kthread_sen = NULL;
>  		vfree(vsen->frame);
>  		vsen->frame = NULL;
>  		return 0;
> @@ -413,6 +382,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  	if (ret)
>  		goto err_free_hdl;
>  
> +	vsen->ved.process_frame = vimc_sen_process_frame;
>  	dev_set_drvdata(comp, &vsen->ved);
>  	vsen->dev = comp;
>  
> diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
> new file mode 100644
> index 000000000000..06b0765cd035
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-streamer.c
> @@ -0,0 +1,188 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/*
> + * vimc-streamer.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2018 Lucas A. M. Magalhães <lucmaga@gmail.com>
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/freezer.h>
> +#include <linux/kthread.h>
> +
> +#include "vimc-streamer.h"
> +
> +/**
> + * vimc_get_source_entity - get the entity connected with the first sink pad
> + *
> + * @ent:	reference media_entity
> + *
> + * Helper function that returns the media entity containing the source pad
> + * linked with the first sink pad from the given media entity pad list.
> + */
> +static struct media_entity *vimc_get_source_entity(struct media_entity *ent)
> +{
> +	struct media_pad *pad;
> +	int i;
> +
> +	for (i = 0; i < ent->num_pads; i++) {
> +		if (ent->pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +			continue;
> +		pad = media_entity_remote_pad(&ent->pads[i]);
> +		return pad ? pad->entity : NULL;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * vimc_streamer_pipeline_terminate - Disable stream in all ved in stream
> + *
> + * @stream: the pointer to the stream structure with the pipeline to be
> + *	    disabled.
> + *
> + * Calls s_stream to disable the stream in each entity of the pipeline
> + *
> + */
> +static void vimc_streamer_pipeline_terminate(struct vimc_stream *stream)
> +{
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +
> +	while (stream->pipe_size) {
> +		stream->pipe_size--;
> +		entity = stream->ved_pipeline[stream->pipe_size]->ent;
> +		entity = vimc_get_source_entity(entity);
> +		stream->ved_pipeline[stream->pipe_size] = NULL;
> +
> +		if (!is_media_entity_v4l2_subdev(entity))
> +			continue;
> +
> +		sd = media_entity_to_v4l2_subdev(entity);
> +		v4l2_subdev_call(sd, video, s_stream, 0);
> +	}
> +}
> +
> +/*
> + * vimc_streamer_pipeline_init - initializes the stream structure
> + *
> + * @stream: the pointer to the stream structure to be initialized
> + * @ved:    the pointer to the vimc entity initializing the stream
> + *
> + * Initializes the stream structure. Walks through the entity graph to
> + * construct the pipeline used later on the streamer thread.
> + * Calls s_stream to enable stream in all entities of the pipeline.
> + */
> +static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
> +				       struct vimc_ent_device *ved)
> +{
> +	struct media_entity *entity;
> +	struct video_device *vdev;
> +	 struct v4l2_subdev *sd;
> +	int ret = 0;
> +
> +	stream->pipe_size = 0;
> +	while (stream->pipe_size < VIMC_STREAMER_PIPELINE_MAX_SIZE) {
> +		if (!ved) {
> +			vimc_streamer_pipeline_terminate(stream);
> +			return -EINVAL;
> +		}
> +		stream->ved_pipeline[stream->pipe_size++] = ved;
> +
> +		entity = vimc_get_source_entity(ved->ent);
> +		/* Check if the end of the pipeline was reached*/
> +		if (!entity)
> +			return 0;
> +
> +		if (is_media_entity_v4l2_subdev(entity)) {
> +			sd = media_entity_to_v4l2_subdev(entity);
> +			ret = v4l2_subdev_call(sd, video, s_stream, 1);
> +			if (ret && ret != -ENOIOCTLCMD) {
> +				vimc_streamer_pipeline_terminate(stream);
> +				return ret;
> +			}
> +			ved = v4l2_get_subdevdata(sd);
> +		} else {
> +			vdev = container_of(entity,
> +					    struct video_device,
> +					    entity);
> +			ved = video_get_drvdata(vdev);
> +		}
> +	}
> +
> +	vimc_streamer_pipeline_terminate(stream);
> +	return -EINVAL;
> +}
> +
> +static int vimc_streamer_thread(void *data)
> +{
> +	struct vimc_stream *stream = data;
> +	int i;
> +
> +	set_freezable();
> +	set_current_state(TASK_UNINTERRUPTIBLE);
> +
> +	for (;;) {
> +		try_to_freeze();
> +		if (kthread_should_stop())
> +			break;
> +
> +		for (i = stream->pipe_size - 1; i >= 0; i--) {
> +			stream->frame = stream->ved_pipeline[i]->process_frame(
> +					stream->ved_pipeline[i],
> +					stream->frame);
> +			if (!stream->frame)
> +				break;
> +			if (IS_ERR(stream->frame))
> +				break;
> +		}
> +		//wait for 60hz
> +		schedule_timeout(HZ / 60);
> +	}
> +
> +	return 0;
> +}
> +
> +int vimc_streamer_s_stream(struct vimc_stream *stream,
> +			   struct vimc_ent_device *ved,
> +			   int enable)
> +{
> +	int ret;
> +
> +	if (!stream || !ved)
> +		return -EINVAL;
> +
> +	if (enable) {
> +		if (stream->kthread)
> +			return 0;
> +
> +		ret = vimc_streamer_pipeline_init(stream, ved);
> +		if (ret)
> +			return ret;
> +
> +		stream->kthread = kthread_run(vimc_streamer_thread, stream,
> +					      "vimc-streamer thread");
> +
> +		if (IS_ERR(stream->kthread))
> +			return PTR_ERR(stream->kthread);
> +
> +	} else {
> +		if (!stream->kthread)
> +			return 0;
> +
> +		ret = kthread_stop(stream->kthread);
> +		if (ret)
> +			return ret;
> +
> +		stream->kthread = NULL;
> +
> +		vimc_streamer_pipeline_terminate(stream);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vimc_streamer_s_stream);
> +
> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Streamer");
> +MODULE_AUTHOR("Lucas A. M. Magalhães <lucmaga@gmail.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
> new file mode 100644
> index 000000000000..752af2e2d5a2
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-streamer.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +/*
> + * vimc-streamer.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2018 Lucas A. M. Magalhães <lucmaga@gmail.com>
> + *
> + */
> +
> +#ifndef _VIMC_STREAMER_H_
> +#define _VIMC_STREAMER_H_
> +
> +#include <media/media-device.h>
> +
> +#include "vimc-common.h"
> +
> +#define VIMC_STREAMER_PIPELINE_MAX_SIZE 16
> +
> +struct vimc_stream {
> +	struct media_pipeline pipe;
> +	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
> +	unsigned int pipe_size;
> +	u8 *frame;
> +	struct task_struct *kthread;
> +};
> +
> +/**
> + * vimc_streamer_s_streamer - start/stop the stream
> + *
> + * @stream:	the pointer to the stream to start or stop
> + * @ved:	The last entity of the streamer pipeline
> + * @enable:	any non-zero number start the stream, zero stop
> + *
> + */
> +int vimc_streamer_s_stream(struct vimc_stream *stream,
> +			   struct vimc_ent_device *ved,
> +			   int enable);
> +
> +#endif  //_VIMC_STREAMER_H_
> 
