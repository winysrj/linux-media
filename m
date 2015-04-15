Return-path: <linux-media-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:34615 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756547AbbDOU5E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 16:57:04 -0400
Message-ID: <552ED06E.8030303@zytor.com>
Date: Wed, 15 Apr 2015 13:56:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>, linux-rdma@vger.kernel.org
CC: Toshi Kani <toshi.kani@hp.com>, Ingo Molnar <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Suresh Siddha <sbsiddha@gmail.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Roland Dreier <roland@purestorage.com>,
	Juergen Gross <jgross@suse.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Borislav Petkov <bp@suse.de>, Mel Gorman <mgorman@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Davidlohr Bueso <dbueso@suse.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
In-Reply-To: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2015 01:42 PM, Andy Lutomirski wrote:
> 
> I disagree.  We should try to NACK any new code that can't function
> without MTRRs.
> 
> (Plus, ARM is growing in popularity in the server space, and ARM quite
> sensibly doesn't have MTRRs.)
> 

<NOT SPEAKING FOR INTEL HERE>

Yes.  People need to understand that MTRRs are fundamentally a
transitional solution, a replacement for the KEN# logic in the P4 and P5
generation processors.  The KEN# logic in the chipset would notify the
CPU that a specific address should not be cached, without affecting the
software (which may have been written for x86s built before caching
existed, even.)

MTRRs move this to the head end, so the CPU knows ahead of time what to
do, as is required with newer architectures.  It also enabled write
combining in a transparent fashion.  However, it is still transitional;
it is there to describe the underlying constraints of the memory system
so that code which doesn't use paging can run at all, but the only thing
that can actually scale is PAT.

	-hpa

