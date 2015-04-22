Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:56137 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965007AbbDVQSw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 12:18:52 -0400
Date: Wed, 22 Apr 2015 10:17:55 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
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
	Ville Syrj?l? <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	mcgrof@do-not-panic.com
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150422161755.GA19500@obsidianresearch.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150422152328.GB5622@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 22, 2015 at 05:23:28PM +0200, Luis R. Rodriguez wrote:
> On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
> > On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
> > > > Mike, do you think the time is right to just remove the iPath driver?
> > > 
> > > With PAT now being default the driver effectively won't work
> > > with write-combining on modern kernels. Even if systems are old
> > > they likely had PAT support, when upgrading kernels PAT will work
> > > but write-combing won't on ipath.
> > 
> > Sorry, do you mean the driver already doesn't get WC? Or do you mean
> > after some more pending patches are applied?
> 
> No, you have to consider the system used and the effects of calls used
> on the driver in light of this table:

So, just to be clear:

At some point Linux started setting the PAT bits during
ioremap_nocache, which overrides MTRR, and at that point the driver
became broken on all PAT capable systems?

Not only that, but we've only just noticed it now, and no user ever
complained?

So that means either no users exist, or all users are on non-PAT
systems?

This driver only works on x86-64 systems. Are there any x86-64 systems
that are not PAT capable? IIRC even the first Opteron had PAT, but my
memory is fuzzy from back then :|

> Another option in order to enable this type of checks at run time
> and still be able to build the driver on standard distributions and
> just prevent if from loading on PAT systems is to have some code in
> place which would prevent the driver from loading if PAT was
> enabled, this would enable folks to disable PAT via a kernel command
> line option, and if that was used then the driver probe would
> complete.

This seems like a reasonble option to me. At the very least we might
learn if anyone is still using these cards.

I'd also love to remove the driver if it turns out there are actually
no users. qib substantially replaces it except for a few very old
cards.

Mike?

Jason
