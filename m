Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50904 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730119AbeHNLq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:46:27 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3] dt-bindings: media: adv748x: Document re-mappable
 addresses
To: Rob Herring <robh@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - FCP"
        <linux-renesas-soc@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20180809192944.7371-1-kieran.bingham@ideasonboard.com>
 <20180813174544.GA11379@rob-hp-laptop>
 <dedade62-91ed-2c92-dac7-fe4a8f9d9452@ideasonboard.com>
 <CAL_JsqJQNtRNq+b3sJ4eEse1pzWy3F-WgbDF7=t-TrvFx6WcUQ@mail.gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <e5f252b8-3188-b7a6-71fe-3c88be08d809@ideasonboard.com>
Date: Tue, 14 Aug 2018 10:00:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJQNtRNq+b3sJ4eEse1pzWy3F-WgbDF7=t-TrvFx6WcUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 13/08/18 23:48, Rob Herring wrote:
> On Mon, Aug 13, 2018 at 1:17 PM Kieran Bingham
> <kieran.bingham@ideasonboard.com> wrote:
>>
>> On 13/08/18 18:45, Rob Herring wrote:
>>> On Thu, Aug 09, 2018 at 08:29:44PM +0100, Kieran Bingham wrote:
>>>> The ADV748x supports configurable slave addresses for its I2C pages.
>>>> Document the page names, and provide an example for setting each of the
>>>> pages explicitly.
>>>
>>> It would be good to say why you need this.
>>
>> In fact - I should probably have added a fixes tag here, which would
>> have added more context:
>>
>> Fixes: 67537fe960e5 ("media: i2c: adv748x: Add support for
>> i2c_new_secondary_device")
> 
> That doesn't really explain things from a DT perspective.
> 
>> Should I repost with this fixes tag?
>> Or can it be collected with the RB tag?
> 
> I'll leave that to Hans.
> 
>>> The only use I can think of
>>> is if there are other devices on the bus and you need to make sure the
>>> addresses don't conflict.
>>
>> Yes, precisely. This driver has 'slave pages' which are created and
>> mapped by the driver. The device has default addresses which are used by
>> the driver - but it's very easy for these to conflict with other devices
>> on the same I2C bus.
>>
>> Because the mappings are simply a software construct, we have a means to
>> specify the desired mappings through DT at the board level - which
>> allows the boards to ensure that conflicts do not appear.
>>
>>
>>> Arguably, that information could be figured out without this in DT.
>>
>> How so ?
>>
>> Scanning the bus is error prone, and dependant upon driver state (and
>> presence), and we have no means currently of requesting 'free/unused'
>> addresses from the I2C core framework.
> 
> True. But assuming all devices are in DT, then you just need to scan
> the child nodes of the bus and get a map of the used addresses. Though
> if you had 2 or more devices like this, then you'd need to maintain
> s/w allocated addresses too. It could all be maintained with a bitmap
> which you initialize with addresses in DT.

We do indeed have cases with platforms which use the same device
populated twice:

See 1d26a5217187 ("ARM: dts: wheat: Fix ADV7513 address usage")

In that instance, a hardware bug means that if one of the two instances
of the ADV7513 goes into standby, it will respond to it's default
hardware slave map addresses. So because of this we must map *both*
instances to be non defaults. (and ideally, we'd want to mark the actual
defaults as unused - but - unusable; alas we don't have a means to do
that yet)


In the instance of this device (the adv748x) it has a default mapping at
address 0x30 for the CBUS page. We have an expansion board, which adds
GMSL cameras to the same board - of which reside on the same I2C bus -
and are fixed to use 0x30 as the base address for one of the components.
(Which even that then gets re-mapped - but it must be available to
perform the remap in the first place)

So we even have this concept of an address which is 'mostly' unused, but
must be available for use at certain stages of the probe sequences.
(There are 8 cameras attached, all with that same 0x30 address)


The GMSL expansion is an 'overlay' (it's actually just an include file
currently, but it /should/ be a DTO), and so I use this functionality to
remap the ADV748x maps to a 'free' block of address space.

Adding that patch [0] ([PATCH] arm64: dts: renesas: salvator-common:
adv748x: Override secondary addresses) was what led me to notice that I
had not updated the DT documentation for the feature, leading to this
patch :)

[0] https://www.spinics.net/lists/linux-renesas-soc/msg31194.html

-- 
Regards
--
Kieran
