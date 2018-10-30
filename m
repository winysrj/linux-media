Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:47594 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbeJaCHp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 22:07:45 -0400
Subject: Re: [PATCH 3/7] dt-bindings: pinctrl: ds90ux9xx: add description of
 TI DS90Ux9xx pinmux
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181008211205.2900-1-vz@mleia.com> <8675619.KiXOS7fxCj@avalon>
 <9bd129b4-ce18-b036-9376-2cb1cb76aaf2@mentor.com> <2595665.eknevzee7a@avalon>
From: Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <3bfa5338-16a0-f9e2-2c82-70af12e25fb1@lucaceresoli.net>
Date: Tue, 30 Oct 2018 17:44:06 +0100
MIME-Version: 1.0
In-Reply-To: <2595665.eknevzee7a@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On 16/10/18 14:48, Laurent Pinchart wrote:
> Hi Vladimir,
> 
> On Saturday, 13 October 2018 16:47:48 EEST Vladimir Zapolskiy wrote:
>> On 10/12/2018 03:01 PM, Laurent Pinchart wrote:
>>> On Tuesday, 9 October 2018 00:12:01 EEST Vladimir Zapolskiy wrote:
>>>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
>>>>
>>>> TI DS90Ux9xx de-/serializers have a capability to multiplex pin
>>>> functions, in particular a pin may have selectable functions of GPIO,
>>>> GPIO line transmitter, one of I2S lines, one of RGB24 video signal lines
>>>> and so on.
>>>>
>>>> The change adds a description of DS90Ux9xx pin multiplexers and GPIO
>>>> controllers.
>>>>
>>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
[...]
>>>> +Available pins, groups and functions (reference to device datasheets):
>>>> +
>>>> +function: "gpio" ("gpio4" is on DS90Ux925 and DS90Ux926 only,
>>>> +		  "gpio9" is on DS90Ux940 only)
>>>> + - pins: "gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6",
>>>> +	 "gpio7", "gpio8", "gpio9"
>>>> +
>>>> +function: "gpio-remote"
>>>> + - pins: "gpio0", "gpio1", "gpio2", "gpio3"
>>>> +
>>>> +function: "pass" (DS90Ux940 specific only)
>>>> + - pins: "gpio0", "gpio3"
>>>
>>> What do those functions mean ?
>>
>> "gpio" function should be already familiar to you.
> 
> I assume this function is only available for the local device, not the remote 
> one ?
> 
>> "gpio-remote" function is the pin function for a GPIO line bridging.
>>
>> "pass" function sets a pin to a status pin function for detecting
>> display timing issues, namely DE or Vsync length value mismatch.
> 
> All this is not clear at all from the proposed DT bindings, it should be 
> properly documented.

It's not clear to me as well. The "gpio-remote" can mean two different
things (at least in the camera serdes TI chips):

 - a GPIO input on the the *local* chip, replicated as an output on the
   *remote* chip
 - a GPIO input on the the *remote* chip, replicated as an output on the
   *local* chip

How to you differentiate them in DT?

The "pass" function is also not clear. A comprehensive example would
help a lot.

Bye,
-- 
Luca
