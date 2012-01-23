Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab2AWQGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:06:20 -0500
Message-ID: <4F1D8575.5040906@redhat.com>
Date: Mon, 23 Jan 2012 14:06:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com> <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com> <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com>
In-Reply-To: <4F1D7BF4.4040603@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 13:25, Tomasz Stanislawski escreveu:
> Hi Mauro,
> 
> On 01/23/2012 03:52 PM, Mauro Carvalho Chehab wrote:
>> Em 23-01-2012 12:32, Tomasz Stanislawski escreveu:
>>> Hi Mauro,
>>>
>>> On 01/23/2012 03:22 PM, Mauro Carvalho Chehab wrote:
>>>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>
>>>> Please better describe this patch. What is it supposing to fix?
>>>
>>> Usually compilation error or bugs discovered in previous
>>> vb2-dma-contig patches adding support for dma-buf.
>>>
>>>>
>>>>> ---
>>>>>    drivers/media/video/videobuf2-core.c |   21 +++++++++------------
>>>>>    include/media/videobuf2-core.h       |    6 +++---
>>>>>    2 files changed, 12 insertions(+), 15 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>>>>> index cb85874..59bb1bc 100644
>>>>> --- a/drivers/media/video/videobuf2-core.c
>>>>> +++ b/drivers/media/video/videobuf2-core.c
>>>>> @@ -119,7 +119,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>>>>>            void *mem_priv = vb->planes[plane].mem_priv;
>>>>>
>>>>>            if (mem_priv) {
>>>>> -            call_memop(q, plane, detach_dmabuf, mem_priv);
>>>>> +            call_memop(q, detach_dmabuf, mem_priv);
>>>>
>>>> Huh? You're not removing the "plane" parameter on this patch, but, instead,
>>>> on a previous patch.
>>>>
>>>> No patch is allowed to break compilation, as it breaks git bisect.
>>>
>>> I agree that patches should not break compilation if patches are accepted to
>>> the mainline. There is a big compilation failure at patch 07 where videobuf2-dma-contig.c disappears.
>>>
>>> Note that these are proof-of-concept patches for support of dma-buf exporting/importing dma-buf in V4L2.
>>> It would be a waste of time polished the patches if they are going to be rejected due to design flaws.
>>
>> It is a waste of time for the reviewers to see a patch like this one,
>> as:
>>     - No description of what is inside the patch is provided;
> 
> Ok. I should have given more details about the patch. I am sorry for missing it. My kernel tree failed to compile after applying patches from
> 
> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966/focus=42968
> 
> I had to generate this patch to compile the code and test it. Most of the fixes refer to Sumit's code and I think he will take care of those bugs.

Ok.

> 
> I admit that I focused on other patches. Like DMA extension, exporting in vb2-core and vb2-dma-contig. Sorry for putting so little attention to bugfixing patch.
> 
>>     - changes that should be happening inside the other patches are
>>       mixed here.
> 
> Right. I missed call_memop here.
> 
>>
>> It is also a waste of your time to submit a patch that will need to be later
>> polished, as you'll need to work with the same thing twice.
> 
> The problem is that those patches were not intended to be accepted. The were intended for discussion. 

The patch subjects were not marked with RFC. Please prefix the subject with something like
	git send-email --subject-prefix " PATCH RFC"

When submitting such patches.

> The other problem is that there are many people waiting for those patches. The dma-buf was already 
> accepted to the mainline. Me and Sumit are trying to help V4L2 to catch-up. The dma-buf and its support
> in vb2-core seams to change very dynamically. Polishing the patch takes much time. If the dma-buf API 
> changes the design of vb2-core may have to be changed. Therefore time spent on polishing would be lost. 

Ok.

> I am sorry for patch flaws. All of them would be fixed when the design is stabilized.

No problem.

> 
>>
>> So, please fix your patch workflow. As a general rule, you should
>> compile every patch you're applying and fix the breakages on them.
>>
>> Also, if you found bugs that need to be fixed and that aren't
>> directly related to your current task, those should generate
>> their own patches, and submitted in separate, in order to be
>> applied sooner upstream and to stable.
> 
> I wanted to post the complete set of patches that produce compilable kernel. 
> herefore most important bugs/issues had to be fixed and attached to the patchset.
> Some of the issues in [1] were mentioned by Laurent and Sakari. I hope Sumit will
> take care of those problems.

Ok. My main concern was not with the driver bits, but with:

1) if fixes are needed at the vb2 core, to ensure that they'll go
   upstream earlier;

2) The userspace API changes to properly support for dma buffers.

If you're not ready to discuss (2), that's ok, but I'd like to follow
the discussions for it with care, not only for reviewing the actual
patches, but also since I want to be sure that it will address the
needs for xawtv and for the Xorg v4l driver. 

>> Failing to do that will mean that important fixes for upstream
>> will be missed.
> 
> Ok. It will be fixed.

Thanks!

Mauro
