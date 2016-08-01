Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:34111 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbcHAHym (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 03:54:42 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 0B2C51800F2
	for <linux-media@vger.kernel.org>; Mon,  1 Aug 2016 09:54:25 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Remove tw686x-kh, soc-camera/rcar-vin and soc-camera/sh_mobile_csi2
Date: Mon,  1 Aug 2016 09:54:22 +0200
Message-Id: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove these three obsolete drivers: the first two have replacement drivers
with the same functionality, the last driver is unused.

Regards,

	Hans

Hans Verkuil (3):
  tw686x-kh: remove obsolete driver
  soc-camera/rcar-vin: remove obsolete driver
  soc-camera/sh_mobile_csi2: remove unused driver

 drivers/media/platform/soc_camera/Kconfig          |   17 -
 drivers/media/platform/soc_camera/Makefile         |    2 -
 drivers/media/platform/soc_camera/rcar_vin.c       | 1970 --------------------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  229 +--
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  400 ----
 drivers/staging/media/Kconfig                      |    2 -
 drivers/staging/media/Makefile                     |    1 -
 drivers/staging/media/tw686x-kh/Kconfig            |   17 -
 drivers/staging/media/tw686x-kh/Makefile           |    3 -
 drivers/staging/media/tw686x-kh/TODO               |    6 -
 drivers/staging/media/tw686x-kh/tw686x-kh-core.c   |  140 --
 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h   |  103 -
 drivers/staging/media/tw686x-kh/tw686x-kh-video.c  |  813 --------
 drivers/staging/media/tw686x-kh/tw686x-kh.h        |  117 --
 include/media/drv-intf/sh_mobile_ceu.h             |    1 -
 include/media/drv-intf/sh_mobile_csi2.h            |   48 -
 16 files changed, 10 insertions(+), 3859 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/rcar_vin.c
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
 delete mode 100644 drivers/staging/media/tw686x-kh/Kconfig
 delete mode 100644 drivers/staging/media/tw686x-kh/Makefile
 delete mode 100644 drivers/staging/media/tw686x-kh/TODO
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-core.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-regs.h
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh-video.c
 delete mode 100644 drivers/staging/media/tw686x-kh/tw686x-kh.h
 delete mode 100644 include/media/drv-intf/sh_mobile_csi2.h

-- 
2.8.1

