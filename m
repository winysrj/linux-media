Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33274 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdHSKea (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 06:34:30 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, wsa@the-dreams.de, jacmet@sunsite.dk,
        jglauber@cavium.com, david.daney@cavium.com,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/4] drivers: make i2c_adapter const
Date: Sat, 19 Aug 2017 16:04:11 +0530
Message-Id: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make i2c_adapter const. Done using Coccinelle.

Bhumika Goyal (4):
  i2c: busses: make i2c_adapter const
  [media] media: pci: make i2c_adapter const
  [media] radio-usb-si4713: make i2c_adapter const
  [media] usb: make i2c_adapter const

 drivers/i2c/busses/i2c-kempld.c                   | 2 +-
 drivers/i2c/busses/i2c-ocores.c                   | 2 +-
 drivers/i2c/busses/i2c-octeon-platdrv.c           | 2 +-
 drivers/i2c/busses/i2c-thunderx-pcidrv.c          | 2 +-
 drivers/i2c/busses/i2c-xiic.c                     | 2 +-
 drivers/media/pci/cobalt/cobalt-i2c.c             | 2 +-
 drivers/media/pci/cx18/cx18-i2c.c                 | 2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c           | 2 +-
 drivers/media/pci/cx25821/cx25821-i2c.c           | 2 +-
 drivers/media/pci/ivtv/ivtv-i2c.c                 | 4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c | 2 +-
 drivers/media/pci/saa7134/saa7134-i2c.c           | 2 +-
 drivers/media/pci/saa7164/saa7164-i2c.c           | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c     | 2 +-
 drivers/media/usb/au0828/au0828-i2c.c             | 2 +-
 drivers/media/usb/cx231xx/cx231xx-i2c.c           | 2 +-
 drivers/media/usb/em28xx/em28xx-i2c.c             | 2 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c               | 2 +-
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c      | 2 +-
 drivers/media/usb/stk1160/stk1160-i2c.c           | 2 +-
 drivers/media/usb/usbvision/usbvision-i2c.c       | 4 ++--
 21 files changed, 23 insertions(+), 23 deletions(-)

-- 
1.9.1
