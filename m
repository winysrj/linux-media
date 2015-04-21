Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964868AbbDUXjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 19:39:12 -0400
Date: Wed, 22 Apr 2015 01:39:07 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andy Lutomirski <luto@amacapital.net>, mike.marciniszyn@intel.com,
	infinipath@intel.com, linux-rdma@vger.kernel.org,
	awalls@md.metrocast.net, Toshi Kani <toshi.kani@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	mcgrof@do-not-panic.com
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150421233907.GA5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150421225732.GA17356@obsidianresearch.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 21, 2015 at 04:57:32PM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2015 at 12:46:01AM +0200, Luis R. Rodriguez wrote:
> 
> > are talking about annotating the qib driver as "known to be broken without PAT"
> > and since the ipath driver needs considerable work to be ported to
> > use PAT (the
> 
> This only seems to be true for one of the chips that driver supports,
> not all possibilities.
> 
> > userspace register is just one area) I wanted to review if we can just remove
> > MTRR use on the ipath driver and annotate write-combining with PAT as a TODO
> > item.
> 
> AFAIK, dropping MTRR support will completely break the performance to
> the point the driver is unusable. If we drop MTRR we may as well
> remove the driver.

To be clear, the arch_phys_wc_add() API will be a no-op when PAT is
enabled on a system. Although some folks think PAT is new, its not,
its just that our implementation on Linux lacked a bit of push, recent
changes however make PAT support complete and that means now we'll have
PAT enabled on systems that likely didn't before on recent kernels.

There are other important motivations to use PAT:

 * Xen won't work with MTRR, having a unified PAT enabled kernel
   will ensure that when Xen is used write-combinging will take
   effect

 * Long term we want to make strong UC the default to ioremap() on
   x86, right now its not, its UC-, we need to convert all drivers
   that want write-combining over to use ioremap_wc() for their
   specific area, and it must not overlap. There are issues with
   using mtrr_add() on regions marked as UC-, since its the default
   this  means that mtrr_add() use on ioramp'd areas on PAT systems
   will actually make write-combining *void*. Refer to this table
   for combinatorial effects for non-PAT / PAT of wc MTRR:

   https://marc.info/?l=linux-kernel&m=142964809710517&w=1

So as the train of PAT enablement moves forward it means systems
that have PAT enabled now might not have write-combining effective.
In order to get the best of both worlds, non-PAT and PAT systems
we must design drivers cleanly for the non-writecombining and
write-combining areas. This mean using ioremap_nocache() for MMIO
and ioremap_wc() *only* for the desired, write-combining area,
followed by arch_phys_wc_add().

> Mike, do you think the time is right to just remove the iPath driver?

With PAT now being default the driver effectively won't work
with write-combining on modern kernels. Even if systems are old
they likely had PAT support, when upgrading kernels PAT will work
but write-combing won't on ipath.

  Luis
