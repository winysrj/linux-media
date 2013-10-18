Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33223 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab3JRJaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 05:30:16 -0400
Message-ID: <5260FF6D.3080305@ti.com>
Date: Fri, 18 Oct 2013 14:59:17 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, <linux-media@vger.kernel.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Handling of VM_IO vma in omap_vout_uservirt_to_phys()
References: <20131017221606.GA20365@quack.suse.cz>
In-Reply-To: <20131017221606.GA20365@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 18 October 2013 03:46 AM, Jan Kara wrote:
>    Hello,
>
>    I was auditing get_user_pages() users and I've noticed that
> omap_vout_uservirt_to_phys() is apparently called for arbitrary address
> passed from userspace. If this address is in VM_IO vma, we use
> vma->vm_pgoff for mapping the virtual address to a physical address.
> However I don't think this is a generally valid computation for arbitrary
> VM_IO vma. So do we expect vma to come from a particular source where this
> is true? If yes, where do we expect vma comes from? Thanks for
> clarification.

I don't know much about this domain, so I might be wrong here.

The function omap_vout_uservirt_to_phys() is used in the mode 
'V4L2_MEMORY_USERPTR', to recieve a virtual address from the user.

The driver hardware only works with physically contiguous buffers. So 
I'm guessing this vma maps to a buffer mmaped by the user application by 
some other device(like a camera or something). This way, the user 
doesn't need to copy the buffer between the 2 devices. I guess the 
computation works in that case. We don't have any safety checks for this 
though.

This driver is currenlty using the videobuf() framework, we would 
eventually switch to videobuf2(), and hopefully this code shouldn't even 
exist then.

Archit

