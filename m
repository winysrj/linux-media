Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:39912 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab2LJVhn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 16:37:43 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 3/9] [media] m920x: factor out a m920x_write_seq() function
Date: Mon, 10 Dec 2012 22:37:11 +0100
Message-Id: <1355175437-21623-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
References: <1352158096-17737-1-git-send-email-ospite@studenti.unina.it>
 <1355175437-21623-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is in preparation for the vp7049 frontend attach function which is
going to set a sequence of registers as well.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/media/usb/dvb-usb/m920x.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 433696d..23416fb 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -63,6 +63,21 @@ static inline int m920x_write(struct usb_device *udev, u8 request,
 	return ret;
 }
 
+static inline int m920x_write_seq(struct usb_device *udev, u8 request,
+				  struct m920x_inits *seq)
+{
+	int ret;
+	while (seq->address) {
+		ret = m920x_write(udev, request, seq->data, seq->address);
+		if (ret != 0)
+			return ret;
+
+		seq++;
+	}
+
+	return ret;
+}
+
 static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 {
 	int ret = 0, i, epi, flags = 0;
@@ -71,15 +86,10 @@ static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 	/* Remote controller init. */
 	if (d->props.rc.legacy.rc_query) {
 		deb("Initialising remote control\n");
-		while (rc_seq->address) {
-			if ((ret = m920x_write(d->udev, M9206_CORE,
-					       rc_seq->data,
-					       rc_seq->address)) != 0) {
-				deb("Initialising remote control failed\n");
-				return ret;
-			}
-
-			rc_seq++;
+		ret = m920x_write_seq(d->udev, M9206_CORE, rc_seq);
+		if (ret != 0) {
+			deb("Initialising remote control failed\n");
+			return ret;
 		}
 
 		deb("Initialising remote control success\n");
-- 
1.7.10.4

