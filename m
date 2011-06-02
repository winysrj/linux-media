Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:39415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab1FBBel (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2011 21:34:41 -0400
Message-ID: <4DE6E8A7.2080305@infradead.org>
Date: Wed, 01 Jun 2011 22:34:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] [media] V4L/videobuf2-memops: use pr_debug for debug
 messages
References: <1306959563-7108-1-git-send-email-u.kleine-koenig@pengutronix.de> <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com>
In-Reply-To: <BANLkTimG=xP7qvpN7G8+Mmmy-JozEpyPNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kyungmin,

Em 01-06-2011 21:50, Kyungmin Park escreveu:
> Acked-by: Kyungmin Park <kyunginn.,park@samsung.com>

As this patch is really trivial and makes sense, I've just applied it earlier
today.

> ---
> 
> I think it's better to add the videobuf2 maintainer entry for proper
> person to know the changes.
> In this case, Marek is missing.
> 
> If any objection, I will make a patch.

No objections from my side. Having the proper driver maintainers written at MAINTAINERS
help people when submitting patches to send the patch to the proper driver maintainer.

Thanks,
Mauro.

> 
> Thank you,
> Kyungmin Park
> 
> 2011/6/2 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
>> Otherwise they clutter the dmesg buffer even on a production kernel.
>>
>> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> ---
>>  drivers/media/video/videobuf2-memops.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
>> index 5370a3a..1987e1b1 100644
>> --- a/drivers/media/video/videobuf2-memops.c
>> +++ b/drivers/media/video/videobuf2-memops.c
>> @@ -177,7 +177,7 @@ int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
>>
>>        vma->vm_ops->open(vma);
>>
>> -       printk(KERN_DEBUG "%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
>> +       pr_debug("%s: mapped paddr 0x%08lx at 0x%08lx, size %ld\n",
>>                        __func__, paddr, vma->vm_start, size);
>>
>>        return 0;
>> @@ -195,7 +195,7 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
>>  {
>>        struct vb2_vmarea_handler *h = vma->vm_private_data;
>>
>> -       printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>> +       pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>>               __func__, h, atomic_read(h->refcount), vma->vm_start,
>>               vma->vm_end);
>>
>> @@ -213,7 +213,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
>>  {
>>        struct vb2_vmarea_handler *h = vma->vm_private_data;
>>
>> -       printk(KERN_DEBUG "%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>> +       pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
>>               __func__, h, atomic_read(h->refcount), vma->vm_start,
>>               vma->vm_end);
>>
>> --
>> 1.7.5.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

