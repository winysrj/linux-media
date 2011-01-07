Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:51027 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1AGKCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 05:02:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Date: Fri, 07 Jan 2011 19:02:14 +0900
From: daeinki <inki.dae@samsung.com>
Subject: Re: Memory sharing issue by application on V4L2 based device driver
 with system mmu.
In-reply-to: <1294390465.6019.212.camel@thor.local>
To: =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel@daenzer.net>
Cc: InKi Dae <daeinki@gmail.com>,
	Jonghun Han <jonghun.han@samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	kyungmin.park@samsung.com
Message-id: <4D26E4A6.2020103@samsung.com>
Content-transfer-encoding: 8BIT
References: <4D25BC22.6080803@samsung.com>
 <AANLkTi=P8qY22saY9a_-rze1wsr-DLMgc6Lfa6qnfM7u@mail.gmail.com>
 <002201cbadfd$6d59e490$480dadb0$%han@samsung.com>
 <AANLkTinsduJkynwwEeM5K9f3D7C6jtBgkAyZ0-_0z2X-@mail.gmail.com>
 <1294390465.6019.212.camel@thor.local>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Michel Dänzer 쓴 글:
> On Fre, 2011-01-07 at 11:17 +0900, InKi Dae wrote: 
>> thank you for your comments.
>>
>> your second comment has no any problem as I said before, user virtual
>> addess could be translated in page unit. but the problem, as you said,
>> is that when cpu access to the memory in user mode, the memory
>> allocated by malloc, page fault occurs so we can't find pfn to user
>> virtual address. I missed that. but I think we could resolve this one.
>>
>> as before, user application allocates memory through malloc function
>> and then send it to device driver(using userptr feature). if the pfn
>> is null when device driver translated user virtual address in page
>> unit then it allocates phsical memory in page unit using some
>> interface such as alloc_page() and then mapping them. when pfn is
>> null, to check it and allocate physical memory in page unit could be
>> processed by videobuf2.
>>
>> of course, videobuf2 has no any duty considered for system mmu. so
>> videobuf2 just provides callback for 3rd party and any platform with
>> system mmu such as Samsung SoC C210 implements the function(allocating
>> physical memory and mapping it) and registers it to callback of
>> videobuf2. by doing so, I think your first comment could be cleared.
> 
> FWIW, TTM (drivers/gpu/drm/ttm, include/drm/ttm) is designed and used
> for managing memory between CPU/GPU and kernel/userspace access. I
> haven't looked at your requirements in detail, but if you haven't looked
> at TTM yet, it sounds like it might be worth a look.
> 
> 
Thank you for your advice. I would look at TTM driver.
