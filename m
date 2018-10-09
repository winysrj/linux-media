Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53449 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725748AbeJJEWm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 00:22:42 -0400
Subject: Re: [PATCH 1/7] dt-bindings: mfd: ds90ux9xx: add description of TI
 DS90Ux9xx ICs
To: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sandeep Jain <Sandeep_Jain@mentor.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
References: <20181008211205.2900-1-vz@mleia.com>
 <20181008211205.2900-2-vz@mleia.com>
 <5631ac17-a1c1-af12-8b30-314880af42df@gmail.com>
 <4569f3e3-3812-f423-eda9-51e7a4d56a58@mleia.com>
 <d7536af1-d78f-6d20-81a0-288be1d67f25@mleia.com>
From: Marek Vasut <marek.vasut@gmail.com>
Message-ID: <c843687c-2897-464a-5ec8-a4f070b8e627@gmail.com>
Date: Tue, 9 Oct 2018 23:03:49 +0200
MIME-Version: 1.0
In-Reply-To: <d7536af1-d78f-6d20-81a0-288be1d67f25@mleia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/09/2018 10:55 PM, Vladimir Zapolskiy wrote:
> On 10/09/2018 02:11 PM, Vladimir Zapolskiy wrote:
>> Hi Marek,
>>
>> On 10/09/2018 03:13 AM, Marek Vasut wrote:
>>> On 10/08/2018 11:11 PM, Vladimir Zapolskiy wrote:
>>>> From: Sandeep Jain <Sandeep_Jain@mentor.com>
>>>>
>>>> The change adds device tree binding description of TI DS90Ux9xx
>>>> series of serializer and deserializer controllers which support video,
>>>> audio and control data transmission over FPD-III Link connection.
>>>>
> 
> [snip]
> 
>>>> +Optional properties:
>>>> +- reg : Specifies the I2C slave address of a local de-/serializer.
>>>> +- power-gpios : GPIO line to control supplied power to the device.
>>>
>>> Shouldn't this be regulator phandle ?
>>
>> It could be, right. I'll ponder upon it.
>>
> 
> No, it can not.
> 
> The property describes PDB "Power-down Mode Input Pin", it is a control
> pin with the predefined voltage, so regulator phandle is not applicable
> here.

Then the DT binding document needs updating, because this is completely
unclear and confusing.

-- 
Best regards,
Marek Vasut
