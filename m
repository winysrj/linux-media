Return-path: <linux-media-owner@vger.kernel.org>
Received: from bruce.bmat.com ([176.9.54.181]:39296 "EHLO bruce.bmat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab2HMOPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 10:15:37 -0400
Message-ID: <50290BFF.6070503@bmat.es>
Date: Mon, 13 Aug 2012 16:15:27 +0200
From: =?ISO-8859-1?Q?Marc_Bol=F3s?= <mark@bmat.es>
Reply-To: mark@bmat.es
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: Question Hauppauge Nova-S-Plus.
References: <5028CC8C.3060907@bmat.es> <CALzAhNXim6t=w-49+TmzKr5sGu6uwgisc6O3oqVkUShYpu+PJQ@mail.gmail.com>
In-Reply-To: <CALzAhNXim6t=w-49+TmzKr5sGu6uwgisc6O3oqVkUShYpu+PJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your reply Steven. I'll reply inline also.

El 13/08/12 15:20, Steven Toth escribió:
>> I've been working for some time with those devices, and recently I have
>> a problem which I've never seen before. The point is that I tune
>> properly frequency and I start watching all channels, but after some
>> time  one or 2 tuners stops, and you cannot tune again any frequency
>> until you reboot all server.
> Interesting. If it was previously working fine, and very reliably,
> then what has changed in your software stack or environment?
>
> What happens if you rmmod and modprobe the driver? Does this help?
I tryed 2 times and it didn't work. I did some tests, the most 
interesting part is that sometimes, it recovers with a restart script 
that I have. maybe at this point it's better that I explain full 
situation with details, so you know better.

I have a lot of linux systems working arround world for TV recording. 
Some of them are for DVB-S recording. I'm using this cards for sometime 
now and it's the first time that I see this problem, and only in one 
country. For example we say that we have 2 countries, A and B. The point 
here is that country A, which I live, I have this system working for 2 
years, and I never saw this problem (it works with kernel drivers and 
debian squeeze amd64). On the other side, country B , I had this cards 
working fine before with another operating system (fedora 64). We 
switched some time ago operating system and now we have debian on all 
countries. Now in country B and debian kernel drivers, is the first time 
I see this problem (kernel them are using is exactly same .deb package 
which I compiled to allow more than 16 dvb adapters to be pluged on a 
system). I've replaced physical cards for new ones, and the problem 
still persists. After introducing a little hardware and operating system 
now I start explaining more detailed the problem.

Right now in digital systems, we use one app to tune and demultiplex and 
other to record files. When you start the system, it tunes everything 
OK, and it starts recording. After some time (always random), some 
tuners leave working (always same transponders, it happens also trying 
on another card), then my record software detects it and restarts the 
tuning instance. I think the main problem (when stops working) is that 
sometimes there is little loss in signal, but it should recover normal 
on aplication restart. But there are 2 transponders that can't restart 
normally. it tryes for some attemps, but you allways have the same 
results. No lock, no carrier, no signal. The interesting point here, is 
that if I restart full server, it works again (but I don't want to have 
a server rebooting 3 or 5 times a day...).

I've checked syslog, dmesg, kernel log and there isn't any trace about 
any hardware or software issue :(

The problem is cronic, is allways there. And the only recover solution 
that I found is to reboot server.

Also I tryed last git drivers, compiling myself, but doesn't work with 
this card and debian OS.
>> One thing very strange there is that always are the same tuners which
>> fails. Signal is OK.
> Do you mean it's always the same physical card that fails, or any of
> your nova-s-plus cards fail in the same way?
>
>> I don't have any error on syslog nor dmesg. And once you reboot it works
>> again.
>>
>> Have anyone seen this problem before and can help me please?
> I haven't seen this before.
>
>
