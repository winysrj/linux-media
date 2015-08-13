Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37514 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbHMPmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 11:42:36 -0400
Received: by wibhh20 with SMTP id hh20so80740414wib.0
        for <linux-media@vger.kernel.org>; Thu, 13 Aug 2015 08:42:35 -0700 (PDT)
Message-ID: <55CCBAE8.8090502@plexistor.com>
Date: Thu, 13 Aug 2015 18:42:32 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: torvalds@linux-foundation.org, axboe@kernel.dk,
	linux-mips@linux-mips.org, linux-ia64@vger.kernel.org,
	linux-nvdimm@ml01.01.org, dhowells@redhat.com,
	sparclinux@vger.kernel.org, egtvedt@samfundet.no,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	x86@kernel.org, dwmw2@infradead.org, hskinnemoen@gmail.com,
	linux-xtensa@linux-xtensa.org, grundler@parisc-linux.org,
	realmz6@gmail.com, alex.williamson@redhat.com,
	linux-metag@vger.kernel.org, monstr@monstr.eu,
	linux-parisc@vger.kernel.org, vgupta@synopsys.com,
	linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
	linux-media@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: RFC: prepare for struct scatterlist entries without page backing
References: <1439363150-8661-1-git-send-email-hch@lst.de> <55CB3F47.3000902@plexistor.com> <20150813144036.GB17375@lst.de>
In-Reply-To: <20150813144036.GB17375@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/13/2015 05:40 PM, Christoph Hellwig wrote:
> On Wed, Aug 12, 2015 at 03:42:47PM +0300, Boaz Harrosh wrote:
>> The support I have suggested and submitted for zone-less sections.
>> (In my add_persistent_memory() patchset)
>>
>> Would work perfectly well and transparent for all such multimedia cases.
>> (All hacks removed). In fact I have loaded pmem (with-pages) on a VRAM
>> a few times and it is great easy fun. (I wanted to experiment with cached
>> memory over a pcie)
> 
> And everyone agree that it was both buggy and incomplete.
> 

What? No one ever said anything about bugs. Is the first ever I hear of it.
I was always in the notion that no one even tried it out.

I'm smoking these page-full nvidimms for more than a year. With RDMA to
pears and swap out to disks. So is not that bad I would say

> Dan has done a respin of the page backed nvdimm work with most of
> these comments addressed.
> 

I would love some comments. All I got so far is silence. (And I do not
like Dan's patches comments will come next week)

> I have to say I hate both pfn-based I/O [1] and page backed nvdimms with
> passion, so we're looking into the lesser evil with an open mind.
> 
> [1] not the SGL part posted here, which I think is quite sane.  The bio
>     side is much worse, though.
> 

What can I say. I like the page-backed nvdimms. And the long term for me
is 2M pages. I hope we can sit one day soon and you explain to me whats
evil about it. I would really really like to understand

Thanks though
Boaz

