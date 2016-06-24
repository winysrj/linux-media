Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/19] usbvision: remove some unused vars
Date: Fri, 24 Jun 2016 12:31:42 -0300
Message-Id: <d69bb093a79e77955e05616c5158291c9a306e95.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 6.1 warns about some unused vars. Remove them:

drivers/media/usb/usbvision/usbvision-core.c:94:18: warning: 'min_imgheight' defined but not used [-Wunused-const-variable=]
 static const int min_imgheight = MIN_FRAME_HEIGHT;
                  ^~~~~~~~~~~~~
drivers/media/usb/usbvision/usbvision-core.c:93:18: warning: 'min_imgwidth' defined but not used [-Wunused-const-variable=]
 static const int min_imgwidth = MIN_FRAME_WIDTH;
                  ^~~~~~~~~~~~
drivers/media/usb/usbvision/usbvision-core.c:92:18: warning: 'max_imgheight' defined but not used [-Wunused-const-variable=]
 static const int max_imgheight = MAX_FRAME_HEIGHT;
                  ^~~~~~~~~~~~~
drivers/media/usb/usbvision/usbvision-core.c:91:18: warning: 'max_imgwidth' defined but not used [-Wunused-const-variable=]
 static const int max_imgwidth = MAX_FRAME_WIDTH;
                  ^~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/usbvision/usbvision-core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
index 1ea04e75fb36..52ac4391582c 100644
--- a/drivers/media/usb/usbvision/usbvision-core.c
+++ b/drivers/media/usb/usbvision/usbvision-core.c
@@ -88,11 +88,6 @@ MODULE_PARM_DESC(adjust_y_offset, "adjust Y offset display [core]");
 #define DBG_SCRATCH	(1 << 4)
 #define DBG_FUNC	(1 << 5)
 
-static const int max_imgwidth = MAX_FRAME_WIDTH;
-static const int max_imgheight = MAX_FRAME_HEIGHT;
-static const int min_imgwidth = MIN_FRAME_WIDTH;
-static const int min_imgheight = MIN_FRAME_HEIGHT;
-
 /* The value of 'scratch_buf_size' affects quality of the picture
  * in many ways. Shorter buffers may cause loss of data when client
  * is too slow. Larger buffers are memory-consuming and take longer
-- 
2.7.4


