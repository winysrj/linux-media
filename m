Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4469 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2GKGgJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 02:36:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH RFC] [media] adv7180.c: convert to v4l2 control framework
Date: Wed, 11 Jul 2012 08:34:53 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1341974086-27887-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1341974086-27887-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207110834.53760.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Federico!

A few small remarks:

On Wed July 11 2012 04:34:46 Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/media/video/adv7180.c |  221 +++++++++++++++++------------------------
>  1 file changed, 90 insertions(+), 131 deletions(-)
> 
> diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
> index 174bffa..7705456 100644
> --- a/drivers/media/video/adv7180.c
> +++ b/drivers/media/video/adv7180.c
> @@ -26,11 +26,10 @@
>  #include <media/v4l2-ioctl.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <linux/mutex.h>
>  
> -#define DRIVER_NAME "adv7180"
> -
>  #define ADV7180_INPUT_CONTROL_REG			0x00
>  #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
>  #define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
> @@ -55,21 +54,21 @@
>  
>  #define ADV7180_AUTODETECT_ENABLE_REG			0x07
>  #define ADV7180_AUTODETECT_DEFAULT			0x7f
> -
> +/* Contrast */
>  #define ADV7180_CON_REG		0x08	/*Unsigned */
> -#define CON_REG_MIN		0
> -#define CON_REG_DEF		128
> -#define CON_REG_MAX		255
> -
> +#define ADV7180_CON_MIN		0
> +#define ADV7180_CON_DEF		128
> +#define ADV7180_CON_MAX		255
> +/* Brightness*/
>  #define ADV7180_BRI_REG		0x0a	/*Signed */
> -#define BRI_REG_MIN		-128
> -#define BRI_REG_DEF		0
> -#define BRI_REG_MAX		127
> -
> +#define ADV7180_BRI_MIN		-128
> +#define ADV7180_BRI_DEF		0
> +#define ADV7180_BRI_MAX		127
> +/* Hue */
>  #define ADV7180_HUE_REG		0x0b	/*Signed, inverted */
> -#define HUE_REG_MIN		-127
> -#define HUE_REG_DEF		0
> -#define HUE_REG_MAX		128
> +#define ADV7180_HUE_MIN		-127
> +#define ADV7180_HUE_DEF		0
> +#define ADV7180_HUE_MAX		128
>  
>  #define ADV7180_ADI_CTRL_REG				0x0e
>  #define ADV7180_ADI_CTRL_IRQ_SPACE			0x20
> @@ -98,12 +97,12 @@
>  #define ADV7180_ICONF1_ACTIVE_LOW	0x01
>  #define ADV7180_ICONF1_PSYNC_ONLY	0x10
>  #define ADV7180_ICONF1_ACTIVE_TO_CLR	0xC0
> -
> +/* Saturation */
>  #define ADV7180_SD_SAT_CB_REG	0xe3	/*Unsigned */
>  #define ADV7180_SD_SAT_CR_REG	0xe4	/*Unsigned */
> -#define SAT_REG_MIN		0
> -#define SAT_REG_DEF		128
> -#define SAT_REG_MAX		255
> +#define ADV7180_SAT_MIN		0
> +#define ADV7180_SAT_DEF		128
> +#define ADV7180_SAT_MAX		255
>  
>  #define ADV7180_IRQ1_LOCK	0x01
>  #define ADV7180_IRQ1_UNLOCK	0x02
> @@ -121,18 +120,18 @@
>  #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND	0x4F
>  
>  struct adv7180_state {
> +	struct v4l2_ctrl_handler ctrl_hdl;
>  	struct v4l2_subdev	sd;
>  	struct work_struct	work;
>  	struct mutex		mutex; /* mutual excl. when accessing chip */
>  	int			irq;
>  	v4l2_std_id		curr_norm;
>  	bool			autodetect;
> -	s8			brightness;
> -	s16			hue;
> -	u8			contrast;
> -	u8			saturation;
>  	u8			input;
>  };
> +#define to_adv7180_sd(_ctrl) &container_of(_ctrl->handler,		\
> +					   struct adv7180_state,	\
> +					   ctrl_hdl)->sd
>  
>  static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
>  {
> @@ -237,7 +236,7 @@ static int adv7180_s_routing(struct v4l2_subdev *sd, u32 input,
>  	if (ret)
>  		return ret;
>  
> -	/*We cannot discriminate between LQFP and 40-pin LFCSP, so accept
> +	/* We cannot discriminate between LQFP and 40-pin LFCSP, so accept
>  	 * all inputs and let the card driver take care of validation
>  	 */
>  	if ((input & ADV7180_INPUT_CONTROL_INSEL_MASK) != input)
> @@ -316,117 +315,39 @@ out:
>  	return ret;
>  }
>  
> -static int adv7180_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> -{
> -	switch (qc->id) {
> -	case V4L2_CID_BRIGHTNESS:
> -		return v4l2_ctrl_query_fill(qc, BRI_REG_MIN, BRI_REG_MAX,
> -					    1, BRI_REG_DEF);
> -	case V4L2_CID_HUE:
> -		return v4l2_ctrl_query_fill(qc, HUE_REG_MIN, HUE_REG_MAX,
> -					    1, HUE_REG_DEF);
> -	case V4L2_CID_CONTRAST:
> -		return v4l2_ctrl_query_fill(qc, CON_REG_MIN, CON_REG_MAX,
> -					    1, CON_REG_DEF);
> -	case V4L2_CID_SATURATION:
> -		return v4l2_ctrl_query_fill(qc, SAT_REG_MIN, SAT_REG_MAX,
> -					    1, SAT_REG_DEF);
> -	default:
> -		break;
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int adv7180_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> -{
> -	struct adv7180_state *state = to_state(sd);
> -	int ret = mutex_lock_interruptible(&state->mutex);
> -	if (ret)
> -		return ret;
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_BRIGHTNESS:
> -		ctrl->value = state->brightness;
> -		break;
> -	case V4L2_CID_HUE:
> -		ctrl->value = state->hue;
> -		break;
> -	case V4L2_CID_CONTRAST:
> -		ctrl->value = state->contrast;
> -		break;
> -	case V4L2_CID_SATURATION:
> -		ctrl->value = state->saturation;
> -		break;
> -	default:
> -		ret = -EINVAL;
> -	}
> -
> -	mutex_unlock(&state->mutex);
> -	return ret;
> -}
> -
> -static int adv7180_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> +	struct v4l2_subdev *sd = to_adv7180_sd(ctrl);
>  	struct adv7180_state *state = to_state(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret = mutex_lock_interruptible(&state->mutex);
> +	int val;
> +
>  	if (ret)
>  		return ret;
> -
> +	val = ctrl->val;
>  	switch (ctrl->id) {
>  	case V4L2_CID_BRIGHTNESS:
> -		if ((ctrl->value > BRI_REG_MAX)
> -		    || (ctrl->value < BRI_REG_MIN)) {
> -			ret = -ERANGE;
> -			break;
> -		}
> -		state->brightness = ctrl->value;
> -		ret = i2c_smbus_write_byte_data(client,
> -						ADV7180_BRI_REG,
> -						state->brightness);
> +		ret = i2c_smbus_write_byte_data(client, ADV7180_BRI_REG, val);
>  		break;
>  	case V4L2_CID_HUE:
> -		if ((ctrl->value > HUE_REG_MAX)
> -		    || (ctrl->value < HUE_REG_MIN)) {
> -			ret = -ERANGE;
> -			break;
> -		}
> -		state->hue = ctrl->value;
>  		/*Hue is inverted according to HSL chart */
> -		ret = i2c_smbus_write_byte_data(client,
> -						ADV7180_HUE_REG, -state->hue);
> +		ret = i2c_smbus_write_byte_data(client, ADV7180_HUE_REG, -val);
>  		break;
>  	case V4L2_CID_CONTRAST:
> -		if ((ctrl->value > CON_REG_MAX)
> -		    || (ctrl->value < CON_REG_MIN)) {
> -			ret = -ERANGE;
> -			break;
> -		}
> -		state->contrast = ctrl->value;
> -		ret = i2c_smbus_write_byte_data(client,
> -						ADV7180_CON_REG,
> -						state->contrast);
> +		ret = i2c_smbus_write_byte_data(client, ADV7180_CON_REG, val);
>  		break;
>  	case V4L2_CID_SATURATION:
> -		if ((ctrl->value > SAT_REG_MAX)
> -		    || (ctrl->value < SAT_REG_MIN)) {
> -			ret = -ERANGE;
> -			break;
> -		}
>  		/*
>  		 *This could be V4L2_CID_BLUE_BALANCE/V4L2_CID_RED_BALANCE
>  		 *Let's not confuse the user, everybody understands saturation
>  		 */
> -		state->saturation = ctrl->value;
> -		ret = i2c_smbus_write_byte_data(client,
> -						ADV7180_SD_SAT_CB_REG,
> -						state->saturation);
> +		ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CB_REG,
> +						val);
>  		if (ret < 0)
>  			break;
> -		ret = i2c_smbus_write_byte_data(client,
> -						ADV7180_SD_SAT_CR_REG,
> -						state->saturation);
> +		ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CR_REG,
> +						val);
>  		break;
>  	default:
>  		ret = -EINVAL;
> @@ -436,6 +357,42 @@ static int adv7180_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
>  	return ret;
>  }
>  
> +static const struct v4l2_ctrl_ops adv7180_ctrl_ops = {
> +	.s_ctrl = adv7180_s_ctrl,
> +};
> +
> +static int adv7180_init_controls(struct adv7180_state *state)
> +{
> +	v4l2_ctrl_handler_init(&state->ctrl_hdl, 2);

2 -> 4, since there are 4 controls. It's a hint only, but it helps optimizing
the internal hash data structure.

> +
> +	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
> +			  V4L2_CID_BRIGHTNESS, ADV7180_BRI_MIN,
> +			  ADV7180_BRI_MAX, 1, ADV7180_BRI_DEF);
> +	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
> +			  V4L2_CID_CONTRAST, ADV7180_CON_MIN,
> +			  ADV7180_CON_MAX, 1, ADV7180_CON_DEF);
> +	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
> +			  V4L2_CID_SATURATION, ADV7180_SAT_MIN,
> +			  ADV7180_SAT_MAX, 1, ADV7180_SAT_DEF);
> +	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
> +			  V4L2_CID_HUE, ADV7180_HUE_MIN,
> +			  ADV7180_HUE_MAX, 1, ADV7180_HUE_DEF);
> +	state->sd.ctrl_handler = &state->ctrl_hdl;
> +	if (state->ctrl_hdl.error) {
> +		int err = state->ctrl_hdl.error;
> +
> +		v4l2_ctrl_handler_free(&state->ctrl_hdl);
> +		return err;
> +	}
> +	v4l2_ctrl_handler_setup(&state->ctrl_hdl);
> +
> +	return 0;
> +}
> +static void adv7180_exit_controls(struct adv7180_state *state)
> +{
> +	v4l2_ctrl_handler_free(&state->ctrl_hdl);
> +}
> +
>  static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>  	.querystd = adv7180_querystd,
>  	.g_input_status = adv7180_g_input_status,
> @@ -445,9 +402,9 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>  static const struct v4l2_subdev_core_ops adv7180_core_ops = {
>  	.g_chip_ident = adv7180_g_chip_ident,
>  	.s_std = adv7180_s_std,
> -	.queryctrl = adv7180_queryctrl,
> -	.g_ctrl = adv7180_g_ctrl,
> -	.s_ctrl = adv7180_s_ctrl,
> +	.queryctrl = v4l2_subdev_queryctrl,
> +	.g_ctrl = v4l2_subdev_g_ctrl,
> +	.s_ctrl = v4l2_subdev_s_ctrl,

If adv7180 is currently *only* used by bridge/platform drivers that also use
the control framework, then you can remove queryctrl/g/s_ctrl altogether.

>  };
>  
>  static const struct v4l2_subdev_ops adv7180_ops = {
> @@ -539,7 +496,7 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
>  
>  	/* register for interrupts */
>  	if (state->irq > 0) {
> -		ret = request_irq(state->irq, adv7180_irq, 0, DRIVER_NAME,
> +		ret = request_irq(state->irq, adv7180_irq, 0, KBUILD_MODNAME,
>  				  state);
>  		if (ret)
>  			return ret;
> @@ -582,26 +539,27 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
>  
>  	/*Set default value for controls */
>  	ret = i2c_smbus_write_byte_data(client, ADV7180_BRI_REG,
> -					state->brightness);
> +					ADV7180_BRI_DEF);
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = i2c_smbus_write_byte_data(client, ADV7180_HUE_REG, state->hue);
> +	ret = i2c_smbus_write_byte_data(client, ADV7180_HUE_REG,
> +					ADV7180_HUE_DEF);

It shouldn't be necessary to initialize the controls since v4l2_ctrl_handler_setup
does that for you already.

>  	if (ret < 0)
>  		return ret;
>  
>  	ret = i2c_smbus_write_byte_data(client, ADV7180_CON_REG,
> -					state->contrast);
> +					ADV7180_CON_DEF);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CB_REG,
> -					state->saturation);
> +					ADV7180_SAT_DEF);
>  	if (ret < 0)
>  		return ret;
>  
>  	ret = i2c_smbus_write_byte_data(client, ADV7180_SD_SAT_CR_REG,
> -					state->saturation);
> +					ADV7180_SAT_DEF);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -632,25 +590,26 @@ static __devinit int adv7180_probe(struct i2c_client *client,
>  	INIT_WORK(&state->work, adv7180_work);
>  	mutex_init(&state->mutex);
>  	state->autodetect = true;
> -	state->brightness = BRI_REG_DEF;
> -	state->hue = HUE_REG_DEF;
> -	state->contrast = CON_REG_DEF;
> -	state->saturation = SAT_REG_DEF;
>  	state->input = 0;
>  	sd = &state->sd;
>  	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);
>  
> -	ret = init_device(client, state);
> -	if (0 != ret)
> +	ret = adv7180_init_controls(state);
> +	if (ret)
>  		goto err_unreg_subdev;
> +	ret = init_device(client, state);
> +	if (ret)
> +		goto err_free_ctrl;
>  	return 0;
>  
> +err_free_ctrl:
> +	adv7180_exit_controls(state);
>  err_unreg_subdev:
>  	mutex_destroy(&state->mutex);
>  	v4l2_device_unregister_subdev(sd);
>  	kfree(state);
>  err:
> -	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", ret);
> +	printk(KERN_ERR KBUILD_MODNAME ": Failed to probe: %d\n", ret);
>  	return ret;
>  }
>  
> @@ -678,7 +637,7 @@ static __devexit int adv7180_remove(struct i2c_client *client)
>  }
>  
>  static const struct i2c_device_id adv7180_id[] = {
> -	{DRIVER_NAME, 0},
> +	{KBUILD_MODNAME, 0},
>  	{},
>  };
>  
> @@ -716,7 +675,7 @@ MODULE_DEVICE_TABLE(i2c, adv7180_id);
>  static struct i2c_driver adv7180_driver = {
>  	.driver = {
>  		   .owner = THIS_MODULE,
> -		   .name = DRIVER_NAME,
> +		   .name = KBUILD_MODNAME,
>  		   },
>  	.probe = adv7180_probe,
>  	.remove = __devexit_p(adv7180_remove),
> 

Regards,

	Hans
