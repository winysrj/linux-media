Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:55482 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbcBPIHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 03:07:55 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id BEEC3180DD7
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 09:07:50 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.6] Two fixes, move timblogiw to staging
Message-ID: <56C2D8D6.9000008@xs4all.nl>
Date: Tue, 16 Feb 2016 09:07:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit f7b4b54e63643b740c598e044874c4bffa0f04f2:

  [media] tvp5150: add HW input connectors support (2016-02-11 11:11:29 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.6d

for you to fetch changes up to f044d49dc5bea0e1c1bc4a6938b6b5a772862fe8:

  saa7134: Fix bytesperline not being set correctly for planar formats (2016-02-16 09:07:04 +0100)

----------------------------------------------------------------
Hans Verkuil (1):
      timblogiw: move to staging in preparation for removal

Hans de Goede (1):
      saa7134: Fix bytesperline not being set correctly for planar formats

Sudip Mukherjee (1):
      media: ti-vpe: add dependency of HAS_DMA

 drivers/media/pci/saa7134/saa7134-video.c                  | 18 ++++++++++++------
 drivers/media/platform/Kconfig                             | 10 +---------
 drivers/media/platform/Makefile                            |  1 -
 drivers/staging/media/Kconfig                              |  2 ++
 drivers/staging/media/Makefile                             |  2 +-
 drivers/staging/media/timb/Kconfig                         | 11 +++++++++++
 drivers/staging/media/timb/Makefile                        |  1 +
 drivers/{media/platform => staging/media/timb}/timblogiw.c |  0
 8 files changed, 28 insertions(+), 17 deletions(-)
 create mode 100644 drivers/staging/media/timb/Kconfig
 create mode 100644 drivers/staging/media/timb/Makefile
 rename drivers/{media/platform => staging/media/timb}/timblogiw.c (100%)
