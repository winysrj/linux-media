Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45585 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001Ab2LCUTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Dec 2012 15:19:22 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:6d9a::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 31DE660099
	for <linux-media@vger.kernel.org>; Mon,  3 Dec 2012 22:19:20 +0200 (EET)
Date: Mon, 3 Dec 2012 22:19:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.9] Monotonic video buffer timestamps
Message-ID: <20121203201918.GO31879@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull request contains monotonic video buffer timestamps and a fix for a
small typo in documentation.

Please pull.


The following changes since commit d8658bca2e5696df2b6c69bc5538f8fe54e4a01e:

  [media] omap3isp: Replace cpu_is_omap3630() with ISP revision check (2012-11-28 10:54:46 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git timestamp-fix-3.9

Sakari Ailus (5):
      v4l: Define video buffer flags for timestamp types
      v4l: Helper function for obtaining timestamps
      v4l: Convert drivers to use monotonic timestamps
      v4l: Tell user space we're using monotonic timestamps
      v4l: There's no __unsigned

 Documentation/DocBook/media/v4l/compat.xml         |   12 ++++
 Documentation/DocBook/media/v4l/io.xml             |   55 +++++++++++++++----
 Documentation/DocBook/media/v4l/v4l2.xml           |   12 ++++-
 drivers/media/common/saa7146/saa7146_fops.c        |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |    6 +-
 drivers/media/pci/cx23885/cx23885-core.c           |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |    2 +-
 drivers/media/pci/cx88/cx88-core.c                 |    2 +-
 drivers/media/pci/meye/meye.c                      |    8 ++--
 drivers/media/pci/saa7134/saa7134-core.c           |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |    2 +-
 drivers/media/pci/zoran/zoran_device.c             |    4 +-
 drivers/media/pci/zoran/zoran_driver.c             |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    4 +-
 drivers/media/platform/davinci/vpfe_capture.c      |    5 +--
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    6 +-
 drivers/media/platform/fsl-viu.c                   |    2 +-
 drivers/media/platform/omap/omap_vout.c            |    2 +-
 drivers/media/platform/omap24xxcam.c               |    2 +-
 drivers/media/platform/omap3isp/ispqueue.c         |    1 +
 drivers/media/platform/sh_vou.c                    |    2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    4 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/timblogiw.c                 |    2 +-
 drivers/media/platform/vino.c                      |   11 +++--
 drivers/media/platform/vivi.c                      |    6 +--
 drivers/media/usb/au0828/au0828-video.c            |    4 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |    2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |    5 ++-
 drivers/media/usb/cx231xx/cx231xx-417.c            |    4 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.c            |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 +-
 drivers/media/usb/pwc/pwc-if.c                     |    3 +-
 drivers/media/usb/s2255/s2255drv.c                 |    6 +--
 drivers/media/usb/sn9c102/sn9c102_core.c           |    5 +-
 drivers/media/usb/stk1160/stk1160-video.c          |    2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |    3 +-
 drivers/media/usb/tlg2300/pd-video.c               |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |    2 +-
 drivers/media/usb/usbvision/usbvision-core.c       |    2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |    5 +-
 drivers/media/usb/zr364xx/zr364xx.c                |    6 +--
 drivers/media/v4l2-core/v4l2-common.c              |   10 ++++
 drivers/media/v4l2-core/videobuf-core.c            |    2 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   10 ++--
 include/media/v4l2-common.h                        |    2 +
 include/uapi/linux/videodev2.h                     |    4 ++
 55 files changed, 166 insertions(+), 95 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
