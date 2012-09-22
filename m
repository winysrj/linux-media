Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51021 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab2IVQwk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Sep 2012 12:52:40 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/5] dvb_usb_v2: fix error handling for .tuner_attach()
Date: Sat, 22 Sep 2012 19:51:37 +0300
Message-Id: <1348332700-10267-2-git-send-email-crope@iki.fi>
In-Reply-To: <1348332700-10267-1-git-send-email-crope@iki.fi>
References: <1348332700-10267-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fe was not set NULL after it was destroyed in tuner attach fail
error case. Due to that it was destroyed again and Kernel oopsed.

Reported-by: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index f990159..9859d2a 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -612,8 +612,10 @@ err_dvb_unregister_frontend:
 
 err_dvb_frontend_detach:
 	for (i = MAX_NO_OF_FE_PER_ADAP - 1; i >= 0; i--) {
-		if (adap->fe[i])
+		if (adap->fe[i]) {
 			dvb_frontend_detach(adap->fe[i]);
+			adap->fe[i] = NULL;
+		}
 	}
 
 err:
-- 
1.7.11.4

