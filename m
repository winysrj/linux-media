Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34729 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942244AbcJZMsa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 08:48:30 -0400
Received: by mail-wm0-f66.google.com with SMTP id y138so3392955wme.1
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 05:48:29 -0700 (PDT)
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
To: Todor Tomov <todor.tomov@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        broonie@kernel.org
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1739314.RkalEXrcbu@avalon> <5800C80D.4000006@linaro.org>
 <2757849.cqAmgViGfT@avalon> <58109035.5030000@linaro.org>
 <5810931B.4070101@linaro.org>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <e88eeb08-6d33-df4e-5d75-6606a4ffa0f3@gmail.com>
Date: Wed, 26 Oct 2016 13:48:24 +0100
MIME-Version: 1.0
In-Reply-To: <5810931B.4070101@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[snip]
>>>>>> +static int ov5645_regulators_enable(struct ov5645 *ov5645)
>>>>>> +{
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	ret = regulator_enable(ov5645->io_regulator);
>>>>>> +	if (ret < 0) {
>>>>>> +		dev_err(ov5645->dev, "set io voltage failed\n");
>>>>>> +		return ret;
>>>>>> +	}
>>>>>> +
>>>>>> +	ret = regulator_enable(ov5645->core_regulator);
>>>>>> +	if (ret) {
>>>>>> +		dev_err(ov5645->dev, "set core voltage failed\n");
>>>>>> +		goto err_disable_io;
>>>>>> +	}
>>>>>> +
>>>>>> +	ret = regulator_enable(ov5645->analog_regulator);
>>>>>> +	if (ret) {
>>>>>> +		dev_err(ov5645->dev, "set analog voltage failed\n");
>>>>>> +		goto err_disable_core;
>>>>>> +	}
>>>>> How about using the regulator bulk API ? This would simplify the enable
>>>>> and disable functions.
>>>> The driver must enable the regulators in this order. I can see in the
>>>> implementation of the bulk api that they are enabled again in order
>>>> but I don't see stated anywhere that it is guaranteed to follow the
>>>> same order in future. I'd prefer to keep it explicit as it is now.
>>> I believe it should be an API guarantee, otherwise many drivers using the bulk
>>> API would break. Mark, could you please comment on that ?
>> Ok, let's wait for a response from Mark.
I don't have the OV5645 datasheet, but I do have the OV5640 and OV5647 
datasheets. Both of these show that AVDD should come up before DVDD 
where DVDD is externally supplied, although the minimum delay between 
them is 0ms. Both datasheets also imply that this requirement is only to 
allow host SCCB access on a shared I2C bus while the device is powering 
up. They imply that if one waits 20ms after power on then SCCB will be 
fine without this sequencing. Your code includes an msleep(20);

Further, the reference schematic for the OV5647 shows three separate 
LDOs with no sequencing between them.

I've no comment on whether the bulk regulator API needs a "keep 
sequencing" flag or somesuch, but I don't think this device will drive 
that requirement.

Regards,
Ian

