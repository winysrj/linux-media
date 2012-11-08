Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTMJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:09 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:08 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 00/21] em28xx: add support fur USB bulk transfers
Date: Thu,  8 Nov 2012 20:11:32 +0200
Message-Id: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for USB bulk transfers to the em28xx driver.

Patch 1 is a bugfix for the image data processing with non-interlaced
devices (webcams) that should be considered for stable (see commit message).

Patches 2-21 extend the driver to support USB bulk transfers.
USB endpoint mapping had to be extended and is a bit tricky.
It might still not be sufficient to handle ALL isoc/bulk endpoints 
of ALL existing devices, but it should work with the devices we have 
seen so far and (most important !) preserves backwards compatibility to 
the current driver behavior.
Isoc endpoints/transfers are preffered by default, patch 21 adds a 
module parameter to change this behavior.

Changes in v2:
- remove warnings about untestet changes from the commit messages of
  patches 14 and 15 (meanwhile changes have been tested)
- fix interpretation of the new module parameter prefer_bulk (patch 21)
- drop patches 22 and 23 (they are not really related to USB transfers)



Frank Schäfer (21):
  em28xx: fix wrong data offset for non-interlaced mode in
    em28xx_copy_video
  em28xx: clarify meaning of field 'progressive' in struct em28xx
  em28xx: rename isoc packet number constants and parameters
  em28xx: rename struct em28xx_usb_isoc_bufs to em28xx_usb_bufs
  em28xx: rename struct em28xx_usb_isoc_ctl to em28xx_usb_ctl
  em28xx: remove obsolete #define EM28XX_URB_TIMEOUT
  em28xx: update description of em28xx_irq_callback
  em28xx: rename function em28xx_uninit_isoc to em28xx_uninit_usb_xfer
  em28xx: create a common function for isoc and bulk URB allocation and
    setup
  em28xx: create a common function for isoc and bulk USB transfer
    initialization
  em28xx: clear USB halt/stall condition in em28xx_init_usb_xfer when
    using bulk transfers
  em28xx: remove double checks for urb->status == -ENOENT in
    urb_data_copy functions
  em28xx: rename function em28xx_isoc_copy and extend for USB bulk
    transfers
  em28xx: rename function em28xx_isoc_copy_vbi and extend for USB bulk
    transfers
  em28xx: rename function em28xx_dvb_isoc_copy and extend for USB bulk
    transfers
  em28xx: rename usb debugging module parameter and macro
  em28xx: rename some USB parameter fields in struct em28xx to clarify
    their role
  em28xx: add fields for analog and DVB USB transfer type selection to
    struct em28xx
  em28xx: set USB alternate settings for analog video bulk transfers
    properly
  em28xx: improve USB endpoint logic, also use bulk transfers
  em28xx: add module parameter for selection of the preferred USB
    transfer type

 drivers/media/usb/em28xx/em28xx-cards.c |  116 +++++++++++---
 drivers/media/usb/em28xx/em28xx-core.c  |  247 +++++++++++++++++------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   85 ++++++----
 drivers/media/usb/em28xx/em28xx-reg.h   |    4 +-
 drivers/media/usb/em28xx/em28xx-vbi.c   |    4 +-
 drivers/media/usb/em28xx/em28xx-video.c |  259 +++++++++++++++++--------------
 drivers/media/usb/em28xx/em28xx.h       |   78 ++++++----
 7 Dateien geändert, 494 Zeilen hinzugefügt(+), 299 Zeilen entfernt(-)

-- 
1.7.10.4

