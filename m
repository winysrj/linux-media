Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaCCKII (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:08 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 61/79] [media] drx-j: call ctrl_set_standard even if a standard is powered
Date: Mon,  3 Mar 2014 07:06:55 -0300
Message-Id: <1393841233-24840-62-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modulation and other parameters might have changed. So, better
to call ctrl_set_standard() even if the device is already
powered.

That helps to put the device into a sane state, if something
got wrong on a previous set_frontend call.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7f17cd14839b..b1a7dfeec489 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20213,18 +20213,15 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	default:
 		return -EINVAL;
 	}
-
-	if (standard != state->current_standard || state->powered_up == 0) {
-		/* Set the standard (will be powered up if necessary */
-		result = ctrl_set_standard(demod, &standard);
-		if (result != 0) {
-			pr_err("Failed to set standard! result=%02x\n",
-			       result);
-			return -EINVAL;
-		}
-		state->powered_up = 1;
-		state->current_standard = standard;
+	/* Set the standard (will be powered up if necessary */
+	result = ctrl_set_standard(demod, &standard);
+	if (result != 0) {
+		pr_err("Failed to set standard! result=%02x\n",
+			result);
+		return -EINVAL;
 	}
+	state->powered_up = 1;
+	state->current_standard = standard;
 
 	/* set channel parameters */
 	channel = def_channel;
-- 
1.8.5.3

