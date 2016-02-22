Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53861 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbcBVWJ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 17:09:26 -0500
Received: from axis700.grange ([87.79.174.200]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MRXzM-1aN5fI1j7A-00SjAu for
 <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 23:09:24 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 064A613EC9
	for <linux-media@vger.kernel.org>; Mon, 22 Feb 2016 23:09:23 +0100 (CET)
Date: Mon, 22 Feb 2016 23:09:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera + generic V4L for 4.6 #2
Message-ID: <Pine.LNX.4.64.1602222220210.15093@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the second set of patches for 4.6 from me. It contains several 
soc-camera enhancements, a re-submittion of the Z16, Y8I and Y12I formats 
- this time with documentation, and a cosmetic patch from me, improving 
function naming. Sorry, I only sent that patch recently to the list. If it 
is somehow wrong, let me know, I'll regenerate the pull request or you can 
drop it yourself, but actually it should be low-risk.

The following changes since commit f7b5dff0b59b20469b2a4889e6170c0069d37c8d:

  [media] media: Use all bits of an enumeration (2016-02-19 11:45:03 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.6-2

for you to fetch changes up to ac2b970c099acf224303b4184c50e330f5140258:

  V4L2: fix a confusing function name (2016-02-21 17:43:16 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      mx3_camera: use %pad format string for dma_ddr_t

Aviv Greenberg (1):
      UVC: Add support for R200 depth camera.

Guennadi Liakhovetski (2):
      V4L: add Y12I, Y8I and Z16 pixel format documentation
      V4L: fix a confusing function name

Guenter Roeck (1):
      atmel-isi: Fix bad usage of IS_ERR_VALUE

Koji Matsuoka (1):
      soc_camera: rcar_vin: Add ARGB8888 caputre format support

Robert Jarzmik (4):
      pxa_camera: fix the buffer free path
      pxa_camera: move interrupt to tasklet
      pxa_camera: trivial move of dma irq functions
      pxa_camera: conversion to dmaengine

 Documentation/DocBook/media/v4l/pixfmt-y12i.xml |  49 +++
 Documentation/DocBook/media/v4l/pixfmt-y8i.xml  |  80 ++++
 Documentation/DocBook/media/v4l/pixfmt-z16.xml  |  81 ++++
 Documentation/DocBook/media/v4l/pixfmt.xml      |  10 +
 drivers/media/platform/soc_camera/Kconfig       |   1 +
 drivers/media/platform/soc_camera/atmel-isi.c   |   4 +-
 drivers/media/platform/soc_camera/mx3_camera.c  |  12 +-
 drivers/media/platform/soc_camera/pxa_camera.c  | 478 +++++++++++-------------
 drivers/media/platform/soc_camera/rcar_vin.c    |  39 +-
 drivers/media/usb/uvc/uvc_driver.c              |  20 +
 drivers/media/usb/uvc/uvcvideo.h                |  12 +
 drivers/media/v4l2-core/videobuf-core.c         |  10 +-
 include/uapi/linux/videodev2.h                  |   3 +
 13 files changed, 517 insertions(+), 282 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y12i.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y8i.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-z16.xml

Thanks
Guennadi
