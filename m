Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.wa.amnet.net.au ([203.161.124.50]:51033 "EHLO
	smtp1.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0BMOfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Feb 2010 09:35:16 -0500
Message-ID: <4B76B895.9090305@barber-family.id.au>
Date: Sat, 13 Feb 2010 22:35:01 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: Steven Toth <steven.toth@mac.com>
CC: linux-media@vger.kernel.org
Subject: Re: New Hauppauge HVR-2200 Revision?
References: <4B5B0E12.3090706@barber-family.id.au> <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com> <4B5B837A.6020001@barber-family.id.au> <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com> <4B5B8E5B.4020600@barber-family.id.au> <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com> <4B5BF61A.4000605@barber-family.id.au> <4B73F6AC.5040803@barber-family.id.au> <4B7412CC.6010003@barber-family.id.au> <4B99D44B-A91C-4145-9317-EFA5AF9BD553@mac.com>
In-Reply-To: <4B99D44B-A91C-4145-9317-EFA5AF9BD553@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/2010 9:44 PM, Steven Toth wrote:
>>> Anyway, apart from the problems noted above it is fine.  I'm not sure what the criteria is for merging support for this card into the main repository, but I would view it as worthy of merging even with these problems outstanding.
>>>
>>> Many thanks,
>>> Frank.
>>>
>>>        
>> Interestingly, so far it only seems to affect the second adapter.  The first one is still working.
>>
>>      
>
> Odd.
>
> Francis,
>
> I find the whole ber/unc values puzzling, essentially they shouldn't happen assuming a good clean DVB-T signal. I'm going to look into this very shortly, along with a broad locking feature I want to change in the demod.
>
> I've had one or two other people comment on the -stable tree and in general they're pretty happy, including myself, which means that I'll be generating a pull request to have these changes merged very shortly (1-2 weeks).
>
> Regards,
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
>
>
>    
Hi Steve,

The unc is clearly wrong because when I watch the picture is fine.

Today I had the i2c error using the other adapter, and nothing seemed to 
be working until I reloaded the modules.

Feb 13 19:39:10 ent kernel: [1748208.155364] saa7164_api_i2c_read() 
error, ret(2) = 0x13
Feb 13 19:39:10 ent kernel: [1748208.155389] tda18271_read_regs: 
[1-0060|M] ERROR: i2c_transfer returned: -5

I think the reason I was only seeing it on the slave was because I was 
mainly using that adapter1.

Thanks again for your efforts,
Francis.
