Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2J0UmK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:10 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg9qB004779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:10 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 28/68] [media] cx231xx-avcore: get rid of a sophisticated do-nothing code
Date: Sat, 27 Oct 2012 18:40:46 -0200
Message-Id: <1351370486-29040-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/cx231xx/cx231xx-avcore.c: In function 'cx231xx_capture_start':
drivers/media/usb/cx231xx/cx231xx-avcore.c:2637:3: warning: suggest braces around empty body in an 'else' statement [-Wempty-body]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index d34dbcf..7222079 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2631,11 +2631,6 @@ int cx231xx_capture_start(struct cx231xx *dev, int start, u8 media_type)
 			rc = cx231xx_stop_stream(dev, ep_mask);
 	}
 
-	if (dev->mode == CX231XX_ANALOG_MODE)
-		;/* do any in Analog mode */
-	else
-		;/* do any in digital mode */
-
 	return rc;
 }
 EXPORT_SYMBOL_GPL(cx231xx_capture_start);
-- 
1.7.11.7

