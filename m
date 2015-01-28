Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:51467 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955AbbA2BwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/7] [media] ARM randconfig fixes
Date: Wed, 28 Jan 2015 22:17:40 +0100
Message-Id: <1422479867-3370921-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is one set of randconfig fixes that I've been carrying in
a local branch for a long time. I have made sure that they are
all still required, but there are others that I have not been
able to reproduce yet, so I will probably send them out once
I get the errors again.

The ones here are all trivial, mostly adding missing dependencies.

Please apply.

Arnd Bergmann (7):
  [media] timberdale: do not select TIMB_DMA
  [media] radio/aimslab: use mdelay instead of udelay
  [media] staging/davinci/vpfe/dm365: add missing dependencies
  [media] siano: fix Kconfig dependencies
  [media] gspca: add INPUT dependency
  [media] marvell-ccic: MMP_CAMERA never worked
  [media] marvell-ccic needs VIDEOBUF2_DMA_SG

 drivers/media/mmc/siano/Kconfig             | 2 ++
 drivers/media/platform/Kconfig              | 6 ++----
 drivers/media/platform/marvell-ccic/Kconfig | 3 ++-
 drivers/media/radio/radio-aimslab.c         | 4 ++--
 drivers/media/usb/gspca/Kconfig             | 1 +
 drivers/media/usb/siano/Kconfig             | 2 ++
 drivers/staging/media/davinci_vpfe/Kconfig  | 2 ++
 7 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.1.0.rc2

