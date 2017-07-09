Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:35968 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdGITmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:25 -0400
Received: by mail-wr0-f177.google.com with SMTP id c11so111934604wrc.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 00/14] ddbridge: bump to ddbridge-0.9.29
Date: Sun,  9 Jul 2017 21:42:07 +0200
Message-Id: <20170709194221.10255-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Preferrably for Linux 4.14 (to get things done).

Hard-depends on the STV0910/STV6111 driver patchset as the diff and the
updated code depends on the driver and the changes involved with the
glue code of the STV/DDCineS2V7 series [1].

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
   additional Demod driver; subject for another series)

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
them. With the ddbridge code bump, all style issues are resolved.

Yes, you will hate me for this large code drop, but at least we sort-of
discussed this beforehand, and we have to start *somewhere*.

Thanks in advance for reviewing and (optimally) getting this merged and
getting the DD driver dilemma solved hopefully once and for all.

[1] http://www.spinics.net/lists/linux-media/msg117946.html
[2] http://www.spinics.net/lists/linux-media/msg117358.html
[3] https://github.com/herrnst/dddvb-linux-kernel/compare/4226861...mediatree/master-ddbupdate

Daniel Scheller (14):
  [media] ddbridge: move/reorder functions
  [media] ddbridge: split code into multiple files
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
 drivers/media/pci/ddbridge/ddbridge-core.c | 4242 ++++++++++++++++++----------
 drivers/media/pci/ddbridge/ddbridge-hw.c   |  299 ++
 drivers/media/pci/ddbridge/ddbridge-hw.h   |   52 +
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  310 ++
 drivers/media/pci/ddbridge/ddbridge-io.h   |   71 +
 drivers/media/pci/ddbridge/ddbridge-irq.c  |  161 ++
 drivers/media/pci/ddbridge/ddbridge-main.c |  393 +++
 drivers/media/pci/ddbridge/ddbridge-regs.h |  138 +-
 drivers/media/pci/ddbridge/ddbridge.h      |  355 ++-
 12 files changed, 4402 insertions(+), 1645 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-io.h
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-irq.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-main.c

-- 
2.13.0
