Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35241 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1DUJ5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:57:32 -0400
Received: by qyg14 with SMTP id 14so897114qyg.19
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2011 02:57:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110421094743.GA8503@minime.bse>
References: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
	<20110421075947.GA8178@minime.bse>
	<BANLkTimHX8aYoeSU1ES0Tw0Swaz9xYLt=Q@mail.gmail.com>
	<20110421094743.GA8503@minime.bse>
Date: Thu, 21 Apr 2011 17:57:31 +0800
Message-ID: <BANLkTimO-4ubi7qUCncB9Z+wwNx1LURvfQ@mail.gmail.com>
Subject: Re: [PATCH v3] media:uvc_driver: add uvc support on no-mmu arch
From: Bob Liu <lliubbo@gmail.com>
To: Bob Liu <lliubbo@gmail.com>, linux-media@vger.kernel.org,
	dhowells@redhat.com, linux-uvc-devel@lists.berlios.de,
	mchehab@redhat.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de, vapier@gentoo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 21, 2011 at 5:47 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> On Thu, Apr 21, 2011 at 04:20:36PM +0800, Bob Liu wrote:
>> > on mmu systems do_mmap_pgoff contains a len = PAGE_ALIGN(len); line.
>> > If we depend on this behavior, why not do it here as well and get rid
>> > of the #ifdef?
>> >
>>
>> If do it in do_mmap_pgoff() the whole system will be effected, I am
>> not sure whether
>> it's correct and needed for other subsystem.
>
> With "here" I was referring to uvc_queue_mmap.
>

I am sorry, I didn't get your idea. You mean using  PAGE_ALIGN() here for both
mmu and no-mmu arch ?

>> >> +     addr = (unsigned long)queue->mem + buffer->buf.m.offset;
>> >> +     ret = addr;
>> >
>> > Why the intermediate step using addr?
>> >
>>
>> If don't return addr, do_mmap_pgoff() will return failure and we can't
>> setup vma correctly.
>> See mm/nommu.c line 1386(add = file->f_op->get_unmmapped_area() ).
>
> I know, but why not do
>        ret = (unsigned long)queue->mem + buffer->buf.m.offset;
> instead?
>

Okay.
Thanks

-- 
Regards,
--Bob
