Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57871 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1HBOsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 10:48:52 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LPB0027R2HEAW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 15:48:50 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.58])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPB00HSU2HBGU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 15:48:50 +0100 (BST)
Date: Tue, 02 Aug 2011 16:48:48 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
In-reply-to: <CAHQjnONh3=dRfL-_6gBT2pa=erRKUe9OMiMQjXDQyN493Gz4tw@mail.gmail.com>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E380E50.8030302@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4E37C7D7.40301@samsung.com>
 <CAHQjnONh3=dRfL-_6gBT2pa=erRKUe9OMiMQjXDQyN493Gz4tw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2011-08-02 13:59, KyongHo Cho wrote:
> On Tue, Aug 2, 2011 at 6:48 PM, Marek Szyprowski
> <m.szyprowski@samsung.com>  wrote:
>> Hello Everyone,
>>
>> This patchset introduces the proof-of-concept infrastructure for buffer
>> sharing between multiple devices using file descriptors. The infrastructure
>> has been integrated with V4L2 framework, more specifically videobuf2 and two
>> S5P drivers FIMC (capture interface) and TV drivers, but it can be easily
>> used by other kernel subsystems, like DRI.
>>
>> In this patch the buffer object has been simplified to absolute minimum - it
>> contains only the buffer physical address (only physically contiguous
>> buffers are supported), but this can be easily extended to complete scatter
>> list in the future.
>>
>
> Is this patch set an attempt to share a buffer between different
> processes via open file descriptors?
> Your patches seems to include several constructs to pack information
> about a buffer in an open file descriptor
> and to unpack it.
>
> I don't have any idea what is the purpose of your attempts.
> Is it the first step to the unified memory model that is being
> discussed in Linaro?

Yes, these patches were posted to demonstrate how sharing the buffers 
between different devices (currently only v4l2 based) can be 
implemented. We are discussing the idea of sharing the buffers on Memory 
Management summit on Linaro Sprint in Cambourne.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


