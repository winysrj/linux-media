Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43781 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab1LKXXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 18:23:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [PATCH v2] media: vb2: vmalloc-based allocator user pointer handling
Date: Mon, 12 Dec 2011 00:24:03 +0100
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
References: <1323275346-25824-1-git-send-email-m.szyprowski@samsung.com> <201112081156.02438.laurent.pinchart@ideasonboard.com> <4EE12F64.8000002@gmail.com>
In-Reply-To: <4EE12F64.8000002@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112120024.04418.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 08 December 2011 22:43:00 Sylwester Nawrocki wrote:
> Hi Laurent,
> 
> On 12/08/2011 11:56 AM, Laurent Pinchart wrote:
> > On Wednesday 07 December 2011 17:29:06 Marek Szyprowski wrote:
> >> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> [...]
> 
> >> -	printk(KERN_DEBUG "Allocated vmalloc buffer of size %ld at
> >> vaddr=%p\n", -			buf->size, buf->vaddr);
> >> +	pr_err("Allocated vmalloc buffer of size %ld at vaddr=%p\n",
> >> buf->size, +	       buf->vaddr);
> > 
> > Turning KERN_DEBUG into pr_err() is a bit harsh :-) In my opinion even
> > KERN_DEBUG is too much here, I don't want to get messages printed to the
> > kernel log every time I allocate buffers.
> 
> Indeed, pr_err looks like an overkill:) I think pr_debug() would be fine
> here.
> 
> >>  	return buf;
> >>  
> >>  }
> >> 
> >> @@ -59,13 +63,87 @@ static void vb2_vmalloc_put(void *buf_priv)
> >> 
> >>  	struct vb2_vmalloc_buf *buf = buf_priv;
> >>  	
> >>  	if (atomic_dec_and_test(&buf->refcount)) {
> >> 
> >> -		printk(KERN_DEBUG "%s: Freeing vmalloc mem at vaddr=%p\n",
> >> -			__func__, buf->vaddr);
> >> +		pr_debug("%s: Freeing vmalloc mem at vaddr=%p\n", __func__,
> >> +			 buf->vaddr);
> > 
> > Same here. Should we get rid of those two messages, or at least
> > conditionally- compile them out of the kernel by default ?
> 
> During compilation pr_debug() will most likely be optimized away if DEBUG
> and CONFIG_DYNAMIC_DEBUG isn't defined, as it is then defined as:
> 
> static inline __printf(1, 2)
> int no_printk(const char *fmt, ...)
> {
> 	return 0;
> }
> 
> Plus it's easy with pr_debug() to enable debug trace while dynamic printk()
> is enabled in the kernel configuration.

My bad. pr_debug() is fine.

-- 
Regards,

Laurent Pinchart
