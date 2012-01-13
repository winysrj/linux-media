Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62949 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab2AMK0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 05:26:05 -0500
Received: by wibhm14 with SMTP id hm14so237239wib.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jan 2012 02:26:04 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [GIT PATCHES FOR 3.3] mx2 emma-prp mem2mem driver
Date: Fri, 13 Jan 2012 11:25:45 +0100
Message-Id: <1326450345-14477-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:
  Mauro Carvalho Chehab (1):
        [media] [PATCH] don't reset the delivery system on DTV_CLEAR

are available in the git repository at:

  git://github.com/jmartinc/video_visstrim.git for_v3.3

Javier Martin (2):
      MEM2MEM: Add support for eMMa-PrP mem2mem operations.
      MX2: Add platform definitions for eMMa-PrP device.

 arch/arm/mach-imx/clock-imx27.c                 |    2 +-
 arch/arm/mach-imx/devices-imx27.h               |    2 +
 arch/arm/plat-mxc/devices/platform-mx2-camera.c |   18 +
 arch/arm/plat-mxc/include/mach/devices-common.h |    2 +
 drivers/media/video/Kconfig                     |   10 +
 drivers/media/video/Makefile                    |    2 +
 drivers/media/video/mx2_emmaprp.c               | 1008 +++++++++++++++++++++++
 7 files changed, 1043 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/mx2_emmaprp.c
