Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2AWOwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:52:15 -0500
Message-ID: <4F1D7418.50201@redhat.com>
Date: Mon, 23 Jan 2012 12:52:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH 04/10] v4l: vb2: fixes for DMABUF support
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-5-git-send-email-t.stanislaws@samsung.com> <4F1D6D3E.7020203@redhat.com> <4F1D6F68.5040202@samsung.com>
In-Reply-To: <4F1D6F68.5040202@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 12:32, Tomasz Stanislawski escreveu:
> Hi Mauro,
> 
> On 01/23/2012 03:22 PM, Mauro Carvalho Chehab wrote:
>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>
>> Please better describe this patch. What is it supposing to fix?
> 
> Usually compilation error or bugs discovered in previous
> vb2-dma-contig patches adding support for dma-buf.
>
>>
>>> ---
>>>   drivers/media/video/videobuf2-core.c |   21 +++++++++------------
>>>   include/media/videobuf2-core.h       |    6 +++---
>>>   2 files changed, 12 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
>>> index cb85874..59bb1bc 100644
>>> --- a/drivers/media/video/videobuf2-core.c
>>> +++ b/drivers/media/video/videobuf2-core.c
>>> @@ -119,7 +119,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>>>           void *mem_priv = vb->planes[plane].mem_priv;
>>>
>>>           if (mem_priv) {
>>> -            call_memop(q, plane, detach_dmabuf, mem_priv);
>>> +            call_memop(q, detach_dmabuf, mem_priv);
>>
>> Huh? You're not removing the "plane" parameter on this patch, but, instead,
>> on a previous patch.
>>
>> No patch is allowed to break compilation, as it breaks git bisect.
> 
> I agree that patches should not break compilation if patches are accepted to
> the mainline. There is a big compilation failure at patch 07 where videobuf2-dma-contig.c disappears.
> 
> Note that these are proof-of-concept patches for support of dma-buf exporting/importing dma-buf in V4L2.
> It would be a waste of time polished the patches if they are going to be rejected due to design flaws.

It is a waste of time for the reviewers to see a patch like this one,
as:
	- No description of what is inside the patch is provided;
	- changes that should be happening inside the other patches are
	  mixed here.

It is also a waste of your time to submit a patch that will need to be later
polished, as you'll need to work with the same thing twice.

So, please fix your patch workflow. As a general rule, you should
compile every patch you're applying and fix the breakages on them.

Also, if you found bugs that need to be fixed and that aren't 
directly related to your current task, those should generate
their own patches, and submitted in separate, in order to be
applied sooner upstream and to stable.

Failing to do that will mean that important fixes for upstream
will be missed.

Regards,
Mauro
