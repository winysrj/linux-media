Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55452 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbFYJS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:18:28 -0400
Date: Thu, 25 Jun 2015 10:18:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Build regressions/improvements in v4.1
Message-ID: <20150625091815.GR7557@n2100.arm.linux.org.uk>
References: <1435006096-12470-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXprKyxirhUZBzNV97oxymcMqeugKixTEC8ojcMq3EeDw@mail.gmail.com>
 <20150622211857.GY7557@n2100.arm.linux.org.uk>
 <CAMuHMdXyaS65sTdkB88btchm5NzwgNK969QNcaoGBj9-77eFXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXyaS65sTdkB88btchm5NzwgNK969QNcaoGBj9-77eFXQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 23, 2015 at 09:50:00AM +0200, Geert Uytterhoeven wrote:
> Hi Russell,
> 
> On Mon, Jun 22, 2015 at 11:18 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Jun 22, 2015 at 10:52:13PM +0200, Geert Uytterhoeven wrote:
> >> On Mon, Jun 22, 2015 at 10:48 PM, Geert Uytterhoeven
> >> <geert@linux-m68k.org> wrote:
> >> > JFYI, when comparing v4.1[1] to v4.1-rc8[3], the summaries are:
> >> >   - build errors: +44/-7
> >>
> >>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> >> 'L_PTE_MT_BUFFERABLE' undeclared here (not in a function):  => 81:10
> >>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> >> 'L_PTE_MT_DEV_CACHED' undeclared here (not in a function):  => 117:10
> >>   + /home/kisskb/slave/src/arch/arm/mm/dump.c: error:
> >> 'L_PTE_MT_DEV_NONSHARED' undeclared here (not in a function):  =>
> >> 108:10
> >
> > I'm rather ignoring this because I don't see these errors here.  This
> > is one of the problems of just throwing out build reports.  With zero
> > information such as a configuration or a method on how to cause the
> > errors, it's pretty much worthless to post errors.
> >
> > Folk who do build testing need to be smarter, and consider what it's
> > like to be on the receiving end of their report emails...
> 
> Fortunately the kisskb service has good bookkeeping of build logs and configs.

As any good build system should do... :)

> Re-adding the lost URL:
> >> [1] http://kisskb.ellerman.id.au/kisskb/head/9038/ (all 254 configs)
> 
>   1. Open URL in web browser,
>   2. Click on "Failed", next to "arm-randconfig",
>   3. Click on "Download", next to "arm-randconfig",
>   4. Reproduce,
>   5. Fix,
>   6. Profit! ;-)

Looking at the last 7 build results...

That shows that many of the "linus" failing build results are down to:

cc1: error: unrecognized command line option '-fstack-protector-strong'

	which is a compiler/kbuild problem.  The kernel build system checks
	for the flag and warns over it:

	ifdef CONFIG_CC_STACKPROTECTOR_STRONG
	  stackp-flag := -fstack-protector-strong
	  ifeq ($(call cc-option, $(stackp-flag)),)
	    $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
	              -fstack-protector-strong not supported by compiler)
	  endif
	else
	  # Force off for distro compilers that enable stack protector by default.
	  stackp-flag := $(call cc-option, -fno-stack-protector)
	endif

	but this doesn't stop the build progressing - and in any case, it
	shows that randconfig with an outdated compiler is a problem with
	modern Kbuild.  That accounts for 3 of the 7 Linus build failures.

.config:19:warning: symbol value '' invalid for PHYS_OFFSET

	which can't be fixed: it has to be given a value.  That's a
	randconfig problem.

/opt/cross/gcc-4.6.3-nolibc/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-geabi-ld: no machine record defined

	Probably another toolchain problem.

arch/arm/mm/built-in.o:(.proc.info.init+0x198): undefined reference to `fa_user_fns'

	This looks like it's been there for years (since 2009...) but
	needs fixing (and we should probably fix it in a generic way.)

/tmp/ccA1GNig.s:671: Error: selected processor does not support Thumb mode `mrs r6,cpsr'

	Maybe Uwe can investigate this one - it's EFM32 related.

Looking at the linux-next builds:

.config:21:warning: symbol value '' invalid for PHYS_OFFSET
cc1: error: unrecognized command line option '-fstack-protector-strong'

	See above.

drivers/dma/pxa_dma.c:192:2: error: void value not ignored as it ought to be

	Relatively new driver...

eeprom.c:(.text+0x26ad0): undefined reference to `pci_ioremap_io'
pci.c:(.init.text+0x518): undefined reference to `pci_ioremap_io'
last.c:(.text+0xb9fb0): undefined reference to `clk_set_parent'

	Probably drivers not correctly checking their dependencies.

include/linux/virtio_ring.h:45:3: error: implicit declaration of function 'dma_wmb' [-Werror=implicit-function-declaration]

	virtio_ring.h not including a required header file?

As for the build errors you're reporting, that doesn't seem to be
anything new.  It seems to be down to a missing dependency between
ARM_PTDUMP and MMU, which means that ARM_PTDUMP is selectable on !MMU
systems.  I'll add that dependency, but that's just a small drop in
the ocean - it looks like it's the least of the problems with ARM
randconfig...

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
