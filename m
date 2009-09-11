Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55835 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZIKRu3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 13:50:29 -0400
Received: by bwz19 with SMTP id 19so950436bwz.37
        for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 10:50:31 -0700 (PDT)
Date: Fri, 11 Sep 2009 20:50:30 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
Message-ID: <20090911175030.GA10479@moon>
References: <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi> <20090910171631.GA4423@moon> <20090910193916.GA4923@moon> <4AAA60D0.50706@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAA60D0.50706@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2009 at 05:38:08PM +0300, Antti Palosaari wrote:
> On 09/10/2009 10:39 PM, Aleksandr V. Piskunov wrote:
>> On Thu, Sep 10, 2009 at 08:16:31PM +0300, Aleksandr V. Piskunov wrote:
>>> On Thu, Sep 10, 2009 at 05:48:22PM +0300, Antti Palosaari wrote:
>>>> Here it is, USB2.0 URB is now about 16k both af9015 and ce6230 devices.
>>>> Now powertop shows only about 220 wakeups on my computer for the both
>>>> sticks.
>>>> Please test and tell what powertop says:
>>>> http://linuxtv.org/hg/~anttip/urb_size/
>>>>
>>>> I wonder if we can decide what URB size DVB USB drivers should follow
>>>> and even add new module param for overriding driver default.
>>>
>>> Thanks, Antti!
>>>
>>> Tested your branch on affected system.
>>>
>>> Load definitely went down, from ~7000 wakeups to ~250 for each tuner
>>> according to powertop.
>>> Both tuners still working ok if not used simultaneously or if used the
>>> same time on different USB controllers.
>>>
>>> Bad news are that original problem still persists: putting both tuners
>>> on same USB controller and zapping simultaneously corrupts stream.
>>> Interesting observation: no matter in what sequence tuners are connected
>>> (i.e. become adapter0 or adapter1), af9015 stream always gets heavily
>>> distorted, visually mplayer picture becomes like 80% corrupted with
>>> random color blocks and pixels, sound becomes a mess. At the same time
>>> ce6230 gets slight corruption, a few discolored blocks at the time and
>>> sound hickups.
>>>
>>> Anyway, will try to do a few more tests:
>>> 1) Two usb flash drives on same controller calculating md5sum of
>>> big .iso file, to check if it is/isn't dvb-usb problem.
>>> 2) Will see if same issue persists on another PC with same motherboard
>>> (slightly different revision) to rule out hardware issues. If I manage
>>> to wire antenna there, that is...
>>
>> Ok, two USB flash drives on same controller, no problem when bulk reading
>> from both at the same time, no speed drops, no corruption.
>>
>> Now if I plug ce6230 tuner, zap to channel and then start reading from
>> flash drive:
>> * slightly corrupted TS stream
>> * flash drive read getting starved on bandwidth, speed drops from 10 MB/s
>>    to ~7 MB/s
>>
>> If I plug af9015 tuner, zap and read from flash
>> * heavy corruption of TS stream
>> * flash drive read speed drops from 10 MB/s to 2(!) MB/s
>>
>> Now I don't really know the USB protocol under-the-hood details, all the
>> different types of bandwidth, reservation and so on. But shouldn't one
>> 480 Mbit/sec controller handle rather large number of digital tuners, each
>> pushing 20-25 Mbit/sec max, even considering all the overhead?
>
> I have no any problems here, ce6230 and af9015 with dual tuners (3x  
> DVB-T 22Mbit/sec TS streams) running same time on same bus.
>
> One possibility is that there is RF-noise looping from device to device  
> disturbing USB transfer or RF-signal. I have seen such situation when I  
> connect multiple DVB-C devices to same antenna cable using cheap 
> splitter.
>
> Anyhow, I increased URB sizes to 65k. Now ce6230 gives 70 wakeups and  
> af9015 120 wakeups - due to remote polling. You can test if you wish,  
> but results are most likely same as earlier. I cannot do much more.
> http://linuxtv.org/hg/~anttip/urb_size/

Ok, I did read basics of USB 2.0 protocol, gotta love these 600 page specs..
So using my fresh knowledge I went away and hacked ce6230 to use Isochronous
transfer endpoint instead of Bulk one. And it helped, tuner works, no
corruption with af9015 running on same controller at the same time.

Of course it isn't a fix per se, af9015 still corrupts if I start bulk
reading from a flash drive, etc. And there are no Isochronous endpoints on
af9015, so no alternative to bulk transfers :)

But at least I'm getting closer to pinpointing the real problem and so far
everything points to AMD SB700 chipset driver. Google says it has quite
some hardware bugs and several workarounds in linux drivers...

P.S. Rather unrelated question, what type of USB transfer is generally
preferred for USB media stream devices, BULK or ISOC? Antti, why did you
choose BULK for ce6230?
