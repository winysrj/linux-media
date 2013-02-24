Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42734 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab3BXWrb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 17:47:31 -0500
Received: by mail-pb0-f50.google.com with SMTP id up1so1323765pbc.37
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2013 14:47:31 -0800 (PST)
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org
Cc: syamsidhardh@gmail.com, tvboxspy@gmail.com, mchehab@redhat.com
Subject: [PATCH] lmedm04: Fix possible NULL pointer dereference
Date: Mon, 25 Feb 2013 04:17:18 +0530
Message-Id: <1361746038-28690-1-git-send-email-s.syam@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for (adap == NULL) has to done before accessing adap.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f30c58c..96804be 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1241,10 +1241,13 @@ static int lme2510_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 		struct usb_data_stream_properties *stream)
 {
 	struct dvb_usb_adapter *adap = fe_to_adap(fe);
-	struct dvb_usb_device *d = adap_to_d(adap);
+	struct dvb_usb_device *d;
 
 	if (adap == NULL)
 		return 0;
+
+	d = adap_to_d(adap);
+
 	/* Turn PID filter on the fly by module option */
 	if (pid_filter == 2) {
 		adap->pid_filtering  = 1;
-- 
1.7.9.5

