Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaLJKCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 05:02:11 -0500
Message-id: <54881A1F.2080607@samsung.com>
Date: Wed, 10 Dec 2014 11:02:07 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com>
In-reply-to: <54804840.4030202@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 12/04/2014 12:40 PM, Jacek Anaszewski wrote:

> On 12/04/2014 11:07 AM, Sakari Ailus wrote:
>> Hi Jacek,
>>
>> On Wed, Dec 03, 2014 at 05:06:41PM +0100, Jacek Anaszewski wrote:
>>> This patch adds device tree binding documentation for
>>> the flash cell of the Maxim max77693 multifunctional device.
>>>
>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Lee Jones <lee.jones@linaro.org>
>>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>>> Cc: Bryan Wu <cooloney@gmail.com>
>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Cc: <devicetree@vger.kernel.org>
>>> ---
>>>   Documentation/devicetree/bindings/mfd/max77693.txt |   89
>>> ++++++++++++++++++++
>>>   1 file changed, 89 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt
>>> b/Documentation/devicetree/bindings/mfd/max77693.txt
>>> index 01e9f30..25a6e78 100644
>>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>>> @@ -41,7 +41,66 @@ Optional properties:
>>>        To get more informations, please refer to documentaion.
>>>       [*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>>>
>>> +- led : the LED submodule device node
>>> +
>>> +There are two led outputs available - fled1 and fled2. Each of them can
>>> +control a separate led or they can be connected together to double
>>> +the maximum current for a single connected led. One led is represented
>>> +by one child node.
>>> +
>>> +Required properties:
>>> +- compatible : Must be "maxim,max77693-led".
>>> +
>>> +Optional properties:
>>> +- maxim,fleds : Array of current outputs in order: fled1, fled2.
>>> +    Note: both current outputs can be connected to a single led
>>> +    Possible values:
>>> +        MAX77693_LED_FLED_UNUSED - the output is left disconnected,
>>> +        MAX77693_LED_FLED_USED - a diode is connected to the output.
>>
>> As you have a LED sub-nodes for each LED already, isn't this redundant?
>
> Well, it seems so :)

I agreed here recklessly. This property allows to describe the
situation when one LED is connected to both outputs. Single sub-node
can describe two type of designs: one LED connected to a single
output or one LED connected to both outputs. Therefore additional
property is needed to assess what is the actual case.

Best Regards,
Jacek Anaszewski

