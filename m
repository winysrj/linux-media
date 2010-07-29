Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61965 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab0G2RSa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 13:18:30 -0400
Date: 29 Jul 2010 19:15:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: awalls@md.metrocast.net
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTlN5mEJjFB@christoph>
In-Reply-To: <1280420775.32069.5.camel@maxim-laptop>
Subject: Re: [PATCH 0/9 v2] IR: few fixes, additions and ENE driver
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxim,

on 29 Jul 10 at 19:26, Maxim Levitsky wrote:
> On Thu, 2010-07-29 at 11:38 -0400, Andy Walls wrote:
>> On Thu, 2010-07-29 at 17:41 +0300, Maxim Levitsky wrote:
>>> On Thu, 2010-07-29 at 09:23 +0200, Christoph Bartelmus wrote:
>>>> Hi Maxim,
>>>>
>>>> on 29 Jul 10 at 02:40, Maxim Levitsky wrote:
>>>> [...]
>>>>> In addition to comments, I changed helper function that processes
>>>>> samples so it sends last space as soon as timeout is reached.
>>>>> This breaks somewhat lirc, because now it gets 2 spaces in row.
>>>>> However, if it uses timeout reports (which are now fully supported)
>>>>> it will get such report in middle.
>>>>>
>>>>> Note that I send timeout report with zero value.
>>>>> I don't think that this value is importaint.
>>>>
>>>> This does not sound good. Of course the value is important to userspace
>>>> and 2 spaces in a row will break decoding.
>>>>
>>>> Christoph
>>>
>>> Could you explain exactly how timeout reports work?
>>>
>>> Lirc interface isn't set to stone, so how about a reasonable compromise.
>>> After reasonable long period of inactivity (200 ms for example), space
>>> is sent, and then next report starts with a pulse.
>>> So gaps between keypresses will be maximum of 200 ms, and as a bonus I
>>> could rip of the logic that deals with remembering the time?
>>>
>>> Best regards,
>>> Maxim Levitsky

> So, timeout report is just another sample, with a mark attached, that
> this is last sample? right?

No, a timeout report is just an additional hint for the decoder that a  
specific amount of time has passed since the last pulse _now_.

[...]
> In that case, lets do that this way:
>
> As soon as timeout is reached, I just send lirc the timeout report.
> Then next keypress will start with pulse.

When timeout reports are enabled the sequence must be:
<pulse> <timeout> <space> <pulse>
where <timeout> is optional.

lircd will not work when you leave out the space. It must know the exact  
time between the pulses. Some hardware generates timeout reports that are  
too short to distinguish between spaces that are so short that the next  
sequence can be interpreted as a repeat or longer spaces which indicate  
that this is a new key press.

Christoph
