Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58116 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab2JURwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:52:35 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1066703wey.19
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:52:34 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 00/23] em28xx: add support fur USB bulk transfers
Date: Sun, 21 Oct 2012 19:52:05 +0300
Message-Id: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for USB bulk transfers to the em28xx driver.

Patch 1 is a bugfix for the image data processing with non-interlaced devices (webcams)
that should be considered for stable (see commit message).

Patches 2-21 extend the driver to support USB bulk transfers.
USB endpoint mapping had to be extended and is a bit tricky.
It might still not be sufficient to handle ALL isoc/bulk endpoints of ALL existing devices,
but it should work with the devices we have seen so far and (most important !) 
preserves backwards compatibility to the current driver behavior.
Isoc endpoints/transfers are preffered by default, patch 21 adds a module parameter to change this behavior.

The last two patches are follow-up patches not really related to USB tranfers.
Patch 22 reduces the code size in em28xx-video by merging the two URB data processing functions 
and patch 23 enables VBI-support for em2840-devices.

Please note that I could test the changes with an analog non-interlaced non-VBI device only !
So further tests with DVB/interlaced/VBI devices are strongly recommended !




Frank Schäfer (23):
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
  em28xx: use common urb data copying function for vbi and non-vbi
    devices
  em28xx: enable VBI-support for em2840 devices

 drivers/media/usb/em28xx/em28xx-cards.c |  114 +++++++++---
 drivers/media/usb/em28xx/em28xx-core.c  |  250 ++++++++++++++++-----------
 drivers/media/usb/em28xx/em28xx-dvb.c   |   85 ++++++---
 drivers/media/usb/em28xx/em28xx-reg.h   |    4 +-
 drivers/media/usb/em28xx/em28xx-vbi.c   |    4 +-
 drivers/media/usb/em28xx/em28xx-video.c |  288 +++++++++++--------------------
 drivers/media/usb/em28xx/em28xx.h       |   78 +++++----
 7 Dateien geändert, 452 Zeilen hinzugefügt(+), 371 Zeilen entfernt(-)

-- 
1.7.10.4

