Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:52609 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3HAN74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 09:59:56 -0400
Received: by mail-ob0-f179.google.com with SMTP id fb19so3793731obc.24
        for <linux-media@vger.kernel.org>; Thu, 01 Aug 2013 06:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130731063742.GP12281@valkosipuli.retiisi.org.uk>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
 <20130719141603.16ef8f0b@lwn.net> <51F65190.9080601@samsung.com>
 <20130729091644.4229dcf6@lwn.net> <20130731063742.GP12281@valkosipuli.retiisi.org.uk>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 1 Aug 2013 15:59:35 +0200
Message-ID: <CAPybu_36zDUc7U+8oHovW07DmHcgCuZUa5hihR2QU3NuMi-EMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as possible
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakarius

I think the whole point of the videobuf2 is sharing pages with the
user space, so until vm_insert_page does not support high order pages
we should split them. Unfortunately the mm is completely out of my
topic, so I don't think that I could be very useful there.

With my patch, in the worst case scenario, the image is split in as
many blocks as today, but in a normal setup the ammount of blocks is 1
or two blocks in total!.

Best regards.





On Wed, Jul 31, 2013 at 8:37 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Jon and Sylwester,
>
> On Mon, Jul 29, 2013 at 09:16:44AM -0600, Jonathan Corbet wrote:
>> On Mon, 29 Jul 2013 13:27:12 +0200
>> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>>
>> > > You've gone to all this trouble to get a higher-order allocation so you'd
>> > > have fewer segments, then you undo it all by splitting things apart into
>> > > individual pages.  Why?  Clearly I'm missing something, this seems to
>> > > defeat the purpose of the whole exercise?
>> >
>> > Individual zero-order pages are required to get them mapped to userspace in
>> > mmap callback.
>>
>> Yeah, Ricardo explained that too.  The right solution might be to fix that
>> problem rather than work around it, but I can see why one might shy at that
>> task! :)
>>
>> I do wonder, though, if an intermediate solution using huge pages might be
>> the best approach?  That would get the number of segments down pretty far,
>> and using huge pages for buffers would reduce TLB pressure significantly
>> if the CPU is working through the data at all.  Meanwhile, inserting huge
>> pages into the process's address space should work easily.  Just a thought.
>
> My ack to that.
>
> And in the case of dma-buf the buffer doesn't need to be mapped to user
> space. It'd be quite nice to be able to share higher order allocations even
> if they couldn't be mapped to user space as such.
>
> Using 2 MiB pages would probably solve Ricardo's issue, but used alone
> they'd waste lots of memory for small buffers. If small pages (in Ricardo's
> case) were used when 2 MiB pages would be too big, e.g. 1 MiB buffer would
> already have 256 pages in it. Perhaps it'd be useful to specify whether
> large pages should be always preferred over smaller ones.
>
> --
> Kind regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     XMPP: sailus@retiisi.org.uk



-- 
Ricardo Ribalda
