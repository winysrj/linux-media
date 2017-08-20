Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38247 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdHTKlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:17 -0400
Received: by mail-wr0-f195.google.com with SMTP id k10so256340wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:17 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 0/6] ddbridge: updates from dddvb-0.9.31
Date: Sun, 20 Aug 2017 12:41:08 +0200
Message-Id: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Digital Devices bumped their driver package to version 0.9.31, which most
importantly carries all refactorisations which are part of the pending
mainline driver bump (bringing dddvb and the proposed kernel version much
closer to each other), and improves further on that. This series bumps
the mainline driver accordingly.

These patches should go in right after and alongside the ddbridge-0.9.29
v4 bump series (see [1], means: 4.14 window material) so we have an
uptodate driver in mainline when the next major version gets tagged by
Linus.

[1] http://www.spinics.net/lists/linux-media/msg119911.html

Daniel Scheller (6):
  [media] ddbridge: fix gap handling
  [media] ddbridge: move ddb_unmap(), cleanup modparams
  [media] ddbridge: move device ID table to ddbridge-hw
  [media] ddbridge: remove ddb_info's from the global scope
  [media] ddbridge: const'ify all ddb_info, ddb_regmap et al
  [media] ddbridge: bump version string to 0.9.31intermediate-integrated

 drivers/media/pci/ddbridge/ddbridge-core.c |  46 +++++++---
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 129 ++++++++++++++++++++++-------
 drivers/media/pci/ddbridge/ddbridge-hw.h   |  45 ++++------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |   5 +-
 drivers/media/pci/ddbridge/ddbridge-main.c |  67 ++-------------
 drivers/media/pci/ddbridge/ddbridge.h      |  27 +++---
 6 files changed, 172 insertions(+), 147 deletions(-)

-- 
2.13.0
