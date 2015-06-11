Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:35118 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbbFKUg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 16:36:59 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 11 Jun 2015 13:36:38 -0700
Message-ID: <CAB=NE6UgtdSoBsA=8+ueYRAZHDnWUSmQAoHhAaefqudBrSY7Zw@mail.gmail.com>
Subject: RIP MTRR - status update for upcoming v4.2
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Borislav Petkov <bp@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
	=?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Toshi Kani <toshi.kani@hp.com>, X86 ML <x86@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Airlie <airlied@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	xen-devel@lists.xenproject.org, Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The series to bury direct MTRR use is almost all in and on its way to
v4.2. As the pending series continue slowly to be merged I wanted to
take the time to reiterate the justification for these changes in
hopes it may help those still reviewing some of these patches which
are pending and to help document all these changes. There are also
some series which depend on symbols now exported through some other
subsystem trees so coordination is needed there. In those cases we
have the option there to sit and wait for the exported symbols to
trickle in through v4.2 and later on v4.3 finalize the changes, or to
let some of the depending changes to in through other subsystem trees.
I don't consider the coordination required difficult to handle so
would prefer to see the changes in for v4.2 to be able to put a nail
on the MTRR coffin sooner rather than later and to also help get more
testing out of this sooner rather than later. PAT is known to have
errata for some CPUs so hearing reports of issues with PAT would be
very valuable. I'll let maintainers decide on how that trickles
through. To help with all this towards the end I provide a status of
all the pending patches to get this work completed.

Justification
=========

We want to bury direct use of MTRR code because:

a) MTRR is x86 specific, this means all existing MTRR code is #idef'd
out. PAT support for x86 was implemented using architecture agnostic
APIs, this enables other architectures to provide support for a
similar write-combining feature, and removes the nasty #idef eyesores.
MTRR should be seen as a first step temporary architectural evolution
to what PAT eventually became on x86.

b) We have a long term goal to change the default behavior of
ioremap_nocache() and pci_mmap_page_range() to use PAT strong UC,
right now we cannot do this, but after all drivers are converted (all
these series I've been posting) we expect to be able to make the
change. Making a change to strong UC on these two calls can only
happen after a period of time of having Linux bake with all these
changes merged and in place. How many kernels we will want Linux baked
with all these transformations to arch_phys before making a change to
ioremap_nocache() and pci_mmap_page_range() is up to x86 folks. There
are other gains possible with this but I welcome others to chime in
here with what gains we can expect from this.

c) MTRR acts on physical addresses and requires power-of-two
alignment, on both the base used and size, this limits the flexibility
for MTRR use. For a good example of its limitations refer to the
patches which change the atyfb driver from using MTRR to PAT.

d) MTRR is known to be unreliable, it can at times not work even on
modern systems.

e) There is a limit to how many MTRRs you can use on a system. If
using a large number of devices with MTRR support you will quickly run
out of MTRRs. This is why originally Andy Lutomirski ended up adding
the arch_phys_wc_add() API, in order to take advantage of PAT which is
*not* bound to the same limitations as MTRRs are.

f) PAT has been available for quite a long time, since Pentium III
(circa 1999) and newer, but having PAT enabled does not restrict use
of MTRR and because of this some systems may end up then combining
MTRR and PAT. I do not believe this wasn't an original highly expected
wide use situation, it technically should work to combine both but
there might be issues with interactions between both, exactly what
issues can exist or have existed remains quite unclear as MTRR in and
of itself has been known to be unreliable anyway. If possible its best
to just be binary about this and only use MTRR if and only if
necessary because of the other issues known with MTRR.

g) Linux has support for Xen PV domains using PAT, this was introduced
by Juergen via v3.19 via commit 47591df50512 ("xen: Support Xen
pv-domains using PAT"). Since MTRR is old we don't want to add MTRR
support into Xen on Linux, instead since Linux now supports PV domains
with PAT we can take full advantage of write combining for PV domains
on Xen provided all Linux drivers are converted to use PAT properly.a
framebuffer folks's ACK

Review of the changes
================

Most of the series has consisted of driver transformations using
Coccinelle SmPL patches to transform existing code which access MTRR
APIs directly to the architecture agnostic write-combining calls.
Other patches extend bus subsystems to make available new
write-combining architecture agnostic APIs. Other patches have
consisted of extending architecture agnostic APIs to help work around
old MTRR hacks -- this was perhaps the hardest task and took quite a
bit of time and review as it required review of implications of all
combinatorial possibilities with MTRR and PAT, which also got
documented as part of the series. In the end it was also determined
some drivers required substantial work to be able to work properly
with PAT, the atyfb driver is an example driver which had the homework
required done. Due to complexities and since the driver / hardware was
ancient we decided to reach a compromise and require users of those
drivers to boot with a kernel parameter to disable PAT, fortunately
this was only required for two old device drivers:

* ipath: the ipath device driver powers the old HTX bus cards that
only work in AMD systems, while the newer IB/qib device driver powers
all PCI-e cards. The ipath device driver is obsolete, hardware hard to
find

* ivtv: the hardware is really rare these days, and perhaps only some
lost souls in some third world country are expected to be using this
feature of the device driver.

Pending RIP MTRR patches
====================

There are a few pending series so I wanted to provide a status update
on those series.

mtrr: bury MTRR - unexport mtrr_add() and mtrr_del()

This is the nail on the MTRR coffin, it will prevent future direct
access to MTRR code. This will not be posted until all of the below
patches are in and merged. A possible next step here might be to
consider separating PAT code from MTRR code and making PAT a first
class citizen, enabling distributions to disable MTRR code in the
future. I thought this was possible but for some reason I recently
thought that there was one possible issue to make this happen. I
suppose we won't know unless we try, unless of course someone already
knows, Toshi?

IB/ipath: use arch_phys_wc_add() and require PAT disabled
IB/ipath: add counting for MTRR
ivtv: use arch_phys_wc_add() and require PAT disabled

This v7 series just posted addresses all drivers which cannot work
with PAT, fortunately we end up with only 2! This series has all
subsystem and driver maintainers ACKs, it was just posted with a few
fixes with the intent to be merged through Boris' x86 tree as it
depends on the newly exported pat_enabled() symbol.

fusion: remove dead MTRR code

This should go through Bottomley's tree, driver maintainer provided an
ACKed, this is just pending integration into the SCSI subsystem tree.
As a last resort my hope is that this can go through Andrew Morton's
tree.

video: fbdev: vesafb: use arch_phys_wc_add()
video: fbdev: vesafb: add missing mtrr_del() for added MTRR
video: fbdev: vesafb: only support MTRR_TYPE_WRCOMB

A v4 series was posted, pending review / Integration through Tomis' tree

video: fbdev: atyfb: use arch_phys_wc_add() and ioremap_wc()
video: fbdev: atyfb: replace MTRR UC hole with strong UC
video: fbdev: atyfb: clarify ioremap() base and length used
video: fbdev: atyfb: move framebuffer length fudging to helper

This provides a work around replacement for the direct MTRR use hack
using the new ioremap_uc() API. This is pending review / ACK by the
driver maintainer Ville Syrjälä, and the subsystem maintainer, Tomi.
Since it relies on ioremap_uc(), which is merged through Boris' tree,
this should go through Boris' tree *iff* we want it in for v4.2,
otherwise this will have to wait for v4.3.

video: fbdev: vt8623fb: use arch_phys_wc_add() and pci_iomap_wc()
video: fbdev: s3fb: use arch_phys_wc_add() and pci_iomap_wc()
video: fbdev: arkfb: use arch_phys_wc_add() and pci_iomap_wc()
lib: devres: add pcim_iomap_wc() variants
pci: add pci_iomap_wc() variants

This has Tomi's ACK already for the driver specific changes, Bjorn
asked for a Documentation guidance update for EXPORT_SYMBOL_GPL(),
this is now merged via linux-next. This is pending consent from Tomi
if it can go in through Bjorn's tree. It is also obviously pending a
final ACK from Bjorn. The devres change would go in without any users,
I leave this for Bjorn to decide but do note my concern of someone in
the future adding a non EXPORT_SYMBOL_GPL() for this implementation.

video: fbdev: gxt4500: use pci_ioremap_wc_bar() for framebuffer
video: fbdev: kyrofb: use arch_phys_wc_add() and pci_ioremap_wc_bar()
video: fbdev: i740fb: use arch_phys_wc_add() and pci_ioremap_wc_bar()
pci: add pci_ioremap_wc_bar()

This requires Tomi's Ack / review, and then obviously Bjorn's own ACK
/ integration. Consent from Tomi of whether or not this can go through
Bjorn's tree is also needed.

 Luis
