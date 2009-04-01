Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:33444 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759153AbZDAHfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 03:35:13 -0400
Date: Wed, 1 Apr 2009 09:34:50 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Gabriele Dini Ciacci <dark.schneider@iol.it>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Drivers for Pinnacle pctv200e and pctv60e
In-Reply-To: <20090401004702.539afbda@gdc1>
Message-ID: <alpine.LRH.1.10.0904010926300.21921@pub4.ifh.de>
References: <20090329155608.396d2257@gdc1> <20090331075610.53620db8@pedra.chehab.org> <20090331212052.152d2ffc@gdc1> <412bdbff0903311359i3f3883dds2d870c93e23d08f2@mail.gmail.com> <20090331233524.4000cb61@gdc1> <412bdbff0903311451w776c7b68t22fc3acbcd23fe64@mail.gmail.com>
 <20090401004702.539afbda@gdc1>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On Wed, 1 Apr 2009, Gabriele Dini Ciacci wrote:
>> While there are indeed drivers based on the same FX2 chip in your
>> device, it may be possible to reuse an existing driver, or you may
>> need a whole new driver, depending on how much the firmware varies
>> between your product versus the others.  You may want to look at the
>> pvrusb2 and cxusb drivers, which also use the FX2 chip, and see what
>> similarities exist in terms of the API and command set.  If it is not
>> similar to any of the others, then writing a new driver is probably
>> the correct approach.
>>
>> Regards,
>>
>> Devin
>>
>
> Fine perfect, thanks,
>
> I will have a look asap and report for judge.

I think you can save the time... When I started on a driver for those two 
devices 4 years ago, I had almost everything finished, but at that time we 
hadn't had a mt2060 driver available.

I think I still have that driver somewhere, I'll check that and will send 
it to the list if I can find it. (at least the I2C-part was a little bit 
cleaner, IIRC).

Gabriele, btw. there is nothing wrong with the I2C-address in your driver. 
setting 0x3e to the demod-address-field in the config-struct is totally 
fine.

OTOH, your problem of unterstanding is most likely the notation used for 
i2c-addresses in linux: In Linux's drivers you'll find the 7-bit notation 
of the chip's i2c-address where as outside Linux, IMO, usually the 8-bit 
(wrong) notation is used:

In the i2c-protocol the first byte of communication is the address plus a 
bit (the LSB) which is indicating wheter it is a read or write access.

ie: AAAA AAAD, where A is address-bits and D is direction.

In Linux what you'll see is e.g 0x1f which is the 7 bit address of 0x3e. 
The same for the tuner 0xc0 or 0xc2 is in Linux 0x60 and 0x61. Or the 
eeprom 0xa0 -> 0x50

On the various USB-2-I2C interfaces most of the time the 8 bit notation is 
used, that why you'll have to shift the address << 1 before filling the 
buffer in the i2c_transfer function.

HTH,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
