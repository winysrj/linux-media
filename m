Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab2J0UoO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:44:14 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKiDmH006597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:44:13 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 37/68] [media] gscpa: get rid of warning: suggest braces around empty body
Date: Sat, 27 Oct 2012 18:40:55 -0200
Message-Id: <1351370486-29040-38-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are hundreds of messages like this one, when GSPCA debug is
disabled, when compiled with W=1:
drivers/media/usb/gspca/spca500.c:725:46: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
Get rid of it, especially as it might actually cause troubles on
some places.

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/gspca/gspca.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index e3eab82..352317d 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -32,7 +32,7 @@ do {								\
 #define D_USBO 0x00
 #define D_V4L2 0x0100
 #else
-#define PDEBUG(level, fmt, ...)
+#define PDEBUG(level, fmt, ...) do {} while(0)
 #endif
 
 #define GSPCA_MAX_FRAMES 16	/* maximum number of video frame buffers */
-- 
1.7.11.7

