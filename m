Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:27256 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752882AbdF0JrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 05:47:22 -0400
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
To: Hans Verkuil <hverkuil@xs4all.nl>, Tony Lindgren <tony@atomide.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170626110711.GW3730@atomide.com>
 <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
 <20170627091421.GZ3730@atomide.com>
 <1d970218-d24a-d460-7d95-b31102d735f2@xs4all.nl>
From: Jyri Sarha <jsarha@ti.com>
Message-ID: <a6f7c3d6-f4a6-1dba-2da0-b36ea2dd8803@ti.com>
Date: Tue, 27 Jun 2017 12:47:15 +0300
MIME-Version: 1.0
In-Reply-To: <1d970218-d24a-d460-7d95-b31102d735f2@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/27/17 12:27, Hans Verkuil wrote:
> On 27/06/17 11:14, Tony Lindgren wrote:
>> * Hans Verkuil <hverkuil@xs4all.nl> [170627 01:39]:
>>> On 26/06/17 13:07, Tony Lindgren wrote:
>>>> Tomi,
>>>>
>>>> * Tomi Valkeinen <tomi.valkeinen@ti.com> [170428 04:15]:
>>>>> On 14/04/17 13:25, Hans Verkuil wrote:
>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>
>>>>>> The CEC pin was always pulled up, making it impossible to use it.
>>>> ...
>>>>
>>>>> Tony, can you queue this? It's safe to apply separately from the rest of
>>>>> the HDMI CEC work.
>>>>
>>>> So the dts changes are merged now but what's the status of the CEC driver
>>>> changes? Were there some issues as I don't see them in next?
>>>
>>> Tomi advised me to wait until a 'hotplug-interrupt-handling series' for the
>>> omap driver is merged to prevent conflicts. Last I heard (about 3 weeks ago)
>>> this was still pending review.
>>
>> OK thanks for the update.
>>
>> Adding Jyri to Cc, hopefully the CEC support allows also setting the
>> HDMI audio volume level on devices implementing it? Or am I too
>> optimistic? :)
> 
> I'm not quite sure what you mean. Do you want CEC to change the volume on the
> TV, or use the TV's remote to change the volume of the HDMI audio output of the
> omap4?
> 

There is no real volume on HDMI audio output as it is a digital
interface, but it should be possible to provide some volume control
using TV's volume trough CEC.

> Anyway, either is supported, but it requires a userspace implementation.
> 

A module to pulseaudio or some extra features to alsa-lib should be
generic enough (who knows, maybe there is already something).

Just an idea. If someone really needs this, the pieces to put it
together should be there.

Best regards,
Jyri

> Although TV remote control messages will be mapped to an input device, and if
> those are hooked up to the alsa audio volume, then this already works.
>> Regards,
> 
> 	Hans
> 
>>
>>> Tomi, any updates on this? It would be nice to get this in for 4.14.
>>
>> Yeah seems like we have real mainline kernel user needs for this one.
>>
>> Regards,
>>
>> Tony
>>
> 
