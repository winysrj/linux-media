Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38769 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413AbbHNQRq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 12:17:46 -0400
Received: by wicja10 with SMTP id ja10so25990357wic.1
        for <linux-media@vger.kernel.org>; Fri, 14 Aug 2015 09:17:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150813.211155.1774898831276303437.davem@davemloft.net>
References: <20150813143150.GA17183@lst.de>
	<CAA9_cmcNA__N_yVTKsEqLAKBuoL-hx73t6opdsmb7w-0qKXaWg@mail.gmail.com>
	<1439524760.8421.23.camel@HansenPartnership.com>
	<20150813.211155.1774898831276303437.davem@davemloft.net>
Date: Fri, 14 Aug 2015 09:17:45 -0700
Message-ID: <CAPcyv4idztwrtr5wBQkiTSNT8L3HWf8zk9webheQAmunLD7cBw@mail.gmail.com>
Subject: Re: [PATCH 29/31] parisc: handle page-less SG entries
From: Dan Williams <dan.j.williams@intel.com>
To: David Miller <davem@davemloft.net>
Cc: Jej B <James.Bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
	linux-nvdimm <linux-nvdimm@ml01.01.org>, dhowells@redhat.com,
	sparclinux@vger.kernel.org, egtvedt@samfundet.no,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	X86 ML <x86@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
	hskinnemoen@gmail.com, linux-xtensa@linux-xtensa.org,
	grundler@parisc-linux.org, realmz6@gmail.com,
	alex.williamson@redhat.com, linux-metag@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Michal Simek <monstr@monstr.eu>,
	linux-parisc@vger.kernel.org, vgupta@synopsys.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-alpha@vger.kernel.org, linux-media@vger.kernel.org,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 13, 2015 at 9:11 PM, David Miller <davem@davemloft.net> wrote:
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>> At least on some PA architectures, you have to be very careful.
>> Improperly managed, multiple aliases will cause the system to crash
>> (actually a machine check in the cache chequerboard). For the most
>> temperamental systems, we need the cache line flushed and the alias
>> mapping ejected from the TLB cache before we access the same page at an
>> inequivalent alias.
>
> Also, I want to mention that on sparc64 we manage the cache aliasing
> state in the page struct.
>
> Until a page is mapped into userspace, we just record the most recent
> cpu to store into that page with kernel side mappings.  Once the page
> ends up being mapped or the cpu doing kernel side stores changes, we
> actually perform the cache flush.
>
> Generally speaking, I think that all actual physical memory the kernel
> operates on should have a struct page backing it.  So this whole
> discussion of operating on physical memory in scatter lists without
> backing page structs feels really foreign to me.

So the only way for page-less pfns to enter the system is through the
->direct_access() method provided by a pmem device's struct
block_device_operations.  Architectures that require struct page for
cache management to must disable ->direct_access() in this case.

If an arch still wants to support pmem+DAX then it needs something
like this patchset (feedback welcome) to map pmem pfns:

https://lkml.org/lkml/2015/8/12/970

Effectively this would disable ->direct_access() on /dev/pmem0, but
permit ->direct_access() on /dev/pmem0m.
