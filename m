Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39903 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1AVQ3E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jan 2011 11:29:04 -0500
Received: by pwj3 with SMTP id 3so466921pwj.19
        for <linux-media@vger.kernel.org>; Sat, 22 Jan 2011 08:29:03 -0800 (PST)
Message-ID: <4D3B05CA.4060402@gmail.com>
Date: Sat, 22 Jan 2011 17:28:58 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com
Subject: Re: [PATCH 2/3] sr030pc30: Use the control framework
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com> <1295487842-23410-3-git-send-email-s.nawrocki@samsung.com> <201101202009.15015.hverkuil@xs4all.nl>
In-Reply-To: <201101202009.15015.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Hans,

On 2011-01-20 20:09, Hans Verkuil wrote:
> Hi Sylwester!
> 
> I have some review comments below...

Thank you for taking time to look at the patches.
> 
> On Thursday, January 20, 2011 02:44:01 Sylwester Nawrocki wrote:
>> Implement controls using the control framework.
>> Add horizontal/vertical flip controls, minor cleanup.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/sr030pc30.c |  311 +++++++++++++++++----------------------
>>  1 files changed, 132 insertions(+), 179 deletions(-)
>>
>> diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
>> index e1eced1..1a195f0 100644
>> --- a/drivers/media/video/sr030pc30.c
>> +++ b/drivers/media/video/sr030pc30.c
>> @@ -19,6 +19,8 @@
>>  #include <linux/i2c.h>
>>  #include <linux/delay.h>
>>  #include <linux/slab.h>
>> +#include <media/v4l2-chip-ident.h>
>> +#include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-subdev.h>
>>  #include <media/v4l2-mediabus.h>
>> @@ -141,17 +143,24 @@ module_param(debug, int, 0644);
>>  
>>  struct sr030pc30_info {
>>  	struct v4l2_subdev sd;
>> +	struct v4l2_ctrl_handler hdl;
>> +	struct {
>> +		/* exposure/auto-exposure cluster */
>> +		struct v4l2_ctrl *autoexposure;
>> +		struct v4l2_ctrl *exposure;
>> +	};
>> +	struct {
>> +		/* blue/red/autowhitebalance cluster */
>> +		struct v4l2_ctrl *autowb;
>> +		struct v4l2_ctrl *blue;
>> +		struct v4l2_ctrl *red;
>> +	};
>> +	struct v4l2_ctrl *hflip;
>> +	struct v4l2_ctrl *vflip;
>>  	const struct sr030pc30_platform_data *pdata;
>>  	const struct sr030pc30_format *curr_fmt;
>>  	const struct sr030pc30_frmsize *curr_win;
>> -	unsigned int auto_wb:1;
>> -	unsigned int auto_exp:1;
>> -	unsigned int hflip:1;
>> -	unsigned int vflip:1;
>>  	unsigned int sleep:1;
>> -	unsigned int exposure;
>> -	u8 blue_balance;
>> -	u8 red_balance;
>>  	u8 i2c_reg_page;
>>  };
>>  
>> @@ -172,52 +181,6 @@ struct i2c_regval {
>>  	u16 val;
>>  };
>>  
...
>> +
>>  static inline int set_i2c_page(struct sr030pc30_info *info,
>>  			       struct i2c_client *client, unsigned int reg)
>>  {
>> @@ -395,59 +363,56 @@ static int sr030pc30_pwr_ctrl(struct v4l2_subdev *sd,
>>  
>>  static inline int sr030pc30_enable_autoexposure(struct v4l2_subdev *sd, int on)
>>  {
>> -	struct sr030pc30_info *info = to_sr030pc30(sd);
>>  	/* auto anti-flicker is also enabled here */
>> -	int ret = cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
>> -	if (!ret)
>> -		info->auto_exp = on;
>> -	return ret;
>> +	return cam_i2c_write(sd, AE_CTL1_REG, on ? 0xDC : 0x0C);
>>  }
>>  
>>  static int sr030pc30_set_exposure(struct v4l2_subdev *sd, int value)
>>  {
>>  	struct sr030pc30_info *info = to_sr030pc30(sd);
>> -
>>  	unsigned long expos = value * info->pdata->clk_rate / (8 * 1000);
>> +	int ret;
>>  
>> -	int ret = cam_i2c_write(sd, EXP_TIMEH_REG, expos >> 16 & 0xFF);
>> +	ret = cam_i2c_write(sd, EXP_TIMEH_REG, expos >> 16 & 0xFF);
>>  	if (!ret)
>>  		ret = cam_i2c_write(sd, EXP_TIMEM_REG, expos >> 8 & 0xFF);
>>  	if (!ret)
>>  		ret = cam_i2c_write(sd, EXP_TIMEL_REG, expos & 0xFF);
>> -	if (!ret) { /* Turn off AE */
>> -		info->exposure = value;
>> +	if (!ret) /* Turn off AE */
>>  		ret = sr030pc30_enable_autoexposure(sd, 0);
>> -	}
>> +
>>  	return ret;
>>  }
>>  
>>  /* Automatic white balance control */
>>  static int sr030pc30_enable_autowhitebalance(struct v4l2_subdev *sd, int on)
>>  {
>> -	struct sr030pc30_info *info = to_sr030pc30(sd);
>> +	int ret;
>>  
>> -	int ret = cam_i2c_write(sd, AWB_CTL2_REG, on ? 0x2E : 0x2F);
>> +	ret = cam_i2c_write(sd, AWB_CTL2_REG, on ? 0x2E : 0x2F);
>>  	if (!ret)
>>  		ret = cam_i2c_write(sd, AWB_CTL1_REG, on ? 0xFB : 0x7B);
>> -	if (!ret)
>> -		info->auto_wb = on;
>>  
>>  	return ret;
>>  }
>>  
>> -static int sr030pc30_set_flip(struct v4l2_subdev *sd)
>> +/**
>> + * sr030pc30_set_flip - set image flipping
>> + * @sd: a pointer to the subdev to apply the seetings to
>> + * @hflip: 1 to enable or 0 to disable horizontal flip
>> + * @vflip: as above but for vertical flip
>> + */
>> +static int sr030pc30_set_flip(struct v4l2_subdev *sd, u32 hflip, u32 vflip)
>>  {
>> -	struct sr030pc30_info *info = to_sr030pc30(sd);
>> -
>>  	s32 reg = cam_i2c_read(sd, VDO_CTL2_REG);
>> +
>>  	if (reg < 0)
>>  		return reg;
>>  
>>  	reg &= 0x7C;
>> -	if (info->hflip)
>> -		reg |= 0x01;
>> -	if (info->vflip)
>> -		reg |= 0x02;
>> +	reg |= ((hflip & 0x1) << 0);
>> +	reg |= ((vflip & 0x1) << 1);
>> +
>>  	return cam_i2c_write(sd, VDO_CTL2_REG, reg | 0x80);
>>  }
> 
> These functions are now very small, so my suggestion is to move the code directly
> into the s_ctrl function.

yeah, that seems reasonable
> 
>>  
>> @@ -468,8 +433,8 @@ static int sr030pc30_set_params(struct v4l2_subdev *sd)
>>  		ret = cam_i2c_write(sd, ISP_CTL_REG(0),
>>  				info->curr_fmt->ispctl1_reg);
>>  	if (!ret)
>> -		ret = sr030pc30_set_flip(sd);
>> -
>> +		ret = sr030pc30_set_flip(sd, info->hflip->val,
>> +					 info->vflip->val);
> 
> Why is flip being set here? It seems out of place to me.

Indeed, there is no good reason for setting the flip register here.

> 
>>  	return ret;
>>  }
>>  
>> @@ -497,108 +462,48 @@ static int sr030pc30_try_frame_size(struct v4l2_mbus_framefmt *mf)
>>  	return -EINVAL;
>>  }
>>  
...
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_AUTO_WHITE_BALANCE:
>> -		sr030pc30_enable_autowhitebalance(sd, ctrl->value);
>> -		break;
>> -	case V4L2_CID_BLUE_BALANCE:
>> -		ret = sr030pc30_set_bluebalance(sd, ctrl->value);
>> -		break;
>> -	case V4L2_CID_RED_BALANCE:
>> -		ret = sr030pc30_set_redbalance(sd, ctrl->value);
>> -		break;
>> -	case V4L2_CID_EXPOSURE_AUTO:
>> -		sr030pc30_enable_autoexposure(sd,
>> -			ctrl->value == V4L2_EXPOSURE_AUTO);
>> -		break;
>> -	case V4L2_CID_EXPOSURE:
>> -		ret = sr030pc30_set_exposure(sd, ctrl->value);
>> -		break;
>> -	default:
>> -		return -EINVAL;
>> -	}
>> +		if (!ctrl->has_new)
>> +			ctrl->val = 0;

Hmm, looks like I merged the changes renaming "has_new" to "is_new"
to the wrong patch. Need to fix that too..
When there is a full support for one of our S5PV210 SoC based reference
boards in the mainline kernel the testing should get easier..

>>  
>> -	return ret;
>> -}
>> -
>> -static int sr030pc30_g_ctrl(struct v4l2_subdev *sd,
>> -			    struct v4l2_control *ctrl)
>> -{
>> -	struct sr030pc30_info *info = to_sr030pc30(sd);
>> +		ret = sr030pc30_enable_autowhitebalance(sd, ctrl->val);
>>  
>> -	v4l2_dbg(1, debug, sd, "%s: id: %d\n", __func__, ctrl->id);
>> +		if (!ret && !ctrl->val) {
>> +			ret = cam_i2c_write(sd, MWB_BGAIN_REG, info->blue->val);
>> +			if (!ret)
>> +				ret = cam_i2c_write(sd, MWB_RGAIN_REG,
>> +						    info->red->val);
>> +		}
>> +		return ret;
>>  
>> -	switch (ctrl->id) {
>> -	case V4L2_CID_AUTO_WHITE_BALANCE:
>> -		ctrl->value = info->auto_wb;
>> -		break;
>> -	case V4L2_CID_BLUE_BALANCE:
>> -		ctrl->value = info->blue_balance;
>> -		break;
>> -	case V4L2_CID_RED_BALANCE:
>> -		ctrl->value = info->red_balance;
>> -		break;
>>  	case V4L2_CID_EXPOSURE_AUTO:
>> -		ctrl->value = info->auto_exp;
>> -		break;
>> -	case V4L2_CID_EXPOSURE:
>> -		ctrl->value = info->exposure;
>> -		break;
>> +		if (!ctrl->has_new)
>> +			ctrl->val = V4L2_EXPOSURE_MANUAL;
>> +
>> +		if (ctrl->val == V4L2_EXPOSURE_MANUAL)
>> +			return sr030pc30_set_exposure(sd, info->exposure->val);
>> +		else
>> +			return sr030pc30_enable_autoexposure(sd, 1);
> 
> Setting up auto<foo> and <foo> controls like this is a bit tricky. I've
> converted several drivers recently and had to do quite a few of these. Based
> on that experience I will be posting a RFC patch this weekend adding special
> support for this to the control framework that simplifies life a bit.
> 
> So I'd appreciate it if you could test those changes with this driver and if
> all is OK, then I'll make a pull request for that and you can base your
> changes on top of that.

OK, I'll be happy to test your extension to the control framework,
hopefully I can do that next week, or at the latest the week after.
I've just noticed patches for the control framework on the mailing list.
I've reviewed them and didn't find, so far ;), any problems.

> 
>> +
>> +	case V4L2_CID_HFLIP:
>> +		return sr030pc30_set_flip(sd, ctrl->val,
>> +					  info->vflip->val);
>> +	case V4L2_CID_VFLIP:
>> +		return sr030pc30_set_flip(sd, info->hflip->val,
>> +					  ctrl->val);
> 
> Since hflip and vflip are set in one register, you might want to make them a
> cluster.

Yeah, that sounds like a good idea. I'll rework it that way.


Cheers,
Sylwester
