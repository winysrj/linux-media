Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:44738 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbbDVUrY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 16:47:24 -0400
Date: Wed, 22 Apr 2015 14:46:37 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Doug Ledford <dledford@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Andy Lutomirski <luto@amacapital.net>,
	mike.marciniszyn@intel.com, infinipath@intel.com,
	linux-rdma@vger.kernel.org, awalls@md.metrocast.net,
	Toshi Kani <toshi.kani@hp.com>,
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
Message-ID: <20150422204637.GA29491@obsidianresearch.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
 <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de>
 <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de>
 <20150422161755.GA19500@obsidianresearch.com>
 <1429728791.121496.10.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1429728791.121496.10.camel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 22, 2015 at 02:53:11PM -0400, Doug Ledford wrote:

> To be precise, the split is that ipath powers the old HTX bus cards that
> only work in AMD systems, qib is all PCI-e cards.  I still have a few
> HTX cards, but I no longer have any systems with HTX slots, so we
> haven't even used this driver in testing for 3 or 4 years now.  And
> these are all old SDR cards, where the performance numbers were 800MB/s
> with WC enabled, 50MB/s without it.

Wow, I doubt any HTX systems are still in any kind of use.

It would be a nice clean up to drop the PPC support out of this driver
too. PPC never had HTX.

Jason
