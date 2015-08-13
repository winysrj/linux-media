Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36891 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbHMXkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 19:40:51 -0400
MIME-Version: 1.0
In-Reply-To: <20150813143528.GC17183@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de> <55CB3F47.3000902@plexistor.com>
 <CAGRGNgUKkaPnyvn30DXyNpdiXQzS6J=1+mQ3ick8C8=bhx_RHA@mail.gmail.com> <20150813143528.GC17183@lst.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 14 Aug 2015 09:40:30 +1000
Message-ID: <CAGRGNgWXO9fYSf5YxPM9atSCmUdHB_WDB=n8zd=7eWK1GaJU4A@mail.gmail.com>
Subject: Re: RFC: prepare for struct scatterlist entries without page backing
To: Christoph Hellwig <hch@lst.de>
Cc: Boaz Harrosh <boaz@plexistor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	axboe@kernel.dk, linux-mips@linux-mips.org,
	linux-ia64@vger.kernel.org, linux-nvdimm@ml01.01.org,
	David Howells <dhowells@redhat.com>,
	sparclinux <sparclinux@vger.kernel.org>,
	Hans-Christian Egtvedt <egtvedt@samfundet.no>,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
	=?UTF-8?Q?H=C3=A5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
	linux-xtensa@linux-xtensa.org, grundler@parisc-linux.org,
	Miao Steven <realmz6@gmail.com>, alex.williamson@redhat.com,
	linux-metag@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
	linux-parisc@vger.kernel.org, vgupta@synopsys.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-alpha@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On Fri, Aug 14, 2015 at 12:35 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Aug 13, 2015 at 09:37:37AM +1000, Julian Calaby wrote:
>> I.e. ~90% of this patch set seems to be just mechanically dropping
>> BUG_ON()s and converting open coded stuff to use accessor functions
>> (which should be macros or get inlined, right?) - and the remaining
>> bit is not flushing if we don't have a physical page somewhere.
>
> Which is was 90%.  By lines changed most actually is the diffs for
> the cache flushing.

I was talking in terms of changes made, not lines changed: by my
recollection, about a third of the patches didn't touch flush calls
and most of the lines changed looked like refactoring so that making
the flush call conditional would be easier.

I guess it smelled like you were doing lots of distinct changes in a
single patch and I got my numbers wrong.

>> Would it make sense to split this patch set into a few bits: one to
>> drop all the useless BUG_ON()s, one to convert all the open coded
>> stuff to accessor functions, then another to do the actual page-less
>> sg stuff?
>
> Without the ifs the BUG_ON() actually are useful to assert we
> never feed the sort of physical addresses we can't otherwise support,
> so I don't think that part is doable.

My point is that there's a couple of patches that only remove
BUG_ON()s, which implies that for that particular driver it doesn't
matter if there's a physical page or not, so therefore that code is
purely "documentation".

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
