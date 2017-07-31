Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0117.outbound.protection.outlook.com ([104.47.2.117]:27101
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751951AbdGaNjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 09:39:06 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 0/3] [media] cx231xx: cleanup i2c adapter handling
Date: Mon, 31 Jul 2017 15:38:49 +0200
Message-Id: <20170731133852.8013-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This seems like fairly straight forward cleanups/bugfixes. I don't
have the hardware and found the issues by reading code while doing
other things. So, it builds for me, but it's untested.

1/3 changes behavior on failure, but I think it's the right thing
to do. If it isn't for some reason, then the current code is crap
anyway, because as-is it compares with a value that is always zero
meaning that the entire "if (0 != bus->i2c_rc)"-clause with its
dev_warn can be removed from cx231xx_i2c_register.

Cheers,
Peter

Peter Rosin (3):
  [media] cx231xx: fail probe if i2c_add_adapter fails
  [media] cx231xx: drop return value of cx231xx_i2c_unregister
  [media] cx231xx: only unregister successfully registered i2c adapters

 drivers/media/usb/cx231xx/cx231xx-core.c | 3 +++
 drivers/media/usb/cx231xx/cx231xx-i2c.c  | 8 ++++----
 drivers/media/usb/cx231xx/cx231xx.h      | 4 ++--
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.11.0
