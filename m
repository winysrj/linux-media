Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab2HESQf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Aug 2012 14:16:35 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q75IGY7Z012220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 5 Aug 2012 14:16:35 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] dvb core: remove support for post FE legacy ioctl intercept
Date: Sun,  5 Aug 2012 15:16:29 -0300
Message-Id: <1344190590-10863-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
References: <1344190590-10863-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This DVB_FE_IOCTL_POST isn't used, so remove it.

Also, intercepting ioctl's like that only works with legacy ioctl's,
due to the way it was implemented. so this design is broken.
Document it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c | 7 -------
 drivers/media/dvb/dvb-core/dvbdev.h       | 9 ++-------
 drivers/media/dvb/dvb-usb-v2/mxl111sf.c   | 4 ----
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index aebcdf2..746dfd8 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -2287,13 +2287,6 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 		break;
 	};
 
-	if (fe->dvb->fe_ioctl_override) {
-		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
-						    DVB_FE_IOCTL_POST);
-		if (cb_err < 0)
-			return cb_err;
-	}
-
 	return err;
 }
 
diff --git a/drivers/media/dvb/dvb-core/dvbdev.h b/drivers/media/dvb/dvb-core/dvbdev.h
index fcc6ae9..3b2c137 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.h
+++ b/drivers/media/dvb/dvb-core/dvbdev.h
@@ -76,7 +76,6 @@ struct dvb_adapter {
 	 * after the core handles an ioctl:
 	 *
 	 * DVB_FE_IOCTL_PRE indicates that the ioctl has not yet been handled.
-	 * DVB_FE_IOCTL_POST indicates that the ioctl has been handled.
 	 *
 	 * When DVB_FE_IOCTL_PRE is passed to the callback as the stage arg:
 	 *
@@ -86,14 +85,10 @@ struct dvb_adapter {
 	 * return a negative int to prevent dvb-core from handling the ioctl,
 	 * 	and return that value as an error.
 	 *
-	 * When DVB_FE_IOCTL_POST is passed to the callback as the stage arg:
-	 *
-	 * return 0 to allow the dvb_frontend ioctl handler to exit normally.
-	 * return a negative int to cause the dvb_frontend ioctl handler to
-	 * 	return that value as an error.
+	 * WARNING: Don't use it on newer drivers: this only affects DVBv3
+	 * calls, and should be removed soon.
 	 */
 #define DVB_FE_IOCTL_PRE 0
-#define DVB_FE_IOCTL_POST 1
 	int (*fe_ioctl_override)(struct dvb_frontend *fe,
 				 unsigned int cmd, void *parg,
 				 unsigned int stage);
diff --git a/drivers/media/dvb/dvb-usb-v2/mxl111sf.c b/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
index 1fb017e..861e0ae 100644
--- a/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/dvb/dvb-usb-v2/mxl111sf.c
@@ -898,10 +898,6 @@ static int mxl111sf_fe_ioctl_override(struct dvb_frontend *fe,
 			break;
 		}
 		break;
-
-	case DVB_FE_IOCTL_POST:
-		/* no post-ioctl handling required */
-		break;
 	}
 	return err;
 };
-- 
1.7.11.2

