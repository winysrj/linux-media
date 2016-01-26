Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:51424 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbcAZVrL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 16:47:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] v4l: remove MEDIA_TUNER dependency for VIDEO_TUNER
Date: Tue, 26 Jan 2016 22:46:02 +0100
Message-Id: <1453844772-3395901-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx selects VIDEO_TUNER, which has a dependency on MEDIA_TUNER,
so we get a Kconfig warning if that is disabled:

warning: (VIDEO_PVRUSB2 && VIDEO_USBVISION && VIDEO_GO7007 && VIDEO_AU0828_V4L2 && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)

VIDEO_TUNER does not actually depend on MEDIA_TUNER, and the
dependency does nothing except cause the above warning, so let's
remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/v4l2-core/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9beece00869b..29b3436d0910 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -37,7 +37,6 @@ config VIDEO_PCI_SKELETON
 # Used by drivers that need tuner.ko
 config VIDEO_TUNER
 	tristate
-	depends on MEDIA_TUNER
 
 # Used by drivers that need v4l2-mem2mem.ko
 config V4L2_MEM2MEM_DEV
-- 
2.7.0

