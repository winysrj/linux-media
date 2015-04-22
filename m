Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34238 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbbDVP72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2015 11:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <20150422155446.GF5622@wotan.suse.de>
References: <CALCETrV0B7rp08-VYjp5=1CWJp7=xTUTBYo3uGxX317RxAQT+w@mail.gmail.com>
 <20150421224601.GY5622@wotan.suse.de> <20150421225732.GA17356@obsidianresearch.com>
 <20150421233907.GA5622@wotan.suse.de> <20150422053939.GA29609@obsidianresearch.com>
 <20150422152328.GB5622@wotan.suse.de> <20150422155446.GF5622@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 22 Apr 2015 08:59:07 -0700
Message-ID: <CAB=NE6UAhw4777mFsQtT5NLdKc-BQDwwZBZpphYOymWuajTZxA@mail.gmail.com>
Subject: Re: ioremap_uc() followed by set_memory_wc() - burrying MTRR
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Andy Walls <awalls@md.metrocast.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Mike Marciniszyn <infinipath@intel.com>,
	linux-rdma@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
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
	"Ville Syrj?l?" <syrjala@sci.fi>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	linux-media@vger.kernel.org, X86 ML <x86@kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 22, 2015 at 8:54 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Apr 22, 2015 at 05:23:28PM +0200, Luis R. Rodriguez wrote:
>> On Tue, Apr 21, 2015 at 11:39:39PM -0600, Jason Gunthorpe wrote:
>> > On Wed, Apr 22, 2015 at 01:39:07AM +0200, Luis R. Rodriguez wrote:
>> > > > Mike, do you think the time is right to just remove the iPath driver?
>> > >
>> > > With PAT now being default the driver effectively won't work
>> > > with write-combining on modern kernels. Even if systems are old
>> > > they likely had PAT support, when upgrading kernels PAT will work
>> > > but write-combing won't on ipath.
>> >
>> > Sorry, do you mean the driver already doesn't get WC? Or do you mean
>> > after some more pending patches are applied?
>>
>> No, you have to consider the system used and the effects of calls used
>> on the driver in light of this table:
>>
>> ----------------------------------------------------------------------
>> MTRR Non-PAT   PAT    Linux ioremap value        Effective memory type
>> ----------------------------------------------------------------------
>>                                                   Non-PAT |  PAT
>>      PAT
>>      |PCD
>>      ||PWT
>>      |||
>> WC   000      WB      _PAGE_CACHE_MODE_WB            WC   |   WC
>> WC   001      WC      _PAGE_CACHE_MODE_WC            WC*  |   WC
>> WC   010      UC-     _PAGE_CACHE_MODE_UC_MINUS      WC*  |   UC
>> WC   011      UC      _PAGE_CACHE_MODE_UC            UC   |   UC
>> ----------------------------------------------------------------------
>>
>> (*) denotes implementation defined and is discouraged
>>
>> ioremap_nocache() will use _PAGE_CACHE_MODE_UC_MINUS by default today,
>> in the future we want to flip the switch and make _PAGE_CACHE_MODE_UC
>> the default. When that flip occurs it will mean ipath cannot get
>> write-combining on both non-PAT and PAT systems. Now that is for
>> the future, lets review the current situation for ipath.
>>
>> For PAT capable systems if mtrr_add() is used today on a Linux system on a
>> region mapped with ioremap_nocache() that will mean you effectively nullify the
>> mtrr_add() effect as the combinatorial effect above yields an effective memory
>> type of UC.  For PAT systems you want to use ioremap_wc() on the region in
>> which you need write-combining followed by arch_phys_wc_add() which will *only*
>> call mtrr_add() *iff* PAT was not enabled. This also means we need to split
>> the ioremap'd areas so that the area that is using ioremap_nocache() can never
>> get write-combining (_PAGE_CACHE_MODE_UC). The ipath driver needs the regions
>> split just as was done for the qib driver.
>>
>> Now we could just say that leaving things as-is is a non-issue if you are OK
>> with non-write-combining effects being the default behaviour left on the ipath
>> driver for PAT systems. In that case we can just use arch_phys_wc_add() on the
>> driver and while it won't trigger the mtrr_add() on PAT systems it sill won't
>> have any effect. We just typically don't want to see use of ioremap_nocache()
>> paired with arch_phys_wc_add(), grammatically the correct thing to do is pair
>> ioremap_wc() areas with a arch_phys_wc_add() to make the write-combining effects
>> on non-PAT systems. If the ipath driver is not going to get he work required
>> to split the regions though perhaps we can live with a corner case driver that
>> annotates PAT must be disabled on the systems that use it and convert it to
>> arch_phys_wc_add() to just help with phasing out of direct use of mtrr_add().
>> With this strategy if and when ipath driver gets a split done it would gain WC
>> on both PAT and non-PAT.
>
> Folks, after some thought I do believe the above temporary strategy would
> avoid issues and would not have to stir people up to go and make code
> changes. We can use the same strategy for both ivtv and ipath:
>
>   * Annotate via Kconfig for the driver that it depends on !X86_PAT
>     that will ensure that PAT systems won't use it, and convert it
>     to use arch_phys_wc_add() to help phase out direct access to mtrr_add()
>
> This would be correct given that the current situation on the driver
> makes write-combining non-effective on PAT systems, we in fact gain
> avoiding these type of use-cases, and annotate this as a big TODO item
> for folks who do want it for PAT systems.
>
> Thoughts?

Another option in order to enable this type of checks at run time and
still be able to build the driver on standard distributions and just
prevent if from loading on PAT systems is to have some code in place
which would prevent the driver from loading if PAT was enabled, this
would enable folks to disable PAT via a kernel command line option,
and if that was used then the driver probe would complete.

 Luis
