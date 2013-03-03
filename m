Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab3CCQPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 11:15:31 -0500
Date: Sun, 3 Mar 2013 13:15:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alfredo =?UTF-8?B?SmVzw7pz?= Delaiti <alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
Message-ID: <20130303131519.6214bcf4@redhat.com>
In-Reply-To: <51336331.10205@netscape.net>
References: <51054759.7050202@netscape.net>
	<20130127141633.5f751e5d@redhat.com>
	<5105A0C9.6070007@netscape.net>
	<20130128082354.607fae64@redhat.com>
	<5106E3EA.70307@netscape.net>
	<511264CF.3010002@netscape.net>
	<51336331.10205@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 03 Mar 2013 11:50:25 -0300
Alfredo Jesús Delaiti <alfredodelaiti@netscape.net> escreveu:

> Hi Mauro and others from the list

> I searched for a plan B to get the data bus and after several 
> alternative plans that were available to me was to do a logic analyzer 
> (http://tfla-01.berlios.de).

Yeah, that should work too.

> With the logic analyzer I could get the data transmitted by the I2C bus 
> under Windows, but when I put this data in replacement of originals in 
> mb86a20s.c and I try to run the Linux TV board, do not get the logic 
> analyzer with the same sequence.

Well, there are other I2C devices on the bus, and the order that they're
initialized in Linux are different than on the original driver.
> 
> The new data replacement in mb86a20s

I just posted today a series of patches improving several things on
mb86a20s and replacing its initialization table to one found on a newer
driver. It also allows using different IF frequencies on the tuner side.

Perhaps this is enough to fix.
> 
> /*
>   * Initialization sequence: Use whatevere default values that PV SBTVD
>   * does on its initialisation, obtained via USB snoop
>   */
> static struct regdata mb86a20s_init[] = {
> 
>      { 0x70, 0x0f },
>      { 0x70, 0xff },
>      { 0x09, 0x3a },
>      { 0x50, 0xd1 },
>      { 0x51, 0x22 },
>      { 0x39, 0x00 },
>      { 0x28, 0x2a },
>      { 0x29, 0x00 },
>      { 0x2a, 0xfd },
>      { 0x2b, 0xc8 },
>      { 0x3b, 0x21 },
>      { 0x3c, 0x38 },
>      { 0x28, 0x20 },
>      { 0x29, 0x3e },
>      { 0x2a, 0xde },
>      { 0x2b, 0x4d },
>      { 0x28, 0x22 },
>      { 0x29, 0x00 },
>      { 0x2a, 0x1f },
>      { 0x2b, 0xf0 },
>      { 0x01, 0x0d },
>      { 0x04, 0x08 },
>      { 0x05, 0x03 },
>      { 0x04, 0x0e },
>      { 0x05, 0x00 },
>      { 0x08, 0x1e },
>      { 0x05, 0x32 },
>      { 0x04, 0x0b },
>      { 0x05, 0x78 },
>      { 0x04, 0x00 },
>      { 0x05, 0x00 },
>      { 0x04, 0x01 },
>      { 0x05, 0x1e },
>      { 0x04, 0x02 },
>      { 0x05, 0x07 },
>      { 0x04, 0x03 },
>      { 0x0a, 0xa0 },
>      { 0x04, 0x09 },
>      { 0x05, 0x00 },
>      { 0x04, 0x0a },
>      { 0x05, 0xff },
>      { 0x04, 0x27 },
>      { 0x05, 0x00 },
>      { 0x08, 0x50 },
>      { 0x05, 0x00 },
>      { 0x04, 0x28 },
>      { 0x05, 0x00 },
>      { 0x04, 0x1e },
>      { 0x05, 0x00 },
>      { 0x04, 0x29 },
>      { 0x05, 0x64 },
>      { 0x04, 0x32 },
>      { 0x05, 0x68 },
>      { 0x04, 0x14 },
>      { 0x05, 0x02 },
>      { 0x04, 0x04 },
>      { 0x05, 0x00 },
>      { 0x08, 0x0a },
>      { 0x05, 0x22 },
>      { 0x04, 0x06 },
>      { 0x05, 0x0e },
>      { 0x04, 0x07 },
>      { 0x05, 0xd8 },
>      { 0x04, 0x12 },
>      { 0x05, 0x00 },
>      { 0x04, 0x13 },
>      { 0x05, 0xff },
>      { 0x52, 0x01 },
>      { 0x50, 0xa7 },
>      { 0x51, 0x00 },
>      { 0x50, 0xa8 },
>      { 0x51, 0xfe },
>      { 0x50, 0xa9 },
>      { 0x51, 0xff },
>      { 0x50, 0xaa },
>      { 0x51, 0x00 },
>      { 0x50, 0xab },
>      { 0x51, 0xff },
>      { 0x50, 0xac },
>      { 0x51, 0xff },
>      { 0x50, 0xad },
>      { 0x51, 0x00 },
>      { 0x50, 0xae },
>      { 0x51, 0xff },
>      { 0x50, 0xaf },
>      { 0x51, 0xff },
>      { 0x5e, 0x07 },
>      { 0x50, 0xdc },
>      { 0x51, 0x3f },
>      { 0x50, 0xdd },
>      { 0x51, 0xff },
>      { 0x50, 0xde },
>      { 0x51, 0x3f },
>      { 0x80, 0xdf },
> 
> So I conclude that there must be some logic that I'm not understanding. 
> Could you indicate the meaning of the data in the table if there are 
> any? or if I'm doing something wrong, what do I do wrong?

I'll take a look on it, and see what it is doing differently.

> I have also observed that the data passing through the I2C bus are not 
> always the same under Windows, there are some differences between them 
> in parts.

Hmm... that's interesting. Did you map the changes?

> Then I put a few fragments of what I get under Windows 7 and Linux. Not 
> the entire I put because they are of a size of 200KiB.
> 
> _Under_Windows_7_
> 
> 0.184315 - Start
> 0.268094 - b00100001 - 0x21 - 33
> 0.279265 - ACK
> 0.361182 - b00010011 - 0x13 - 19
> 0.372353 - NACK

This is a read.

> 0.511985 - b00100000 - 0x20 - 32
> 0.523156 - ACK
> 0.603211 - b01110000 - 0x70 - 112
> 0.614382 - ACK
> 0.698161 - b00001111 - 0x0f - 15
> 0.70747 - ACK
> 0.847102 - b00100000 - 0x20 - 32
> 0.858273 - ACK
> 0.938329 - b01110000 - 0x70 - 112
> 0.949499 - ACK
> 1.03514 - b11111111 - 0xff - 255
> 1.04445 - ACK

Funny that it doesn't write 01 to register 08 here.
I think that the this is to disable TS while resetting.

...

> _Under_Linux_
> 
> 0.268594 - Start
> 0.358125 - b00100000 - 0x20 - 32
> 0.367451 - ACK
> 0.447656 - b01110000 - 0x70 - 112
> 0.456982 - ACK
> 0.548379 - b11111111 - 0xff - 255
> 0.55957 - ACK
> 0.686406 - b00100000 - 0x20 - 32
> 0.697597 - ACK
> 0.781533 - b00001000 - 0x08 - 8
> 0.790859 - NACK
> 0.871064 - b00000001 - 0x01 - 1
> 0.882256 - ACK

You're likely still using the old table.

> In the next letter, if you let me, I'll cut the old text, because I 
> guess we're back on topic and not too heavy (KB) message.

Sure. I always cut not commented parts of the messages I answer.


Cheers,
Mauro
