Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.32.49]:42425 "EHLO smtp.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757193AbZLIWMJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 17:12:09 -0500
Message-ID: <4B2020BD.709@jusst.de>
Date: Wed, 09 Dec 2009 23:12:13 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>, linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>	 <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>	 <4B1EE49A.8030701@redhat.com> <1a297b360912090342r3c73496x3abe8ccba62b701@mail.gmail.com> <4B1F9FD0.4020702@redhat.com>
In-Reply-To: <4B1F9FD0.4020702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.12.09 14:02, schrieb Mauro Carvalho Chehab:
> Manu Abraham wrote:
>    
>> On Wed, Dec 9, 2009 at 3:43 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com>  wrote:
>>      
>    
>>> Even with STB, let's assume a very slow cpu that runs at 100 Megabytes/second. So, the clock
>>> speed is 10 nanoseconds. Assuming that this CPU doesn't have a good pipeline, being
>>> capable of handling only one instruction per second, you'll have one instruction at executed
>>> at each 10 nanoseconds (as a reference, a Pentium 1, running at 133 Mbps is faster than this).
>>>        
>> Incorrect.
>> A CPU doesn't execute instruction per clock cycle. Clock cycles
>> required to execute an instruction do vary from 2 cycles 12 cycles
>> varying from CPU to CPU.
>>      
> See the description of an old Pentium MMX processor (the sucessor of i586, running up to 200 MHz):
> 	http://www.intel.com/design/archives/processors/mmx/docs/243185.htm
>
> Thanks to superscalar architecture, it runs 2 instructions per clock cycle (IPC).
>
> Newer processors can run more instructions per clock cycle. For example, any Pentium-4 processor,
> can do 3 IPC:
> 	http://www.intel.com/support/processors/pentium4/sb/CS-017371.htm
>    

I don't think you can just take the average IPC rates into account for 
this. When doing a syscall the processors TLB cache will be cleared, 
which will force the CPU to go to the whole instruction pipeline before 
the first syscall instruction is actually executed. This will introduce 
a delay for each syscall you make. I'm not exactly sure about the length 
of the delay, but I think it should be something like 2 clock cycles.
>>> So, even on such bad hardware that is at least 20x slower than a netbook running at 1Gbps,
>>> what determines the delay is the amount of I/O you're doing, and not the number of extra
>>> code.
>>>        
>>
>> The I/O overhead required to read 4 registers from hardware is the
>> same whether you use the ioctl approach or s2api.
>>      
> It seems you got my point. What will determinate the delay is the number of I/O's, and not the
> amount of instructions.
>    
The number of hardware I/Os is constant for both cases, so we do not 
need to discuss them as pro/con for any of the proposals.
>> Eventually, as you have pointed out yourself, The data struct will be
>> in the cache all the time for the ioctl approach. The only new
>> addition to the existing API in the ioctl case is a CALL instruction
>> as compared to the numerous instructions in comparison to that you
>> have pointed out as with the s2api approach.
>>      
> True, but, as shown, the additional delay introduced by the code is less than 0.01%, even on
> a processor that has half of the speed of a 12-year old very slow CPU (a Pentium MMX @ 100 MHz
> is capable of 2 IPC. My calculus assumed 1 IPC).
>
> So, what will affect the delay is the number of I/O you need to do.
>
> To get all data that the ioctl approach struct has, the delay for S2API will be equal.
> To get less data, S2API will have a small delay.
>    
Imho the S2API would be slower when reading all data the ioctl fetches, 
due to the way the instructions would be handled.

Correct me, if I'm wrong with any of this.

Cheers,
Julian

