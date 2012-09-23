Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab2IWUld (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 16:41:33 -0400
Received: by bkcjk13 with SMTP id jk13so562504bkc.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 13:41:31 -0700 (PDT)
Message-ID: <505F65E8.6040601@googlemail.com>
Date: Sun, 23 Sep 2012 22:41:28 +0300
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ov2640: select sensor register bank before applying
 h/v-flip settings
References: <1348424926-12864-1-git-send-email-fschaefer.oss@googlemail.com> <Pine.LNX.4.64.1209232217260.31250@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209232217260.31250@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.09.2012 23:21, schrieb Guennadi Liakhovetski:
> Hi Frank
>
> On Sun, 23 Sep 2012, Frank Schäfer wrote:
>
>> We currently don't select the register bank in ov2640_s_ctrl, so we can end up
>> writing to DSP register 0x04 instead of sensor register 0x04.
>> This happens for example when calling ov2640_s_ctrl after ov2640_s_fmt.
> Yes, in principle, I agree, bank switching in the driver is not very... 
> consistent and also this specific case looks buggy. But, we have to fix 
> your fix.
>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> Cc: stable@kernel.org
>> ---
>>  drivers/media/i2c/soc_camera/ov2640.c |    8 ++++++++
>>  1 Datei geändert, 8 Zeilen hinzugefügt(+)
>>
>> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
>> index 78ac574..e4fc79e 100644
>> --- a/drivers/media/i2c/soc_camera/ov2640.c
>> +++ b/drivers/media/i2c/soc_camera/ov2640.c
>> @@ -683,8 +683,16 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
>>  	struct v4l2_subdev *sd =
>>  		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
>>  	struct i2c_client  *client = v4l2_get_subdevdata(sd);
>> +	struct regval_list regval;
>> +	int ret;
>>  	u8 val;
>>  
>> +	regval.reg_num = BANK_SEL;
>> +	regval.value = BANK_SEL_SENS;
>> +	ret = ov2640_write_array(client, &regval);
> This doesn't look right to me. ov2640_write_array() keeps writing register 
> address - value pairs to the hardware until it encounters an "ENDMARKER," 
> which you don't have here, so, it's hard to say what will be written to 
> the sensor... Secondly, you only have to write a single register here, for 
> this the driver is already using i2c_smbus_write_byte_data() directly, 
> please, do the same.

Argh, yes, you're right.
The mistake was to split this off from patch 3 to reduce changes for
stable...
I will combine both patches and resend the series.

Regards,
Frank

>
> Thanks
> Guennadi
>
>> +	if (ret < 0)
>> +		return ret;
>> +
>>  	switch (ctrl->id) {
>>  	case V4L2_CID_VFLIP:
>>  		val = ctrl->val ? REG04_VFLIP_IMG : 0x00;
>> -- 
>> 1.7.10.4
>>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

