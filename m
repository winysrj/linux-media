Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:59931 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753147AbdHQOOz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 10:14:55 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-i2c@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: [RFC PATCH v4 0/6] i2c: document DMA handling and add helpers for it
Date: Thu, 17 Aug 2017 16:14:43 +0200
Message-Id: <20170817141449.23958-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, after revisiting old mail threads, taking part in a similar discussion on
the USB list, and implementing a not-convincing solution before, here is what I
cooked up to document and ease DMA handling for I2C within Linux. Please have a
look at the documentation introduced in patch 3 for details.

While the previous versions tried to magically apply bounce buffers when
needed, it became clear that detecting DMA safe buffers is too fragile. This
approach is now opt-in, a DMA_SAFE flag needs to be set on an i2c_msg. The
outcome so far is very convincing IMO. The core additions are simple and easy
to understand (makes me even think of inlining them again?). The driver changes
for the Renesas IP cores became easier to understand, too. While only a tad for
the i2c-sh_mobile driver, the situation became a LOT better for the i2c-rcar
driver. No more DMA disabling for the whole transfer in case of unsafe buffers,
we are back to per-msg handling. And the code fix is now an easy to understand
one line change. Yay!

Of course, we must now whitelist DMA safe buffers. An example for I2C_RDWR case
is in this series. It makes the i2ctransfer utility have DMA_SAFE buffers,
which is nice for testing as i2cdump will (currently) not use DMA_SAFE buffers.
My plan is to add two new calls: i2c_master_{send|receive}_dma_safe which can
be used if DMA_SAFE buffers are provided. So, drivers can simply switch to
them. Also, the buffers used within i2c_smbus_xfer_emulated() need to be
converted to be DMA_SAFE which will cover a huge bunch of use cases. The rest
is then updating drivers which can be done when needed.

As these conversions are not done yet, this patch series has RFC status. But I
already would like to get opinions on this approach, so I'll cc mailing lists
of the heavier I2C users. Please let me know what you think.

All patches have been tested with a Renesas Salvator-X board (r8a7796/M3-W).

The branch can be found here:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git renesas/topic/i2c-core-dma-rfc-v4

And big kudos to Renesas Electronics for funding this work, thank you very much!

Regards,

   Wolfram

Changes since v3:
	* completely redesigned

Wolfram Sang (6):
  i2c: add a message flag for DMA safe buffers
  i2c: add helpers to ease DMA handling
  i2c: add docs to clarify DMA handling
  i2c: sh_mobile: use helper to decide if DMA is useful
  i2c: rcar: skip DMA if buffer is not safe
  i2c: dev: mark RDWR buffers as DMA_SAFE

 Documentation/i2c/DMA-considerations | 50 ++++++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-rcar.c        |  2 +-
 drivers/i2c/busses/i2c-sh_mobile.c   |  8 ++++--
 drivers/i2c/i2c-core-base.c          | 45 ++++++++++++++++++++++++++++++++
 drivers/i2c/i2c-dev.c                |  2 ++
 include/linux/i2c.h                  |  3 +++
 include/uapi/linux/i2c.h             |  3 +++
 7 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/i2c/DMA-considerations

-- 
2.11.0
