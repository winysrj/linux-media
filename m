Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52894 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbcEJWCp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 18:02:45 -0400
Subject: Re: [PATCH] media: dvb_ringbuffer: Add memory barriers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1451248920-4935-1-git-send-email-smoch@web.de>
 <56B7997C.1070503@web.de> <20160507102235.22e096d8@recife.lan>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Soeren Moch <smoch@web.de>
Message-ID: <57325AA8.60607@web.de>
Date: Wed, 11 May 2016 00:03:20 +0200
MIME-Version: 1.0
In-Reply-To: <20160507102235.22e096d8@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

thanks for looking after this patch.

On 05/07/16 15:22, Mauro Carvalho Chehab wrote:
> Hi Soeren,
>
> Em Sun, 7 Feb 2016 20:22:36 +0100
> Soeren Moch <smoch@web.de> escreveu:
>
>> On 27.12.2015 21:41, Soeren Moch wrote:
>>> Implement memory barriers according to Documentation/circular-buffers.txt:
>>> - use smp_store_release() to update ringbuffer read/write pointers
>>> - use smp_load_acquire() to load write pointer on reader side
>>> - use ACCESS_ONCE() to load read pointer on writer side
>>>
>>> This fixes data stream corruptions observed e.g. on an ARM Cortex-A9
>>> quad core system with different types (PCI, USB) of DVB tuners.
>>>
>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>> Cc: stable@vger.kernel.org # 3.14+
>>
>> Mauro,
>>
>> any news or comments on this?
>> Since this is a real fix for broken behaviour, can you pick this up, please?
>
> The problem here is that I'm very reluctant to touch at the DVB core
> without doing some tests myself, as things like locking can be
> very sensible.

I agree. But this patch adds memory barriers (no locks) according to
Documentation/circular-buffers.txt. It should not be dangerous to
follow these guidelines.
Nevertheless, independent review and testing is always a good idea,
especially in core code.

> I'll try to find some time to take a look on it for Kernel 4.8,

Thanks.

> but I'd like to reproduce the bug locally.
 >
> Could you please provide me enough info to reproduce it (and
> eventually some test MPEG-TS where you know this would happen)?

I used vdr with different types of DVB tuners on a TBS2910 board
(quad core ARM Cortex-A9, see arch/arm/boot/dts/imx6q-tbs2910.dts).
With more than one active cpu core I occasionally see data stream
corruptions in recorded ts streams. This is not the case for one
active cpu.

The problem occurs when dvb_dmxdev_buffer_write() and
dvb_dmxdev_buffer_read() are running simultaneously on different
cpu cores on architectures without strong write ordering (e.g.
on arm, not on x86). Here the write data pointer (written in
dvb_ringbuffer_write() ) can become visible to the other cpu core
(in dvb_ringbuffer_avail() ), before the actual ts packet data is
visible. dvb_ringbuffer_read_user() then can read old ts data,
although new ts data is already written into the ringbuffer
by the other cpu core.

With smp_store_release() and smp_load_acquire() the correct
write ordering is maintained, ts packet data is visible on the
reading cpu core before the updated write pointer.

> I have two DekTek RF generators here, so I should be able to
> play such TS and see what happens with and without the patch
> on x86, arm32 and arm64.

On x86 you should not see any difference, since
smp_store_release() and smp_load_acquire() expand to
simple stores and loads there. On multi-core arm systems
you may see broken ts streams without patch, especially
when reading the dvr device very fast, so that the
dvb_ringbuffer is always close to empty.

Regards,
Soeren


> Regards,
> Mauro
>
>>
>> Regards,
>> Soeren
>>
>>> ---
>>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>> Cc: linux-media@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>>
>>> Since smp_store_release() and smp_load_acquire() were introduced in linux-3.14,
>>> a 3.14+ stable tag was added. Is it desired to apply a similar patch to older
>>> stable kernels?
>>> ---
>>>   drivers/media/dvb-core/dvb_ringbuffer.c | 27 ++++++++++++++-------------
>>>   1 file changed, 14 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/media/dvb-core/dvb_ringbuffer.c b/drivers/media/dvb-core/dvb_ringbuffer.c
>>> index 1100e98..58b5968 100644
>>> --- a/drivers/media/dvb-core/dvb_ringbuffer.c
>>> +++ b/drivers/media/dvb-core/dvb_ringbuffer.c
>>> @@ -55,7 +55,7 @@ void dvb_ringbuffer_init(struct dvb_ringbuffer *rbuf, void *data, size_t len)
>>>
>>>   int dvb_ringbuffer_empty(struct dvb_ringbuffer *rbuf)
>>>   {
>>> -	return (rbuf->pread==rbuf->pwrite);
>>> +	return (rbuf->pread == smp_load_acquire(&rbuf->pwrite));
>>>   }
>>>
>>>
>>> @@ -64,7 +64,7 @@ ssize_t dvb_ringbuffer_free(struct dvb_ringbuffer *rbuf)
>>>   {
>>>   	ssize_t free;
>>>
>>> -	free = rbuf->pread - rbuf->pwrite;
>>> +	free = ACCESS_ONCE(rbuf->pread) - rbuf->pwrite;
>>>   	if (free <= 0)
>>>   		free += rbuf->size;
>>>   	return free-1;
>>> @@ -76,7 +76,7 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
>>>   {
>>>   	ssize_t avail;
>>>
>>> -	avail = rbuf->pwrite - rbuf->pread;
>>> +	avail = smp_load_acquire(&rbuf->pwrite) - rbuf->pread;
>>>   	if (avail < 0)
>>>   		avail += rbuf->size;
>>>   	return avail;
>>> @@ -86,14 +86,15 @@ ssize_t dvb_ringbuffer_avail(struct dvb_ringbuffer *rbuf)
>>>
>>>   void dvb_ringbuffer_flush(struct dvb_ringbuffer *rbuf)
>>>   {
>>> -	rbuf->pread = rbuf->pwrite;
>>> +	smp_store_release(&rbuf->pread, smp_load_acquire(&rbuf->pwrite));
>>>   	rbuf->error = 0;
>>>   }
>>>   EXPORT_SYMBOL(dvb_ringbuffer_flush);
>>>
>>>   void dvb_ringbuffer_reset(struct dvb_ringbuffer *rbuf)
>>>   {
>>> -	rbuf->pread = rbuf->pwrite = 0;
>>> +	smp_store_release(&rbuf->pread, 0);
>>> +	smp_store_release(&rbuf->pwrite, 0);
>>>   	rbuf->error = 0;
>>>   }
>>>
>>> @@ -119,12 +120,12 @@ ssize_t dvb_ringbuffer_read_user(struct dvb_ringbuffer *rbuf, u8 __user *buf, si
>>>   			return -EFAULT;
>>>   		buf += split;
>>>   		todo -= split;
>>> -		rbuf->pread = 0;
>>> +		smp_store_release(&rbuf->pread, 0);
>>>   	}
>>>   	if (copy_to_user(buf, rbuf->data+rbuf->pread, todo))
>>>   		return -EFAULT;
>>>
>>> -	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
>>> +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
>>>
>>>   	return len;
>>>   }
>>> @@ -139,11 +140,11 @@ void dvb_ringbuffer_read(struct dvb_ringbuffer *rbuf, u8 *buf, size_t len)
>>>   		memcpy(buf, rbuf->data+rbuf->pread, split);
>>>   		buf += split;
>>>   		todo -= split;
>>> -		rbuf->pread = 0;
>>> +		smp_store_release(&rbuf->pread, 0);
>>>   	}
>>>   	memcpy(buf, rbuf->data+rbuf->pread, todo);
>>>
>>> -	rbuf->pread = (rbuf->pread + todo) % rbuf->size;
>>> +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
>>>   }
>>>
>>>
>>> @@ -158,10 +159,10 @@ ssize_t dvb_ringbuffer_write(struct dvb_ringbuffer *rbuf, const u8 *buf, size_t
>>>   		memcpy(rbuf->data+rbuf->pwrite, buf, split);
>>>   		buf += split;
>>>   		todo -= split;
>>> -		rbuf->pwrite = 0;
>>> +		smp_store_release(&rbuf->pwrite, 0);
>>>   	}
>>>   	memcpy(rbuf->data+rbuf->pwrite, buf, todo);
>>> -	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
>>> +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
>>>
>>>   	return len;
>>>   }
>>> @@ -181,12 +182,12 @@ ssize_t dvb_ringbuffer_write_user(struct dvb_ringbuffer *rbuf,
>>>   			return len - todo;
>>>   		buf += split;
>>>   		todo -= split;
>>> -		rbuf->pwrite = 0;
>>> +		smp_store_release(&rbuf->pwrite, 0);
>>>   	}
>>>   	status = copy_from_user(rbuf->data+rbuf->pwrite, buf, todo);
>>>   	if (status)
>>>   		return len - todo;
>>> -	rbuf->pwrite = (rbuf->pwrite + todo) % rbuf->size;
>>> +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
>>>
>>>   	return len;
>>>   }
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

