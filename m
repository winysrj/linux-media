Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbbDUWqG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 18:46:06 -0400
Date: Wed, 22 Apr 2015 00:46:01 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>,
	jgunthorpe@obsidianresearch.com, mike.marciniszyn@intel.com,
	infinipath@intel.com, linux-rdma@vger.kernel.org,
	awalls@md.metrocast.net
Cc: linux-rdma@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
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
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	mcgrof@do-not-panic.com
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
Message-ID: <20150421224601.GY5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 15, 2015 at 01:42:47PM -0700, Andy Lutomirski wrote:
> On Mon, Apr 13, 2015 at 10:49 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> 
> > c) ivtv: the driver does not have the PCI space mapped out separately, and
> > in fact it actually does not do the math for the framebuffer, instead it lets
> > the device's own CPU do that and assume where its at, see
> > ivtvfb_get_framebuffer() and CX2341X_OSD_GET_FRAMEBUFFER, it has a get
> > but not a setter. Its not clear if the firmware would make a split easy.
> > We'd need ioremap_ucminus() here too and __arch_phys_wc_add().
> >
> 
> IMO this should be conceptually easy to split.  Once we get the
> framebuffer address, just unmap it (or don't prematurely map it) and
> then ioremap the thing.

Side note to ipath driver folks: as reviewed with Andy Walls, the
ivtv driver cannot easily be ported to use PAT so we are evaluating
simply removing write-combing from that driver on future kernels.

> 
> > From the beginning it seems only framebuffer devices used MTRR/WC, lately it
> > seems infiniband drivers also find good use for for it for PIO TX buffers to
> > blast some sort of data, in the future I would not be surprised if other
> > devices found use for it.
> 
> IMO the Infiniband maintainers should fix their code.  Especially in
> the server space, there aren't that many MTRRs to go around.  I wrote
> arch_phys_wc_add in the first place because my server *ran out of
> MTRRs*.
> 
> Hey, IB people: can you fix your drivers to use arch_phys_wc_add
> (which is permitted to be a no-op) along with ioremap_wc?  Your users

ipath driver maintainers:

The ipath driver is one of two drivers left to convert over to
arch_phys_wc_add(). MTRR use is being deprecated, and its use is actually
highly discouraged now that we have proper PAT implemenation on Linux. Since we
are talking about annotating the qib driver as "known to be broken without PAT"
and since the ipath driver needs considerable work to be ported to use PAT (the
userspace register is just one area) I wanted to review if we can just remove
MTRR use on the ipath driver and annotate write-combining with PAT as a TODO
item.

This would help a lot in our journey to bury MTRR use.

  Luis
