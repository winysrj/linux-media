Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2HNJsb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 05:48:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7E9mVgJ020444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 05:48:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] media/usb: fix compilation for pure dvb usb drivers
Date: Tue, 14 Aug 2012 06:48:27 -0300
Message-Id: <1344937707-15588-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344917565-22396-3-git-send-email-mchehab@redhat.com>
References: <1344917565-22396-3-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch shold be fold with "rename most media/video usb drivers to media/usb"
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 2719198..069a3c1 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -35,7 +35,7 @@ source "drivers/media/usb/tm6000/Kconfig"
 endif
 
 
-if MEDIA_USB_DRIVERS && I2C && MEDIA_DIGITAL_TV_SUPPORT
+if I2C && MEDIA_DIGITAL_TV_SUPPORT
 	comment "Digital TV USB devices"
 source "drivers/media/usb/dvb-usb/Kconfig"
 source "drivers/media/usb/dvb-usb-v2/Kconfig"
-- 
1.7.11.2

