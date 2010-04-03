Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0DCBcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 21:32:13 -0400
Message-ID: <4BB69A95.5000705@redhat.com>
Date: Fri, 02 Apr 2010 22:32:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/15] V4L/DVB: ir-core: Add logic to decode IR protocols
 at the IR core
References: <cover.1270142346.git.mchehab@redhat.com>	 <20100401145632.7b1b98d5@pedra> <1270251567.3027.55.camel@palomino.walls.org>
In-Reply-To: <1270251567.3027.55.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2010-04-01 at 14:56 -0300, Mauro Carvalho Chehab wrote:
>> Adds a method to pass IR raw pulse/code events into ir-core. This is
>> needed in order to support LIRC. It also helps to move common code
>> from the drivers into the core.
>>
>> In order to allow testing, it implements a simple NEC protocol decoder
>> at ir-nec-decoder.c file. The logic is about the same used at saa7134
>> driver that handles Avermedia M135A and Encore FM53 boards.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>  create mode 100644 drivers/media/IR/ir-nec-decoder.c
>>  create mode 100644 drivers/media/IR/ir-raw-event.c
> 
> Hi Mauro,
> 
> I haven't taken a very hard look at this since I'm very busy this month.
> 
> It looks OK so far. 

Thank you for your review. 

One general comment: my main target of writing the NEC decoder is to have one
decoder for testing. I know that there are several other implementations, so I 
didn't try to write a perfect decoder, but, instead, I wrote a code that 
works, and that allows me to continue the Remote Controller subsystem design. 
In other words, for sure there are lots of space for improvements there ;)

> I do have some comments....
> 
> 
>> diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
>> index 171890e..18794c7 100644
>> --- a/drivers/media/IR/Makefile
>> +++ b/drivers/media/IR/Makefile
>> @@ -1,5 +1,5 @@
>>  ir-common-objs  := ir-functions.o ir-keymaps.o
>> -ir-core-objs	:= ir-keytable.o ir-sysfs.o
>> +ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o ir-nec-decoder.o
>>  
>>  obj-$(CONFIG_IR_CORE) += ir-core.o
>>  obj-$(CONFIG_VIDEO_IR) += ir-common.o
>> diff --git a/drivers/media/IR/ir-nec-decoder.c b/drivers/media/IR/ir-nec-decoder.c
>> new file mode 100644
>> index 0000000..16360eb
>> --- /dev/null
>> +++ b/drivers/media/IR/ir-nec-decoder.c
>> @@ -0,0 +1,131 @@
>> +/* ir-raw-event.c - handle IR Pulse/Space event
>> + *
>> + * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License as published by
>> + *  the Free Software Foundation version 2 of the License.
>> + *
>> + *  This program is distributed in the hope that it will be useful,
>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *  GNU General Public License for more details.
>> + */
>> +
>> +#include <media/ir-core.h>
>> +
>> +/* Start time: 4.5 ms  */
>> +#define MIN_START_TIME	3900000
>> +#define MAX_START_TIME	5100000
> 
> Hmmm.
> 
> An NEC header pulse is nominally        16 * 560 us = 8.96 ms
> An NEC header space is nominally         8 * 560 us = 4.48 ms
> An NEC repeat header space is nominally  4 * 560 us = 2.24 ms
> 
> I think you need a more explicit name than {MIN,MAX}_START_TIME.

Part of the problem with this decoder is that it was conceived to work with
the saa7134 driver. The driver is currently programmed to trigger IRQ on just
one of the edge (positive or negative, I need to double check). Due to that,
this time is just half of the time it should be.

I've changed on a latter patch my decoder to work with just the duration
of the bits.

After reviewing the datasheet, now I think I know how to program IRQ to
trigger on both edges. So, my idea is to enable it and rewrite the decoder.

> 
> 
>> +/* Pulse time: 560 us  */
>> +#define MIN_PULSE_TIME	460000
>> +#define MAX_PULSE_TIME	660000
>> +
>> +/* Bit 1 space time: 2.25ms-560 us */
>> +#define MIN_BIT1_TIME	1490000
>> +#define MAX_BIT1_TIME	1890000
>> +
>> +/* Bit 0 space time: 1.12ms-560 us */
>> +#define MIN_BIT0_TIME	360000
>> +#define MAX_BIT0_TIME	760000
>> +
> 
> The fundamental unit of time in the NEC protocol is ideally:
> 
> 	4192/197 cycles / 38 kHz = 559978.6 ns ~= 560 ns
> 
> All other time durations in the NEC protocol are multiples of this unit.

Yes, I know. By max/min, I've meant to handle delta variations around
the main time, since the driver may miss the exact moment where it were
supposed to collect the timestamp.

> See:
> 
> 	http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2#l1.96
> 
> If you define the your above constants in terms of that time unit, it
> makes the tolerances you added in explicitly visible when reading the
> source.

I'll take a look on your code and work to improve this decoder. The way you've
declared is for sure cleaner than mine.

>> +/** Decode NEC pulsecode. This code can take up to 76.5 ms to run.
>> +	Unfortunately, using IRQ to decode pulse didn't work, since it uses
>> +	a pulse train of 38KHz. This means one pulse on each 52 us
>> +*/
>> +
>> +int ir_nec_decode(struct input_dev *input_dev,
>> +		  struct ir_raw_event *evs,
>> +		  int len)
>> +{
>> +	int i, count = -1;
>> +	int ircode = 0, not_code = 0;
>> +#if 0
>> +	/* Needed only after porting the event code to the decoder */
>> +	struct ir_input_dev *ir = input_get_drvdata(input_dev);
>> +#endif
>> +
>> +	/* Be sure that the first event is an start one and is a pulse */
>> +	for (i = 0; i < len; i++) {
>> +		if (evs[i].type & (IR_START_EVENT | IR_PULSE))
>> +			break;
>> +	}
>> +	i++;	/* First event doesn't contain data */
>> +
>> +	if (i >= len)
>> +		return 0;
>> +
>> +	/* First space should have 4.5 ms otherwise is not NEC protocol */
>> +	if ((evs[i].delta.tv_nsec < MIN_START_TIME) |
>> +	    (evs[i].delta.tv_nsec > MAX_START_TIME) |
>> +	    (evs[i].type != IR_SPACE))
>> +		goto err;
>> +
>> +	/*
>> +	 * FIXME: need to implement the repeat sequence
>> +	 */
> 
> I have an NEC protocol decoder here:
> 
> 	http://linuxtv.org/hg/~awalls/cx23885-ir2/rev/2cfef53b95a2
> 
> If you would find it useful, please feel free to borrow ideas or parts
> of the code to implement any features you are missing.  (That code works
> by converting a mark-space pair to an "nec_symbol", and then taking
> action based on the symbol.)

Ok, I will take a look on it.
> 
> I suspect you will want to implement the repeat sequence.  It is hard
> not to get a repeat sequence from a remote.
> 
> NEC ideally sends a repeat at intervals of:
> 
> 	4192 cycles * 38 kHz = 110.316 ms

I suspect that the original RC shipped with this board doesn't produce a repeat
event. I have another IR here that produces. I'll double test and see if I can
improve the repeat code (a latter patch implements a repeat code).

> 
>> +	count = 0;
>> +	for (i++; i < len; i++) {
>> +		int bit;
>> +
>> +		if ((evs[i].delta.tv_nsec < MIN_PULSE_TIME) |
>> +		    (evs[i].delta.tv_nsec > MAX_PULSE_TIME) |
>> +		    (evs[i].type != IR_PULSE))
>> +			goto err;
>> +
>> +		if (++i >= len)
>> +			goto err;
>> +		if (evs[i].type != IR_SPACE)
>> +			goto err;
>> +
>> +		if ((evs[i].delta.tv_nsec > MIN_BIT1_TIME) &&
>> +		    (evs[i].delta.tv_nsec < MAX_BIT1_TIME))
>> +			bit = 1;
>> +		else if ((evs[i].delta.tv_nsec > MIN_BIT0_TIME) &&
>> +			 (evs[i].delta.tv_nsec < MAX_BIT0_TIME))
>> +			bit = 0;
>> +		else
>> +			goto err;
>> +
>> +		if (bit) {
>> +			int shift = count;
>> +			/* Address first, then command */
>> +			if (shift < 8) {
>> +				shift += 8;
>> +				ircode |= 1 << shift;
>> +			} else if (shift < 16) {
>> +				not_code |= 1 << shift;
>> +			} else if (shift < 24) {
>> +				shift -= 16;
>> +				ircode |= 1 << shift;
>> +			} else {
>> +				shift -= 24;
>> +				not_code |= 1 << shift;
>> +			}
>> +		}
>> +		if (++count == 32)
>> +			break;
>> +	}
>> +
>> +	/*
>> +	 * Fixme: may need to accept Extended NEC protocol?
>> +	 */
> 
> Both of the NEC remotes that I own use the extended protocol, IIRC.

I found one NEC IR here that uses the extended protocol. The issue I have here is that
maybe it could be interesting to allow enable or disable a more pedantic check.
At least on the room I'm working, I have two strong fluorescent lamps that interfere
on the IR sensor of the saa7134 board. I'll probably add a sysfs node to allow enable/
disable the strict check for non-extended protocol.
 
-- 

Cheers,
Mauro
