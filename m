Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47296 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbcFBHVO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jun 2016 03:21:14 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 75EF7180B7D
	for <linux-media@vger.kernel.org>; Thu,  2 Jun 2016 09:21:09 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.8] Remove deprecated drivers
Message-ID: <574FDE65.5080206@xs4all.nl>
Date: Thu, 2 Jun 2016 09:21:09 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Speaks for itself.

Regards,

	Hans

The following changes since commit 6a2cf60b3e6341a3163d3cac3f4bede126c2e894:

  Merge tag 'v4.7-rc1' into patchwork (2016-05-30 18:16:14 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.8a

for you to fetch changes up to f57b08d9fd0dee6f087e6333f55520e4fe2281f7:

  staging/media: remove deprecated timb driver (2016-06-02 09:10:58 +0200)

----------------------------------------------------------------
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
 drivers/staging/media/mx2/mx2_camera.c     | 1636 ---------------------------------------------------------------------------
 drivers/staging/media/mx3/Kconfig          |   15 -
 drivers/staging/media/mx3/Makefile         |    3 -
 drivers/staging/media/mx3/TODO             |   10 -
 drivers/staging/media/mx3/mx3_camera.c     | 1264 ----------------------------------------------------------
 drivers/staging/media/omap1/Kconfig        |   13 -
 drivers/staging/media/omap1/Makefile       |    3 -
 drivers/staging/media/omap1/TODO           |    8 -
 drivers/staging/media/omap1/omap1_camera.c | 1702 ------------------------------------------------------------------------------
 drivers/staging/media/timb/Kconfig         |   11 -
 drivers/staging/media/timb/Makefile        |    1 -
 drivers/staging/media/timb/timblogiw.c     |  870 ----------------------------------------
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
