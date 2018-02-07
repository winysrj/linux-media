Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58148 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753580AbeBGJCb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 04:02:31 -0500
Subject: Re: [PATCH 5/5] add module parameters for default values
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-6-git-send-email-floe@butterbrot.org>
 <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>
 <039aaa61-4150-ebde-5f9e-a0ffc8888cfb@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c3f7b904-fb23-5925-0826-da5ad7ed84ad@xs4all.nl>
Date: Wed, 7 Feb 2018 10:02:24 +0100
MIME-Version: 1.0
In-Reply-To: <039aaa61-4150-ebde-5f9e-a0ffc8888cfb@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 09:33, Florian Echtler wrote:
> On 06.02.2018 22:31, Hans Verkuil wrote:
>> On 02/06/2018 10:01 PM, Florian Echtler wrote:
>>> To allow setting custom parameters for the sensor directly at startup, the
>>> three primary controls are exposed as module parameters in this patch.
>>>
>>> +/* module parameters */
>>> +static uint brightness = SUR40_BRIGHTNESS_DEF;
>>> +module_param(brightness, uint, 0644);
>>> +MODULE_PARM_DESC(brightness, "set default brightness");
>>> +static uint contrast = SUR40_CONTRAST_DEF;
>>> +module_param(contrast, uint, 0644);
>>> +MODULE_PARM_DESC(contrast, "set default contrast");
>>> +static uint gain = SUR40_GAIN_DEF;
>>> +module_param(gain, uint, 0644);
>>> +MODULE_PARM_DESC(contrast, "set default gain");
>>
>> contrast -> gain
> 
> Ah, typo. Thanks, will fix that.
> 
>> Isn't 'initial gain' better than 'default gain'?
> 
> Probably correct, yes.
> 
>> If I load this module with gain=X, will the gain control also
>> start off at X? I didn't see any code for that.
> 
> This reminds me: how can I get/set the control from inside the driver?
> Should I use something like the following:
> 
> struct v4l2_ctrl *ctrl = v4l2_ctrl_find(&sur40->ctrls, V4L2_CID_BRIGHTNESS);
> int val = v4l2_ctrl_g_ctrl(ctrl);
> // modify val...
> v4l2_ctrl_s_ctrl(ctrl, val);

Yes, that's correct. Usually drivers store the ctrl in their state struct
when they create the control. That way you don't have to find it.

> 
>> It might be useful to add the allowed range in the description.
>> E.g.: "set initial gain, range=0-255". Perhaps mention even the
>> default value, but I'm not sure if that's really needed.
> 
> Good point, though - right now the code directly sets the registers without any
> clamping, I guess it would be better to call the control framework as mentioned
> above?

Easiest is just to use this value for the default when you create the
control. Just clamp it first.

E.g.:

static uint gain = SUR40_GAIN_DEF;
module_param(gain, uint, 0644);

...

gain = clamp(gain, SUR40_GAIN_MIN, SUR40_GAIN_MAX);
v4l2_ctrl_new_std(&sur40->ctrls, &sur40_ctrl_ops, V4L2_CID_GAIN,
	  SUR40_GAIN_MIN, SUR40_GAIN_MAX, 1, gain);

You need to clamp gain first, otherwise v4l2_ctrl_new_std would fail
if the given default value is out of range.

Regards,

	Hans
