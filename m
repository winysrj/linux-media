Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.176.18]:59866 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3D0FLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Apr 2013 01:11:53 -0400
Received: from smtp8.mail.ru (smtp8.mail.ru [94.100.176.53])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id B811819800D3
	for <linux-media@vger.kernel.org>; Sat, 27 Apr 2013 09:07:05 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] media: coda: Fix compile breakage
Date: Sat, 27 Apr 2013 09:06:38 +0400
Message-Id: <1367039198-28639-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch adds GENERIC_ALLOCATOR, if "coda" is selected.

drivers/built-in.o: In function `coda_remove':
:(.text+0x110634): undefined reference to `gen_pool_free'
drivers/built-in.o: In function `coda_probe':
:(.text+0x1107d4): undefined reference to `of_get_named_gen_pool'
:(.text+0x1108b8): undefined reference to `gen_pool_alloc'
:(.text+0x1108d0): undefined reference to `gen_pool_virt_to_phys'
:(.text+0x110918): undefined reference to `dev_get_gen_pool'

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/media/platform/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 0cbe1ff..414a769 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -145,6 +145,7 @@ config VIDEO_CODA
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select GENERIC_ALLOCATOR
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
-- 
1.8.1.5

