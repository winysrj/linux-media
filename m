Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbZLINCK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 08:02:10 -0500
Message-ID: <4B1F9FD0.4020702@redhat.com>
Date: Wed, 09 Dec 2009 11:02:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Julian Scheel <julian@jusst.de>, linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>	 <1a297b360912081346k45b7844bg5d408d47a38da5b4@mail.gmail.com>	 <4B1EE49A.8030701@redhat.com> <1a297b360912090342r3c73496x3abe8ccba62b701@mail.gmail.com>
In-Reply-To: <1a297b360912090342r3c73496x3abe8ccba62b701@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham wrote:
> On Wed, Dec 9, 2009 at 3:43 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:

>> Even with STB, let's assume a very slow cpu that runs at 100 Megabytes/second. So, the clock
>> speed is 10 nanoseconds. Assuming that this CPU doesn't have a good pipeline, being
>> capable of handling only one instruction per second, you'll have one instruction at executed
>> at each 10 nanoseconds (as a reference, a Pentium 1, running at 133 Mbps is faster than this).
> 
> Incorrect.
> A CPU doesn't execute instruction per clock cycle. Clock cycles
> required to execute an instruction do vary from 2 cycles 12 cycles
> varying from CPU to CPU.

See the description of an old Pentium MMX processor (the sucessor of i586, running up to 200 MHz):
	http://www.intel.com/design/archives/processors/mmx/docs/243185.htm

Thanks to superscalar architecture, it runs 2 instructions per clock cycle (IPC).

Newer processors can run more instructions per clock cycle. For example, any Pentium-4 processor,
can do 3 IPC:
	http://www.intel.com/support/processors/pentium4/sb/CS-017371.htm

>> So, even on such bad hardware that is at least 20x slower than a netbook running at 1Gbps,
>> what determines the delay is the amount of I/O you're doing, and not the number of extra
>> code.
> 
> 
> The I/O overhead required to read 4 registers from hardware is the
> same whether you use the ioctl approach or s2api.

It seems you got my point. What will determinate the delay is the number of I/O's, and not the
amount of instructions.
 
> Eventually, as you have pointed out yourself, The data struct will be
> in the cache all the time for the ioctl approach. The only new
> addition to the existing API in the ioctl case is a CALL instruction
> as compared to the numerous instructions in comparison to that you
> have pointed out as with the s2api approach.

True, but, as shown, the additional delay introduced by the code is less than 0.01%, even on
a processor that has half of the speed of a 12-year old very slow CPU (a Pentium MMX @ 100 MHz
is capable of 2 IPC. My calculus assumed 1 IPC).

So, what will affect the delay is the number of I/O you need to do.

To get all data that the ioctl approach struct has, the delay for S2API will be equal.
To get less data, S2API will have a small delay.

Cheers,
Mauro.
