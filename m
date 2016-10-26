Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33937 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755579AbcJZOIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 10:08:02 -0400
Received: by mail-wm0-f44.google.com with SMTP id d128so13390094wmf.1
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 07:08:02 -0700 (PDT)
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
To: Ian Arkver <ian.arkver.dev@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1739314.RkalEXrcbu@avalon> <5800C80D.4000006@linaro.org>
 <2757849.cqAmgViGfT@avalon> <58109035.5030000@linaro.org>
 <5810931B.4070101@linaro.org>
 <e88eeb08-6d33-df4e-5d75-6606a4ffa0f3@gmail.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <5810B8BF.4020501@linaro.org>
Date: Wed, 26 Oct 2016 17:07:59 +0300
MIME-Version: 1.0
In-Reply-To: <e88eeb08-6d33-df4e-5d75-6606a4ffa0f3@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/26/2016 03:48 PM, Ian Arkver wrote:
> [snip]
>>>>>>> +static int ov5645_regulators_enable(struct ov5645 *ov5645)
>>>>>>> +{
>>>>>>> +    int ret;
>>>>>>> +
>>>>>>> +    ret = regulator_enable(ov5645->io_regulator);
>>>>>>> +    if (ret < 0) {
>>>>>>> +        dev_err(ov5645->dev, "set io voltage failed\n");
>>>>>>> +        return ret;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    ret = regulator_enable(ov5645->core_regulator);
>>>>>>> +    if (ret) {
>>>>>>> +        dev_err(ov5645->dev, "set core voltage failed\n");
>>>>>>> +        goto err_disable_io;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    ret = regulator_enable(ov5645->analog_regulator);
>>>>>>> +    if (ret) {
>>>>>>> +        dev_err(ov5645->dev, "set analog voltage failed\n");
>>>>>>> +        goto err_disable_core;
>>>>>>> +    }
>>>>>> How about using the regulator bulk API ? This would simplify the enable
>>>>>> and disable functions.
>>>>> The driver must enable the regulators in this order. I can see in the
>>>>> implementation of the bulk api that they are enabled again in order
>>>>> but I don't see stated anywhere that it is guaranteed to follow the
>>>>> same order in future. I'd prefer to keep it explicit as it is now.
>>>> I believe it should be an API guarantee, otherwise many drivers using the bulk
>>>> API would break. Mark, could you please comment on that ?
>>> Ok, let's wait for a response from Mark.
> I don't have the OV5645 datasheet, but I do have the OV5640 and OV5647 datasheets. Both of these show that AVDD should come up before DVDD where DVDD is externally supplied, although the minimum delay between them is 0ms. Both datasheets also imply that this requirement is only to allow host SCCB access on a shared I2C bus while the device is powering up. They imply that if one waits 20ms after power on then SCCB will be fine without this sequencing. Your code includes an msleep(20);

There is also requirement that DOVDD should become stable before AVDD (in both cases -
external or internal DVDD).

Aren't these requirements needed to allow I2C access to another device on the same I2C bus even during these 20ms?

> 
> Further, the reference schematic for the OV5647 shows three separate LDOs with no sequencing between them.
> 
> I've no comment on whether the bulk regulator API needs a "keep sequencing" flag or somesuch, but I don't think this device will drive that requirement.
> 
> Regards,
> Ian
> 

Best regards,
Todor

