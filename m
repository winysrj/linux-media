Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60903 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab3IHAXB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Sep 2013 20:23:01 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, kbuild-all@01.org
Subject: [PATCH 3/3] msi3101: Kconfig select VIDEOBUF2_VMALLOC
Date: Sun,  8 Sep 2013 03:21:51 +0300
Message-Id: <1378599711-26875-4-git-send-email-crope@iki.fi>
In-Reply-To: <1378599711-26875-1-git-send-email-crope@iki.fi>
References: <1378599711-26875-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[linuxtv-media:master 395/499] sdr-msi3101.c:undefined reference to
`vb2_vmalloc_memops'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/msi3101/Kconfig b/drivers/staging/media/msi3101/Kconfig
index b94a95a..76d5bbd 100644
--- a/drivers/staging/media/msi3101/Kconfig
+++ b/drivers/staging/media/msi3101/Kconfig
@@ -1,3 +1,4 @@
 config USB_MSI3101
 	tristate "Mirics MSi3101 SDR Dongle"
 	depends on USB && VIDEO_DEV && VIDEO_V4L2
+        select VIDEOBUF2_VMALLOC
-- 
1.7.11.7

