Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45766 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3FQMMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 08:12:22 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00JP9DRXKQ10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jun 2013 13:12:21 +0100 (BST)
Message-id: <51BEFD22.30708@samsung.com>
Date: Mon, 17 Jun 2013 14:12:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [GIT PULL FOR 3.11] Media entity link handling fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes corrections of the media entity links handling and resolves
potential issues when media entity drivers are in different kernel modules. 
It allows to keep all entities that belong to same media graph in correct
state, when one of an entity's driver module gets unloaded.

The following changes since commit dd8c393b3c39f7ebd9ad69ce50cc836773d512b6:

  [media] media: i2c: ths7303: make the pdata as a constant pointer (2013-06-13 11:42:17 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.11-2

for you to fetch changes up to 28521e45c4478b7bc083e445573aacb7d174dd35:

  V4L: Remove all links of the media entity when unregistering subdev (2013-06-17 13:42:22 +0200)

----------------------------------------------------------------
Sakari Ailus (2):
      davinci_vpfe: Clean up media entity after unregistering subdev
      smiapp: Clean up media entity after unregistering subdev

Sylwester Nawrocki (2):
      media: Add a function removing all links of a media entity
      V4L: Remove all links of the media entity when unregistering subdev

 drivers/media/i2c/smiapp/smiapp-core.c             |    2 +-
 drivers/media/media-entity.c                       |   50 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-device.c              |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |    4 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   14 +++---
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    2 +-
 include/media/media-entity.h                       |    3 ++
 9 files changed, 71 insertions(+), 16 deletions(-)

Thanks,
Sylwester
