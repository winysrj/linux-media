Return-path: <linux-media-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:37680 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbbDUW6Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 18:58:24 -0400
Date: Tue, 21 Apr 2015 16:57:32 -0600
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
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	mcgrof@do-not-panic.com
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150421225732.GA17356@obsidianresearch.com>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150421224601.GY5622@wotan.suse.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 22, 2015 at 12:46:01AM +0200, Luis R. Rodriguez wrote:

> are talking about annotating the qib driver as "known to be broken without PAT"
> and since the ipath driver needs considerable work to be ported to
> use PAT (the

This only seems to be true for one of the chips that driver supports,
not all possibilities.

> userspace register is just one area) I wanted to review if we can just remove
> MTRR use on the ipath driver and annotate write-combining with PAT as a TODO
> item.

AFAIK, dropping MTRR support will completely break the performance to
the point the driver is unusable. If we drop MTRR we may as well
remove the driver.

Mike, do you think the time is right to just remove the iPath driver?

Jason
