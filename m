Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42109 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750786AbdLDMJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 07:09:32 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] Various fixes
Message-ID: <876f773e-ef60-1ad6-c631-00c67e5dfec0@xs4all.nl>
Date: Mon, 4 Dec 2017 13:09:27 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The usual set of fixes, cleanups and small enhancements.

Regards,

	Hans

The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:

  media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.16b

for you to fetch changes up to 7ca70cd3b7828df33fc85abc36c5ec924ea6b2e5:

  cx23885: Handle return value of kasprintf (2017-12-04 12:53:14 +0100)

----------------------------------------------------------------
Andy Shevchenko (2):
      media: adv7180: Remove duplicate checks
      media: i2c: adv748x: Remove duplicate NULL check

Arnd Bergmann (1):
      solo6x10: hide unused variable

Arvind Yadav (2):
      hdpvr: Fix an error handling path in hdpvr_probe()
      cx23885: Handle return value of kasprintf

Colin Ian King (4):
      tuners: mxl5005s: make arrays static const, reduces object code size
      cxusb: pass buf as a const u8 * pointer and make buf static const
      pt3: remove redundant assignment to mask
      drivers/media/pci/zoran: remove redundant assignment to pointer h

Dan Carpenter (1):
      stk-webcam: Fix use after free on disconnect

Hans Verkuil (2):
      adv7604.c: add missing return
      cec-adap: add '0x' prefix when printing status

Ian Jamison (1):
      media: imx: Remove incorrect check for queue state in start/stop_streaming

Joe Perches (2):
      gspca: Convert PERR to gspca_err
      gspca: Convert PDEBUG to gspca_dbg

Jérémy Lefaure (1):
      media: use ARRAY_SIZE

Kieran Bingham (2):
      media: i2c: adv748x: Store the pixel rate ctrl on CSI objects
      media: vsp1: Prevent suspending and resuming DRM pipelines

Romain Reignier (1):
      media: cx231xx: Add support for The Imaging Source DFG/USB2pro

Srishti Sharma (2):
      Staging: media: omap4iss: Use WARN_ON() instead of BUG_ON().
      Staging: media: imx: Prefer using BIT macro

Stanimir Varbanov (1):
      venus: venc: set correctly GOP size and number of B-frames

 drivers/media/cec/cec-adap.c                     |   2 +-
 drivers/media/common/saa7146/saa7146_video.c     |   9 ++-
 drivers/media/dvb-frontends/cxd2841er.c          |   7 +--
 drivers/media/i2c/adv7180.c                      |  12 ++--
 drivers/media/i2c/adv748x/adv748x-afe.c          |   1 +
 drivers/media/i2c/adv748x/adv748x-core.c         |   6 +-
 drivers/media/i2c/adv748x/adv748x-csi2.c         |  13 +++--
 drivers/media/i2c/adv748x/adv748x.h              |   1 +
 drivers/media/i2c/adv7604.c                      |   1 +
 drivers/media/pci/cx23885/cx23885-input.c        |  15 ++++-
 drivers/media/pci/pt3/pt3_i2c.c                  |   1 -
 drivers/media/pci/saa7146/hexium_gemini.c        |   3 +-
 drivers/media/pci/saa7146/hexium_orion.c         |   3 +-
 drivers/media/pci/saa7146/mxb.c                  |   3 +-
 drivers/media/pci/solo6x10/solo6x10-gpio.c       |   2 +
 drivers/media/pci/zoran/videocodec.c             |   1 -
 drivers/media/platform/qcom/venus/venc.c         |  15 +++--
 drivers/media/platform/qcom/venus/venc_ctrls.c   |  59 +++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_drv.c           |  16 +++++-
 drivers/media/tuners/mxl5005s.c                  |  17 ++++--
 drivers/media/usb/cx231xx/cx231xx-cards.c        |  28 ++++++++++
 drivers/media/usb/cx231xx/cx231xx.h              |   1 +
 drivers/media/usb/dvb-usb/cxusb.c                |   8 ++-
 drivers/media/usb/dvb-usb/friio-fe.c             |   5 +-
 drivers/media/usb/gspca/autogain_functions.c     |  16 +++---
 drivers/media/usb/gspca/benq.c                   |   8 +--
 drivers/media/usb/gspca/conex.c                  |  13 +++--
 drivers/media/usb/gspca/cpia1.c                  |  74 ++++++++++++------------
 drivers/media/usb/gspca/dtcs033.c                |  28 +++++-----
 drivers/media/usb/gspca/etoms.c                  |  38 ++++++-------
 drivers/media/usb/gspca/finepix.c                |   4 +-
 drivers/media/usb/gspca/gl860/gl860.c            |  37 ++++++------
 drivers/media/usb/gspca/gspca.c                  | 153 +++++++++++++++++++++++++++-----------------------
 drivers/media/usb/gspca/gspca.h                  |   9 +--
 drivers/media/usb/gspca/jeilinj.c                |  19 ++++---
 drivers/media/usb/gspca/jl2005bcd.c              |  45 ++++++++-------
 drivers/media/usb/gspca/kinect.c                 |  11 ++--
 drivers/media/usb/gspca/konica.c                 |  28 +++++-----
 drivers/media/usb/gspca/m5602/m5602_core.c       |  34 +++++------
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c    |  21 +++----
 drivers/media/usb/gspca/m5602/m5602_ov7660.c     |  11 ++--
 drivers/media/usb/gspca/m5602/m5602_ov9650.c     |  26 ++++-----
 drivers/media/usb/gspca/m5602/m5602_po1030.c     |  27 ++++-----
 drivers/media/usb/gspca/m5602/m5602_s5k4aa.c     |  16 +++---
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c     |   2 +-
 drivers/media/usb/gspca/mars.c                   |   4 +-
 drivers/media/usb/gspca/mr97310a.c               |  29 +++++-----
 drivers/media/usb/gspca/nw80x.c                  |  24 ++++----
 drivers/media/usb/gspca/ov519.c                  | 155 +++++++++++++++++++++++++++------------------------
 drivers/media/usb/gspca/ov534.c                  |  25 +++++----
 drivers/media/usb/gspca/ov534_9.c                |  23 ++++----
 drivers/media/usb/gspca/pac207.c                 |  16 +++---
 drivers/media/usb/gspca/pac7302.c                |   2 +-
 drivers/media/usb/gspca/pac7311.c                |   2 +-
 drivers/media/usb/gspca/pac_common.h             |   7 +--
 drivers/media/usb/gspca/sn9c2028.c               |  34 +++++------
 drivers/media/usb/gspca/sn9c2028.h               |   7 +--
 drivers/media/usb/gspca/sn9c20x.c                |   2 +-
 drivers/media/usb/gspca/sonixj.c                 |  58 +++++++++----------
 drivers/media/usb/gspca/spca1528.c               |  17 +++---
 drivers/media/usb/gspca/spca500.c                |  66 +++++++++++-----------
 drivers/media/usb/gspca/spca501.c                |  10 ++--
 drivers/media/usb/gspca/spca505.c                |   6 +-
 drivers/media/usb/gspca/spca506.c                |  16 +++---
 drivers/media/usb/gspca/spca508.c                |  20 ++++---
 drivers/media/usb/gspca/spca561.c                |  20 ++-----
 drivers/media/usb/gspca/sq905.c                  |  16 +++---
 drivers/media/usb/gspca/sq905c.c                 |  37 ++++++------
 drivers/media/usb/gspca/sq930x.c                 |  29 +++++-----
 drivers/media/usb/gspca/stk014.c                 |   6 +-
 drivers/media/usb/gspca/stk1135.c                |  15 ++---
 drivers/media/usb/gspca/stv0680.c                |  36 ++++++------
 drivers/media/usb/gspca/stv06xx/stv06xx.c        |  74 ++++++++++++------------
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c   |  10 ++--
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  23 +++++---
 drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c |   2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c |  16 +++---
 drivers/media/usb/gspca/sunplus.c                |  36 ++++++------
 drivers/media/usb/gspca/t613.c                   |  24 ++++----
 drivers/media/usb/gspca/topro.c                  |   6 +-
 drivers/media/usb/gspca/touptek.c                |  89 +++++++++++++++--------------
 drivers/media/usb/gspca/vc032x.c                 |  51 +++++++++--------
 drivers/media/usb/gspca/w996Xcf.c                |   9 +--
 drivers/media/usb/gspca/xirlink_cit.c            |  32 ++++++-----
 drivers/media/usb/gspca/zc3xx.c                  |  83 ++++++++++++++-------------
 drivers/media/usb/hdpvr/hdpvr-core.c             |  26 +++++----
 drivers/media/usb/stkwebcam/stk-webcam.c         |   2 +-
 drivers/staging/media/imx/imx-media-capture.c    |   6 --
 drivers/staging/media/imx/imx-media.h            |  16 +++---
 drivers/staging/media/omap4iss/iss.c             |   2 +-
 90 files changed, 1114 insertions(+), 924 deletions(-)
