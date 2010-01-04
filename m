Return-path: <linux-media-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([203.16.214.141]:35546 "EHLO
	ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306Ab0ADNBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 08:01:52 -0500
Message-ID: <4B41E6BA.6000009@internode.on.net>
Date: Tue, 05 Jan 2010 00:01:46 +1100
From: Raena Lea-Shannon <raen@internode.on.net>
MIME-Version: 1.0
To: Samuel Rakitnican <samuel.rakitnican@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <op.u5yfmghz6dn9rq@crni.lan>
In-Reply-To: <op.u5yfmghz6dn9rq@crni.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Samuel Rakitnican wrote:
> On Sun, 03 Jan 2010 09:21:21 +0100, Raena Lea-Shannon 
> <raen@internode.on.net> wrote:
> 
>>
>>
>> istvan_v@mailbox.hu wrote:
>>> On 01/02/2010 05:10 PM, Raena Lea-Shannon wrote:
>>>
>>>> I have 2 TV Cards. The DTV2000 H Plus and a Technisat. The Technisat
>>>> works very well. I am trying to get the DVT working for other video
>>>> input devices such as VCR to make copies of old Videos and an inteface
>>>> for my N95 video out.
>>>>
>>>> I do not seem to be able to get it to find a tuner. Seems to be problem
>>>> finding the card. Any suggestions wold be greatly appreciated.
>>>  This card uses an Xceive XC4000 tuner, which is not supported yet.
>>> However, a driver for the tuner chip is being developed at
>>> kernellabs.com, so the card may become supported in the future.
>>> -- 
>> [snip]
>>
>> That seems odd. This patch on the LinuxTv site
>> http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html
>> seems to be using the cx88 drivers?
> 
> [...]
> 
> Hi,
> 
> I'm not a developer, but I think that your device uses both of these 
> chips. cx88 is the bridge chip, while the Xceive is the tuner chip. So, 
> both of them needs to be supported in order for a device to work properly.
> 
> Please see the following link for reference:
>     http://www.kernellabs.com/blog/?p=1045
> 
> Regards
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Thanks
