Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40556 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3DLLge (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 07:36:34 -0400
Received: by mail-lb0-f180.google.com with SMTP id t11so2526359lbi.39
        for <linux-media@vger.kernel.org>; Fri, 12 Apr 2013 04:36:33 -0700 (PDT)
Message-ID: <5167F182.60600@cogentembedded.com>
Date: Fri, 12 Apr 2013 15:35:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	vladimir.barinov@cogentembedded.com, kernel@pengutronix.de
Subject: Re: [PATCH v2 2/2] adv7180: add more subdev video ops
References: <201304120208.09564.sergei.shtylyov@cogentembedded.com> <201304121005.28966.hverkuil@xs4all.nl>
In-Reply-To: <201304121005.28966.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12-04-2013 12:05, Hans Verkuil wrote:

> Thanks for the patch!

> I've got some comments about this, though.

> See below:

> On Fri April 12 2013 00:08:09 Sergei Shtylyov wrote:
>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>> Add subdev video ops for ADV7180 video decoder.  This makes decoder usable on
>> the soc-camera drivers.

>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>>   drivers/media/i2c/adv7180.c |  105 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 105 insertions(+)

>> Index: linux/drivers/media/i2c/adv7180.c
>> ===================================================================
>> --- linux.orig/drivers/media/i2c/adv7180.c
>> +++ linux/drivers/media/i2c/adv7180.c
[...]
>> @@ -397,10 +400,112 @@ static void adv7180_exit_controls(struct
>>   	v4l2_ctrl_handler_free(&state->ctrl_hdl);
>>   }
>>
>> +static int adv7180_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
>> +				 enum v4l2_mbus_pixelcode *code)
>> +{
>> +	if (index > 0)
>> +		return -EINVAL;
>> +
>> +	*code = V4L2_MBUS_FMT_YUYV8_2X8;
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv7180_try_mbus_fmt(struct v4l2_subdev *sd,
>> +				struct v4l2_mbus_framefmt *fmt)
>> +{
>> +	struct adv7180_state *state = to_state(sd);
>> +
>> +	adv7180_querystd(sd, &state->curr_norm);

> No, you must use the currently set std here. What querystd returns is
> effectively unpredictable, and that defeats the purpose of this try
> function. It is always up to the application to call querystd and then
> call s_std to set the standard explicitly. The same problem applies to
> the other calls to querystd in this patch.

    The current set/change of std is implemented in the initialization stage 
or in the interrupt handler. So it is not able to catch the change of STD if 
the h/w do not use the ADC7180 IRQ line. Implementation of polling scheme for 
systems without IRQ line used will provide unnecessary overhead. Hence the 
adv7180_querystd was added in order to update the state->curr_norm. Should 
this be changed to:

+    if (!state->irq)
+        adv7180_querystd(sd, &state->curr_norm);

?

[...]
>> +static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>> +{
>> +	struct adv7180_state *state = to_state(sd);
>> +
>> +	adv7180_querystd(sd, &state->curr_norm);
>> +
>> +	a->bounds.left = 0;
>> +	a->bounds.top = 0;
>> +	a->bounds.width = 720;
>> +	a->bounds.height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
>> +	a->defrect = a->bounds;
>> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	a->pixelaspect.numerator = 1;
>> +	a->pixelaspect.denominator = 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int adv7180_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>> +{
>> +	struct adv7180_state *state = to_state(sd);
>> +
>> +	adv7180_querystd(sd, &state->curr_norm);
>> +
>> +	a->c.left = 0;
>> +	a->c.top = 0;
>> +	a->c.width = 720;
>> +	a->c.height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
>> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +
>> +	return 0;
>> +}

> You are not actually implementing any cropping, so are these two ops really
> necessary?

    Thank you for the comment.
    You are right, cropping and not implemented and g_crop is not a demand for 
camera-soc
(the sample for minimal ops needed for camera-soc was taken from 
drivers/media/platform/
soc_camera/soc_camera_platform.c that also does not implement cropping via 
s_crop), but
cropcap currently is needed by some soc-camera drivers in order to determine 
the default
rectangle.

[...]

> Regards,
> 	Hans

WBR, Sergei

