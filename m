Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38669 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbeKFV4Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 16:56:16 -0500
Received: by mail-wm1-f65.google.com with SMTP id l2-v6so11612729wmh.3
        for <linux-media@vger.kernel.org>; Tue, 06 Nov 2018 04:31:15 -0800 (PST)
From: Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [PATCH 2/2] media: ov5645: Report number of skip frames
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1529309219-27404-1-git-send-email-todor.tomov@linaro.org>
 <1529309219-27404-2-git-send-email-todor.tomov@linaro.org>
 <20180619040432.xbcrkgof6rycg3db@kekkonen.localdomain>
Message-ID: <6f9e1ca6-afee-ee03-7722-a0a991b0e9e5@linaro.org>
Date: Tue, 6 Nov 2018 14:31:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180619040432.xbcrkgof6rycg3db@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the reply and sorry for not following up on this for so long.

On 19.06.2018 07:04, Sakari Ailus wrote:
> Hi Todor,
> 
> On Mon, Jun 18, 2018 at 11:06:59AM +0300, Todor Tomov wrote:
>> The OV5645 supports automatic exposure (AE) and automatic white
>> balance (AWB). When streaming is started it takes up to 5 frames
>> until the AE and AWB converge and output a frame with good quality.
> 
> The frames aren't bad as such; it's just that the AE hasn't converged yet.
> I presume the number of the frames needed depends on the lighting
> conditions.

Yes, the number of frames (for AE and AWB converge) is different in
different conditions. From testing I see usually 4 frames are needed,
in more rare cases - 5 frames. The sensor doesn't provide any information
about the state of the algorithms - are they currently converged or not.
So the driver has no way to check that or tell for sure.

> 
> The g_skip_frames is intended to tell the frames really are bad, i.e.
> distorted or broken somehow.

I was about to say that if the exposure is severely wrong then they are
bad enough to not be used, which means that they are anyway bad, however...

> 
> I wouldn't discard them on the grounds of unconverged exposure. If we did,
> then on which other grounds should the frames be discarded as well? Does
> the white balance and focus need to be converged as well before considering
> the frames good, for instance?

...I agree that this measure for a bad vs not bad frame is quite subjective
(when we have no feedback about the state of the algorithms).

> 
> If you need this, I'd use a control instead to tell AE has converged.
> 
> I wonder what others think.

It would be nice to hear any ideas if anyone has any. I wonder whether the
driver can do anything useful besides leaving it to the userspace.

Best regards,
Todor

> 
>>
>> Implement g_skip_frames to report number of frames to be skipped
>> when streaming is started.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/i2c/ov5645.c | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>> index 1722cda..00bc3c0 100644
>> --- a/drivers/media/i2c/ov5645.c
>> +++ b/drivers/media/i2c/ov5645.c
>> @@ -70,6 +70,9 @@
>>  #define OV5645_SDE_SAT_U		0x5583
>>  #define OV5645_SDE_SAT_V		0x5584
>>  
>> +/* Number of frames needed for AE and AWB to converge */
>> +#define OV5645_NUM_OF_SKIP_FRAMES 5
>> +
>>  struct reg_value {
>>  	u16 reg;
>>  	u8 val;
>> @@ -1071,6 +1074,13 @@ static int ov5645_s_stream(struct v4l2_subdev *subdev, int enable)
>>  	return 0;
>>  }
>>  
>> +static int ov5645_get_skip_frames(struct v4l2_subdev *sd, u32 *frames)
>> +{
>> +	*frames = OV5645_NUM_OF_SKIP_FRAMES;
>> +
>> +	return 0;
>> +}
>> +
>>  static const struct v4l2_subdev_core_ops ov5645_core_ops = {
>>  	.s_power = ov5645_s_power,
>>  };
>> @@ -1088,10 +1098,15 @@ static const struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
>>  	.get_selection = ov5645_get_selection,
>>  };
>>  
>> +static const struct v4l2_subdev_sensor_ops ov5645_sensor_ops = {
>> +	.g_skip_frames = ov5645_get_skip_frames,
>> +};
>> +
>>  static const struct v4l2_subdev_ops ov5645_subdev_ops = {
>>  	.core = &ov5645_core_ops,
>>  	.video = &ov5645_video_ops,
>>  	.pad = &ov5645_subdev_pad_ops,
>> +	.sensor = &ov5645_sensor_ops,
>>  };
>>  
>>  static int ov5645_probe(struct i2c_client *client,
>> -- 
>> 2.7.4
>>
> 
