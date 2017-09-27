Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52970 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdI0SaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:30:11 -0400
Subject: Re: [PATCH] vimc: add test_pattern and h/vflip controls to the sensor
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <519c6f9f-178e-5ffa-e7a3-83057d31602a@xs4all.nl>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <1baf9c70-ef12-546e-ef25-7d7ab1058c2b@collabora.com>
Date: Wed, 27 Sep 2017 15:30:03 -0300
MIME-Version: 1.0
In-Reply-To: <519c6f9f-178e-5ffa-e7a3-83057d31602a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your patch and sorry for my late reply.
Please see my comments and questions below

On 2017-07-28 07:23 AM, Hans Verkuil wrote:
> Add support for the test_pattern control and the h/vflip controls.
> 
> This makes it possible to switch to more interesting test patterns and to
> test control handling in v4l-subdevs.
> 
> There are more tpg-related controls that can be added, but this is a good
> start.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
> index dca528a316e7..2e9981b18166 100644
> --- a/drivers/media/platform/vimc/vimc-common.h
> +++ b/drivers/media/platform/vimc/vimc-common.h
> @@ -22,6 +22,11 @@
>  #include <media/media-device.h>
>  #include <media/v4l2-device.h>
> 
> +/* VIMC-specific controls */
> +#define VIMC_CID_VIMC_BASE		(0x00f00000 | 0xf000)
> +#define VIMC_CID_VIMC_CLASS		(0x00f00000 | 1)

Why this values, shouldn't we use a derivative from
V4L2_CID_PRIVATE_BASE for custom controls? Or can we use random values?

> +#define VIMC_CID_TEST_PATTERN		(VIMC_CID_VIMC_BASE + 0)
> +
>  #define VIMC_FRAME_MAX_WIDTH 4096
>  #define VIMC_FRAME_MAX_HEIGHT 2160
>  #define VIMC_FRAME_MIN_WIDTH 16
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 615c2b18dcfc..532097566b27 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -22,6 +22,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/vmalloc.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-tpg.h>
> 
> @@ -38,6 +39,7 @@ struct vimc_sen_device {
>  	u8 *frame;
>  	/* The active format */
>  	struct v4l2_mbus_framefmt mbus_format;
> +	struct v4l2_ctrl_handler hdl;
>  };
> 
>  static const struct v4l2_mbus_framefmt fmt_default = {
> @@ -291,6 +293,31 @@ static const struct v4l2_subdev_ops vimc_sen_ops = {
>  	.video = &vimc_sen_video_ops,
>  };
> 
> +static int vimc_sen_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct vimc_sen_device *vsen =
> +		container_of(ctrl->handler, struct vimc_sen_device, hdl);
> +
> +	switch (ctrl->id) {
> +	case VIMC_CID_TEST_PATTERN:
> +		tpg_s_pattern(&vsen->tpg, ctrl->val);
> +		break;
> +	case V4L2_CID_HFLIP:
> +		tpg_s_hflip(&vsen->tpg, ctrl->val);
> +		break;
> +	case V4L2_CID_VFLIP:
> +		tpg_s_vflip(&vsen->tpg, ctrl->val);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops vimc_sen_ctrl_ops = {
> +	.s_ctrl = vimc_sen_s_ctrl,
> +};
> +
>  static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
>  				 void *master_data)
>  {
> @@ -299,10 +326,29 @@ static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
>  				container_of(ved, struct vimc_sen_device, ved);
> 
>  	vimc_ent_sd_unregister(ved, &vsen->sd);
> +	v4l2_ctrl_handler_free(&vsen->hdl);
>  	tpg_free(&vsen->tpg);
>  	kfree(vsen);
>  }
> 
> +/* Image Processing Controls */
> +static const struct v4l2_ctrl_config vimc_sen_ctrl_class = {
> +	.ops = &vimc_sen_ctrl_ops,
> +	.flags = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY,

I was wondering if it is really necessary to specify the ops and flags
in the class, as this is seems to me a meta control for the other
controls to be grouped in a class.

> +	.id = VIMC_CID_VIMC_CLASS,
> +	.name = "VIMC Controls",
> +	.type = V4L2_CTRL_TYPE_CTRL_CLASS,
> +};
> +
> +static const struct v4l2_ctrl_config vimc_sen_ctrl_test_pattern = {
> +	.ops = &vimc_sen_ctrl_ops,
> +	.id = VIMC_CID_TEST_PATTERN,
> +	.name = "Test Pattern",
> +	.type = V4L2_CTRL_TYPE_MENU,
> +	.max = TPG_PAT_NOISE,
> +	.qmenu = tpg_pattern_strings,
> +};
> +
>  static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  			      void *master_data)
>  {
> @@ -316,6 +362,20 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  	if (!vsen)
>  		return -ENOMEM;
> 
> +	v4l2_ctrl_handler_init(&vsen->hdl, 4);
> +
> +	v4l2_ctrl_new_custom(&vsen->hdl, &vimc_sen_ctrl_class, NULL);
> +	v4l2_ctrl_new_custom(&vsen->hdl, &vimc_sen_ctrl_test_pattern, NULL);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			V4L2_CID_VFLIP, 0, 1, 1, 0);
> +	v4l2_ctrl_new_std(&vsen->hdl, &vimc_sen_ctrl_ops,
> +			V4L2_CID_HFLIP, 0, 1, 1, 0);

Shouldn't we test the return values of the above functions? Or maybe not
because we should know what we are doing and this doesn't depend on the
user space.

> +	vsen->sd.ctrl_handler = &vsen->hdl;
> +	if (vsen->hdl.error) {
> +		ret = vsen->hdl.error;
> +		goto err_free_vsen;
> +	}
> +
>  	/* Initialize ved and sd */
>  	ret = vimc_ent_sd_register(&vsen->ved, &vsen->sd, v4l2_dev,
>  				   pdata->entity_name,
> @@ -323,7 +383,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>  				   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
>  				   &vimc_sen_ops);
>  	if (ret)
> -		goto err_free_vsen;
> +		goto err_free_hdl;
> 
>  	dev_set_drvdata(comp, &vsen->ved);
>  	vsen->dev = comp;
> @@ -342,6 +402,8 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
> 
>  err_unregister_ent_sd:
>  	vimc_ent_sd_unregister(&vsen->ved,  &vsen->sd);
> +err_free_hdl:
> +	v4l2_ctrl_handler_free(&vsen->hdl);
>  err_free_vsen:
>  	kfree(vsen);
> 


This conflicts a bit in the way I was preparing the optimization to
generate the pattern directly from the capture device as it will need to
propagate the changes from the controls in the sensor as well, but it
shouldn't be a problem to let the sensor to configure the tpg used in
the capture, I'll re-work my patch to include this.

Helen
