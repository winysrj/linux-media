Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46070 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdJOUwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:00 -0400
Received: by mail-wm0-f65.google.com with SMTP id q124so30332529wmb.0
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:00 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH for 4.15] ddbridge update to 0.9.32
Date: Sun, 15 Oct 2017 22:51:49 +0200
Message-Id: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

For the 4.15 merge window. These patches update the mainline ddbridge
driver to version 0.9.32, which was released ~3 weeks ago by upstream.

Nothing really fancy in this series, in fact upstream applied many of
the changes that went into the mainline driver, which was released as
0.9.32. A few more changes were applied though, namely the CI DuoFlex/
PCIe Bridge support has been split from -core (like ie. the MaxS8 card
support), upstream named the files with the MaxS8 support code
"-max.[c|h]" (thus the rename), and everything was made checkpatch-
strict clean.

One condition in stv0910.c:read_status() was missing in mainline and is
being added in 7/8.

The series was tested for bisect safety and checked with smatch.

Please pull for 4.15.

Daniel Scheller (8):
  [media] ddbridge: remove unneeded *fe vars from attach functions
  [media] ddbridge: fixup checkpatch-strict issues
  [media] ddbridge: split off CI (common interface) from ddbridge-core
  [media] ddbridge/ci: change debug printing to debug severity
  [media] ddbridge/max: rename ddbridge-maxs8.[c|h] to
    ddbridge-max.[c|h]
  [media] ddbridge/max: prefix lnb_init_fmode() and fe_attach_mxl5xx()
  [media] stv0910: read and update mod_cod in read_status()
  [media] ddbridge: update driver version number

 drivers/media/dvb-frontends/stv0910.c              |  13 +
 drivers/media/pci/ddbridge/Makefile                |   4 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c           | 349 +++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ci.h           |  30 ++
 drivers/media/pci/ddbridge/ddbridge-core.c         | 494 ++++-----------------
 drivers/media/pci/ddbridge/ddbridge-hw.c           |   8 +-
 drivers/media/pci/ddbridge/ddbridge-i2c.c          |  16 +-
 drivers/media/pci/ddbridge/ddbridge-main.c         |  23 +-
 .../ddbridge/{ddbridge-maxs8.c => ddbridge-max.c}  |  54 ++-
 .../ddbridge/{ddbridge-maxs8.h => ddbridge-max.h}  |  12 +-
 drivers/media/pci/ddbridge/ddbridge-regs.h         |  32 +-
 drivers/media/pci/ddbridge/ddbridge.h              |  91 ++--
 12 files changed, 602 insertions(+), 524 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.h
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.c => ddbridge-max.c} (92%)
 rename drivers/media/pci/ddbridge/{ddbridge-maxs8.h => ddbridge-max.h} (73%)

-- 
2.13.6
