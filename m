Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:61911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZDFCOy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 22:14:54 -0400
Date: Mon, 6 Apr 2009 06:14:43 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] au0828: fix Kconfig dependance
Message-ID: <20090406021443.GA21068@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this build error:
ERROR: "videobuf_queue_vmalloc_init" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "videobuf_vmalloc_free" [drivers/media/video/au0828/au0828.ko] undefined!
ERROR: "videobuf_to_vmalloc" [drivers/media/video/au0828/au0828.ko] undefined!

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/media/video/au0828/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/au0828/Kconfig b/drivers/media/video/au0828/Kconfig
index 05cdf49..0c3a5ba 100644
--- a/drivers/media/video/au0828/Kconfig
+++ b/drivers/media/video/au0828/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_AU0828
 	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
+	select VIDEOBUF_VMALLOC
 	select DVB_AU8522 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
