Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:61792 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:37:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GTLFILWY80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 16:37:33 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY900IZ3FILTG@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 16:37:33 +0000 (GMT)
Date: Mon, 23 Jan 2012 17:37:31 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
In-reply-to: <4F1D8575.5040906@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Message-id: <4F1D8CCB.8060805@samsung.com>
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com>
 <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com>
 <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com>
 <4F1D8575.5040906@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
On 01/23/2012 05:06 PM, Mauro Carvalho Chehab wrote:
> Em 23-01-2012 13:25, Tomasz Stanislawski escreveu:
>> Hi Mauro,
>>
>> On 01/23/2012 03:52 PM, Mauro Carvalho Chehab wrote:
>>> Em 23-01-2012 12:32, Tomasz Stanislawski escreveu:
>>>> Hi Mauro,
>>>>
>>>> On 01/23/2012 03:22 PM, Mauro Carvalho Chehab wrote:
>>>>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>>>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>>
>>>>> Please better describe this patch. What is it supposing to fix?

[snip]

>>> It is also a waste of your time to submit a patch that will need to be later
>>> polished, as you'll need to work with the same thing twice.
>>
>> The problem is that those patches were not intended to be accepted. The were intended for discussion.
>
> The patch subjects were not marked with RFC. Please prefix the subject with something like
> 	git send-email --subject-prefix " PATCH RFC"
>
> When submitting such patches.

Right!!!
Sorry, I forgot about it. Probably, if I had added those 3 letter we 
would have avoided this whole misunderstanding about the purpose of the 
patches :)

>
>> The other problem is that there are many people waiting for those patches. The dma-buf was already
>> accepted to the mainline. Me and Sumit are trying to help V4L2 to catch-up. The dma-buf and its support
>> in vb2-core seams to change very dynamically. Polishing the patch takes much time. If the dma-buf API
>> changes the design of vb2-core may have to be changed. Therefore time spent on polishing would be lost.
>
> Ok.
>
>> I am sorry for patch flaws. All of them would be fixed when the design is stabilized.
>
> No problem.
>
>>
>>>
>>> So, please fix your patch workflow. As a general rule, you should
>>> compile every patch you're applying and fix the breakages on them.
>>>
>>> Also, if you found bugs that need to be fixed and that aren't
>>> directly related to your current task, those should generate
>>> their own patches, and submitted in separate, in order to be
>>> applied sooner upstream and to stable.
>>
>> I wanted to post the complete set of patches that produce compilable kernel.
>> herefore most important bugs/issues had to be fixed and attached to the patchset.
>> Some of the issues in [1] were mentioned by Laurent and Sakari. I hope Sumit will
>> take care of those problems.
>
> Ok. My main concern was not with the driver bits, but with:
>
> 1) if fixes are needed at the vb2 core, to ensure that they'll go
>     upstream earlier;
>

First, we should select patches not related to DMABUF.

The fixes related to DMABUF could be postponed because they will be 
applied in new version for Sumit's patches.

Next videobuf2-dma-contig.c file is patched.

Fixes to handling of mmap and userptr would go first with all DMABUF 
related features removed. Lack of DMABUF related callbacks will not 
break backward compatibility.

Next, DMABUF support is added to vb2-core.

Finally, that DMABUF exporting/importing patches would be applied.

> 2) The userspace API changes to properly support for dma buffers.
>
> If you're not ready to discuss (2), that's ok, but I'd like to follow
> the discussions for it with care, not only for reviewing the actual
> patches, but also since I want to be sure that it will address the
> needs for xawtv and for the Xorg v4l driver.
>

The support of dmabuf could be easily added to framebuffer API.
I expect that it would not be difficult to add it to Xv.
The selection API could be used to control scaling and composing
of video stream into framebuffer or a texture for composing manager.

Regards,
Tomasz Stanislawski

>>> Failing to do that will mean that important fixes for upstream
>>> will be missed.
>>
>> Ok. It will be fixed.
>
> Thanks!
>
> Mauro
>

