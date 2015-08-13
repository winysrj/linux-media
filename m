Return-path: <linux-media-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48737 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbHMOd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 10:33:28 -0400
Date: Thu, 13 Aug 2015 16:33:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Dan Williams <dan.j.williams@intel.com>,
	Vineet Gupta <vgupta@synopsys.com>,
	=?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
	Hans-Christian Egtvedt <egtvedt@samfundet.no>,
	Miao Steven <realmz6@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Michal Simek <monstr@monstr.eu>,
	the arch/x86 maintainers <x86@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	grundler@parisc-linux.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	linux-alpha@vger.kernel.org,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	linux-metag@vger.kernel.org,
	linux-mips <linux-mips@linux-mips.org>,
	Parisc List <linux-parisc@vger.kernel.org>,
	ppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-s390 <linux-s390@vger.kernel.org>,
	sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 31/31] dma-mapping-common: skip kmemleak checks for
	page-less SG entries
Message-ID: <20150813143325.GB17183@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de> <1439363150-8661-32-git-send-email-hch@lst.de> <CA+55aFxfZM81HNfo2ysfhGwrhx6GX-+F--+jLFmMVv+Z0id2rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfZM81HNfo2ysfhGwrhx6GX-+F--+jLFmMVv+Z0id2rw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 12, 2015 at 09:05:15AM -0700, Linus Torvalds wrote:
> [ Again, I'm responding to one random patch - this pattern was in
> other patches too.  ]
> 
> A question: do we actually expect to mix page-less and pageful SG
> entries in the same SG list?
> 
> How does that happen?

Both for DAX and the video buffer case people could do direct I/O
spanning the boundary between such a VMA and a normal one unless
we add special code to prevent that.  Right now I don't think it's
all that useful, but then again it doesn't seem harmful either
and adding those checks might add up.
