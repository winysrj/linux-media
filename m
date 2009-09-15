Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:35926 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZIOFQ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 01:16:56 -0400
Message-ID: <4AAF232F.9060204@cogweb.net>
Date: Mon, 14 Sep 2009 22:16:31 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: linux-media@vger.kernel.org
Subject: Audio drop on saa7134
References: <4AAEFEC9.3080405@cogweb.net>	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net> <1252988501.3250.62.camel@pc07.localdom.local>
In-Reply-To: <1252988501.3250.62.camel@pc07.localdom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:
> Am Montag, den 14.09.2009, 21:02 -0700 schrieb David Liontooth:
>   
>> <snip>
>> We've been using saa7135 cards for several years with relatively few 
>> incidents, but they occasionally drop audio.
>> I've been unable to find any pattern in the audio drops, so I haven't 
>> reported it -- I have no way to reproduce the error, but it happens 
>> regularly, affecting between 3 and 5% of recordings. Audio will 
>> sometimes drop in the middle of a recording and then resume, or else 
>> work fine on the next recording.
>>     
>
> Hi Dave,
>
> hmm, losing audio on three to five percent of the recordings is a lot!
>
> When we started to talk to each other, we had only saa7134 PAL/SECAM
> devices over here.
>
> That has changed a lot, but still no System-M here.
>
> The kernel thread detecting audio on saa7133/35/31e behaves different
> from the one on saa7134.
>
> But if you let it run with audio_debug=1, you should have something in
> the logs when losing the audio. The kernel audio detection thread must
> have been started without success or id find the right thing again. I
> would assume caused by a weaker signal in between.
>
> Do you know about the insmod option audio_ddep?
>
> It is pretty hidden and I almost must look it up myself in the code.
>
> Cheers,
> Hermann
>
>   
OK, I'll try running with audio_debug=1. Could you clarify what you mean 
by "The kernel audio detection thread must have been started without 
success or id find the right thing again"? An audio drop can be 
initiated at any point in the recording. A weak signal is a good guess, 
but I've never noticed a correlation with video quality.

I didn't know about audio_ddep -- what does it do? I'm not seeing it in 
modinfo.

It would be fantastic to get this problem solved -- we've had to record 
everything in parallel to avoid loss, and still very occasionally lose 
sound.

Cheers,
Dave



