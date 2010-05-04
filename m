Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0EDTuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 15:50:11 -0400
Message-ID: <4BE07A6A.9000303@redhat.com>
Date: Tue, 04 May 2010 16:50:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 calculating urb buffer
References: <4BDB067E.4070501@arcor.de> <4BDB3017.9070101@arcor.de> <4BE03F8D.1050905@arcor.de> <4BE066B7.2050704@redhat.com> <4BE071C2.4050309@arcor.de>
In-Reply-To: <4BE071C2.4050309@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:

>>> datagram from urb to videobuf
>>>
>>> urb           copy to     temp         copy to         1. videobuf
>>>                          buffer                        2. audiobuf
>>>                                                        3. vbi
>>> 184 Packets   ------->   184 * 3072    ---------->     4. etc.
>>> a 3072 bytes               bytes
>>>                184 *                   3072 *
>>>              3072 bytes              180 bytes
>>>                                 (184 bytes - 4 bytes
>>>                                     header )
>> In order to receive 184 packets with 3072 bytes each, the USB code will
>> try to allocate the next power-of-two memory block capable of receiving
>> such data block. As: 184 * 3072 = 565248, the kernel allocator will seek
>> for a continuous block of 1 MB, that can do DMA transfers (required by
>> ehci driver). On a typical machine, due to memory fragmentation,
>> in general, there aren't many of such blocks. So, this will increase the
>> probability of not having any such large block available, causing an
> horrible
>> dump at kernel, plus a -ENOMEM on the driver, generally requiring a reboot
>> if you want to run the driver again.
>>
> And direct copy from urb to videobuf/alsa/vbi in 184 Bytes segments.
> 
> urb                      1. videobuf
>               copy to    2. audiobuf
>                          3. vbi
> 184 Packets   ------->   4. etc.
> a 3072 bytes   
>               180 Bytes (without headers)

That's basically what that logic does. It preserves the header if you select
TM6000 format (so, no checks for the start of the block, etc), or copies
just the data, if you select YUY2 or UYUV.

> or how can I copy 180 Bytes Data from 184 Bytes block with an
> anligment of 184 urb pipe (184 * 3072 Bytes)?

A 184 x 3072 URB pipe is a big problem. We used a large pipe in the past, and this
won't work. For example, on a notebook I used to run some tests with 1 GB of
ram after starting X and do anything (like opening a browser), the URB
allocation used to fail, as there weren't any available 1MB segment at
the DMA area. Even without starting X, after a few tests, it would eventually
have fragmented the memory and the driver stops working.


-- 

Cheers,
Mauro
