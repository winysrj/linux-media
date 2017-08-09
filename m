Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35938 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdHIUbc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:32 -0400
Received: by mail-wr0-f180.google.com with SMTP id y43so27830696wrd.3
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 00/12] ddbridge: bump to ddbridge-0.9.29
Date: Wed,  9 Aug 2017 22:31:16 +0200
Message-Id: <20170809203128.31476-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Even without DDB IOCTLs, target: 4.14.

Changes from v2 to v3:
* (private) IOCTLs (temporarily) removed. Proper implementation via
  UAPI and some documentation will be (re)added with a separate patch.
  Even with this functionality removed (which most prominently is used
  to update the card FPGA) everything is still working as intended.
  With this, also temporarily removed the existing FLASHIO IOCTL.
* Code move/split already merged thus no longer part of the series

Changes from v1 to v2:
* I2C access functions (ie. i2c_read() et al) refactored from
  ddbridge-i2c.c into ddbridge-i2c.h and declared static, and needed
  include added to all .c files making use of them. This fixes symbol
  conflicts in the global namespace with other drivers (kbuild test
  robot reported a conflict with an infiniband driver) when compiling
  into the kernel blob. While at it, code style has been made proper
  (in ddbridge-i2c.h) and the 0.9.29 code bump patch was updated to
  re-use the "plural" functions from their "singular" equivalents.
* The IRQ_HANDLE_BYTE() macro was removed. It is used nowhere, even
  in the unmodified/unstripped upstream driver.
* Shortened the buffer overflow fix in ddb_ports_init() from checking
  "p > 0" to only check "p".

Changes from original series to the resend:
* rebased on latest mediatree-master wrt
    commit 618e8aac3d7c ("media: ddbridge: constify i2c_algorithm structure")
* build error in ddbridge-core.c fixed wrt
    commit dcda9b04713c ("mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic")
* useless return removed from void calc_con()
* UTF8 in ddbridge-regs.h removed
* Tested-by's added to commit messages

Previous Tested-by testimonials still apply, extensive retesting wrt
IOCTLs isn't neccessary.

Mauro/Media maintainers, this updates drivers/media/pci/ddbridge to the
very latest code that DD carry in their vendor driver package as of
version 0.9.29, in the "once, the big-bang-way is ok" way as discussed at
[2] (compared to the incremental, awkward to do variant since that
involves dissecting all available release archives and having to - try
to - build proper commits out of this, which will always be inaccurate;
a start was done at [3], however - and please understand - I definitely
don't want to continue doing that...)

In patch 14, I add myself to MAINTAINERS. This means I will care about
getting driver updates as they're released by DD into mainline,  starting
from this (0.9.29) version, which is definitely doable in an incremental
way. So, I'll make sure the in-kernel driver won't bit-rot again, and it
will receive new hardware support as it becomes available in a timely
manner.

While the driver code bump looks massive, judging from the diff, there's
mostly a whole lot of refactoring and restructuring of variables, port/
link management and all such stuff in it. Feature-wise, this is most
notable:

 - Support for all (PCIe) CI (single/duo) cards and Flex addons
 - Support for MSI (Message Signaled Interrupts), though disabled by
   default since there were still reports of problems with this
 - TS Loopback support (set up ports to behave as if a CI is connected,
   without decryption of course)
 - As mentioned: Heavy code reordering, and split up into multiple files

Stripped functionality compared to dddvb:

 - DVB-C modulator card support removed (requires DVB core API)
 - OctoNET SAT>IP server/box support removed (requires API aswell)
 - with this, GT link support was removed (only on OctoNET hardware)
 - MaxS8 4/8 DVB-S/S2 card support (temporarily) removed (requires an
   additional Demod driver; subject for another, later, series)

A note on the patches:

The bump starts by aligning the code "order-wise" to the updated driver,
to keep the diff a bit cleaner. Next, the code split is applied, without
actually changing any functionality. Compared to upstream, this isn't done
by moving functions into different C files and then do an include on them,
but we're handling them with the Makefile, building separate objects, and
having proper prototypes in ddbridge.h. After the code bump, further split
up is applied to increase readability and maintainability (also, for the
MaxS8 support, there will be another object with another ~400 LoC, which
originally lives in ddbridge-core aswell). Then, all issues found by W=1
and smatch are resolved, one by one. This is kept separate since those
fixes will be proposed for upstream inclusion. The last thing is the
addition of the MSI default Kconfig options which will mainly inform users
that there's something that might(!) cause issues but is still being
worked on - the default is "off" to provide a proper OotB experience.

To distinguish from the original unchanged vendor driver, "-integrated" is
suffixed to the version code.

Note on checkpatch:

First two patches are solely code-moving, so checkpatch will complain on
them. With the ddbridge code bump, all non-strict style issues are
resolved. "--strict" checking will receive another round of patches
afterwards.

Yes, you will hate me for this large code drop, but at least we sort-of
discussed this beforehand, and we have to start *somewhere*.

Thanks in advance for reviewing and (optimally) getting this merged and
getting the DD driver dilemma solved hopefully once and for all.

[1] http://www.spinics.net/lists/linux-media/msg117946.html
[2] http://www.spinics.net/lists/linux-media/msg117358.html
[3] https://github.com/herrnst/dddvb-linux-kernel/compare/4226861...mediatree/master-ddbupdate

Daniel Scheller (12):
  [media] ddbridge: bump ddbridge code to version 0.9.29
  [media] ddbridge: split I/O related functions off from ddbridge.h
  [media] ddbridge: split off IRQ handling
  [media] ddbridge: split off hardware definitions and mappings
  [media] ddbridge: check pointers before dereferencing
  [media] ddbridge: only register frontends in fe2 if fe is not NULL
  [media] ddbridge: fix possible buffer overflow in ddb_ports_init()
  [media] ddbridge: remove unreachable code
  [media] ddbridge: fix impossible condition warning
  [media] ddbridge: fix dereference before check
  [media] ddbridge: Kconfig option to control the MSI modparam default
  [media] MAINTAINERS: add entry for ddbridge

 MAINTAINERS                                |    8 +
 drivers/media/pci/ddbridge/Kconfig         |   15 +
 drivers/media/pci/ddbridge/Makefile        |    3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 3140 +++++++++++++++++++++-------
 drivers/media/pci/ddbridge/ddbridge-hw.c   |  299 +++
 drivers/media/pci/ddbridge/ddbridge-hw.h   |   52 +
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  218 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.h  |   41 +-
 drivers/media/pci/ddbridge/ddbridge-io.h   |   71 +
 drivers/media/pci/ddbridge/ddbridge-irq.c  |  148 ++
 drivers/media/pci/ddbridge/ddbridge-main.c |  525 ++---
 drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
 drivers/media/pci/ddbridge/ddbridge.h      |  334 ++-
 13 files changed, 3681 insertions(+), 1311 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-io.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-irq.c

-- 
2.13.0
