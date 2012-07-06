Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab2GFNxX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 09:53:23 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q66DrNMs026844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 6 Jul 2012 09:53:23 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] uvc/Kconfig: Fix INPUT/EVDEV dependencies
Date: Fri,  6 Jul 2012 10:53:20 -0300
Message-Id: <1341582800-25760-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USB_VIDEO_CLASS_INPUT_EVDEV should be dependent on the UVC
selection, as otherwise, when UVC is unselected, this dependent
config still appears.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/uvc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/video/uvc/Kconfig
index 6c197da..541c9f1 100644
--- a/drivers/media/video/uvc/Kconfig
+++ b/drivers/media/video/uvc/Kconfig
@@ -10,6 +10,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
+	depends on USB_VIDEO_CLASS
 	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
 	---help---
 	  This option makes USB Video Class devices register an input device
-- 
1.7.10.4

