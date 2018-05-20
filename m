Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:41486 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbeETGum (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 02:50:42 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/7] don't check number of I2C messages in drivers
Date: Sun, 20 May 2018 08:50:31 +0200
Message-Id: <20180520065039.7989-1-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The core does it now, we can simplify drivers.

Based on v4.17-rc5. buildbot is happy. I'd suggest the media tree.

Thanks,

   Wolfram

Wolfram Sang (7):
  media: netup_unidvb: don't check number of messages in the driver
  media: si4713: don't check number of messages in the driver
  media: cx231xx: don't check number of messages in the driver
  media: em28xx: don't check number of messages in the driver
  media: hdpvr: don't check number of messages in the driver
  media: tm6000: don't check number of messages in the driver
  media: dvb-usb: don't check number of messages in the driver

 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c | 5 -----
 drivers/media/radio/si4713/radio-usb-si4713.c     | 3 ---
 drivers/media/usb/cx231xx/cx231xx-i2c.c           | 2 --
 drivers/media/usb/dvb-usb/m920x.c                 | 3 ---
 drivers/media/usb/em28xx/em28xx-i2c.c             | 4 ----
 drivers/media/usb/hdpvr/hdpvr-i2c.c               | 3 ---
 drivers/media/usb/tm6000/tm6000-i2c.c             | 2 --
 7 files changed, 22 deletions(-)

-- 
2.11.0
