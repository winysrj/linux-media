Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38403 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbcIUOBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 10:01:18 -0400
Received: by mail-wm0-f44.google.com with SMTP id l132so93339847wmf.1
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2016 07:01:18 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] media: Add a driver for the ov5645 camera sensor.
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1467989679-29774-1-git-send-email-todor.tomov@linaro.org>
 <1467989679-29774-3-git-send-email-todor.tomov@linaro.org>
 <20160824101708.GI12130@valkosipuli.retiisi.org.uk>
 <57BDBC2F.7020902@linaro.org>
 <20160825071800.GK12130@valkosipuli.retiisi.org.uk>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, mchehab@osg.samsung.com,
        hverkuil@xs4all.nl, geert@linux-m68k.org, matrandg@cisco.com,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <57E292AB.9060808@linaro.org>
Date: Wed, 21 Sep 2016 17:01:15 +0300
MIME-Version: 1.0
In-Reply-To: <20160825071800.GK12130@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

One more question below:

On 08/25/2016 10:18 AM, Sakari Ailus wrote:
>>>> +
>>>> +static struct v4l2_subdev_core_ops ov5645_core_ops = {
>>>> +	.s_power = ov5645_s_power,
>>>> +};
>>>> +
>>>> +static struct v4l2_subdev_video_ops ov5645_video_ops = {
>>>> +	.s_stream = ov5645_s_stream,
>>>> +};
>>>> +
>>>> +static struct v4l2_subdev_pad_ops ov5645_subdev_pad_ops = {
>>>> +	.enum_mbus_code = ov5645_enum_mbus_code,
>>>> +	.enum_frame_size = ov5645_enum_frame_size,
>>>> +	.get_fmt = ov5645_get_format,
>>>> +	.set_fmt = ov5645_set_format,
>>>> +	.get_selection = ov5645_get_selection,
>>>
>>> Could you add init_cfg() pad op to initialise the try format and selections?
>>
>> Yes, I'll do that.

If I follow the code correctly this init_cfg() is called whenever the device is opened, right?
This means that the format will be reset to default values every time the userspace opens the device.
So I wonder if this is what we really want, or do we want to keep the last set format instead. For
example if we use media-ctl only to get the current format, this is already enough - it opens the
subdev node and resets the format to default.


-- 
Best regards,
Todor Tomov
