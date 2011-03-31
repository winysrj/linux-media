Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35425 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759375Ab1CaWSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 18:18:14 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
	"Ankita Garg" <ankita@in.ibm.com>,
	"Daniel Walker" <dwalker@codeaurora.org>,
	"Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
	"Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz> <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
 <1301606078.31087.1275.camel@nimitz>
Date: Fri, 01 Apr 2011 00:18:10 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1301606078.31087.1275.camel@nimitz>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
>> +unsigned long alloc_contig_freed_pages(unsigned long start, unsigned
>> long end,
>> +                                      gfp_t flag)
>> +{
>> +       unsigned long pfn = start, count;
>> +       struct page *page;
>> +       struct zone *zone;
>> +       int order;
>> +
>> +       VM_BUG_ON(!pfn_valid(start));

On Thu, 31 Mar 2011 23:14:38 +0200, Dave Hansen wrote:
> We BUG_ON() in bootmem.  Basically if we try to allocate an early-boot
> structure and fail, we're screwed.  We can't keep running without an
> inode hash, or a mem_map[].
>
> This looks like it's going to at least get partially used in drivers, at
> least from the examples.  Are these kinds of things that, if the driver
> fails to load, that the system is useless and hosed?  Or, is it
> something where we might limp along to figure out what went wrong before
> we reboot?

Bug in the above place does not mean that we could not allocate memory.  It
means caller is broken.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
