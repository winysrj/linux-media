Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49474 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab1C2Ulv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 16:41:51 -0400
Received: by qwk3 with SMTP id 3so405913qwk.19
        for <linux-media@vger.kernel.org>; Tue, 29 Mar 2011 13:41:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103291650.50501.hverkuil@xs4all.nl>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
	<201103291650.50501.hverkuil@xs4all.nl>
Date: Tue, 29 Mar 2011 22:41:50 +0200
Message-ID: <AANLkTi=tC6-bonR8bJc3U=gM0_0HNb4gwA2uqRd+Mm=w@mail.gmail.com>
Subject: Re: v4l: Buffer pools
From: Robert Fekete <robert.fekete@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Willy POISSON <willy.poisson@stericsson.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans!

On 29 March 2011 16:50, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, March 29, 2011 16:01:33 Willy POISSON wrote:
>> Hi all,
>>       Following to the Warsaw mini-summit action point, I would like to open the thread to gather buffer pool & memory manager requirements.
>> The list of requirement for buffer pool may contain:
>> -     Support physically contiguous and virtual memory

Only physical contigous allocator supported in hwmem as of today.

>> -     Support IPC, import/export handles (between processes/drivers/userland/etc)

Supported in hwmem

>> -     Security(access rights in order to secure no one unauthorized is allowed to access buffers)

Supported in hwmem

>> -     Cache flush management (by using setdomain and optimize when flushing is needed)

Supported in hwmem

>> -     Pin/unpin in order to get the actual address to be able to do defragmentation

Pin/unpin implemented but defragmentation not done...yet. It's more of
a memory allocator feature and I know CMA took influence of this and
added pin/unpin into CMA in order to be able to do defragmentation

>> -     Support pinning in user land in order to allow defragmentation while buffer is mmapped but not pined.
>> -     Both a user API and a Kernel API is needed for this module. (Kernel drivers needs to be able to resolve buffer handles as well from the memory manager module, and pin/unpin)

Supported in hwmem

>> -     be able to support any platform specific allocator (Separate memory allocation from management as allocator is platform dependant)

As Laurent pinpointed we have a tightly coupled physical contigous
memory allocator in hwmem today. Plan is to separate this more clearly
from the hwmem api's and also add a virtual memory allocator as
well(This is not supported today). We have also tested as a quick
prototype to use CMA as allocator.


>> -     Support multiple region domain (Allow to allocate from several memory domain ex: DDR1, DDR2, Embedded SRAM to make for ex bandwidth load balancing ...)

Not supported in hwmem today. No problems to add separate
regions(mapped to several ddr banks or whatever), although
loadbalancing and similar will likely need some fancy hw in order to
spread addresses across the regions efficiently.

>
> Thanks for your input, Willy!
>
> I have one question: do you know which of the points mentioned above are
> implemented in actual existing code that ST-Ericsson uses? Ideally with links
> to such code as well if available :-)
>
> That will help as a reference.
>

You can find the details of current hwmem in the linux-mm list.
http://marc.info/?l=linux-mm&w=2&r=1&s=hwmem&q=b

BR
/Robert Fekete
