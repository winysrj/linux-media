Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:46130 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3ASXlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:41:51 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: peter.senna@gmail.com, n.pajkovsky@gmail.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH V2 00/24] [media] use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:07 -0200
Message-Id: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series introduce the use of IS_ENABLED() macro.
For example replace:
 #if defined(CONFIG_VIDEO_CX88_DVB) || \
     defined(CONFIG_VIDEO_CX88_DVB_MODULE)
with:
 #if IS_ENABLED(CONFIG_VIDEO_CX88_DVB)

Changes from V1:
   Updated subject
   Fixed commit message of patch 15/24
   Fixed commit message of patch 24/24

Peter Senna Tschudin (24):
  pci/cx88/cx88.h: use IS_ENABLED() macro
  pci/saa7134/saa7134.h: use IS_ENABLED() macro
  pci/ttpci/av7110.c: use IS_ENABLED() macro
  platform/marvell-ccic/mcam-core.h: use IS_ENABLED() macro
  radio/si470x/radio-si470x.h: use IS_ENABLED() macro
  usb/gspca/cpia1.c: use IS_ENABLED() macro
  usb/gspca: use IS_ENABLED() macro
  usb/gspca/konica.c: use IS_ENABLED() macro
  usb/gspca/ov519.c: use IS_ENABLED() macro
  usb/gspca/pac207.c: use IS_ENABLED() macro
  gspca/pac7302.c: use IS_ENABLED() macro
  usb/gspca/pac7311.c: use IS_ENABLED() macro
  usb/gspca/se401.c: use IS_ENABLED() macro
  usb/gspca/sn9c20x.c: use IS_ENABLED() macro
  usb/gspca/sonixb.c: use IS_ENABLED() macro
  usb/gspca/sonixj.c: use IS_ENABLED() macro
  usb/gspca/spca561.c: use IS_ENABLED() macro
  usb/gspca/stv06xx/stv06xx.c: use IS_ENABLED() macro
  usb/gspca/t613.c: use IS_ENABLED() macro
  usb/gspca/xirlink_cit.c: use IS_ENABLED() macro
  usb/gspca/zc3xx.c: use IS_ENABLED() macro
  usb/hdpvr/hdpvr-core.c: use IS_ENABLED() macro
  usb/hdpvr/hdpvr-i2c.c: use IS_ENABLED() macro
  v4l2-core/v4l2-common.c: use IS_ENABLED() macro

 drivers/media/pci/cx88/cx88.h                   | 10 ++++------
 drivers/media/pci/saa7134/saa7134.h             |  4 ++--
 drivers/media/pci/ttpci/av7110.c                | 10 +++++-----
 drivers/media/platform/marvell-ccic/mcam-core.h |  6 +++---
 drivers/media/radio/si470x/radio-si470x.h       |  4 ++--
 drivers/media/usb/gspca/cpia1.c                 |  6 +++---
 drivers/media/usb/gspca/gspca.c                 | 10 +++++-----
 drivers/media/usb/gspca/gspca.h                 |  6 +++---
 drivers/media/usb/gspca/konica.c                |  6 +++---
 drivers/media/usb/gspca/ov519.c                 |  6 +++---
 drivers/media/usb/gspca/pac207.c                |  4 ++--
 drivers/media/usb/gspca/pac7302.c               |  4 ++--
 drivers/media/usb/gspca/pac7311.c               |  4 ++--
 drivers/media/usb/gspca/se401.c                 |  4 ++--
 drivers/media/usb/gspca/sn9c20x.c               |  4 ++--
 drivers/media/usb/gspca/sonixb.c                |  6 +++---
 drivers/media/usb/gspca/sonixj.c                |  4 ++--
 drivers/media/usb/gspca/spca561.c               |  6 +++---
 drivers/media/usb/gspca/stv06xx/stv06xx.c       |  4 ++--
 drivers/media/usb/gspca/t613.c                  |  6 +++---
 drivers/media/usb/gspca/xirlink_cit.c           |  8 ++++----
 drivers/media/usb/gspca/zc3xx.c                 |  4 ++--
 drivers/media/usb/hdpvr/hdpvr-core.c            |  6 +++---
 drivers/media/usb/hdpvr/hdpvr-i2c.c             |  2 +-
 drivers/media/v4l2-core/v4l2-common.c           |  4 ++--
 25 files changed, 68 insertions(+), 70 deletions(-)

-- 
1.7.11.7

