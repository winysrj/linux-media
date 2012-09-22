Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50215 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab2IVQwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 12:52:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] anysee: do not remove CI when it is not attached
Date: Sat, 22 Sep 2012 19:51:40 +0300
Message-Id: <1348332700-10267-5-git-send-email-crope@iki.fi>
In-Reply-To: <1348332700-10267-1-git-send-email-crope@iki.fi>
References: <1348332700-10267-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 8 ++++----
 drivers/media/usb/dvb-usb-v2/anysee.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 6705d81..ec540140 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1217,6 +1217,8 @@ static int anysee_ci_init(struct dvb_usb_device *d)
 	if (ret)
 		return ret;
 
+	state->ci_attached = true;
+
 	return 0;
 }
 
@@ -1225,7 +1227,7 @@ static void anysee_ci_release(struct dvb_usb_device *d)
 	struct anysee_state *state = d_to_priv(d);
 
 	/* detach CI */
-	if (state->has_ci)
+	if (state->ci_attached)
 		dvb_ca_en50221_release(&state->ci);
 
 	return;
@@ -1257,10 +1259,8 @@ static int anysee_init(struct dvb_usb_device *d)
 	/* attach CI */
 	if (state->has_ci) {
 		ret = anysee_ci_init(d);
-		if (ret) {
-			state->has_ci = false;
+		if (ret)
 			return ret;
-		}
 	}
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index 4ab4676..c1a4273 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -56,6 +56,7 @@ struct anysee_state {
 	u8 seq;
 	u8 fe_id:1; /* frondend ID */
 	u8 has_ci:1;
+	u8 ci_attached:1;
 	struct dvb_ca_en50221 ci;
 	unsigned long ci_cam_ready; /* jiffies */
 };
-- 
1.7.11.4

