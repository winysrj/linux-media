Return-path: <mchehab@pedra>
Received: from mout.perfora.net ([74.208.4.195]:54998 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202Ab0I0SmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Sep 2010 14:42:15 -0400
Message-ID: <4CA0E451.2010902@vorgon.com>
Date: Mon, 27 Sep 2010 11:37:05 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx5000 default auto sleep mode
References: <4BC5FB77.2020303@vorgon.com>	 <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com>	 <1271303099.7643.7.camel@palomino.walls.org> <h2h829197381004142139q35705f60q61dd04b05f509af6@mail.gmail.com> <4BE8B6B9.1070605@vorgon.com>
In-Reply-To: <4BE8B6B9.1070605@vorgon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I am seeing a problem again. driver I'm using is v4l-20100625. Don't 
know if the tuner card is dieing again or what. I had the sleep mode 
turned on and have been using the fusion dual along with a 1800. THe 
1800 shows as the 3rd device. Friday I had recordings setup on 2 
channels at the same time and one started recording the wrong channel 
with a lot of pixiling. When I used femon to try switching through 
tuners one tuner disapeared and then the other tuner switched to the 
channel the other was incorectly trying to record. Ended up restarting 
vdr and the drivers. Today I found that epg data was missing for several 
channels. When I used femon to switch tuners, the second tuner was no 
signal. I have turned the power save back off and restarted. Hopefully 
all 3 tuners will work tonight. This would be the second fusion HDTV7 to 
go bad and it is in a different computer running x63 instead of x32. So 
ether there is a bug in the drivers or theses are really crappy tuners.

On 5/10/2010 6:45 PM, Timothy D. Lenz wrote:
>
>
> On 4/14/2010 9:39 PM, Devin Heitmueller wrote:
>> On Wed, Apr 14, 2010 at 11:44 PM, Andy Walls<awalls@md.metrocast.net>
>> wrote:
>>> On Wed, 2010-04-14 at 13:40 -0400, Devin Heitmueller wrote:
>>>> On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz<tlenz@vorgon.com>
>>>> wrote:
>>>>> Thanks to Andy Walls, found out why I kept loosing 1 tuner on a
>>>>> FusionHD7
>>>>> Dual express. Didn't know linux supported an auto sleep mode on the
>>>>> tuner
>>>>> chips and that it defaulted to on. Seems like it would be better to
>>>>> default
>>>>> to off.
>>>>
>>>> Regarding the general assertion that the power management should be
>>>> disabled by default, I disagree. The power savings is considerable,
>>>> the time to bring the tuner out of sleep is negligible, and it's
>>>> generally good policy.
>>>>
>>>> Andy, do you have any actual details regarding the nature of the
>>>> problem?
>>>
>>> Not really. DViCo Fusion dual digital tv card. One side of the card
>>> would yield "black video screen" when starting a digital capture
>>> sometime after (?) the VDR ATSC EPG plugin tried to suck off data. I'm
>>> not sure there was a causal relationship.
>>>
>>> I hypothesized that one side of the dual-tuner was going stupid or one
>>> of the two channels used in the cx23885 was getting confused. I was
>>> looking at how to narrow the problem down to cx23885 chip or xc5000
>>> tuner, or s5h14xx demod when I noted the power managment module option
>>> for the xc5000. I suggested Tim try it.
>>>
>>> It was dumb luck that my guess actually made his symptoms go away.
>>>
>>> That's all I know.
>>
>> We did have a similar issue with the PCTV 800i. Basically, the GPIO
>> definition was improperly defined for the xc5000 reset callback. As a
>> result, it was strobing the reset on both the xc5000 *and* the
>> s5h1411, which would then cause the s5h1411's hardware state to not
>> match the driver state.
>>
>> After multiple round trips with the hardware engineer at PCTV, I
>> finally concluded that there actually wasn't a way to strobe the reset
>> without screwing up the demodulator, which prompted me to disable the
>> xc5000 reset callback (see cx88-cards:2944).
>>
>> My guess is that the reset GPIO definition for that board is wrong (a
>> problem exposed by this change), or that it's resetting the s5h1411 as
>> well.
>>
>> Devin
>>
>
>
> I replaced the single tuner with the other FusionHD7 Dual Express I had
> so there was two of the same cards. Within a few hours Both tuners where
> down on the original card and even restarting drivers wouldn't bring it
> back. So I moved the new card to it's slot and put the single back in in
> case the old card was defective. I removed the no power off switch and
> went out for awhile. When I came back vdr had crashed which often
> happens when it tried to tune and there is no signal as in when a tuner
> goes down. For some reason vdr/xine/xorg/vdpau combo is very unstable
> when signal is poor or missing. I wish we could dump xine as it seems to
> be the cause. I never had a problem with vdr crashing when it rained
> knocking out signal when the nexus card was providing video.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
