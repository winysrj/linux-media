Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4155 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDQJXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:23:01 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3H9MwoA087211
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 11:23:00 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B077F2A0410
	for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 11:22:52 +0200 (CEST)
Message-ID: <534F9D6C.2080102@xs4all.nl>
Date: Thu, 17 Apr 2014 11:22:52 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] vb fixes: stop_streaming should return void
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 701b57ee3387b8e3749845b02310b5625fbd8da0:

  [media] vb2: Add videobuf2-dvb support (2014-04-16 18:59:29 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16b

for you to fetch changes up to faaec8bdaceac06587c95df4f71159b2c6f8ed01:

  vb2: fix compiler warning (2014-04-17 08:17:08 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      vb2: stop_streaming should return void
      bfin_capture: drop unnecessary vb2_is_streaming check.
      vb2: fix compiler warning

 Documentation/video4linux/v4l2-pci-skeleton.c            |  3 +--
 drivers/media/pci/sta2x11/sta2x11_vip.c                  |  3 +--
 drivers/media/platform/blackfin/bfin_capture.c           |  6 +-----
 drivers/media/platform/coda.c                            |  4 +---
 drivers/media/platform/davinci/vpbe_display.c            |  5 ++---
 drivers/media/platform/davinci/vpif_capture.c            |  6 ++----
 drivers/media/platform/davinci/vpif_display.c            |  6 ++----
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |  4 +---
 drivers/media/platform/exynos4-is/fimc-capture.c         |  6 +++---
 drivers/media/platform/exynos4-is/fimc-isp-video.c       |  5 ++---
 drivers/media/platform/exynos4-is/fimc-lite.c            |  6 +++---
 drivers/media/platform/exynos4-is/fimc-m2m.c             |  3 +--
 drivers/media/platform/marvell-ccic/mcam-core.c          |  7 +++----
 drivers/media/platform/mem2mem_testdev.c                 |  5 ++---
 drivers/media/platform/s3c-camif/camif-capture.c         |  4 ++--
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |  4 +---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             |  3 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             |  3 +--
 drivers/media/platform/s5p-tv/mixer_video.c              |  3 +--
 drivers/media/platform/soc_camera/atmel-isi.c            |  6 ++----
 drivers/media/platform/soc_camera/mx2_camera.c           |  4 +---
 drivers/media/platform/soc_camera/mx3_camera.c           |  4 +---
 drivers/media/platform/soc_camera/rcar_vin.c             |  4 +---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  4 ++--
 drivers/media/platform/vivi.c                            |  3 +--
 drivers/media/platform/vsp1/vsp1_video.c                 |  4 +---
 drivers/media/usb/em28xx/em28xx-v4l.h                    |  2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |  8 ++------
 drivers/media/usb/pwc/pwc-if.c                           |  7 ++-----
 drivers/media/usb/s2255/s2255drv.c                       |  5 ++---
 drivers/media/usb/stk1160/stk1160-v4l.c                  |  4 ++--
 drivers/media/usb/usbtv/usbtv-video.c                    |  9 +++------
 drivers/media/v4l2-core/videobuf2-core.c                 |  4 ++--
 drivers/staging/media/davinci_vpfe/vpfe_video.c          |  3 +--
 drivers/staging/media/dt3155v4l/dt3155v4l.c              |  3 +--
 drivers/staging/media/go7007/go7007-v4l2.c               |  3 +--
 drivers/staging/media/msi3101/sdr-msi3101.c              | 24 ++++++++----------------
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c         |  7 ++-----
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c       |  3 +--
 drivers/staging/media/solo6x10/solo6x10-v4l2.c           |  3 +--
 include/media/videobuf2-core.h                           |  2 +-
 41 files changed, 70 insertions(+), 132 deletions(-)
