Return-path: <mchehab@pedra>
Received: from server1.net1.cc ([213.137.48.2]:57860 "EHLO server1.net1.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab1FLWeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 18:34:10 -0400
Message-ID: <4DF53EDA.5000207@net1.cc>
Date: Mon, 13 Jun 2011 01:34:02 +0300
From: Doychin Dokov <root@net1.cc>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [PATCH] Add support for PCTV452E.
References: <201105242151.22826.hselasky@c2i.net> <4DF399EA.6090508@net1.cc> <4DF52148.4060704@net1.cc> <4DF531BE.8090005@net1.cc>
In-Reply-To: <4DF531BE.8090005@net1.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I also confirmed it works with s2-liplianin on Debian's 2.6.38-bpo2 
kernel without such problems.

Another thing I've tested is to compile the media_tree with the stb6100, 
but the problem persist, so it seems it's not related to the component 
that both devices share.

Any ideas what might be the reason for that, or at least where I should 
focus at searching?

На 13.6.2011 г. 00:38 ч., Doychin Dokov написа:
> On 2.6.32.5 with s2-liplianin tree this is not observed, i.e. everything
> works as expected - the S2-3650 does not cause the TBS device to stutter.
>
> На 12.6.2011 г. 23:27 ч., Doychin Dokov написа:
>> The same thing happens when the devices are on different USB buses:
>> Bus 002 Device 004: ID 0b48:300a TechnoTrend AG TT-connect S2-3650 CI
>> Bus 001 Device 007: ID 0b48:3006 TechnoTrend AG TT-connect S-2400 DVB-S
>> Bus 001 Device 004: ID 734c:5980 TBS Technologies China
>>
>> When the S2-3650 CI scans, the stream output from the TBS is gone. When
>> it's done scanning / locking, the TBS continues to work fine. The S-2400
>> is not affected in any way, nor it affects the other receivers.
>>
>> It seems the issue is not relative to the devices being on the same USB
>> bus, nor the kernel used. I've tried Debian's 2.6.32.5 and 2.6.38-bpo2
>> on a Debian Squeeze system.
>>
>> На 11.6.2011 г. 19:38 ч., Doychin Dokov написа:
>>> i've been using the patches in the latest media_tree for some hours -
>>> the S2-3650 CI seems to work. There's one thing that disturbs me, though
>>> - when it scans / locks on a frequency, another device on the same PC,
>>> using the same stb6100, gets stuck for a moment. Any ideas what might be
>>> the cause for that? The two devices do not share common RF input signal,
>>> but are on the same USB bus:
>>> Bus 001 Device 004: ID 734c:5980 TBS Technologies China
>>> Bus 001 Device 003: ID 0b48:300a TechnoTrend AG TT-connect S2-3650 CI
>>>
>>> The TBS device is a QBOX2 SI, which works with their official driver
>>> from their web-site.
>>>
>>> There's also a third DVB device in the system - a TT S-2400 (which is on
>>> the other USB bus, though), which does not exhibit any problems related
>>> with the first two devices, nor causes them to get stuck when it's
>>> scanning.
>>>
>>> I'll try to switch devices around and see if anything changes.
>>>
>>
>

