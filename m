Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35042 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdFXQDF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Jun 2017 12:03:05 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so20075362wrb.2
        for <linux-media@vger.kernel.org>; Sat, 24 Jun 2017 09:03:05 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 0/9] STV0910/STV6111 drivers, ddbridge CineS2 V7 support
Date: Sat, 24 Jun 2017 18:02:52 +0200
Message-Id: <20170624160301.17710-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

For Linux 4.14.

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

Also, all uppercase writing an camel case are still there yet, and if you
don't ultimately insist of having this changed (there are drivers all over
the place which have uppercase vars), I'll prefer to keep it like it is
at the moment to not diverge even more from upstream, that'll ease syncing
later on that way. Else, I can change this ofc.

Patch 2 is a fix for an issue found while preparing this series for
posting, and was in parallel submitted to the vendor's GIT repository.

Patch 8 eventually needs fixup (printk -> dev_*) wrt
https://patchwork.linuxtv.org/patch/42034/

Regarding MAINTAINERS and maintainership: I already offered to volunteer
to regularly check for upstream updates and sync them to mainline, as
outlined at
http://www.mail-archive.com/linux-media@vger.kernel.org/msg114469.html .
If this qualifies for an entry in MAINTAINERS, then that one's missing.
Please advise.

Mauro, I assume you're the one who reviews this (since these are new
drivers). It'd be very great to have this in for 4.14 to tackle the
ddbridge bump for 4.15.

Daniel Scheller (9):
  [media] dvb-frontends: add ST STV0910 DVB-S/S2 demodulator frontend
    driver
  [media] dvb-frontends/stv0910: Fix possible buffer overflow
  [media] dvb-frontends/stv0910: add multistream (ISI) and PLS
    capabilities
  [media] dvb-frontends/stv0910: Fix signal strength reporting
  [media] dvb-frontends/stv0910: Add missing set_frontend fe-op
  [media] dvb-frontends: add ST STV6111 DVB-S/S2 tuner frontend driver
  [media] ddbridge: return stv09xx id in port_has_stv0900_aa()
  [media] ddbridge: support for CineS2 V7(A) and DuoFlex S2 V4 hardware
  [media] ddbridge: stv0910 single demod mode module option

 drivers/media/dvb-frontends/Kconfig        |   18 +
 drivers/media/dvb-frontends/Makefile       |    2 +
 drivers/media/dvb-frontends/stv0910.c      | 1765 +++++++++++
 drivers/media/dvb-frontends/stv0910.h      |   32 +
 drivers/media/dvb-frontends/stv0910_regs.h | 4759 ++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/stv6111.c      |  675 ++++
 drivers/media/dvb-frontends/stv6111.h      |   20 +
 drivers/media/pci/ddbridge/Kconfig         |    4 +
 drivers/media/pci/ddbridge/ddbridge-core.c |  149 +-
 drivers/media/pci/ddbridge/ddbridge.h      |    2 +
 10 files changed, 7418 insertions(+), 8 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/stv0910.c
 create mode 100644 drivers/media/dvb-frontends/stv0910.h
 create mode 100644 drivers/media/dvb-frontends/stv0910_regs.h
 create mode 100644 drivers/media/dvb-frontends/stv6111.c
 create mode 100644 drivers/media/dvb-frontends/stv6111.h

-- 
2.13.0
