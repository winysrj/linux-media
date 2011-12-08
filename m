Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39794 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1LHVnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 16:43:06 -0500
Received: by eekc4 with SMTP id c4so78031eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2011 13:43:04 -0800 (PST)
Message-ID: <4EE12F64.8000002@gmail.com>
Date: Thu, 08 Dec 2011 22:43:00 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH v2] media: vb2: vmalloc-based allocator user pointer handling
References: <1323275346-25824-1-git-send-email-m.szyprowski@samsung.com> <201112081156.02438.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112081156.02438.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/08/2011 11:56 AM, Laurent Pinchart wrote:
> On Wednesday 07 December 2011 17:29:06 Marek Szyprowski wrote:
>> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
[...]
>> -	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at vaddr=%p\n",
>> -			buf->size, buf->vaddr);
>> +	pr_err("Allocated vmalloc buffer of size %ld at vaddr=%p\n", buf->size,
>> +	       buf->vaddr);
> 
> Turning KERN_DEBUG into pr_err() is a bit harsh :-) In my opinion even 
> KERN_DEBUG is too much here, I don't want to get messages printed to the 
> kernel log every time I allocate buffers.

Indeed, pr_err looks like an overkill:) I think pr_debug() would be fine here.

> 
>>  	return buf;
>>  }
>> @@ -59,13 +63,87 @@ static void vb2_vmalloc_put(void *buf_priv)
>>  	struct vb2_vmalloc_buf *buf = buf_priv;
>>
>>  	if (atomic_dec_and_test(&buf->refcount)) {
>> -		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
>> -			__func__, buf->vaddr);
>> +		pr_debug("%s: Freeing vmalloc mem at vaddr=%p\n", __func__,
>> +			 buf->vaddr);
> 
> Same here. Should we get rid of those two messages, or at least conditionally-
> compile them out of the kernel by default ?

During compilation pr_debug() will most likely be optimized away if DEBUG and
CONFIG_DYNAMIC_DEBUG isn't defined, as it is then defined as:

static inline __printf(1, 2)
int no_printk(const char *fmt, ...)
{
	return 0;
}

Plus it's easy with pr_debug() to enable debug trace while dynamic printk()
is enabled in the kernel configuration.

--

Regards,
Sylwester
