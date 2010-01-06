Return-path: <linux-media-owner@vger.kernel.org>
Received: from luna.schedom-europe.net ([193.109.184.86]:51743 "EHLO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab0AFSqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jan 2010 13:46:54 -0500
Message-ID: <4B44DA95.7050601@dommel.be>
Date: Wed, 06 Jan 2010 19:46:45 +0100
From: Johan <johan.vanderkolk@dommel.be>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: av7110 error reporting
References: <4B3BC2F2.30806@dommel.be> <201001060244.42935@orion.escape-edv.de>
In-Reply-To: <201001060244.42935@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss wrote:
> Hi,
>
> Johan wrote:
>   
>> I need some guidance on error messages..
>>
>> T
>> [ 7678.312025] dvb-ttpci: StartHWFilter error  buf 0b07 0010 0803 b96a  
>> ret 0  handle ffff
>>
>> These start as soon as I view or record a channel, and obviously fills 
>> up the log quickly.
>>
>> I believe the code that generates these messages is at the bottom of 
>> this message (part of av7110.c). This code was introduced in 2005 to 
>> improve error reporting.
>>     
>
> True.
>
>   
>> Currently I run today's v4l-dvb (using a hg update), and kernel 
>> 2.6.31-16. (Ubuntu), however the issue occurred in older combinations as 
>> well (over a year ago), so it is not introduced by the last kernels or 
>> DVB driverset.
>>
>> The message seems to be triggered by the variable "handle" being larger 
>> then 32. On my system it always reports ffff.
>>     
>
> Handle == ffff means that the av7110 was not able to create a new filter
> entry. This will happen if there are already 32 active filters.
>
> Does it happen for all channels, or only for a specific one?
> If the latter is true: Which channel is causing the problem?
> Does it have a large number of audio pids?
>
>   
>> Am I looking at faulty hardware, or can I resolve this issue more 
>> elegant than just disabling the fault report?
>> (keep in mind that I do not have a programming/coding background)
>>     
>
> You may disable the warning, but be warned that some parts of the data
> will not be recorded due to missing filter entries...
>
> Oliver
>
>   
Think I know why this is happening. Using Mplayer I see that dvb-ttpci 
is used by about 4-5 processes. No errors.
Using mythtv 0.22 lsmod reports dvb-ttpci being used by 31 processes. 
Errors.

My idea is that mythtv's multirec feature is causing this, even though I 
have not enabled any virtual tuner.
My card, an unmodified Nexus-s (from 1998) may not support multirec due 
to its hardware design. (took me quite a bit of googling to make this 
assumption).

So, if my assumption is correct, the error is with Mythtv, where it is 
assumed that my card is multirec capable. (and how would Mythtv know, 
since the driver is the same ?)

I have now bought an HVR4000, so I have time to mod the Nexus. (and dig 
out my reading glasses to find the pins)

Johan



