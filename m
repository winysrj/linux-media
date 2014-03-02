Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48677 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751370AbaCBPjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Mar 2014 10:39:21 -0500
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:102:7fc9::80:2])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5CC866008E
	for <linux-media@vger.kernel.org>; Sun,  2 Mar 2014 17:39:19 +0200 (EET)
Date: Sun, 2 Mar 2014 17:38:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.15] Fix buffer timestamp documentation, add new
 timestamp flags
Message-ID: <20140302153846.GL15635@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the long overdue timestamp flag patchset. Buffers are stamped at
frame end now by default, and a new timestamp source buffer flag mask is
introduced. Some fixes to a few mem2mem drivers are also included.

Changes since the review: fix documentation build in io.xml in the last
patch; xref linkend tag was missing the final slash ("/"); it's now there.

Please pull.


The following changes since commit a06b429df49bb50ec1e671123a45147a1d1a6186:

  [media] au0828: rework GPIO management for HVR-950q (2014-02-28 15:21:31 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git timestamp-buf-ready

for you to fetch changes up to 98ff8bb775df6f5990a56ac90f0957670a1991a5:

  v4l: Document timestamp buffer flag behaviour (2014-03-02 17:31:38 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      vb2: fix timecode and flags handling for output buffers

Sakari Ailus (10):
      v4l: Document timestamp behaviour to correspond to reality
      v4l: Use full 32 bits for buffer flags
      v4l: Rename vb2_queue.timestamp_type as timestamp_flags
      v4l: Timestamp flags will soon contain timestamp source, not just type
      v4l: Add timestamp source flags, mask and document them
      v4l: Handle buffer timestamp flags correctly
      uvcvideo: Tell the user space we're using start-of-exposure timestamps
      exynos-gsc, m2m-deinterlace, mx2_emmaprp: Copy v4l2_buffer data from src to dst
      v4l: Copy timestamp source flags to destination on m2m devices
      v4l: Document timestamp buffer flag behaviour

 Documentation/DocBook/media/v4l/io.xml             |  124 ++++++++++----------
 drivers/media/parport/bw-qcam.c                    |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c     |    2 +-
 drivers/media/platform/coda.c                      |    7 +-
 drivers/media/platform/davinci/vpbe_display.c      |    2 +-
 drivers/media/platform/davinci/vpif_capture.c      |    2 +-
 drivers/media/platform/davinci/vpif_display.c      |    2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   12 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |    2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |    7 +-
 drivers/media/platform/m2m-deinterlace.c           |   11 +-
 drivers/media/platform/mem2mem_testdev.c           |    7 +-
 drivers/media/platform/mx2_emmaprp.c               |   13 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |    2 +-
 drivers/media/platform/s5p-g2d/g2d.c               |    7 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |    7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    9 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |    2 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |    2 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/ti-vpe/vpe.c                |    6 +-
 drivers/media/platform/vivi.c                      |    2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |    2 +-
 drivers/media/usb/em28xx/em28xx-video.c            |    4 +-
 drivers/media/usb/pwc/pwc-if.c                     |    2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |    2 +-
 drivers/media/usb/usbtv/usbtv-video.c              |    2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |    3 +-
 drivers/media/v4l2-core/videobuf2-core.c           |   64 +++++++++-
 include/media/videobuf2-core.h                     |    4 +-
 include/uapi/linux/videodev2.h                     |   42 ++++---
 34 files changed, 236 insertions(+), 127 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
