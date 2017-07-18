Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:36505 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbdGRKYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 06:24:18 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v3 0/4] i2c: document DMA handling and add helpers for it
Date: Tue, 18 Jul 2017 12:23:35 +0200
Message-Id: <20170718102339.28726-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, after revisiting old mail threads and taking part in a similar discussion
on the USB list, here is what I cooked up to document and ease DMA handling for
I2C within Linux. Please have a look at the documentation introduced in patch 2
for further details.

All patches have been tested with a Renesas Salvator-X board (r8a7796/M3-W) and
a Renesas Lager board (r8a7790/H2). A more detailed test description can be
found here: http://elinux.org/Tests:I2C-core-DMA

The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/topic/i2c-core-dma-v3

And big kudos to Renesas Electronics for funding this work, thank you very much!

Regards,

   Wolfram


Changes since v2:

* rebased to v4.13-rc1
* helper functions are not inlined anymore but moved to i2c core
* __must_check has been added to the buffer check helper
* the release function has been renamed to contain 'dma' as well
* documentation updates. Hopefully better wording now
* removed the doubled Signed-offs
* adding more potentially interested parties to CC


Wolfram Sang (4):
  i2c: add helpers to ease DMA handling
  i2c: add docs to clarify DMA handling
  i2c: sh_mobile: use helper to decide if DMA is useful
  i2c: rcar: check for DMA-capable buffers

 Documentation/i2c/DMA-considerations | 38 ++++++++++++++++++++
 drivers/i2c/busses/i2c-rcar.c        | 18 +++++++---
 drivers/i2c/busses/i2c-sh_mobile.c   |  8 +++--
 drivers/i2c/i2c-core-base.c          | 68 ++++++++++++++++++++++++++++++++++++
 include/linux/i2c.h                  |  5 +++
 5 files changed, 130 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/i2c/DMA-considerations

-- 
2.11.0
