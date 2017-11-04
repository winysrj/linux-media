Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:44782 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751474AbdKDUUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 16:20:24 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [PATCH v6 0/9] i2c: document DMA handling and add helpers for it
Date: Sat,  4 Nov 2017 21:20:00 +0100
Message-Id: <20171104202009.3818-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, after revisiting old mail threads, taking part in a similar discussion on
the USB list, and implementing a not-convincing solution before, here is what I
cooked up to document and ease DMA handling for I2C within Linux. Please have a
look at the documentation introduced in patch 7 for details. And to make it
clear again: The stuff below is opt-in. If host drivers are not updated, they
will continue to work like before.

While previous versions until v3 tried to magically apply bounce buffers when
needed, it became clear that detecting DMA safe buffers is too fragile. This
approach is now opt-in, a DMA_SAFE flag needs to be set on an i2c_msg. The
outcome so far is very convincing IMO. The core additions are simple and easy
to understand. The driver changes for the Renesas IP cores became easy to
understand, too.

Of course, we must now whitelist DMA safe buffers. This series implements it
for core functionality:

a) for the I2C_RDWR when messages come from userspace
b) for i2c_smbus_xfer_emulated(), DMA safe buffers are now allocated for
   block transfers
c) i2c_master_{send|recv} have now a *_dmasafe variant

I am still not sure how we can teach regmap this new flag. regmap is a heavy
user of I2C, so broonie's opinion here would be great to have. The rest should
mostly be updating individual drivers which can be done when needed.

All patches have been tested with a Renesas Salvator-X board (r8a7796/M3-W) and
Renesas Lager board (r8a7790/H2). But more testing is really really welcome.

The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/topic/i2c-core-dma-v6

It is planned to land upstream in v4.16 and I want to push it to linux-next
early after v4.15 to get lots of testing for the core changes.

Big kudos to Renesas Electronics for funding this work, thank you very much!

Regards,

   Wolfram

Change since V5:
* i2c_master_{send|recv} have now a *_dmasafe variant
* for i2c_smbus_xfer_emulated(), DMA safe buffers are now allocated for
  block transfers
* updated the documentation
* merged some rewording suggestions from Jonathan Cameron (thanks!)
* rebased the patches v4.14-rc6+i2c/for-next, reordered patches


Wolfram Sang (9):
  i2c: add a message flag for DMA safe buffers
  i2c: add helpers to ease DMA handling
  i2c: dev: mark RDWR buffers as DMA_SAFE
  i2c: refactor i2c_master_{send_recv}
  i2c: add i2c_master_{send|recv}_dmasafe
  i2c: smbus: use DMA safe buffers for emulated SMBus transactions
  i2c: add docs to clarify DMA handling
  i2c: sh_mobile: use core helper to decide when to use DMA
  i2c: rcar: skip DMA if buffer is not safe

 Documentation/i2c/DMA-considerations |  67 +++++++++++++++++++++
 drivers/i2c/busses/i2c-rcar.c        |   2 +-
 drivers/i2c/busses/i2c-sh_mobile.c   |   8 ++-
 drivers/i2c/i2c-core-base.c          | 110 ++++++++++++++++++++---------------
 drivers/i2c/i2c-core-smbus.c         |  45 ++++++++++++--
 drivers/i2c/i2c-dev.c                |   2 +
 include/linux/i2c.h                  |  68 ++++++++++++++++++++--
 include/uapi/linux/i2c.h             |   3 +
 8 files changed, 246 insertions(+), 59 deletions(-)
 create mode 100644 Documentation/i2c/DMA-considerations

-- 
2.11.0
