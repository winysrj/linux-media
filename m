Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60623 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab0G2Tnt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 15:43:49 -0400
Date: 29 Jul 2010 21:35:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: awalls@md.metrocast.net
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTlNJJN3jFB@christoph>
References: <1280424946.32069.11.camel@maxim-laptop>
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Maxim Levitsky "maximlevitsky@gmail.com" wrote:
[...]
>>>>> Could you explain exactly how timeout reports work?
[...]
>>> So, timeout report is just another sample, with a mark attached, that
>>> this is last sample? right?
>>
>> No, a timeout report is just an additional hint for the decoder that a
>> specific amount of time has passed since the last pulse _now_.
>>
>> [...]
>>> In that case, lets do that this way:
>>>
>>> As soon as timeout is reached, I just send lirc the timeout report.
>>> Then next keypress will start with pulse.
>>
>> When timeout reports are enabled the sequence must be:
>> <pulse> <timeout> <space> <pulse>
>> where <timeout> is optional.
>>
>> lircd will not work when you leave out the space. It must know the exact
>> time between the pulses. Some hardware generates timeout reports that are
>> too short to distinguish between spaces that are so short that the next
>> sequence can be interpreted as a repeat or longer spaces which indicate
>> that this is a new key press.

> Let me give an example to see if I got that right.
>
>
> Suppose we have this sequence of reports from the driver:
>
> 500 (pulse)
> 200000 (timeout)
> 100000000 (space)
> 500 (pulse)
>
>
> Is that correct that time between first and second pulse is
> '100200000' ?

No, it's 100000000. The timeout is optional and just a hint to the decoder  
how much time has passed already since the last pulse. It does not change  
the meaning of the next space.

Christoph
