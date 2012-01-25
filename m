Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42215 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2AYKeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 05:34:23 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYC00KSRO1A3U@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 10:34:22 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LYC00H4IO199I@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Jan 2012 10:34:22 +0000 (GMT)
Date: Wed, 25 Jan 2012 11:34:19 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
In-reply-to: <CAB2ybb8fXUARSriD2x-4TNLVtxpg5hA6NKjrAOOwzHJ0Cko6Ag@mail.gmail.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: linux-media@vger.kernel.org
Message-id: <4F1FDAAB.2040804@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
 <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com>
 <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com>
 <CAB2ybb8fXUARSriD2x-4TNLVtxpg5hA6NKjrAOOwzHJ0Cko6Ag@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sumit,
On 01/25/2012 06:35 AM, Semwal, Sumit wrote:
> Hi Tomasz,
> On Mon, Jan 23, 2012 at 8:55 PM, Tomasz Stanislawski
> <t.stanislaws@samsung.com>  wrote:
>> Hi Mauro,
>>
>>
> <snip>
>>
>> Ok. I should have given more details about the patch. I am sorry for missing
>> it. My kernel tree failed to compile after applying patches from
>>
>> [1]
>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
>>
>> I had to generate this patch to compile the code and test it. Most of the
>> fixes refer to Sumit's code and I think he will take care of those bugs.
> Is your kernel tree a mainline kernel? I am pretty sure I posted out
> the RFC after compile testing.

Our development kernel often contains patches that are not posted to 
opensource. The tree presented in the cover letter contains only patches 
that were approved for opensource submission.

Some of the patches that are not merged into the mainline may break 
compilation if patches from the mailing list are applied on the top. The 
example is 'media: vb2: remove plane argument from call_memop and 
cleanup mempriv usage'. I had to add fixes to compile the code. Moreover 
I had to test a working application that makes use of DMABUF 
exporting/importing via V4L2 API. So I had to fix other issues that are 
not only compilation related.

As I remember we agreed that I had to post an incremental patchset.
Therefore all needed fixes had to be present in the tree.

The fixes were posted in this patchset to keep the whole work together.
I expect that you already prepared a patch fixing majority of issues 
from this patch. Many of them were mentioned in Pawel's and Laurent's 
and Sakari's reviews. If you find fixes in this patch useful you can 
merge them into next version of RFC 'v4l: DMA buffer sharing support as 
a user'.

>
>>
> <snip>
>>
>>
>> I wanted to post the complete set of patches that produce compilable kernel.
>> Therefore most important bugs/issues had to be fixed and attached to the
>> patchset. Some of the issues in [1] were mentioned by Laurent and Sakari. I
>> hope Sumit will take care of those problems.
> I must've misunderstood when you said 'I would like to take care of
> these patches'. Please let me know if you'd like me to submit next
> version of my RFC separately with fixes for these issues, or would you
> manage that as part of your RFC patch series submission.

This patchset is an RFC. It was my big mistake that I forgot to add this 
to the title of the patchset. I am not going to post the patch with 
fixes to your part any more. It would be great if you merged it into new 
version of 'DMA buffer sharing support as a user'.

IMO, some parts should go as separate threads:
- extension to DMA subsystem, introduction of dma_get_pages. This would 
probably go to DMA mailing list.
- redesign of dma-contig allocator (w/o dmabuf exporting/importing)
- buffer importing via dmabuf in V4L2 and vb2-dma-contig
- buffer exporting via dmabuf in V4L2 and vb2-dma-contig

BTW. Could you state your opinion on presented solution for dma-buf 
exporting in vb2-core and vb2-dma-contig allocator?

Regards,
Tomasz Stanislawski

>>
>>>
>>> Failing to do that will mean that important fixes for upstream
>>> will be missed.
>>
>>
>> Ok. It will be fixed.
>>
>>>
>>> Regards,
>>> Mauro
>>>
>>
>> Regards,
>> Tomasz Stanislawski
>>
> Best regards,
> ~Sumit.

