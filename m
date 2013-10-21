Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:33970 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3JUJSn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Oct 2013 05:18:43 -0400
Message-ID: <5264F133.9000407@ti.com>
Date: Mon, 21 Oct 2013 14:47:39 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: <linux-media@vger.kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Handling of VM_IO vma in omap_vout_uservirt_to_phys()
References: <20131017221606.GA20365@quack.suse.cz> <5260FF6D.3080305@ti.com> <20131018131100.GB20660@quack.suse.cz>
In-Reply-To: <20131018131100.GB20660@quack.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 October 2013 06:41 PM, Jan Kara wrote:
> On Fri 18-10-13 14:59:17, Archit Taneja wrote:
>> Hi,
>>
>> On Friday 18 October 2013 03:46 AM, Jan Kara wrote:
>>>    Hello,
>>>
>>>    I was auditing get_user_pages() users and I've noticed that
>>> omap_vout_uservirt_to_phys() is apparently called for arbitrary address
>>> passed from userspace. If this address is in VM_IO vma, we use
>>> vma->vm_pgoff for mapping the virtual address to a physical address.
>>> However I don't think this is a generally valid computation for arbitrary
>>> VM_IO vma. So do we expect vma to come from a particular source where this
>>> is true? If yes, where do we expect vma comes from? Thanks for
>>> clarification.
>>
>> I don't know much about this domain, so I might be wrong here.
>>
>> The function omap_vout_uservirt_to_phys() is used in the mode
>> 'V4L2_MEMORY_USERPTR', to recieve a virtual address from the user.
>>
>> The driver hardware only works with physically contiguous buffers.
>> So I'm guessing this vma maps to a buffer mmaped by the user
>> application by some other device(like a camera or something). This
>> way, the user doesn't need to copy the buffer between the 2 devices.
>> I guess the computation works in that case. We don't have any safety
>> checks for this though.
>    OK, so you really expect vma to be setup in a particular way. In
> videobuf2 framework this seems to correspond to what
> drivers/media/v4l2-core/videobuf2-vmalloc.c is doing (although that one is
> checking the range is really physically contiguous in
> vb2_get_contig_userptr()).
>
>> This driver is currenlty using the videobuf() framework, we would
>> eventually switch to videobuf2(), and hopefully this code shouldn't
>> even exist then.
>    This is good to know but if that isn't happening soon I guess I'll
> convert the code somehow because I want to do some changes to the way
> get_user_pages() is called.

I think the conversion will take some time.

I don't think we have tested user pointer support on omap_vout for quite 
a while. Anyway, I can still test to see if the change works fine or not.

Archit

