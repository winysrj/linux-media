Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64778 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3ENNil (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 09:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
References: <CAAQKjZNNw4qddo6bE5OY_CahrqDtqkxdO7Pm9RCguXyj9F4cMQ@mail.gmail.com>
	<51909DB4.2060208@canonical.com>
	<025201ce4fbb$363d0390$a2b70ab0$%dae@samsung.com>
	<5190B7D8.3010803@canonical.com>
	<027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
	<5190D14A.7050904@canonical.com>
	<028a01ce4fd4$5ec6f000$1c54d000$%dae@samsung.com>
	<CAF6AEGvWazezZdLDn5=H8wNQdQSWV=EmqE1a4wh7QwrT_h6vKQ@mail.gmail.com>
	<CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
	<CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
	<006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
Date: Tue, 14 May 2013 09:38:40 -0400
Message-ID: <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
From: Rob Clark <robdclark@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 13, 2013 at 10:52 PM, Inki Dae <inki.dae@samsung.com> wrote:
>> well, for cache management, I think it is a better idea.. I didn't
>> really catch that this was the motivation from the initial patch, but
>> maybe I read it too quickly.  But cache can be decoupled from
>> synchronization, because CPU access is not asynchronous.  For
>> userspace/CPU access to buffer, you should:
>>
>>   1) wait for buffer
>>   2) prepare-access
>>   3)  ... do whatever cpu access to buffer ...
>>   4) finish-access
>>   5) submit buffer for new dma-operation
>>
>
>
> For data flow from CPU to DMA device,
> 1) wait for buffer
> 2) prepare-access (dma_buf_begin_cpu_access)
> 3) cpu access to buffer
>
>
> For data flow from DMA device to CPU
> 1) wait for buffer

Right, but CPU access isn't asynchronous (from the point of view of
the CPU), so there isn't really any wait step at this point.  And if
you do want the CPU to be able to signal a fence from userspace for
some reason, you probably what something file/fd based so the
refcnting/cleanup when process dies doesn't leave some pending DMA
action wedged.  But I don't really see the point of that complexity
when the CPU access isn't asynchronous in the first place.

BR,
-R


> 2) finish-access (dma_buf_end _cpu_access)
> 3) dma access to buffer
>
> 1) and 2) are coupled with one function: we have implemented
> fence_helper_commit_reserve() for it.
>
> Cache control(cache clean or cache invalidate) is performed properly
> checking previous access type and current access type.
> And the below is actual codes for it,
