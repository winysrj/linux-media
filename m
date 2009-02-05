Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:51198 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZBEXu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2009 18:50:27 -0500
Message-ID: <498B7B3A.7050904@gmail.com>
Date: Fri, 06 Feb 2009 03:50:18 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Manu <eallaud@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Re : [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	<1232998154.24736.2@manu-laptop> <497F66E5.9060901@gmail.com>	<c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com>	<497F78E9.9090608@gmail.com>	<157f4a8c0902021443s5b567aap461b50d305088699@mail.gmail.com> <1233839327.6096.1@manu-laptop>
In-Reply-To: <1233839327.6096.1@manu-laptop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu wrote:
> Le 02.02.2009 18:43:33, Chris Silva a écrit :
>> On Tue, Jan 27, 2009 at 9:13 PM, Manu Abraham 
>> <abraham.manu@gmail.com>
>> wrote:
>>> Alex Betis wrote:
>>>> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham
>> <abraham.manu@gmail.com>wrote:
>>>>>> Hmm OK, but is there by any chance a fix for those issues
>> somewhere or
>>>>>> in the pipe at least? I am willing to test (as I already
>> offered), I
>>>>>> can compile the drivers, spread printk or whatever else is 
>> needed
>> to
>>>>>> get useful reports. Let me know if I can help sort this problem.
>> BTW in
>>>>>> my case it is DVB-S2 30000 SR and FEC 5/6.
>>>>> It was quite not appreciable on my part to provide a fix or reply
>> in
>>>>> time nor spend much time on it earlier, but that said i was quite
>>>>> stuck up with some other things.
>>>>>
>>>>> Can you please pull a copy of the multiproto tree
>>>>> http://jusst.de/hg/multiproto or the v4l-dvb tree from
>>>>> http://jusst.de/hg/v4l-dvb
>>>>>
>>>>> and apply the following patch and comment what your result is ?
>>>>> Before applying please do check whether you still have the 
>> issues.
>>>> Manu,
>>>> I've tried to increase those timers long ago when played around
>> with my card
>>>> (Twinhan 1041) and scan utility.
>>>> I must say that I've concentrated mostly on DVB-S channels that
>> wasn't
>>>> always locking.
>>>> I didn't notice much improvements. The thing that did help was
>> increasing
>>>> the resolution of scan zigzags.
>>> With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.
>>> Most likely you haven't tried that change.
>>>
>>>> I've sent a patch on that ML and people were happy with the
>> results.
>>> I did look at your patch, but that was completely against the 
>> tuning
>>> algorithm.
>>>
>>> [..]
>>>
>>>> I believe DVB-S2 lock suffer from the same problem, but in that
>> case the
>>>> zigzag is done in the chip and not in the driver.
>>> Along with the patch i sent, does the attached patch help you in
>>> anyway (This works out for DVB-S2 only)?
>>>
>> Manu,
>>
>> I've tried both multiproto branches you indicated above, *with* and
>> *without* the patches you sent to the ML (fix_iterations.patch and
>> increase timeout.patch) on this thread.
>> Sadly, same behavior as S2API V4L-DVB current branch. No lock on 
>> 30000
>> 3/4 channels. It achieves a 0.5 second jittery sound but no image. It
>> seems the driver is struggling to correctly lock on that channel, but
>> doesn't get there in time... Or maybe the hardware... Dunno...

Can you please send me a complete trace with the stb6100 and stb0899
modules loaded with verbose=5 for the 30MSPS transponder what you
are trying ? One simple szap would be enough (no scan please) based
on the http://jusst.de/hg/v4l-dvb tree.

Before you start testing, start clean from a cold boot after a
powerdown. This makes it a bit more easier identify things.

Regards,
Manu

