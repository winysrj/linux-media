Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:44920 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab1ILPKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Sep 2011 11:10:44 -0400
Message-ID: <4E6E20B5.2020004@tis.icnet.pl>
Date: Mon, 12 Sep 2011 17:09:41 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] media: ov6650: Fix wrong register used for red control
References: <201109121325.25986.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1109121343350.9638@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109121343350.9638@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> Hi Janusz
> 
> Thanks for the patch, but, since I anyway will have to re-roll my branch 
> on linuxtv, maybe I'll roll in your s/BLUE/RED/ hunk into the original 
> patch from Hans with a suitable
> 
> [jkrzyszt@tis.icnet.pl: fix a typo in the register name]
> 
> comment, and then add this your patch without that hunk and with an 
> amended description on top, would that be ok with you?

Yeah, that's exactly what I thought could be more appropriate.

Thanks,
Janusz

> 
> Thanks
> Guennadi
> 
> On Mon, 12 Sep 2011, Janusz Krzysztofik wrote:
> 
>> REG_BLUE has been used by mistake instead of REG_RED. Fix it.
>>
>> While being at it, fix a few minor issues:
>> * with no "retrun ret;" at the end, there is no need to initialize ret
>>   any longer,
>> * consequently use conditional expressions, not if...else constructs,
>>   throughout ov6650_s_ctrl(),
>> * v4l2_ctrl_new_std_menu() max value of V4L2_EXPOSURE_MANUAL instead of
>>   equivalent 1 looks more clear.
>>
>> Created on top of "Converting soc_camera to the control framework"
>> series.
>>
>> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
>> ---
>>  drivers/media/video/ov6650.c |   16 +++++++---------
>>  1 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
>> index 089a4aa..c0709ee 100644
>> --- a/drivers/media/video/ov6650.c
>> +++ b/drivers/media/video/ov6650.c
>> @@ -310,7 +310,7 @@ static int ov6550_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
>>  	struct v4l2_subdev *sd = &priv->subdev;
>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>  	uint8_t reg, reg2;
>> -	int ret = 0;
>> +	int ret;
>>  
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_AUTOGAIN:
>> @@ -342,7 +342,7 @@ static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
>>  	struct ov6650 *priv = container_of(ctrl->handler, struct ov6650, hdl);
>>  	struct v4l2_subdev *sd = &priv->subdev;
>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> -	int ret = 0;
>> +	int ret;
>>  
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_AUTOGAIN:
>> @@ -357,7 +357,7 @@ static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
>>  		if (!ret && !ctrl->val) {
>>  			ret = ov6650_reg_write(client, REG_BLUE, priv->blue->val);
>>  			if (!ret)
>> -				ret = ov6650_reg_write(client, REG_BLUE,
>> +				ret = ov6650_reg_write(client, REG_RED,
>>  							priv->red->val);
>>  		}
>>  		return ret;
>> @@ -370,10 +370,8 @@ static int ov6550_s_ctrl(struct v4l2_ctrl *ctrl)
>>  	case V4L2_CID_BRIGHTNESS:
>>  		return ov6650_reg_write(client, REG_BRT, ctrl->val);
>>  	case V4L2_CID_EXPOSURE_AUTO:
>> -		if (ctrl->val == V4L2_EXPOSURE_AUTO)
>> -			ret = ov6650_reg_rmw(client, REG_COMB, COMB_AEC, 0);
>> -		else
>> -			ret = ov6650_reg_rmw(client, REG_COMB, 0, COMB_AEC);
>> +		ret = ov6650_reg_rmw(client, REG_COMB, ctrl->val ==
>> +				V4L2_EXPOSURE_AUTO ? COMB_AEC : 0, COMB_AEC);
>>  		if (!ret && ctrl->val == V4L2_EXPOSURE_MANUAL)
>>  			ret = ov6650_reg_write(client, REG_AECH,
>>  						priv->exposure->val);
>> @@ -993,8 +991,8 @@ static int ov6650_probe(struct i2c_client *client,
>>  	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
>>  			V4L2_CID_BRIGHTNESS, 0, 0xff, 1, 0x80);
>>  	priv->autoexposure = v4l2_ctrl_new_std_menu(&priv->hdl,
>> -			&ov6550_ctrl_ops, V4L2_CID_EXPOSURE_AUTO, 1, 0,
>> -			V4L2_EXPOSURE_AUTO);
>> +			&ov6550_ctrl_ops, V4L2_CID_EXPOSURE_AUTO,
>> +			V4L2_EXPOSURE_MANUAL, 0, V4L2_EXPOSURE_AUTO);
>>  	priv->exposure = v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
>>  			V4L2_CID_EXPOSURE, 0, 0xff, 1, DEF_AECH);
>>  	v4l2_ctrl_new_std(&priv->hdl, &ov6550_ctrl_ops,
>> -- 
>> 1.7.3.4
>>
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

