Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52920 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1EHXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:21 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 3/8] DVB: call get_property at the end of dtv_property_process_get
Date: Sun,  8 May 2011 23:03:36 +0000
Message-Id: <1304895821-21642-4-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

- Drivers should be able to override properties returned to the user.
- The default values get prefilled from the cache.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 1ac7633..bcb4186 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1196,14 +1196,7 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 				    struct dtv_property *tvp,
 				    struct file *file)
 {
-	int r = 0;
-
-	/* Allow the frontend to validate incoming properties */
-	if (fe->ops.get_property)
-		r = fe->ops.get_property(fe, tvp);
-
-	if (r < 0)
-		return r;
+	int r;
 
 	switch(tvp->cmd) {
 	case DTV_FREQUENCY:
@@ -1323,6 +1316,13 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 		return -EINVAL;
 	}
 
+	/* Allow the frontend to override outgoing properties */
+	if (fe->ops.get_property) {
+		r = fe->ops.get_property(fe, tvp);
+		if (r < 0)
+			return r;
+	}
+
 	dtv_property_dump(tvp);
 
 	return 0;
-- 
1.7.2.5

