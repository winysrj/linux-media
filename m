Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:58152 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab2AYOJn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 09:09:43 -0500
Received: by mail-tul01m020-f170.google.com with SMTP id up3so4029017obb.15
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 06:09:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1FDAAB.2040804@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
 <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com>
 <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com>
 <CAB2ybb8fXUARSriD2x-4TNLVtxpg5hA6NKjrAOOwzHJ0Cko6Ag@mail.gmail.com> <4F1FDAAB.2040804@samsung.com>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 25 Jan 2012 19:39:21 +0530
Message-ID: <CAB2ybb8DF=TY9rU-7mFT-Ashb634G9c-Ksc0V534hTWzQkN2+A@mail.gmail.com>
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,
On Wed, Jan 25, 2012 at 4:04 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
>
> Hi Sumit,
>
> On 01/25/2012 06:35 AM, Semwal, Sumit wrote:
>>
>> Hi Tomasz,
>> On Mon, Jan 23, 2012 at 8:55 PM, Tomasz Stanislawski
>> <t.stanislaws@samsung.com>  wrote:
>>>
>>> Hi Mauro,
>>>
>>>
>> <snip>
>>>
>>>
>>> Ok. I should have given more details about the patch. I am sorry for
>>> missing
>>> it. My kernel tree failed to compile after applying patches from
>>>
>>> [1]
>>>
>>> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
>>>
>>> I had to generate this patch to compile the code and test it. Most of the
>>> fixes refer to Sumit's code and I think he will take care of those bugs.
>>
>> Is your kernel tree a mainline kernel? I am pretty sure I posted out
>> the RFC after compile testing.
>
>
> Our development kernel often contains patches that are not posted to
> opensource. The tree presented in the cover letter contains only patches
> that were approved for opensource submission.
Right; I understand that - I just wanted to make sure you didn't hit
some problem with my patches that I didn't. Thanks for confirming that
it was your dev kernel.
>
> Some of the patches that are not merged into the mainline may break
> compilation if patches from the mailing list are applied on the top. The
> example is 'media: vb2: remove plane argument from call_memop and cleanup
> mempriv usage'. I had to add fixes to compile the code. Moreover I had to
> test a working application that makes use of DMABUF exporting/importing via
> V4L2 API. So I had to fix other issues that are not only compilation
> related.
>
I understand.
> As I remember we agreed that I had to post an incremental patchset.
> Therefore all needed fixes had to be present in the tree.
>
> The fixes were posted in this patchset to keep the whole work together.
> I expect that you already prepared a patch fixing majority of issues from
> this patch. Many of them were mentioned in Pawel's and Laurent's and
> Sakari's reviews. If you find fixes in this patch useful you can merge them
> into next version of RFC 'v4l: DMA buffer sharing support as a user'.
>
>
OK - this makes it quite clear; I will re-work my RFC then.

>>
>>>
>> <snip>
>>>
>>>
>>>
>>> I wanted to post the complete set of patches that produce compilable
>>> kernel.
>>> Therefore most important bugs/issues had to be fixed and attached to the
>>> patchset. Some of the issues in [1] were mentioned by Laurent and Sakari.
>>> I
>>> hope Sumit will take care of those problems.
>>
>> I must've misunderstood when you said 'I would like to take care of
>> these patches'. Please let me know if you'd like me to submit next
>> version of my RFC separately with fixes for these issues, or would you
>> manage that as part of your RFC patch series submission.
>
>
> This patchset is an RFC. It was my big mistake that I forgot to add this to
> the title of the patchset. I am not going to post the patch with fixes to
> your part any more. It would be great if you merged it into new version of
> 'DMA buffer sharing support as a user'.
>
That's OK with me.

> IMO, some parts should go as separate threads:
> - extension to DMA subsystem, introduction of dma_get_pages. This would
> probably go to DMA mailing list.
> - redesign of dma-contig allocator (w/o dmabuf exporting/importing)
> - buffer importing via dmabuf in V4L2 and vb2-dma-contig
> - buffer exporting via dmabuf in V4L2 and vb2-dma-contig
>
> BTW. Could you state your opinion on presented solution for dma-buf
> exporting in vb2-core and vb2-dma-contig allocator?
>
I agree with your ordering of these parts; Also, with this ordering, I
guess I should pay more attention to parts 1. (extension to DMA...)
and 2. (redesign of dma-contig allocator...) - which I hope you are
going to do? I can then base out my next version of RFC on these.

I was OoO for past couple of days, hence missed all the action :) - I
will try and go through your approach, and comment as soon as I can.
Hopefully in a couple of days.
> Regards,
> Tomasz Stanislawski
>
>
<snip>
Best regards,
~Sumit.
