Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42961 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2GZJgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 05:36:54 -0400
Received: by wgbdr13 with SMTP id dr13so1629115wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2012 02:36:52 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: "[PULL] video_visstrim for 3.6"
Date: Thu, 26 Jul 2012 11:36:44 +0200
Message-Id: <1343295404-8931-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
this pull request is composed of two series that provide support for two mem2mem devices:
- 'm2m-deinterlace' video deinterlacer
- 'coda video codec'
I've included platform support for them too.


The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  https://github.com/jmartinc/video_visstrim.git for_3.6

for you to fetch changes up to 9bb10266da63ae7f8f198573e099580e9f98f4e8:

  i.MX27: Visstrim_M10: Add support for deinterlacing driver. (2012-07-26 10:57:30 +0200)

----------------------------------------------------------------
Javier Martin (5):
      i.MX: coda: Add platform support for coda in i.MX27.
      media: coda: Add driver for Coda video codec.
      Visstrim M10: Add support for Coda.
      media: Add mem2mem deinterlacing driver.
      i.MX27: Visstrim_M10: Add support for deinterlacing driver.

 arch/arm/mach-imx/clk-imx27.c                   |    4 +-
 arch/arm/mach-imx/devices-imx27.h               |    4 +
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c     |   49 +-
 arch/arm/plat-mxc/devices/Kconfig               |    6 +-
 arch/arm/plat-mxc/devices/Makefile              |    1 +
 arch/arm/plat-mxc/devices/platform-imx27-coda.c |   37 +
 arch/arm/plat-mxc/include/mach/devices-common.h |    8 +
 drivers/media/video/Kconfig                     |   17 +
 drivers/media/video/Makefile                    |    3 +
 drivers/media/video/coda.c                      | 1848 +++++++++++++++++++++++
 drivers/media/video/coda.h                      |  216 +++
 drivers/media/video/m2m-deinterlace.c           | 1119 ++++++++++++++
 12 files changed, 3305 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm/plat-mxc/devices/platform-imx27-coda.c
 create mode 100644 drivers/media/video/coda.c
 create mode 100644 drivers/media/video/coda.h
 create mode 100644 drivers/media/video/m2m-deinterlace.c

Thanks,
Javier.
