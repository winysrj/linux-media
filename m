Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbbBOWNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 17:13:50 -0500
Subject: [PATCH] CONFIG_VIDEO_DEV needs to be enabled by
 MEDIA_DIGITAL_TV_SUPPORT also
From: David Howells <dhowells@redhat.com>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org
Date: Sun, 15 Feb 2015 22:13:13 +0000
Message-ID: <20150215221313.4844.16785.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_VIDEO_DEV needs to be enabled by MEDIA_DIGITAL_TV_SUPPORT so that DVB
TV receiver drivers can be enabled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 49cd308..52d4a20 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -102,7 +102,7 @@ config MEDIA_CONTROLLER
 config VIDEO_DEV
 	tristate
 	depends on MEDIA_SUPPORT
-	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
+	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
 	default y
 
 config VIDEO_V4L2_SUBDEV_API

