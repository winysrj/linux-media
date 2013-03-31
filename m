Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40425 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3CaKMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Mar 2013 06:12:36 -0400
Date: Sun, 31 Mar 2013 12:12:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antonio Ospite <ospite@studenti.unina.it>
Subject: [media] m920x: Fix uninitialized variable warning
Message-ID: <20130331121226.0b0e9e26@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/m920x.c:91:6: warning: "ret" may be used uninitialized in this function [-Wuninitialized]
drivers/media/usb/dvb-usb/m920x.c:70:6: note: "ret" was declared here

This is real, if a remote control has an empty initialization sequence
we would get success or failure randomly.

OTOH the initialization of ret in m920x_init is needless, the function
returns with an error as soon as an error happens, so the last return
can only be a success and we can hard-code 0 there.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>
---
Untested, I don't have the hardware.

 drivers/media/usb/dvb-usb/m920x.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-3.9-rc4.orig/drivers/media/usb/dvb-usb/m920x.c	2013-03-05 10:33:29.497926362 +0100
+++ linux-3.9-rc4/drivers/media/usb/dvb-usb/m920x.c	2013-03-31 11:25:54.009509019 +0200
@@ -67,7 +67,8 @@ static inline int m920x_write(struct usb
 static inline int m920x_write_seq(struct usb_device *udev, u8 request,
 				  struct m920x_inits *seq)
 {
-	int ret;
+	int ret = 0;
+
 	while (seq->address) {
 		ret = m920x_write(udev, request, seq->data, seq->address);
 		if (ret != 0)
@@ -81,7 +82,7 @@ static inline int m920x_write_seq(struct
 
 static int m920x_init(struct dvb_usb_device *d, struct m920x_inits *rc_seq)
 {
-	int ret = 0, i, epi, flags = 0;
+	int ret, i, epi, flags = 0;
 	int adap_enabled[M9206_MAX_ADAPTERS] = { 0 };
 
 	/* Remote controller init. */
@@ -124,7 +125,7 @@ static int m920x_init(struct dvb_usb_dev
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int m920x_init_ep(struct usb_interface *intf)


-- 
Jean Delvare
