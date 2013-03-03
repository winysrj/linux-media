Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:50324 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCTkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Mar 2013 14:40:19 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3510704eei.35
        for <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 11:40:18 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 0/5] em28xx: add support for the em2765 bridge
Date: Sun,  3 Mar 2013 20:40:56 +0100
Message-Id: <1362339661-3446-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds basic support for the em25xx/276x/7x/8x camera bridges.
These devices differ from the em2710/2750 and em28xx bridges in several points:
1) a second i2c bus is provided which has to be accessed with a different 
   read/write algorithm (=> patch 1)
2) a different frame data format is used (=> patch 3)
3) additional output formats (e.g. mpeg) are provided. This patch series does
   not (yet) add support for them, but it fixes the output format selection 
   for these bridges (the current code sets bit 5 of the output format register,
   which has a different meaning for the other bridges and breaks capturing
   with em25xx family sdevices). (=> patch 4)
4) registers 0x34+0x35 (VBI_START_H/V for em28xx devices) are used for a 
   different (unknown) purpose. This needs to be investigated further (could be 
   zooming, cropping, image statistics or AWB/AE window selection).
   At normal operation, these registers are set to capturing (input) 
   width/height / 16. (=> patch 5)

Patch 2 add the chip id of the em2765 as found in the "SpeedLink Vicious And 
Devine Laplace" webcam. The changes have also been tested with this device.


Frank Schäfer (5):
  em28xx: add support for em25xx i2c bus B read/write/check device
    operations
  em28xx: add chip id of the em2765
  em28xx: add support for em25xx/em276x/em277x/em278x frame data
    processing
  em28xx: make em28xx_set_outfmt() working with EM25xx family bridges
  em28xx: write output frame resolution to regs 0x34+0x35 for em25xx
    family bridges

 drivers/media/usb/em28xx/em28xx-cards.c |   17 +++-
 drivers/media/usb/em28xx/em28xx-core.c  |   27 ++++-
 drivers/media/usb/em28xx/em28xx-i2c.c   |  164 +++++++++++++++++++++++++++----
 drivers/media/usb/em28xx/em28xx-reg.h   |    7 ++
 drivers/media/usb/em28xx/em28xx-video.c |   72 +++++++++++++-
 drivers/media/usb/em28xx/em28xx.h       |    8 ++
 6 Dateien geändert, 271 Zeilen hinzugefügt(+), 24 Zeilen entfernt(-)

-- 
1.7.10.4

