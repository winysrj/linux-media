Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39770 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030446AbeFSSuU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 14:50:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id p11-v6so2293004wmc.4
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2018 11:50:20 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com, rjkm@metzlerbros.de,
        mvoelkel@DigitalDevices.de
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 0/9] DD drivers: cleanup licensing
Date: Tue, 19 Jun 2018 20:50:07 +0200
Message-Id: <20180619185016.24402-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Upstream committed a change to the dddvb driver package ([1]) that makes
things clear everything is licensed under the terms of the GPLv2-only.
So, apply the MODULE_LICENSE change to ddbridge, mxl5xx, stv0910 and
stv6111, and, as things are sorted now, apply SPDX license identifiers,
add missing header boilerplates in the DVB frontend drivers and fix up
a few cosmetics throughout the boilerplates.

One note re checkpatch and the order of the patches: I wanted to add
missing boilerplates where needed first before adding SPDX tags, so
checkpatch complains missing/malformed SPDX tags on those patches. Also,
I didn't want to touch the mxl5xx_regs more than needed, so checkpatch
moans about >80 columns in that patch/file.

Ralph/Manfred: Although all license related things should be clear by
now, please be so kind and send Acks (or complaints, if any) on these
patches so we can finally get rid of any mismatches in the in-kernel
drivers.

Changed in v3:
* (there was only one version posted so far but this is nonetheless
  the third iteration overall)
* Split up changes into more patches as requested by GregKH
* Note the change in the upstream driver package

[1] https://github.com/DigitalDevices/dddvb/commit/3db30defab4bd5429f6563b084a215b83da01ea0

Daniel Scheller (9):
  [media] mxl5xx/stv0910/stv6111/ddbridge: fix MODULE_LICENSE to 'GPL
    v2'
  [media] ddbridge: add SPDX license identifiers
  [media] ddbridge: header/boilerplate cleanups and cosmetics
  [media] dvb-frontends/mxl5xx: cleanup and fix licensing boilerplates
  [media] dvb-frontends/mxl5xx: add SPDX license identifier
  [media] dvb-frontends/stv0910: cleanup and fix licensing boilerplates
  [media] dvb-frontends/stv0910: add SPDX license identifier
  [media] dvb-frontends/stv6111: cleanup and fix licensing boilerplates
  [media] dvb-frontends/stv6111: add SPDX license identifier

 drivers/media/dvb-frontends/mxl5xx.c       |  6 +++---
 drivers/media/dvb-frontends/mxl5xx.h       | 22 ++++++++++++++++++++++
 drivers/media/dvb-frontends/mxl5xx_defs.h  |  6 ++++++
 drivers/media/dvb-frontends/mxl5xx_regs.h  |  4 ++--
 drivers/media/dvb-frontends/stv0910.c      |  5 +++--
 drivers/media/dvb-frontends/stv0910.h      | 18 ++++++++++++++++++
 drivers/media/dvb-frontends/stv0910_regs.h |  3 ++-
 drivers/media/dvb-frontends/stv6111.c      |  6 +++---
 drivers/media/dvb-frontends/stv6111.h      | 16 ++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ci.c   |  6 ++----
 drivers/media/pci/ddbridge/ddbridge-ci.h   |  6 ++----
 drivers/media/pci/ddbridge/ddbridge-core.c |  8 ++------
 drivers/media/pci/ddbridge/ddbridge-hw.c   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-hw.h   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.h  |  6 +++---
 drivers/media/pci/ddbridge/ddbridge-io.h   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-main.c |  6 +++---
 drivers/media/pci/ddbridge/ddbridge-max.c  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-max.h  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-regs.h |  7 ++-----
 drivers/media/pci/ddbridge/ddbridge.h      |  7 ++-----
 22 files changed, 103 insertions(+), 53 deletions(-)

-- 
2.16.4
