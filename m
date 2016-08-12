Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56613 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbcHLHqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 03:46:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 87B7A1800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 09:46:07 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Remove tw686x-kh, sh_mobile_csi2 and s5p-tv
Message-ID: <6cebd1f6-5b97-1a90-e373-e5fc0a8986ca@xs4all.nl>
Date: Fri, 12 Aug 2016 09:46:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Spring cleaning...

The new rcar-vin driver needs a bit more work before the old soc-camera driver
can be removed, so that soc-camera driver is not included in this pull request.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git deldrvs

for you to fetch changes up to bc06be8818ce2700020500bbff6c56ac91815627:

  s5p-tv: remove obsolete driver (2016-08-12 09:41:06 +0200)

----------------------------------------------------------------
Hans Verkuil (3):
      tw686x-kh: remove obsolete driver
      soc-camera/sh_mobile_csi2: remove unused driver
      s5p-tv: remove obsolete driver

 MAINTAINERS                                              |    8 -
 drivers/gpu/drm/exynos/Kconfig                           |    3 +-
 drivers/media/platform/Kconfig                           |    1 -
 drivers/media/platform/Makefile                          |    1 -
 drivers/media/platform/s5p-tv/Kconfig                    |   88 ----
 drivers/media/platform/s5p-tv/Makefile                   |   19 -
 drivers/media/platform/s5p-tv/hdmi_drv.c                 | 1059 ---------------------------------------
 drivers/media/platform/s5p-tv/hdmiphy_drv.c              |  324 ------------
 drivers/media/platform/s5p-tv/mixer.h                    |  364 --------------
 drivers/media/platform/s5p-tv/mixer_drv.c                |  527 --------------------
 drivers/media/platform/s5p-tv/mixer_grp_layer.c          |  270 ----------
 drivers/media/platform/s5p-tv/mixer_reg.c                |  551 --------------------
 drivers/media/platform/s5p-tv/mixer_video.c              | 1130 ------------------------------------------
 drivers/media/platform/s5p-tv/mixer_vp_layer.c           |  242 ---------
 drivers/media/platform/s5p-tv/regs-hdmi.h                |  146 ------
 drivers/media/platform/s5p-tv/regs-mixer.h               |  122 -----
 drivers/media/platform/s5p-tv/regs-sdo.h                 |   63 ---
 drivers/media/platform/s5p-tv/regs-vp.h                  |   88 ----
 drivers/media/platform/s5p-tv/sdo_drv.c                  |  497 -------------------
 drivers/media/platform/s5p-tv/sii9234_drv.c              |  407 ---------------
 drivers/media/platform/soc_camera/Kconfig                |    7 -
 drivers/media/platform/soc_camera/Makefile               |    1 -
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  229 +--------
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       |  400 ---------------
 drivers/staging/media/Kconfig                            |    2 -
 drivers/staging/media/Makefile                           |    1 -
 drivers/staging/media/tw686x-kh/Kconfig                  |   17 -
 drivers/staging/media/tw686x-kh/Makefile                 |    3 -
 drivers/staging/media/tw686x-kh/TODO                     |    6 -
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c         |  140 ------
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h         |  103 ----
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c        |  813 ------------------------------
 drivers/staging/media/tw686x-kh/tw686x-kh.h              |  117 -----
 include/media/drv-intf/sh_mobile_ceu.h                   |    1 -
 include/media/drv-intf/sh_mobile_csi2.h                  |   48 --
 35 files changed, 11 insertions(+), 7787 deletions(-)
 delete mode 100644 drivers/media/platform/s5p-tv/Kconfig
 delete mode 100644 drivers/media/platform/s5p-tv/Makefile
 delete mode 100644 drivers/media/platform/s5p-tv/hdmi_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/hdmiphy_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer.h
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_grp_layer.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_reg.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_video.c
 delete mode 100644 drivers/media/platform/s5p-tv/mixer_vp_layer.c
 delete mode 100644 drivers/media/platform/s5p-tv/regs-hdmi.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-mixer.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-sdo.h
 delete mode 100644 drivers/media/platform/s5p-tv/regs-vp.h
 delete mode 100644 drivers/media/platform/s5p-tv/sdo_drv.c
 delete mode 100644 drivers/media/platform/s5p-tv/sii9234_drv.c
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
 delete mode 100644 drivers/staging/media/tw686x-kh/Kconfig
 delete mode 100644 drivers/staging/media/tw686x-kh/Makefile
 delete mode 100644 drivers/staging/media/tw686x-kh/TODO
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-core.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-video.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh.h
 delete mode 100644 include/media/drv-intf/sh_mobile_csi2.h
