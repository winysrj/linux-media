Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:32939 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbeBJBWL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 20:22:11 -0500
Received: by mail-pg0-f54.google.com with SMTP id u1so4769227pgr.0
        for <linux-media@vger.kernel.org>; Fri, 09 Feb 2018 17:22:11 -0800 (PST)
Subject: Re: [PATCH] media: imx: csi: fix enum_mbus_code for unknown mbus
 format codes
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208144749.10558-1-p.zabel@pengutronix.de>
 <79024ebb-bb01-876a-9da9-4c65d3298112@gmail.com>
 <a578997e-f8e7-a663-97c1-eefe1141a772@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <b18a5c5e-7adc-8790-77e5-dab5364bd463@gmail.com>
Date: Fri, 9 Feb 2018 17:22:08 -0800
MIME-Version: 1.0
In-Reply-To: <a578997e-f8e7-a663-97c1-eefe1141a772@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 02/08/2018 12:01 PM, Hans Verkuil wrote:
> On 02/08/2018 08:27 PM, Steve Longerbeam wrote:
>>
>> On 02/08/2018 06:47 AM, Philipp Zabel wrote:
>>> If no imx_media_pixfmt is found for a given mbus format code,
>>> we shouldn't crash. Return -EINVAL for any index.
>> Hi Philipp,
>>
>> If imx_media_find_mbus_format() returns NULL at that location, it means
>> the current format has an invalid pixel code. It's not possible for an
>> ACTIVE
>> format to have an invalid code, so it must be a TRY format with an
>> uninitialized
>> (zero) code. Which makes sense if enum_mbus_code(TRY) pad op is called
>> before
>> set_fmt(TRY), at the sink pad, was *ever* called. Am I right?
>>
>> It looks there is another location where this could possibly happen, in
>> csi_try_fmt().
>> In that case it would happen if set_fmt(TRY) is called on a source pad,
>> before
>> set_fmt(TRY) was ever called at the sink pad. That's a weird corner case
>> because
>> it's not clear what a set_fmt(TRY) at the source pads should choose for
>> pixel
>> code if there was never a set_fmt(TRY) at the sink pad.
>>
>> But perhaps the following should be added to this patch as well. It
>> makes the
>> assumption that the TRY code at the sink pad is the same as the default
>> active code set from csi_registered().
>>
>> Or maybe I should ask the question, what should drivers do in set_fmt(TRY)
>> at their source pads, if there was no prior set_fmt(TRY) at their sink pads?
> Drivers can set the initial TRY value by implementing the init_cfg pad op.
> See e.g. drivers/media/platform/vimc/vimc-sensor.c.

Thanks. I will send a patch that implements init_cfg pad op in all
imx-media subdevs.

Steve

>
> I think you have two choices: either set it to some default format, or copy
> the current ACTIVE format. It doesn't really matter, as long as there is
> something valid.
>
> Many drivers will likely fail this test.
>
> Regards,
>
> 	Hans
>
>
