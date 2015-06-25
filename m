Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55473 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbbFYJaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 05:30:17 -0400
Date: Thu, 25 Jun 2015 10:30:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Build regressions/improvements in v4.1
Message-ID: <20150625093007.GS7557@n2100.arm.linux.org.uk>
References: <1435006096-12470-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXprKyxirhUZBzNV97oxymcMqeugKixTEC8ojcMq3EeDw@mail.gmail.com>
 <20150622211857.GY7557@n2100.arm.linux.org.uk>
 <CAMuHMdXyaS65sTdkB88btchm5NzwgNK969QNcaoGBj9-77eFXQ@mail.gmail.com>
 <20150625091815.GR7557@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150625091815.GR7557@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2015 at 10:18:15AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jun 23, 2015 at 09:50:00AM +0200, Geert Uytterhoeven wrote:
> As for the build errors you're reporting, that doesn't seem to be
> anything new.  It seems to be down to a missing dependency between
> ARM_PTDUMP and MMU, which means that ARM_PTDUMP is selectable on !MMU
> systems.  I'll add that dependency, but that's just a small drop in
> the ocean - it looks like it's the least of the problems with ARM
> randconfig...

Now that the build has finished... even with that fixed...

arch/arm/mach-versatile/built-in.o: In function `pci_versatile_setup':
arch/arm/mach-versatile/pci.c:249: undefined reference to `pci_ioremap_io'
kernel/built-in.o: In function `set_section_ro_nx':
kernel/module.c:1738: undefined reference to `set_memory_nx'
kernel/built-in.o: In function `set_page_attributes':
kernel/module.c:1709: undefined reference to `set_memory_ro'
...

which means that DEBUG_SET_MODULE_RONX also needs to depend on MMU.
As for the pci_ioremap_io, I'm not sure what to do about that.

In any case, I'll queue up both of these dependency fixes as low
priority.  Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
