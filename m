Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2ILLNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 07:13:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8CBDqfg006326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 07:13:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] au0828, cx231xx: remove dependency for DVB_CAPTURE_DRIVERS
Date: Wed, 12 Sep 2012 08:13:47 -0300
Message-Id: <1347448427-28747-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This symbol got removed by menu reorganization; just depending on
DVB_CORE is enough.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/au0828/Kconfig  | 1 -
 drivers/media/usb/cx231xx/Kconfig | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
index 385e557b..1766c0c 100644
--- a/drivers/media/usb/au0828/Kconfig
+++ b/drivers/media/usb/au0828/Kconfig
@@ -2,7 +2,6 @@
 config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
 	depends on I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2
-	depends on DVB_CAPTURE_DRIVERS
 	select I2C_ALGOBIT
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 77913df..86feeea 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -40,7 +40,7 @@ config VIDEO_CX231XX_ALSA
 
 config VIDEO_CX231XX_DVB
 	tristate "DVB/ATSC Support for Cx231xx based TV cards"
-	depends on VIDEO_CX231XX && DVB_CORE && DVB_CAPTURE_DRIVERS
+	depends on VIDEO_CX231XX && DVB_CORE
 	select VIDEOBUF_DVB
 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.7.11.4

