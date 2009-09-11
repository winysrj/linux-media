Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50801 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZIKOiN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 10:38:13 -0400
Message-ID: <4AAA60D0.50706@iki.fi>
Date: Fri, 11 Sep 2009 17:38:08 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
CC: Markus Rechberger <mrechberger@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Clinton Meyer <clintonmeyer22@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: LinuxTV firmware blocks all wireless connections / traffic
References: <829197380909091459x5367e95dnbd15f23e8377cf33@mail.gmail.com> <20090910091400.GA15105@moon> <d9def9db0909100358o14f07362n550b95a033c8a798@mail.gmail.com> <20090910124549.GA18426@moon> <20090910124807.GB18426@moon> <4AA8FB2F.2040504@iki.fi> <20090910134139.GA20149@moon> <4AA9038B.8090404@iki.fi> <4AA911B6.2040301@iki.fi> <20090910171631.GA4423@moon> <20090910193916.GA4923@moon>
In-Reply-To: <20090910193916.GA4923@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2009 10:39 PM, Aleksandr V. Piskunov wrote:
> On Thu, Sep 10, 2009 at 08:16:31PM +0300, Aleksandr V. Piskunov wrote:
>> On Thu, Sep 10, 2009 at 05:48:22PM +0300, Antti Palosaari wrote:
>>> Here it is, USB2.0 URB is now about 16k both af9015 and ce6230 devices.
>>> Now powertop shows only about 220 wakeups on my computer for the both
>>> sticks.
>>> Please test and tell what powertop says:
>>> http://linuxtv.org/hg/~anttip/urb_size/
>>>
>>> I wonder if we can decide what URB size DVB USB drivers should follow
>>> and even add new module param for overriding driver default.
>>
>> Thanks, Antti!
>>
>> Tested your branch on affected system.
>>
>> Load definitely went down, from ~7000 wakeups to ~250 for each tuner
>> according to powertop.
>> Both tuners still working ok if not used simultaneously or if used the
>> same time on different USB controllers.
>>
>> Bad news are that original problem still persists: putting both tuners
>> on same USB controller and zapping simultaneously corrupts stream.
>> Interesting observation: no matter in what sequence tuners are connected
>> (i.e. become adapter0 or adapter1), af9015 stream always gets heavily
>> distorted, visually mplayer picture becomes like 80% corrupted with
>> random color blocks and pixels, sound becomes a mess. At the same time
>> ce6230 gets slight corruption, a few discolored blocks at the time and
>> sound hickups.
>>
>> Anyway, will try to do a few more tests:
>> 1) Two usb flash drives on same controller calculating md5sum of
>> big .iso file, to check if it is/isn't dvb-usb problem.
>> 2) Will see if same issue persists on another PC with same motherboard
>> (slightly different revision) to rule out hardware issues. If I manage
>> to wire antenna there, that is...
>
> Ok, two USB flash drives on same controller, no problem when bulk reading
> from both at the same time, no speed drops, no corruption.
>
> Now if I plug ce6230 tuner, zap to channel and then start reading from
> flash drive:
> * slightly corrupted TS stream
> * flash drive read getting starved on bandwidth, speed drops from 10 MB/s
>    to ~7 MB/s
>
> If I plug af9015 tuner, zap and read from flash
> * heavy corruption of TS stream
> * flash drive read speed drops from 10 MB/s to 2(!) MB/s
>
> Now I don't really know the USB protocol under-the-hood details, all the
> different types of bandwidth, reservation and so on. But shouldn't one
> 480 Mbit/sec controller handle rather large number of digital tuners, each
> pushing 20-25 Mbit/sec max, even considering all the overhead?

I have no any problems here, ce6230 and af9015 with dual tuners (3x 
DVB-T 22Mbit/sec TS streams) running same time on same bus.

One possibility is that there is RF-noise looping from device to device 
disturbing USB transfer or RF-signal. I have seen such situation when I 
connect multiple DVB-C devices to same antenna cable using cheap splitter.

Anyhow, I increased URB sizes to 65k. Now ce6230 gives 70 wakeups and 
af9015 120 wakeups - due to remote polling. You can test if you wish, 
but results are most likely same as earlier. I cannot do much more.
http://linuxtv.org/hg/~anttip/urb_size/

Antti
-- 
http://palosaari.fi/
