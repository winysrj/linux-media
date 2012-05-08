Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64432 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab2EHPvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 11:51:50 -0400
Received: by vbbff1 with SMTP id ff1so2073984vbb.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 08:51:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8912304.YZOJNbqn9K@avalon>
References: <1335997148-4915-1-git-send-email-kartikmohta@gmail.com> <8912304.YZOJNbqn9K@avalon>
From: Kartik Mohta <kartikmohta@gmail.com>
Date: Tue, 8 May 2012 11:51:29 -0400
Message-ID: <CABPY-JfB7sHDsCSPMWEfaHW5GpgrDtn6On48YQLEQ4+WG=0Fmw@mail.gmail.com>
Subject: Re: [PATCH] mt9v032: Correct the logic for the auto-exposure setting
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, May 8, 2012 at 7:12 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Kartik,
>
> Thank you for the patch.
>
> On Wednesday 02 May 2012 18:19:08 Kartik Mohta wrote:
>> The driver uses the ctrl value passed in as a bool to determine whether
>> to enable auto-exposure, but the auto-exposure setting is defined as an
>> enum where AUTO has a value of 0 and MANUAL has a value of 1. This leads
>> to a reversed logic where if you send in AUTO, it actually sets manual
>> exposure and vice-versa.
>>
>> Signed-off-by: Kartik Mohta <kartikmohta@gmail.com>
>> ---
>>  drivers/media/video/mt9v032.c |    8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
>> index 75e253a..8ea8737 100644
>> --- a/drivers/media/video/mt9v032.c
>> +++ b/drivers/media/video/mt9v032.c
>> @@ -470,6 +470,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>>                       container_of(ctrl->handler, struct mt9v032, ctrls);
>>       struct i2c_client *client = v4l2_get_subdevdata(&mt9v032->subdev);
>>       u16 data;
>> +     int aec_value;
>>
>>       switch (ctrl->id) {
>>       case V4L2_CID_AUTOGAIN:
>> @@ -480,8 +481,13 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>>               return mt9v032_write(client, MT9V032_ANALOG_GAIN, ctrl->val);
>>
>>       case V4L2_CID_EXPOSURE_AUTO:
>> +             if(ctrl->val == V4L2_EXPOSURE_MANUAL)
>> +                     aec_value = 0;
>> +             else
>> +                     aec_value = 1;
>> +
>>               return mt9v032_update_aec_agc(mt9v032, MT9V032_AEC_ENABLE,
>> -                                           ctrl->val);
>> +                                           aec_value);
>
> What about just
>
>                return mt9v032_update_aec_agc(mt9v032, MT9V032_AEC_ENABLE,
>                                              !ctrl->val);
>
> If you're fine with that change I'll modify the patch accordingly, there's no
> need to resubmit (I'll of course keep the patch attribution).
>

That should work since the only supported exposure modes are auto and
manual with enum values 0 and 1 respectively, but then aren't you
depending on the values of the enum to not change in the future? Also
the change gives an impression that the value is a bool which it is
not. If that is fine, you can change it.

-- 
Kartik
