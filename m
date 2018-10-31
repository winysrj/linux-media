Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:48336 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbeKAFbR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Nov 2018 01:31:17 -0400
Subject: Re: [PATCH 3/7] dt-bindings: pinctrl: ds90ux9xx: add description of
 TI DS90Ux9xx pinmux
To: Luca Ceresoli <luca@lucaceresoli.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181008211205.2900-1-vz@mleia.com> <8675619.KiXOS7fxCj@avalon>
 <9bd129b4-ce18-b036-9376-2cb1cb76aaf2@mentor.com> <2595665.eknevzee7a@avalon>
 <3bfa5338-16a0-f9e2-2c82-70af12e25fb1@lucaceresoli.net>
From: Vladimir Zapolskiy <vz@mleia.com>
Message-ID: <cef7b8f6-4591-86e2-f2c9-f97845ad840a@mleia.com>
Date: Wed, 31 Oct 2018 22:31:36 +0200
MIME-Version: 1.0
In-Reply-To: <3bfa5338-16a0-f9e2-2c82-70af12e25fb1@lucaceresoli.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Luca,

On 10/30/2018 06:44 PM, Luca Ceresoli wrote:
> Hi Vladimir,
> 
> On 16/10/18 14:48, Laurent Pinchart wrote:
>> Hi Vladimir,
>>
>> On Saturday, 13 October 2018 16:47:48 EEST Vladimir Zapolskiy wrote:
>>> On 10/12/2018 03:01 PM, Laurent Pinchart wrote:
>>>> On Tuesday, 9 October 2018 00:12:01 EEST Vladimir Zapolskiy wrote:
>>>>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>>>>
>>>>> TI DS90Ux9xx de-/serializers have a capability to multiplex pin
>>>>> functions, in particular a pin may have selectable functions of GPIO,
>>>>> GPIO line transmitter, one of I2S lines, one of RGB24 video signal lines
>>>>> and so on.
>>>>>
>>>>> The change adds a description of DS90Ux9xx pin multiplexers and GPIO
>>>>> controllers.
>>>>>
>>>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> [...]
>>>>> +Available pins, groups and functions (reference to device datasheets):
>>>>> +
>>>>> +function: "gpio" ("gpio4" is on DS90Ux925 and DS90Ux926 only,
>>>>> +		  "gpio9" is on DS90Ux940 only)
>>>>> + - pins: "gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6",
>>>>> +	 "gpio7", "gpio8", "gpio9"
>>>>> +
>>>>> +function: "gpio-remote"
>>>>> + - pins: "gpio0", "gpio1", "gpio2", "gpio3"
>>>>> +
>>>>> +function: "pass" (DS90Ux940 specific only)
>>>>> + - pins: "gpio0", "gpio3"
>>>>
>>>> What do those functions mean ?
>>>
>>> "gpio" function should be already familiar to you.
>>
>> I assume this function is only available for the local device, not the remote 
>> one ?
>>
>>> "gpio-remote" function is the pin function for a GPIO line bridging.
>>>
>>> "pass" function sets a pin to a status pin function for detecting
>>> display timing issues, namely DE or Vsync length value mismatch.
>>
>> All this is not clear at all from the proposed DT bindings, it should be 
>> properly documented.
> 
> It's not clear to me as well. The "gpio-remote" can mean two different
> things (at least in the camera serdes TI chips):
> 
>  - a GPIO input on the the *local* chip, replicated as an output on the
>    *remote* chip
>  - a GPIO input on the the *remote* chip, replicated as an output on the
>    *local* chip
> 
> How to you differentiate them in DT?
> 

"gpio-remote" function is directly translated into "GPIOx Remote Enable"
bit setting, the documentation says:

1) Deserializer IC pin configuration:

	Enable GPIO control from remote Serializer. The GPIO pin will
	be an output, and the value is received from the remote Serializer.

2) Serializer IC pin configuration:

	Enable GPIO control from remote Deserializer. The GPIO pin will
	be an output, and the value is received from the remote Deserializer.

So, it is always an output signal, the line signal is "bridged" (repeated)
as a corresponding line signal on a remote IC, note that there is no
difference between serializer and deserializer ICs.

> The "pass" function is also not clear. A comprehensive example would
> help a lot.

As this devicetree documentation says, the "pass" pin function is specific
for DS90Ux940 deserializer, I would suggest to check its datasheet for
getting a comprehensive answer, but I've already copy-pasted information
from the datasheet into my previous answer to Laurent.

The reason why the "pass" pin function is listed is quite simple, the
pin function interferes other pin functions, see DS90Ux940 GPIO0 and
GPIO3 controls, I hope I've managed to describe it properly by
DS90UX940_GPIO(0, ...) and DS90UX940_GPIO(3, ...) pin descriptions in
the pinctrl driver.

--
Best wishes,
Vladimir
