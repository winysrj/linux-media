Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53084 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZLILmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 06:42:06 -0500
Received: by fxm5 with SMTP id 5so7360002fxm.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 03:42:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B1EE49A.8030701@redhat.com>
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>
	 <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>
	 <4B1EE49A.8030701@redhat.com>
Date: Wed, 9 Dec 2009 15:42:11 +0400
Message-ID: <1a297b360912090342r3c73496x3abe8ccba62b701@mail.gmail.com>
Subject: Re: New DVB-Statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Julian Scheel <julian@jusst.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 9, 2009 at 3:43 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Manu Abraham wrote:
>
>>> Not true. As pointed at the previous answer, the difference between a new ioctl
>>> and S2API is basically the code at dtv_property_prepare_get_stats() and
>>> dtv_property_process_get(). This is a pure code that uses a continuous struct
>>> that will likely be at L3 cache, inside the CPU chip. So, this code will run
>>> really quickly.
>>
>>
>>
>> AFAIK, cache eviction occurs with syscalls: where content in the
>> caches near the CPU cores is pushed to the outer cores, resulting in
>> cache misses. Not all CPU's are equipped with L3 caches. Continuous
>> syscalls can result in TLB cache misses from what i understand, which
>> is expensive.
>
> It is very likely that the contents of struct fe to go into the cache during the
> syscall. I was conservative when I talked about L3. Depending on the cache sizes,
> I won't doubt that the needed fields of the fe struct will go to L1 cache.



Ah, so the data structure which is there in the ioctl approach as well
and "less likely" to get cache hits since the calls are lesser.


>>> As current CPU's runs at the order of Teraflops (as the CPU clocks are at gigahertz
>>> order, and CPU's can handle multiple instructions per clock cycle), the added delay
>>> is in de order of nanosseconds.
>>
>>
>> Consider STB's where DVB is generally deployed rather than the small
>> segment of home users running a stack on a generic PC.
>
> Even with STB, let's assume a very slow cpu that runs at 100 Megabytes/second. So, the clock
> speed is 10 nanoseconds. Assuming that this CPU doesn't have a good pipeline, being
> capable of handling only one instruction per second, you'll have one instruction at executed
> at each 10 nanoseconds (as a reference, a Pentium 1, running at 133 Mbps is faster than this).

Incorrect.
A CPU doesn't execute instruction per clock cycle. Clock cycles
required to execute an instruction do vary from 2 cycles 12 cycles
varying from CPU to CPU.


> An I/O operation at i2c is of the order of 10^-3. Assuming that an additional delay of 10%
> (10 ^ -4) will deadly affect realtime capability (with it is very doubtful), this means that
> the CPU can run up to 10,000 (!!!) instructions to generate such delay. If you compile that code
> and check the number or extra instructions I bet it will be shorter enough to not cause any
> practical effect.
>
> So, even on such bad hardware that is at least 20x slower than a netbook running at 1Gbps,
> what determines the delay is the amount of I/O you're doing, and not the number of extra
> code.


The I/O overhead required to read 4 registers from hardware is the
same whether you use the ioctl approach or s2api.


>  > Hardware I/O is the most expensive operation involved.
>
> True. That's what I said.
>
>> Case #1: the ioctl approach
>        <code stripped>
>>
>> Now Case #2: based on s2api
>        <code stripped>
>
>> Now that we can see the actual code flow, we can see the s2api
>> approach requires an unnecessary large tokenizer/serializer, involving
>> multiple function calls.
>
> Are you seeing there 10.000 assembler instructions or so? If not, the size of the code is
> not relevant.
>
> Also: gcc optimizer transforms switches into a binary tree. So, if you have 64
> cases on switch, it will require 7 comparations (log2(64)) to get a match.
>
> For example, a quick look at the code you've presented, let's just calculate
> the number of operations on the dtv_property_proccess_get() routine, without
> debug stuff:
>
> static int dtv_property_process_get() {
>        CMP (if fe->ops.get_property)
>        CMP (if r < 0)                   <==== This if only happens if the first one is executed. On my patch, it is not executed
>                                                (the code you posted is the one before my patch)
>        SWITCH (7 CMP's)                 <==== due to binary tree optimization done by gcc
>        MOV
> }
>
> So, that entire code (that has about 200 lines) has, in fact
> 9 comparations and one move instruction.
>
> At dtv_property_prepare_get_stats(), the code is even cheaper: just a switch with 8
> elements (log2(8) = 3), so 3 comparations, and one move instruction.
>
> The additional cost on dvb_frontend_ioctl_properties is:
>        2 MOVs
>        One loop calling dtv_property_prepare_get_stats() - up to 4 times to retrieve
> all quality values
>        one INC
>        one CMP and function CALL (the same cost exists also with the struct)
>        One loop calling dtv_property_get_stats() - up to 4 times to retrieve
> all quality values
>
> So, if I've calculated it right, we're talking about 2+1+16+1+2+1+40 = 63 instructions.
>
> 2) the userspace->kernelspace payload.
>
> Case #1: The size of S2API structs. It will range from 24 to 84 (depending on what
> you want to get, from one to 4 different value pairs).
>
> Case #2: The size of the ioctl struct: about 30 bytes (If I summed the size of all structs correctly).
>
> payload of S2API is generally bigger, except if just one parameter is required.
>
> The size of the S2API cache struct doesn't matter here, as it is part of "struct fe", so
> it is present anyway.




Eventually, as you have pointed out yourself, The data struct will be
in the cache all the time for the ioctl approach. The only new
addition to the existing API in the ioctl case is a CALL instruction
as compared to the numerous instructions in comparison to that you
have pointed out as with the s2api approach.

Regards,
Manu
