Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.wa.amnet.net.au ([203.161.124.51]:57568 "EHLO
	smtp2.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab0AXH0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 02:26:46 -0500
Message-ID: <4B5BF61A.4000605@barber-family.id.au>
Date: Sun, 24 Jan 2010 15:26:18 +0800
From: Francis Barber <fedora@barber-family.id.au>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: New Hauppauge HVR-2200 Revision?
References: <4B5B0E12.3090706@barber-family.id.au>	 <83bcf6341001230700h7db6600i89b9092051049612@mail.gmail.com>	 <4B5B837A.6020001@barber-family.id.au>	 <83bcf6341001231529o54f3afb9p29fa955bc93a660e@mail.gmail.com>	 <4B5B8E5B.4020600@barber-family.id.au> <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com>
In-Reply-To: <83bcf6341001231618r59f03dc9t1eb746c39e67b5fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 24/01/2010 8:18 AM, Steven Toth wrote:
> http://www.kernellabs.com/blog/?page_id=17
>
> Firmware links from here.
>
> - Steve
>
> On Sat, Jan 23, 2010 at 7:03 PM, Francis Barber
> <fedora@barber-family.id.au>  wrote:
>    
>> On 24/01/2010 7:29 AM, Steven Toth wrote:
>>      
>>> I put some new patches into the saa7164-stable earlier today. These
>>> will probably help.
>>>
>>> www.kernellabs.com/hg/saa7164-stable
>>>
>>> Let me know.
>>>
>>> Regards,
>>>
>>> - Steve
>>>
>>>
>>>        
>> Thanks, I will give this a try later today.
>>
>> Presumably I should use the firmware from version 7.6.27.27323 (although
>> there doesn't seem to be any firmware corresponding to dvb-fe-tda10048 with
>> this download)?
>>
>> Regards,
>> Frank.
>>
>>      

Using a03ea24beafc from www.kernellabs.com/hg/saa7164-stable pretty 
well, thanks very much for working on this quickly!  As an aside, I'm 
interested as to why I should use the firmware from the older drivers.

The only problem with it now is that when I tune HD channels tzap 
consistently reports unc, for example:

status 1f | signal fefe | snr 00f6 | ber 0000000f | unc 0000006a | 
FE_HAS_LOCK
status 1f | signal fefe | snr 00f6 | ber 0000000e | unc 0000006a | 
FE_HAS_LOCK
status 1f | signal fefe | snr 00f6 | ber 00000012 | unc 0000006a | 
FE_HAS_LOCK

I can't see any problems when watching the channels, however (ie, the 
picture looks fine).

Thanks again,
Frank.
