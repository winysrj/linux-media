Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56185 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2GRAWM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 20:22:12 -0400
Message-ID: <500601A8.6020606@iki.fi>
Date: Wed, 18 Jul 2012 03:22:00 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
References: <4FFF327A.9080300@iki.fi> <CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com> <CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com> <4FFF763B.1060705@iki.fi> <CALzAhNXTq5T1SyukjoswUFo8HS6q9XzP=nUPUSTV-xjGPUUQMQ@mail.gmail.com>
In-Reply-To: <CALzAhNXTq5T1SyukjoswUFo8HS6q9XzP=nUPUSTV-xjGPUUQMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2012 04:16 PM, Steven Toth wrote:
>> There is set_property() and get_property() callbacks defined for FE already.
>> But those are not used. My opinion is that those callbacks should be changed
>> to deliver data for demodulator and for tuner too instead of current method
>> - which is common huge properties cache structure shared between all
>> sub-drivers. I don't like it all as it is stupid to add stuff that common
>> structure for every standard we has. Lets take example device that supports
>> DVB-C and other device supports ISDB-T. How many common parameters we has? I
>> think only one - frequency. All the others are just waste.
>
> When we did DVB V5 for S2 we added set/get property for the
> demodulators, from memory I had some cx24116 S2 specifics that I was
> passing, and I expected other demod drivers to adopt the same
> mechanism. It was fairly obvious at the time that we needed a much
> more generic way to pass internel controls around from the core to the
> demods.

cx24116 driver does not define set_property() or get_property() 
currently. I looked the history and yes, there has been those calls. But 
what I saw - only stub implementation. It still may be possible that 
there has been real implementation in some time as I didn't looked 
through all commits - was too many commits to check manually.

And later Mauro has removed totally those unused calls with mention it 
uses DVB v5 *only*.

commit 1ac6a854ad444680bffbacd9e340e40c75adc367
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Dec 22 17:28:11 2011 -0300

     [media] cx24116: report delivery system and cleanups

     This is one of the first drivers using DVBv5. It relies only
     on DVBv5 way, but still it contains some stub for unused
     methods. Remove them, add the delivery system and do some
     trivial cleanups.


So I suspect you remember wrong. At least there is now common 
misunderstood what is aimed and what is really done about those callbacks.

> The cache was to support backwards compatible V3 interfaces and
> demods, amongst other things.

That is what I see cache could be needed.

> No reason why a new demod today could not support get/set only for
> configuration.

That patch adds set_property() and get_property() handling for dvb-frontend.
http://kerneltrap.org/mailarchive/git-commits-head/2008/10/13/3643454/thread

For me it looks like meaning is to use those for valid parameters. For 
example demod driver supports DVB-S but set_property() is called with 
unsupported delivery system DVB-S2. Driver could nack it and it is never 
even added to the cache. If success is returned then dvb-frontend adds 
given parameter to cache and finally calls set_frontend() in order to 
make demod make tuning request using cached values.


But yes, it looks like those calls are possible to use for setting 
parameters to demod as every parameter is passed for demod using 
set_frontend() too.

>> What I think I am going to make new RFC which changes that so every
>> parameter from userspace is passed to the demodulator driver (using
>> set_property() - change it current functionality) and not cached to the
>> common cache at all. Shortly: change current common cache based parameter
>> transmission to happen set parameter to demodulator one by one.
>
> The other reason for the common cache was to allow sets of parameters
> to be pushed into the kernel from apps then, at the most appropriate
> time, tuned. The order of operations becomes irrelevant, so the cache
> is highly useful, else you end up with demods caching all of their own
> parameters anyway, many drivers duplicating a frequency field in their
> provate contexts, for example.
>
> It's hard to imaging how not using the cache today.

Maybe I should make an example. For demod it should be trivial, but for 
tuner you must still pass frequency and bandwidth using cache as struct 
dvb_frontend_parameters was removed some time ago.

>>>> What did you ever decide about the enable/disable of the LNA? And, how
>>>> would the bridge do that in your proposed solution? Via the proposed GPIO
>>>> interface?
>>
>>
>> I sent PATCH RFC for DVB API to add LNA support yesterday. It is new API
>
> Understood, thanks for the note.

All in all, I would like to see kind of solution where every property is 
passed to the every driver:
* bridge - set_property(FREQUENCY, 666555000)
* tuner - set_property(FREQUENCY, 666555000)
* demod - set_property(FREQUENCY, 666555000)

and each driver then picks needed parameters. Likely it is still too 
much work without enough benefits to implement...

regards
Antti


-- 
http://palosaari.fi/


