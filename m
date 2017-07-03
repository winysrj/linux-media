Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35518 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755472AbdGCRVI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 13:21:08 -0400
Received: by mail-wr0-f194.google.com with SMTP id z45so45399981wrb.2
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 10:21:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v3 00/10] STV0910/STV6111 drivers, ddbridge CineS2 V7 support
Date: Mon,  3 Jul 2017 19:20:53 +0200
Message-Id: <20170703172104.27283-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

For Linux 4.14.

This v3 is a fixup for the previously posted v2. Smatch and W=1 uncovered
three additional issues in the stv6111 driver, see the v3 notes below.
While at it, few things have been fixed in patch 1 (initial stv0910
driver). Sorry for the noise and the mail spam, will try harder to
properly test things before posting next time... At least, we're clean of
warnings (smatch and W=1) and bisect issues now.

Superseeds initial (v1) and v2 series.

This series adds drivers for the ST STV0910 DVB-S/S2 demodulator ICs and
the ST STV6111 DVB-S/S2 tuners, and utilises them to enable ddbridge to
support the current line of Digital Devices DVB-S/S2 hardware (e.g. Cine
S2 V7/V7A adapters, DuoFlex S2 V4 addon modules and maybe more, with
similar components).

The two new drivers have been picked up from Digital Devices' vendor-
provided dddvb driver package, as of release 0.9.29. Permission to reuse
(and mainline) them was formally granted by Ralph Metzler
<rjkm@metzlerbros.de>.

Drivers have been cleaned up alot (formatting fixes, dead code removal,
features depending on not-yet-available API changes removed). Checkpatch
complaints left:

  WARNING: please write a paragraph that describes the config symbol fully
  #39: FILE: drivers/media/dvb-frontends/Kconfig:31:
  +config DVB_STV0910

Not sure what checkpatch demands, since a module description exists in
Kconfig... Applies to the stv6111 aswell.

  WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
  #64:
  new file mode 100644

See below.

  WARNING: 'VALIDE' may be misspelled - perhaps 'VALID'?
  #3314: FILE: drivers/media/dvb-frontends/stv0910_regs.h:1467:
  +#define FSTV0910_P2_NOSRAM_VALIDE  0xf30e0004

Picked from upstream. Since I'm not sure if this really is a mistake
(maybe the hardware vendor really wants to name the reg like this?) so
kept as-is.

CamelCase and ALLCAPS are changed into kernel_kase. Patches have been
proposed to the vendor driver package maintainers to keep things synced
as much as possible.

Patch 2 is a fix for an issue found while preparing this series for
posting, and was in parallel submitted to the vendor's GIT repository.

Adding myself to MAINTAINERS for stv0910 and stv6111 as I'll keep track
of any upstream (vendor provided package) changes and propose them
for mainline inclusion.

Tested-by's from Richard Scobie <r.scobie@clear.net.nz> added to the
commit descriptions.

Mauro, I assume you're the one who reviews this (since these are new
drivers). It'd be very great to have this in for 4.14 to tackle the
ddbridge bump for 4.15. Of course awaiting review yet. I believe this
v3 is at least cleaned up as much as possible, thus an even better
merge candidate than v2 :-)

Changes from v2 to v3:
 - Fixed three warnings in the stv6111 driver, uncovered by W=1 and
   another smatch run:
   * in wait_for_call_done(), int status was redeclared to u8 status
     (due to the camelcase fixup), triggering a -Wtype-limits warning.
     Additional fix proposed to the vendor package maintainers aswell.
   * removed variable "symb" from set_params() (fixes -Wunused-but-set-
     variable)
   * added '#include "stv6111.h"', fixes -Wmissing-prototype for
     *stv6111_attach()
 - Removed unused scrambling_code vars from patch 1
 - Changed "return -1" to "return -EINVAL" in manage_matype_info()
 - Add required fe.dtv_propcache vars/references to the dummy STR
   function, fixes bisect

Changes from v1 to v2:
 - CamelCase and ALLCAPS changed to kernel_case
 - Signal statistics acquisition refactored to comply with standards
 - printk* and pr_* changed to dev_*
 - Add myself to MAINTAINERS for stv0910 and stv6111

Daniel Scheller (10):
  [media] dvb-frontends: add ST STV0910 DVB-S/S2 demodulator frontend
    driver
  [media] dvb-frontends/stv0910: Fix possible buffer overflow
  [media] dvb-frontends/stv0910: add multistream (ISI) and PLS
    capabilities
  [media] dvb-frontends/stv0910: Add demod-only signal strength
    reporting
  [media] dvb-frontends/stv0910: Add missing set_frontend fe-op
  [media] dvb-frontends: add ST STV6111 DVB-S/S2 tuner frontend driver
  [media] ddbridge: return stv09xx id in port_has_stv0900_aa()
  [media] ddbridge: support for CineS2 V7(A) and DuoFlex S2 V4 hardware
  [media] ddbridge: stv0910 single demod mode module option
  [media] MAINTAINERS: add entries for stv0910 and stv6111

 MAINTAINERS                                |   16 +
 drivers/media/dvb-frontends/Kconfig        |   18 +
 drivers/media/dvb-frontends/Makefile       |    2 +
 drivers/media/dvb-frontends/stv0910.c      | 1771 +++++++++++
 drivers/media/dvb-frontends/stv0910.h      |   32 +
 drivers/media/dvb-frontends/stv0910_regs.h | 4759 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/stv6111.c      |  674 ++++
 drivers/media/dvb-frontends/stv6111.h      |   20 +
 drivers/media/pci/ddbridge/Kconfig         |    4 +
 drivers/media/pci/ddbridge/ddbridge-core.c |  151 +-
 drivers/media/pci/ddbridge/ddbridge.h      |    2 +
 11 files changed, 7441 insertions(+), 8 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/stv0910.c
 create mode 100644 drivers/media/dvb-frontends/stv0910.h
 create mode 100644 drivers/media/dvb-frontends/stv0910_regs.h
 create mode 100644 drivers/media/dvb-frontends/stv6111.c
 create mode 100644 drivers/media/dvb-frontends/stv6111.h

-- 
2.13.0
