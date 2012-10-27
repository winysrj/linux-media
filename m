Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2J0UmE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:04 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg3Ww019789
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:04 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 60/68] [media] usbvision-core: fix a warning
Date: Sat, 27 Oct 2012 18:41:18 -0200
Message-Id: <1351370486-29040-61-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/usbvision/usbvision-core.c:1749:2: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/usbvision/usbvision.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
index 43cf61f..8a25876 100644
--- a/drivers/media/usb/usbvision/usbvision.h
+++ b/drivers/media/usb/usbvision/usbvision.h
@@ -167,7 +167,7 @@ enum {
 
 /* This macro restricts an int variable to an inclusive range */
 #define RESTRICT_TO_RANGE(v, mi, ma) \
-	{ if ((v) < (mi)) (v) = (mi); else if ((v) > (ma)) (v) = (ma); }
+	{ if (((int)v) < (mi)) (v) = (mi); else if ((v) > (ma)) (v) = (ma); }
 
 /*
  * We use macros to do YUV -> RGB conversion because this is
-- 
1.7.11.7

