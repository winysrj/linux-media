Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45314 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbcFBHS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2016 03:18:59 -0400
Received: from durdane.fritz.box (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 119FA180B7D
	for <linux-media@vger.kernel.org>; Thu,  2 Jun 2016 09:18:53 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/4] Remove deprecated drivers
Date: Thu,  2 Jun 2016 09:18:48 +0200
Message-Id: <1464851932-17915-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove deprecated drivers from staging/media.

Regards,

	Hans

Hans Verkuil (4):
  staging/media: remove deprecated mx2 driver
  staging/media: remove deprecated mx3 driver
  staging/media: remove deprecated omap1 driver
  staging/media: remove deprecated timb driver

 drivers/staging/media/Kconfig              |    8 -
 drivers/staging/media/Makefile             |    4 -
 drivers/staging/media/mx2/Kconfig          |   15 -
 drivers/staging/media/mx2/Makefile         |    3 -
 drivers/staging/media/mx2/TODO             |   10 -
 drivers/staging/media/mx2/mx2_camera.c     | 1636 --------------------------
 drivers/staging/media/mx3/Kconfig          |   15 -
 drivers/staging/media/mx3/Makefile         |    3 -
 drivers/staging/media/mx3/TODO             |   10 -
 drivers/staging/media/mx3/mx3_camera.c     | 1264 ---------------------
 drivers/staging/media/omap1/Kconfig        |   13 -
 drivers/staging/media/omap1/Makefile       |    3 -
 drivers/staging/media/omap1/TODO           |    8 -
 drivers/staging/media/omap1/omap1_camera.c | 1702 ----------------------------
 drivers/staging/media/timb/Kconfig         |   11 -
 drivers/staging/media/timb/Makefile        |    1 -
 drivers/staging/media/timb/timblogiw.c     |  870 --------------
 17 files changed, 5576 deletions(-)
 delete mode 100644 drivers/staging/media/mx2/Kconfig
 delete mode 100644 drivers/staging/media/mx2/Makefile
 delete mode 100644 drivers/staging/media/mx2/TODO
 delete mode 100644 drivers/staging/media/mx2/mx2_camera.c
 delete mode 100644 drivers/staging/media/mx3/Kconfig
 delete mode 100644 drivers/staging/media/mx3/Makefile
 delete mode 100644 drivers/staging/media/mx3/TODO
 delete mode 100644 drivers/staging/media/mx3/mx3_camera.c
 delete mode 100644 drivers/staging/media/omap1/Kconfig
 delete mode 100644 drivers/staging/media/omap1/Makefile
 delete mode 100644 drivers/staging/media/omap1/TODO
 delete mode 100644 drivers/staging/media/omap1/omap1_camera.c
 delete mode 100644 drivers/staging/media/timb/Kconfig
 delete mode 100644 drivers/staging/media/timb/Makefile
 delete mode 100644 drivers/staging/media/timb/timblogiw.c

-- 
2.8.1

