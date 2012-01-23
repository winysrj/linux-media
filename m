Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab2AWQvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 11:51:44 -0500
Message-ID: <4F1D901A.6010101@redhat.com>
Date: Mon, 23 Jan 2012 14:51:38 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com> <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com> <4F1D7418.50201@redhat.com> <4F1D7BF4.4040603@samsung.com> <4F1D8575.5040906@redhat.com> <4F1D8CCB.8060805@samsung.com>
In-Reply-To: <4F1D8CCB.8060805@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 14:37, Tomasz Stanislawski escreveu:
> Hi Mauro,
> On 01/23/2012 05:06 PM, Mauro Carvalho Chehab wrote:
>> Em 23-01-2012 13:25, Tomasz Stanislawski escreveu:
>>> Hi Mauro,
>>>
>>> On 01/23/2012 03:52 PM, Mauro Carvalho Chehab wrote:
>>>> Em 23-01-2012 12:32, Tomasz Stanislawski escreveu:
>>>>> Hi Mauro,
>>>>>
>>>>> On 01/23/2012 03:22 PM, Mauro Carvalho Chehab wrote:
>>>>>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>>>>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>>>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>>>>>
>>>>>> Please better describe this patch. What is it supposing to fix?
> 
> [snip]
> 
>>>> It is also a waste of your time to submit a patch that will need to be later
>>>> polished, as you'll need to work with the same thing twice.
>>>
>>> The problem is that those patches were not intended to be accepted. The were intended for discussion.
>>
>> The patch subjects were not marked with RFC. Please prefix the subject with something like
>>     git send-email --subject-prefix " PATCH RFC"
>>
>> When submitting such patches.
> 
> Right!!!
> Sorry, I forgot about it. Probably, if I had added those 3 letter we would have avoided this whole misunderstanding about the purpose of the patches :)
> 
>>
>>> The other problem is that there are many people waiting for those patches. The dma-buf was already
>>> accepted to the mainline. Me and Sumit are trying to help V4L2 to catch-up. The dma-buf and its support
>>> in vb2-core seams to change very dynamically. Polishing the patch takes much time. If the dma-buf API
>>> changes the design of vb2-core may have to be changed. Therefore time spent on polishing would be lost.
>>
>> Ok.
>>
>>> I am sorry for patch flaws. All of them would be fixed when the design is stabilized.
>>
>> No problem.
>>
>>>
>>>>
>>>> So, please fix your patch workflow. As a general rule, you should
>>>> compile every patch you're applying and fix the breakages on them.
>>>>
>>>> Also, if you found bugs that need to be fixed and that aren't
>>>> directly related to your current task, those should generate
>>>> their own patches, and submitted in separate, in order to be
>>>> applied sooner upstream and to stable.
>>>
>>> I wanted to post the complete set of patches that produce compilable kernel.
>>> herefore most important bugs/issues had to be fixed and attached to the patchset.
>>> Some of the issues in [1] were mentioned by Laurent and Sakari. I hope Sumit will
>>> take care of those problems.
>>
>> Ok. My main concern was not with the driver bits, but with:
>>
>> 1) if fixes are needed at the vb2 core, to ensure that they'll go
>>     upstream earlier;
>>
> 
> First, we should select patches not related to DMABUF.
> 
> The fixes related to DMABUF could be postponed because they will be applied in new version for Sumit's patches.
> 
> Next videobuf2-dma-contig.c file is patched.
> 
> Fixes to handling of mmap and userptr would go first with all DMABUF related features removed. Lack of DMABUF related callbacks will not break backward compatibility.
> 
> Next, DMABUF support is added to vb2-core.
> 
> Finally, that DMABUF exporting/importing patches would be applied.

Sounds like a plan.

Regards,
Mauro
