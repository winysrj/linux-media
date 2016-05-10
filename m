Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:62607 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbcEJWC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 May 2016 18:02:56 -0400
Subject: Re: [PATCH] media: dvb_ringbuffer: Add memory barriers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1451248920-4935-1-git-send-email-smoch@web.de>
 <56B7997C.1070503@web.de> <20160507102235.22e096d8@recife.lan>
 <20160507102606.73e86c0d@recife.lan>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
From: Soeren Moch <smoch@web.de>
Message-ID: <57325AB7.7020304@web.de>
Date: Wed, 11 May 2016 00:03:35 +0200
MIME-Version: 1.0
In-Reply-To: <20160507102606.73e86c0d@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/16 15:26, Mauro Carvalho Chehab wrote:
> Em Sat, 7 May 2016 10:22:35 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
>
>> Hi Soeren,
>>
>> Em Sun, 7 Feb 2016 20:22:36 +0100
>> Soeren Moch <smoch@web.de> escreveu:
>>
>>> On 27.12.2015 21:41, Soeren Moch wrote:
>>>> Implement memory barriers according to Documentation/circular-buffers.txt:
>>>> - use smp_store_release() to update ringbuffer read/write pointers
>>>> - use smp_load_acquire() to load write pointer on reader side
>>>> - use ACCESS_ONCE() to load read pointer on writer side
>>>>
>>>> This fixes data stream corruptions observed e.g. on an ARM Cortex-A9
>>>> quad core system with different types (PCI, USB) of DVB tuners.
>>>>
>>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>>> Cc: stable@vger.kernel.org # 3.14+
>>>
>>> Mauro,
>>>
>>> any news or comments on this?
>>> Since this is a real fix for broken behaviour, can you pick this up, please?
>>
>> The problem here is that I'm very reluctant to touch at the DVB core
>> without doing some tests myself, as things like locking can be
>> very sensible.
>
> In addition, it is good if other DVB developers could also test it.
> Even being sent for some time, until now, nobody else tested it.

I know that people from the german vdrportal.de also use this patch
for quite some time now. Unfortunately they are not active on the
linux-media mailing list.

>>
>> I'll try to find some time to take a look on it for Kernel 4.8,
>> but I'd like to reproduce the bug locally.
>>
>> Could you please provide me enough info to reproduce it (and
>> eventually some test MPEG-TS where you know this would happen)?
>>
>> I have two DekTek RF generators here, so I should be able to
>> play such TS and see what happens with and without the patch
>> on x86, arm32 and arm64.
>
> Ah,  forgot to mention, but checkpatch.pl wants comments for the memory
> barriers:
>

OK, when I wrote this patch (linux-4.4-rc6) checkpatch.pl did not
complain about missing comments. I will send a version 2 of this
patch to address these warnings.

Regards,
Soeren

> WARNING: memory barrier without comment
> #52: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:58:
> +	return (rbuf->pread == smp_load_acquire(&rbuf->pwrite));
>
> WARNING: memory barrier without comment
> #70: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:79:
> +	avail = smp_load_acquire(&rbuf->pwrite) - rbuf->pread;
>
> WARNING: memory barrier without comment
> #79: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:89:
> +	smp_store_release(&rbuf->pread, smp_load_acquire(&rbuf->pwrite));
>
> WARNING: memory barrier without comment
> #87: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:96:
> +	smp_store_release(&rbuf->pread, 0);
>
> WARNING: memory barrier without comment
> #88: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:97:
> +	smp_store_release(&rbuf->pwrite, 0);
>
> WARNING: memory barrier without comment
> #97: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:123:
> +		smp_store_release(&rbuf->pread, 0);
>
> WARNING: memory barrier without comment
> #103: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:128:
> +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
>
> WARNING: memory barrier without comment
> #112: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:143:
> +		smp_store_release(&rbuf->pread, 0);
>
> WARNING: memory barrier without comment
> #117: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:147:
> +	smp_store_release(&rbuf->pread, (rbuf->pread + todo) % rbuf->size);
>
> WARNING: memory barrier without comment
> #126: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:162:
> +		smp_store_release(&rbuf->pwrite, 0);
>
> WARNING: memory barrier without comment
> #130: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:165:
> +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
>
> WARNING: memory barrier without comment
> #139: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:185:
> +		smp_store_release(&rbuf->pwrite, 0);
>
> WARNING: memory barrier without comment
> #145: FILE: drivers/media/dvb-core/dvb_ringbuffer.c:190:
> +	smp_store_release(&rbuf->pwrite, (rbuf->pwrite + todo) % rbuf->size);
>
> Thanks,
> Mauro
>

