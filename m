Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.wa.amnet.net.au ([203.161.124.51]:33447 "EHLO
	smtp2.wa.amnet.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbbJEOjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2015 10:39:16 -0400
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
To: Steven Toth <stoth@kernellabs.com>
References: <5610B12B.8090201@tresar-electronics.com.au>
 <CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
 <5611D97B.9020101@tresar-electronics.com.au>
 <CALzAhNVVipTAE3T9Hpmi8_CT=ZS5Wd04W5LfMaf-X5QP2d0sQw@mail.gmail.com>
 <56128AA6.8010106@tresar-electronics.com.au>
Cc: Linux-Media <linux-media@vger.kernel.org>
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Message-ID: <56128B91.2090100@tresar-electronics.com.au>
Date: Mon, 5 Oct 2015 22:39:13 +0800
MIME-Version: 1.0
In-Reply-To: <56128AA6.8010106@tresar-electronics.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi
   Just for clarification
I forgot to add that I had already got past that little bump by chunking 
the allocation to src_buf in the same loop as the memcpy_toio
But I'll rebuild the module with the memcpy_toio directly accessing src 
and see how it goes.

Regards
    Richard Tresidder

On 05/10/15 22:35, Richard Tresidder wrote:
>
>
> On 05/10/15 22:22, Steven Toth wrote:
>> On Sun, Oct 4, 2015 at 9:59 PM, Richard Tresidder
>> <rtresidd@tresar-electronics.com.au> wrote:
>>> Hi Steven
>>>     Nope standard x86_64
>>> kernel 3.10.0-229.14.1.el7.x86_64
>> Hmm.
>>
>>> Was rather surprised as all my quick reading indicates that the kernel
>>> should quite happily do this...
>>> Though looks like its the largest chunk you can request? I'm not 
>>> well enough
>>> up to speed with the nitty gritty..
>> Yeah, 4MB is the upper limit IIRC.
>>
>>> There is mention of something similar against this card on www 
>>> linuxtv org
>>> wiki index.php  Hauppauge_WinTV-HVR-2200
>>>
>>> ********
>>> Note: Some kernels will not have enough free memory available for the
>>> driver. The dmesg error will start with a message like this:
>>> ] modprobe: page allocation failure: order:10, mode:0x2000d0
>>> followed by a stack trace and other debugging information. While the 
>>> driver
>>> will load, no devices will be registered.
>>> The simple workaround is to allocate more memory for the kernel:
>>> sudo /bin/echo 16384 > /proc/sys/vm/min_free_kbytes
>>> sudo rmmod saa7164
>>> sudo modprobe saa7164
>>> ********
>> Hmm. I wasn't aware people in the past has seen the issue either. I
>> assume you've tried the above and its not helping, or in fact growing
>> that number for experimentation purposes.
>>
>> Do you have a large number of other devices / drivers loaded? I
>> suspect another driver is burning through kernel memory before the
>> saa7164 has a chance to be initialized.
> Nope nothing I can see Its actually the only addon card I have in this 
> system..
> I'd be buggered If 4GB of RAM is fragmented enough early on in the 
> boot stage...?
> I've hunted but can't find a nice way to determine what contiguous 
> blocks are available..
> Noted there was a simple module that could be compiled in to test such 
> things, I'll play with that and see what it turns up..
>
>> I took a quick look at saa7164-fw.c this morning, I see no reason why
>> the allocation is required at all. With a small patch the function
>> could be made to memcpy from 'src' directly, dropping the need to
>> allocate srcbuf what-so-ever. This would remove the need for the 4MB
>> temporary allocation, and might get you past this issue, likely on to
>> the next (user buffer allocations are also large - as I recall). Note
>> that the 4MB allocation is temporary, so its not a long term saving,
>> but it might get you past the hump.
> That was my thoughts exactly.. but I took a minimal fiddling approach 
> to begin with..
> I wasn't sure if there was some requirement for the memcpy_toio 
> requiring a specially allocated source..? can't see why..
> Was going to dig into that next as a side job..
>
>

