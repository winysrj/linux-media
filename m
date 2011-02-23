Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab1BWXw1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 18:52:27 -0500
Message-ID: <4D659DB7.8030300@redhat.com>
Date: Wed, 23 Feb 2011 20:52:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Question on V4L2 S_STD call
References: <AANLkTikqDACH2rVd6PBVr3eofnJP-UmD0bNDar9RDUoL@mail.gmail.com>	<4D658A40.9050604@redhat.com> <AANLkTimbNe6-YwydnRVc+Ng0aW1-9S_Gg6AKfbHaEdxp@mail.gmail.com>
In-Reply-To: <AANLkTimbNe6-YwydnRVc+Ng0aW1-9S_Gg6AKfbHaEdxp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-02-2011 19:56, Devin Heitmueller escreveu:
>>> However, the cx231xx has code for setting up the DIF which basically
>>> says:
>>>
>>> if (standard & V4L2_STD_MN) {
>>>  ...
>>> } else if ((standard == V4L2_STD_PAL_I) |
>>>                         (standard & V4L2_STD_PAL_D) |
>>>                       (standard & V4L2_STD_SECAM)) {
>>>  ...
>>> } else {
>>>   /* default PAL BG */
>>>   ...
>>> }
>>
>> This doesn't soung wrong to me.
> 
> If it were doing "standard == V4L2_STD_PAL_D" instead of "standard &
> V4L2_STD_PAL_D", then it would be behaving as you described.  But it's
> just checking to see if it's in the mask at all, which means if you
> pass "PAL", then you always get the second block.

PAL/D is one of the standards where "normal" PAL fits. I think that the
"old" drivers are all capable of auto-detecting between PAL/BGDK.

Assuming that the behaviour for PAL/D would be changed like you said (e. g.
choosing to support only PAL/BG if STD_PAL is selected), tvtime won't work 
with PAL/D, as it doesn't allow selecting PAL/D. 

Btw, PAL/K works properly, if set as PAL/BG on that part of the code? It
seems to be broken on other parts of the driver, like, for example, on
cx231xx_Get_Colibri_CarrierOffset(). I remember I had to make a fix there
for PAL/M and PAL/N to work at changeset 0f86158375308804f86d36c7d45aaff1d7dc0d96.

I suspect that some other fixes are needed anyway at the driver, as it seems
that there are some bad stuff for some video standards.

>> Basically, tvtime does the wrong thing with respect to video standards.
>>
>> The simplest fix is to enumerate the supported standards and to display
>> them to the userspace, letting userspace to select a standard, allowing
>> them to tell the driver what standard is needed, and not requiring a restart
>> if the user changes the video standard, especially if the number of
>> lines doesn't change.
>>
>> Another way would be to ask user where he lives and then tell the kernel
>> driver to use the standards available on that Country only. This won't work
>> 100%, as the user may want to force to a specific standard anyway (for
>> example, here, most STB's output signals in NTSC/M, but the broadcast and
>> official standard is PAL/M). People with equipments like VCR/game consoles
>> and other random stuff may also need to force it to PAL/60, NTSC/443, etc
>> for the composite/svideo ports.
>>
>> What most drivers do is to first select the more specific standards,
>> assuming that, if userspace is requesting a specific standard, this
>> should take precedence over the generic ones. If everything fails, go
>> to the default PAL standards.
> 
> Yeah, I was trying to provide as seamless an experience for users of
> existing applications that have been around forever, such as tvtime.
> While I admit that tvtime could definitely stand to improve in
> providing more flexibility to users, I was just trying to understand
> how applications such as this have managed to work the way it has for
> years without more people complaining.

Some drivers like tuner-core have "hack" parameters just because of tvtime
(and other applications?) that doesn't/don't allow properly selecting the 
video standard. The only real fix that will work is to change userspace
apps that don't do the right thing.

Cheers,
Mauro.
