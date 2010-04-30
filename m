Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54752 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab0D3RaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:01 -0400
Message-ID: <4BDA6E47.6050200@web.de>
Date: Fri, 30 Apr 2010 07:44:39 +0200
From: =?UTF-8?B?QW5kcsOpIFdlaWRlbWFubg==?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] TT S2-1600 allow more current for diseqc
References: <20100411231805.4bc7fdef@borg.bxl.tuxicoman.be>	 <4BD7E7A3.2060101@web.de> <20100428103303.2fe4c9ea@zombie>	 <r2y1a297b361004280613s10585a6we3d14ddb9de5bcfc@mail.gmail.com> <1272587465.3305.34.camel@pc07.localdom.local>
In-Reply-To: <1272587465.3305.34.camel@pc07.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,
On 30.04.2010 02:31, hermann pitton wrote:

> Hi,
>
> Am Mittwoch, den 28.04.2010, 17:13 +0400 schrieb Manu Abraham:
>> On Wed, Apr 28, 2010 at 12:33 PM, Guy Martin<gmsoft@tuxicoman.be>  wrote:
>>> On Wed, 28 Apr 2010 09:45:39 +0200
>>> André Weidemann<Andre.Weidemann@web.de>  wrote:
>>>
>>>> I advise not to pull this change into the kernel sources.
>>>> The card has only been testet with the a maximum current of 515mA.
>>>> Anything above is outside the specification for this card.
>>>
>>>
>>> I'm currently running two of these cards in the same box with this
>>> patch.
>>> Actually, later on I've even set curlim = SEC_CURRENT_LIM_OFF because
>>> sometimes diseqc wasn't working fine and that seemed to solve the
>>> problem.
>>
>> I would advise to not do this: since disabling current limiting etc
>> will cause a large problem in the case of a short circuit thereby no
>> protection to the hardware. In such an event, it could probably damage
>> the tracks carrying power on the card as well as the tracks on the
>> motherboard, and in some cases the gold finches themselves and or the
>> PCI connector.
>>
>> Generally, there are only a few devices capable of sourcing>  0.5A, So
>> I wonder ....
>>
>> Regards,
>> Manu
>
> for the few devices I do have, you seem to be for sure right.
>
> All the Creatix stuff drawing up to 900mA on a potentially dual isl6405
> has direct voltage from the PSU over an extra floppy connector.
>
> Max. 500mA should be sufficient with a DiSEqC 1.2 compliant rotor.
> Nothing else should come above that limit.
>
> I wonder, if someone close in reading specs just now, can tell if 900mA
> can be sufficient for two rotors ;)
>
> Andre, BTW, assuming you still have a CTX944 (md8800 Quad), can you
> measure if the 16be:0008 device really does switch between 13 and 18V.

You seem to mistake me for someone else. I do not have a CTX944 and 
never had.

Regards
  André
