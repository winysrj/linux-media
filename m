Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:34180 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZIOGHj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 02:07:39 -0400
Message-ID: <4AAF2F1B.2050206@cogweb.net>
Date: Mon, 14 Sep 2009 23:07:23 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Re: Audio drop on saa7134
References: <4AAEFEC9.3080405@cogweb.net>	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net>	 <1252988501.3250.62.camel@pc07.localdom.local>	 <4AAF232F.9060204@cogweb.net> <1252993000.3250.97.camel@pc07.localdom.local>
In-Reply-To: <1252993000.3250.97.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:
> Am Montag, den 14.09.2009, 22:16 -0700 schrieb David Liontooth:
>   
>> hermann pitton wrote:
>>     
>>> Am Montag, den 14.09.2009, 21:02 -0700 schrieb David Liontooth:
>>>   
>>>       
>>>> <snip>
>>>> We've been using saa7135 cards for several years with relatively few 
>>>> incidents, but they occasionally drop audio.
>>>> I've been unable to find any pattern in the audio drops, so I haven't 
>>>> reported it -- I have no way to reproduce the error, but it happens 
>>>> regularly, affecting between 3 and 5% of recordings. Audio will 
>>>> sometimes drop in the middle of a recording and then resume, or else 
>>>> work fine on the next recording.
>>>>     
>>>>         
>>> Hi Dave,
>>>
>>> hmm, losing audio on three to five percent of the recordings is a lot!
>>>
>>> When we started to talk to each other, we had only saa7134 PAL/SECAM
>>> devices over here.
>>>
>>> That has changed a lot, but still no System-M here.
>>>
>>> The kernel thread detecting audio on saa7133/35/31e behaves different
>>> from the one on saa7134.
>>>
>>> But if you let it run with audio_debug=1, you should have something in
>>> the logs when losing the audio. The kernel audio detection thread must
>>> have been started without success or id find the right thing again. I
>>> would assume caused by a weaker signal in between.
>>>
>>> Do you know about the insmod option audio_ddep?
>>>
>>> It is pretty hidden and I almost must look it up myself in the code.
>>>
>>> Cheers,
>>> Hermann
>>>
>>>   
>>>       
>> OK, I'll try running with audio_debug=1. Could you clarify what you mean 
>> by "The kernel audio detection thread must have been started without 
>> success or id find the right thing again"? An audio drop can be 
>> initiated at any point in the recording. A weak signal is a good guess, 
>> but I've never noticed a correlation with video quality.
>>     
>
> You said audio sometimes recovers, than the kernel thread did detect it
> again, else failed on the pilots.
>
>   
>> I didn't know about audio_ddep -- what does it do? I'm not seeing it in 
>> modinfo.
>>     
>
> Oh, are you sure?
>
>   
My mistake -- I'm running 2.6.19 and it's there.
>> It would be fantastic to get this problem solved -- we've had to record 
>> everything in parallel to avoid loss, and still very occasionally lose 
>> sound.
>>     
>
> It could also be something else, but that is the point to start.
>
> It stops the kernel audio detection thread and tells him to believe that
> only the norm given by insmod should be assumed.
>
> It is some hex in saa7134-audio, don't know it off hand for NTSC.
>
> Wait, i'll look it up. 0x40.
>   
Thank you! I'll try turning off the audio detection thread first, and 
then run debug.

 options saa7134 card=95,95,95,95 tuner=39,39,39,39 
audio_ddep=0x40,0x40,0x40,0x40 # audio_debug=9,9,9,9

It's a production system so I may need to wait until the weekend.

Cheers,
Dave

