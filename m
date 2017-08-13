Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35449 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdHMIzD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 04:55:03 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: crope@iki.fi, mchehab@kernel.org, ezequiel@vanguardiasur.com.ar,
        laurent.pinchart@ideasonboard.com, royale@zerezo.com,
        sean@mess.org, klimov.linux@gmail.com, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] constify media usb_device_id
Date: Sun, 13 Aug 2017 14:24:42 +0530
Message-Id: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] [media] usb: constify usb_device_id
  [PATCH 2/3] [media] rc: constify usb_device_id
  [PATCH 3/3] [media] radio: constify usb_device_id

 drivers/media/radio/dsbr100.c                     | 2 +-
 drivers/media/radio/radio-keene.c                 | 2 +-
 drivers/media/radio/radio-ma901.c                 | 2 +-
 drivers/media/radio/radio-mr800.c                 | 2 +-
 drivers/media/radio/radio-raremono.c              | 2 +-
 drivers/media/radio/radio-shark.c                 | 2 +-
 drivers/media/radio/radio-shark2.c                | 2 +-
 drivers/media/radio/si470x/radio-si470x-usb.c     | 2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c     | 2 +-
 drivers/media/rc/ati_remote.c                     | 2 +-
 drivers/media/rc/igorplugusb.c                    | 2 +-
 drivers/media/rc/imon.c                           | 2 +-
 drivers/media/rc/mceusb.c                         | 2 +-
 drivers/media/rc/redrat3.c                        | 2 +-
 drivers/media/rc/streamzap.c                      | 2 +-
 drivers/media/usb/airspy/airspy.c                 | 2 +-
 drivers/media/usb/as102/as102_usb_drv.c           | 2 +-
 drivers/media/usb/b2c2/flexcop-usb.c              | 2 +-
 drivers/media/usb/cpia2/cpia2_usb.c               | 2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c             | 2 +-
 drivers/media/usb/hackrf/hackrf.c                 | 2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c              | 2 +-
 drivers/media/usb/msi2500/msi2500.c               | 2 +-
 drivers/media/usb/s2255/s2255drv.c                | 2 +-
 drivers/media/usb/stk1160/stk1160-core.c          | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c          | 2 +-
 drivers/media/usb/tm6000/tm6000-cards.c           | 2 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c           | 2 +-
 drivers/media/usb/usbtv/usbtv-core.c              | 2 +-
 drivers/media/usb/uvc/uvc_driver.c                | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c               | 2 +-
 32 files changed, 32 insertions(+), 32 deletions(-)

-- 
2.7.4
