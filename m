Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39803 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1AWLWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 06:22:03 -0500
Received: by pva4 with SMTP id 4so533017pva.19
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 03:22:02 -0800 (PST)
Message-ID: <4D3C0F33.6060208@gmail.com>
Date: Sun, 23 Jan 2011 20:21:23 +0900
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com
Subject: Re: [PATCH 2/3] sr030pc30: Use the control framework
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com> <1295487842-23410-3-git-send-email-s.nawrocki@samsung.com> <201101202009.15015.hverkuil@xs4all.nl>
In-Reply-To: <201101202009.15015.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/21/2011 04:09 AM, Hans Verkuil wrote:
> Hi Sylwester!
> 
> I have some review comments below...
> 
> On Thursday, January 20, 2011 02:44:01 Sylwester Nawrocki wrote:
>> Implement controls using the control framework.
>> Add horizontal/vertical flip controls, minor cleanup.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>>   drivers/media/video/sr030pc30.c |  311 +++++++++++++++++----------------------
>>   1 files changed, 132 insertions(+), 179 deletions(-)
>>
...
>> -
>> -static int sr030pc30_s_ctrl(struct v4l2_subdev *sd,
>> -			    struct v4l2_control *ctrl)
>> +static int sr030pc30_s_ctrl(struct v4l2_ctrl *ctrl)
>>   {
>> -	int i, ret = 0;
>> -
>> -	for (i = 0; i<  ARRAY_SIZE(sr030pc30_ctrl); i++)
>> -		if (ctrl->id == sr030pc30_ctrl[i].id)
>> -			break;
>> -
>> -	if (i == ARRAY_SIZE(sr030pc30_ctrl))
>> -		return -EINVAL;
>> -
>> -	if (ctrl->value<  sr030pc30_ctrl[i].minimum ||
>> -		ctrl->value>  sr030pc30_ctrl[i].maximum)
>> -			return -ERANGE;
>> +	struct v4l2_subdev *sd = to_sd(ctrl);
>> +	struct sr030pc30_info *info = to_sr030pc30(sd);
>> +	int ret = 0;
>>
>> -	v4l2_dbg(1, debug, sd, "%s: ctrl_id: %d, value: %d\n",
>> -			 __func__, ctrl->id, ctrl->value);
>> +	v4l2_dbg(1, debug, sd, "%s: ctrl id: %d, value: %d\n",
>> +			 __func__, ctrl->id, ctrl->val);
>>
>>   	switch (ctrl->id) {
>>   	case V4L2_CID_AUTO_WHITE_BALANCE:
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
>> +		if (!ret&&  !ctrl->val) {
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
>>   	case V4L2_CID_EXPOSURE_AUTO:
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
> Setting up auto<foo>  and<foo>  controls like this is a bit tricky. I've
> converted several drivers recently and had to do quite a few of these. Based
> on that experience I will be posting a RFC patch this weekend adding special
> support for this to the control framework that simplifies life a bit.
> 
> So I'd appreciate it if you could test those changes with this driver and if
> all is OK, then I'll make a pull request for that and you can base your
> changes on top of that.
> 

I have converted sr030pc30 already just need to do testing when I get my hands
on the hardware. With your foo/auto-foo for V4L2_CID_EXPOSURE_AUTO I did:

	case V4L2_CID_EXPOSURE_AUTO:
	        if (ctrl->val == V4L2_EXPOSURE_MANUAL)
                        ret = sr030pc30_set_exposure(sd, info->exposure->val);

                /* Set autoexposure and auto anti-flicker. */
                if (!ret)
                        return cam_i2c_write(sd, AE_CTL1_REG,
                                             ctrl->val == V4L2_EXPOSURE_MANUAL ?
                                             0xDC : 0x0C);
                return ret;
 
Is the change with foo/auto-foo controls support in v4l2 core only about
that the "is_new" flag don't have to be checked in s_ctrl for each control
and ctrl->val reassigned there?


Regards,
Sylwester
