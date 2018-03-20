Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37419 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751475AbeCTVBm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 17:01:42 -0400
Received: by mail-wr0-f196.google.com with SMTP id z12so3138876wrg.4
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 14:01:41 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: gregkh@linuxfoundation.org, mvoelkel@DigitalDevices.de,
        rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 0/5] SPDX license identifiers in all DD drivers
Date: Tue, 20 Mar 2018 22:01:27 +0100
Message-Id: <20180320210132.7873-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This series adds SPDX license identifiers to all source files which are
copyright by either Digital Devices GmbH or Metzlerbros GbR, who are
the original authors of the ddbridge, ngene, cxd2099, mxl5xx, stv0910
and stv6111 bridge/demod/tuner drivers, with the mxl5xx driver being
based on source code released by MaxLinear.

All source code either carries the license text "redistribute and/or
modify it under the terms of the GNU GPL version 2 only as published
by the FSF", or simply "... GPL version 2" in the case of the mxl5xx
driver, which all should equal to the SPDX License Identifier
"GPL-2.0-only" as of SPDX License List Version 3.0 published on
December the 28th, 2017, which is applied as license tag to all files
of the mentioned drivers by this series.

During checking of those modules I noticed that the module info carries
the "GPL" version tag, which, according to include/linux/module.h, equals
to "GPL version 2 or later", which (I believe) in turn is a mismatch to
what is written in the file header's license boilerplates. This series
corrects this by setting all MODULE_LICENSE() descriptors to "GPL v2",
which equals to the "GNU GPL version 2 only" phrase.

Besides that, this fixes some whitespace cosmetics in the headers, and
removes the link to gnu.org (if existing), which points to the GPLv3
license anyway.

The original intention was to fully replace all the licensing headers
with only the SPDX License Identifiers as it is done in a lot of other
in-tree drivers nowadays. However, Digital Devices disagreed to do this
and expressed major concerns regarding this, in that a machine readable
license tag instead of a full license boilerplate won't hold up equally,
so we agreed to keep the license boilerplate text as is right now.

Greg, I'm Cc'ing you on this due to the last paragraph, as AFAIK you're
one of the initiators of the SPDX tagging initiative, and you even added
tags to 10k+ files all over the tree :-) so we maybe can discuss this
further, also with DD, in the hopes you're fine with this - sorry in
advance if not.

Ralph, Manfred, I'm Cc'ing you on these five patches aswell, so if there
are any concerns left regarding the changes proposed by these patches,
please raise them.

Daniel Scheller (5):
  [media] stv0910/stv6111: add SPDX license headers
  [media] dvb-frontends/mxl5xx: add SPDX license headers
  [media] dvb-frontends/cxd2099: add SPDX license headers
  [media] ddbridge: add SPDX license headers
  [media] ngene: add SPDX license headers

 drivers/media/dvb-frontends/cxd2099.c      |  5 +++--
 drivers/media/dvb-frontends/cxd2099.h      |  3 ++-
 drivers/media/dvb-frontends/mxl5xx.c       |  6 +++---
 drivers/media/dvb-frontends/mxl5xx.h       | 13 +++++++++++++
 drivers/media/dvb-frontends/mxl5xx_defs.h  |  1 +
 drivers/media/dvb-frontends/mxl5xx_regs.h  |  4 ++--
 drivers/media/dvb-frontends/stv0910.c      |  5 +++--
 drivers/media/dvb-frontends/stv0910.h      |  9 +++++++++
 drivers/media/dvb-frontends/stv6111.c      |  6 +++---
 drivers/media/dvb-frontends/stv6111.h      |  7 +++++++
 drivers/media/pci/ddbridge/Makefile        |  2 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c   |  6 ++----
 drivers/media/pci/ddbridge/ddbridge-ci.h   |  6 ++----
 drivers/media/pci/ddbridge/ddbridge-core.c |  8 ++------
 drivers/media/pci/ddbridge/ddbridge-hw.c   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-hw.h   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-i2c.h  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-io.h   |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-main.c |  8 ++++----
 drivers/media/pci/ddbridge/ddbridge-max.c  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-max.h  |  4 ++--
 drivers/media/pci/ddbridge/ddbridge-regs.h |  7 ++-----
 drivers/media/pci/ddbridge/ddbridge.h      |  7 ++-----
 drivers/media/pci/ngene/Makefile           |  2 +-
 drivers/media/pci/ngene/ngene-cards.c      | 10 +++-------
 drivers/media/pci/ngene/ngene-core.c       |  8 ++------
 drivers/media/pci/ngene/ngene-dvb.c        |  8 ++------
 drivers/media/pci/ngene/ngene-i2c.c        |  8 ++------
 drivers/media/pci/ngene/ngene.h            |  7 ++-----
 30 files changed, 87 insertions(+), 87 deletions(-)

-- 
2.16.1
