Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59823 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbbAMMzH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 07:55:07 -0500
Message-ID: <54B51579.8020807@xs4all.nl>
Date: Tue, 13 Jan 2015 13:54:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 14/16] [media] adv7180: Add fast switch support
References: <1421150481-30230-1-git-send-email-lars@metafoo.de> <1421150481-30230-15-git-send-email-lars@metafoo.de>
In-Reply-To: <1421150481-30230-15-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

A few small comments:

On 01/13/15 13:01, Lars-Peter Clausen wrote:
> In fast switch mode the adv7180 (and similar) can lock onto a new signal
> faster when switching between different inputs. As a downside though it is
> no longer able to auto-detect the incoming format.
> 
> The fast switch mode is exposed as a boolean v4l control that allows
> userspace applications to either enable or disable fast switch mode.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/media/i2c/adv7180.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 4d789c7..82c8296 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -127,6 +127,9 @@
>  #define ADV7180_REG_VPP_SLAVE_ADDR	0xFD
>  #define ADV7180_REG_CSI_SLAVE_ADDR	0xFE
>  
> +#define ADV7180_REG_FLCONTROL 0x40e0
> +#define ADV7180_FLCONTROL_FL_ENABLE 0x1
> +
>  #define ADV7180_CSI_REG_PWRDN	0x00
>  #define ADV7180_CSI_PWRDN	0x80
>  
> @@ -164,6 +167,8 @@
>  #define ADV7180_DEFAULT_CSI_I2C_ADDR 0x44
>  #define ADV7180_DEFAULT_VPP_I2C_ADDR 0x42
>  
> +#define V4L2_CID_ADV_FAST_SWITCH	(V4L2_CID_DV_CLASS_BASE + 0x1010)

You need to reserve a range for private controls in uapi/linux/v4l2-controls.h
(see e.g. V4L2_CID_USER_SAA7134_BASE). Currently only user class controls
have a range reservation, but it can be done for other control classes as well.
However, I would put this control in the user class anyway. The DV class isn't
really appropriate for an SDTV device.

> +
>  struct adv7180_state;
>  
>  #define ADV7180_FLAG_RESET_POWERED	BIT(0)
> @@ -509,6 +514,18 @@ static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
>  			break;
>  		ret = adv7180_write(state, ADV7180_REG_SD_SAT_CR, val);
>  		break;
> +	case V4L2_CID_ADV_FAST_SWITCH:
> +		if (ctrl->val) {
> +			/* ADI required write */
> +			adv7180_write(state, 0x80d9, 0x44);
> +			adv7180_write(state, ADV7180_REG_FLCONTROL,
> +				ADV7180_FLCONTROL_FL_ENABLE);
> +		} else {
> +			/* ADI required write */
> +			adv7180_write(state, 0x80d9, 0xc4);
> +			adv7180_write(state, ADV7180_REG_FLCONTROL, 0x00);
> +		}
> +		break;
>  	default:
>  		ret = -EINVAL;
>  	}
> @@ -521,6 +538,16 @@ static const struct v4l2_ctrl_ops adv7180_ctrl_ops = {
>  	.s_ctrl = adv7180_s_ctrl,
>  };
>  
> +static const struct v4l2_ctrl_config adv7180_ctrl_fast_switch = {
> +	.ops = &adv7180_ctrl_ops,
> +	.id = V4L2_CID_ADV_FAST_SWITCH,
> +	.name = "Fast switching",

This should be "Fast Switching" to be consistent with the standard control naming
convention.

> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.min = 0,
> +	.max = 1,
> +	.step = 1,
> +};
> +
>  static int adv7180_init_controls(struct adv7180_state *state)
>  {
>  	v4l2_ctrl_handler_init(&state->ctrl_hdl, 4);
> @@ -537,6 +564,8 @@ static int adv7180_init_controls(struct adv7180_state *state)
>  	v4l2_ctrl_new_std(&state->ctrl_hdl, &adv7180_ctrl_ops,
>  			  V4L2_CID_HUE, ADV7180_HUE_MIN,
>  			  ADV7180_HUE_MAX, 1, ADV7180_HUE_DEF);
> +	v4l2_ctrl_new_custom(&state->ctrl_hdl, &adv7180_ctrl_fast_switch, NULL);
> +
>  	state->sd.ctrl_handler = &state->ctrl_hdl;
>  	if (state->ctrl_hdl.error) {
>  		int err = state->ctrl_hdl.error;
> 

Regards,

	Hans
