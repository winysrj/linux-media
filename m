Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52094 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbbAPOyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 09:54:45 -0500
Message-ID: <54B92620.6020408@xs4all.nl>
Date: Fri, 16 Jan 2015 15:54:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>,
	linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl
Subject: Re: [PATCH] cx23885/vb2 regression: please test this patch
References: <54B52548.7010109@xs4all.nl> <54B55C23.1070409@apollo.lv>
In-Reply-To: <54B55C23.1070409@apollo.lv>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2015 06:55 PM, Raimonds Cicans wrote:
> On 13.01.2015 16:01, Hans Verkuil wrote:
>> Hi Raimonds, Jurgen,
>>
>> Can you both test this patch? It should (I hope) solve the problems you
>> both had with the cx23885 driver.
>>
>> This patch fixes a race condition in the vb2_thread that occurs when
>> the thread is stopped. The crucial fix is calling kthread_stop much
>> earlier in vb2_thread_stop(). But I also made the vb2_thread more
>> robust.
> 
> With this patch I am unable to get any error except first
> (AMD-Vi: Event logged [IO_PAGE_FAULT...).
> But I am not convinced, because before patch I get
> first error much often and earlier than almost any other error,
> so it may be just "bad luck" and other errors do not
> appear because first error appear earlier.

No, the first error and the others errors are unrelated.

Can you check that the function cx23885_risc_field in
drivers/media/pci/cx23885/cx23885-core.c uses "sg = sg_next(sg);"
instead of "sg++;"?

See also the original patch: https://patchwork.linuxtv.org/patch/27071/

To avoid confusion I would prefer that you test with a 3.18 or higher kernel
and please state which kernel version you use and whether you used the
media_build system or a specific git repo to build the drivers.

> 
> BTW question about RISC engine:
> what kind of memory use RISC engine to store
> DMA programs (code)? Internal SRAM or host's?

Internal SRAM.

> I ask because "cx23885[0]: mpeg risc op code error"
> error message storm after first message looks like
> RISC engine used host's memory when this memory
> was unmapped.

That's why I need to know whether sg_next is used or not. Because if that's
not the case, then that explains the error.

If you get the error again with a 3.18 or higher kernel and with my patch,
then please copy-and-paste that message again.

I'm also interested if you can reproduce it using just command-line tools
(and let me know what it is you do). Use only one DVB adapter, not both.

Regards,

	Hans
