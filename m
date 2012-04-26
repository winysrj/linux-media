Return-path: <linux-media-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:39984 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759178Ab2DZUH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 16:07:28 -0400
From: Chris Ball <cjb@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"
Date: Thu, 26 Apr 2012 16:07:51 -0400
Message-ID: <87d36u9rzc.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes:

drivers/built-in.o: In function `mcam_v4l_open':
/drivers/media/video/marvell-ccic/mcam-core.c:1565: undefined reference to `vb2_vmalloc_memops'

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: stable <stable@vger.kernel.org>
---
 drivers/media/video/marvell-ccic/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index bf739e3..2086b87 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -15,6 +15,7 @@ config VIDEO_MMP_CAMERA
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_VMALLOC
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
