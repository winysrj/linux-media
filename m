Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57494 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754483AbeBUPXS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:23:18 -0500
Subject: Re: [PATCH v9 07/11] media: i2c: ov772x: Support frame interval
 handling
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519059584-30844-8-git-send-email-jacopo+renesas@jmondi.org>
 <f154f229-6977-4d3e-38b9-6d1669adbf91@xs4all.nl> <20180221151644.GI7203@w540>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9a33f0c2-4bef-5c9f-906e-b1d6d44f6de6@xs4all.nl>
Date: Wed, 21 Feb 2018 16:23:10 +0100
MIME-Version: 1.0
In-Reply-To: <20180221151644.GI7203@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/18 16:16, jacopo mondi wrote:
>>>  static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
>>> -	.enum_mbus_code = ov772x_enum_mbus_code,
>>> -	.get_selection	= ov772x_get_selection,
>>> -	.get_fmt	= ov772x_get_fmt,
>>> -	.set_fmt	= ov772x_set_fmt,
>>> +	.enum_frame_interval	= ov772x_enum_frame_interval,
>>> +	.enum_mbus_code		= ov772x_enum_mbus_code,
>>> +	.get_selection		= ov772x_get_selection,
>>> +	.get_fmt		= ov772x_get_fmt,
>>> +	.set_fmt		= ov772x_set_fmt,
>>
>> Shouldn't these last four ops be added in the previous patch?
>> They don't have anything to do with the frame interval support.
>>
> 
> If you look closely you'll notice I have just re-aligned them, since I
> was at there to add enum_frame_interval operation

Ah, sorry. I missed that. Never mind then :-)

	Hans

> 
>> Anyway, after taking care of the memsets and these four ops you can add
>> my:
>>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thanks
>    j
> 
