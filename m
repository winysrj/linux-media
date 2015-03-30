Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:34616 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbbC3Uvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 16:51:33 -0400
Subject: [PATCH] rc-core: fix dib0700 scancode generation for RC5
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: david.cimburek@gmail.com, m.chehab@samsung.com
Date: Mon, 30 Mar 2015 22:51:01 +0200
Message-ID: <20150330205101.16848.5180.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit af3a4a9bbeb00df3e42e77240b4cdac5479812f9 cleaned up the NEC
scancode logic but overlooked the RC5 case. This patch brings the
RC5 case in line with the NEC code and makes the struct
self-documenting.

Signed-off-by: David Härdeman <david@hardeman.nu>
Reported-by: David Cimbůrek <david.cimburek@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/usb/dvb-usb/dib0700_core.c |   70 +++++++++++++++++-------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 50856db..605b090 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -658,10 +658,20 @@ out:
 struct dib0700_rc_response {
 	u8 report_id;
 	u8 data_state;
-	u8 system;
-	u8 not_system;
-	u8 data;
-	u8 not_data;
+	union {
+		struct {
+			u8 system;
+			u8 not_system;
+			u8 data;
+			u8 not_data;
+		} nec;
+		struct {
+			u8 not_used;
+			u8 system;
+			u8 data;
+			u8 not_data;
+		} rc5;
+	};
 };
 #define RC_MSG_SIZE_V1_20 6
 
@@ -697,8 +707,8 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 
 	deb_data("IR ID = %02X state = %02X System = %02X %02X Cmd = %02X %02X (len %d)\n",
 		 poll_reply->report_id, poll_reply->data_state,
-		 poll_reply->system, poll_reply->not_system,
-		 poll_reply->data, poll_reply->not_data,
+		 poll_reply->nec.system, poll_reply->nec.not_system,
+		 poll_reply->nec.data, poll_reply->nec.not_data,
 		 purb->actual_length);
 
 	switch (d->props.rc.core.protocol) {
@@ -707,30 +717,30 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
-		if (poll_reply->system     == 0x00 &&
-		    poll_reply->not_system == 0x00 &&
-		    poll_reply->data       == 0x00 &&
-		    poll_reply->not_data   == 0xff) {
+		if (poll_reply->nec.system     == 0x00 &&
+		    poll_reply->nec.not_system == 0x00 &&
+		    poll_reply->nec.data       == 0x00 &&
+		    poll_reply->nec.not_data   == 0xff) {
 			poll_reply->data_state = 2;
 			break;
 		}
 
-		if ((poll_reply->data ^ poll_reply->not_data) != 0xff) {
+		if ((poll_reply->nec.data ^ poll_reply->nec.not_data) != 0xff) {
 			deb_data("NEC32 protocol\n");
-			keycode = RC_SCANCODE_NEC32(poll_reply->system     << 24 |
-						     poll_reply->not_system << 16 |
-						     poll_reply->data       << 8  |
-						     poll_reply->not_data);
-		} else if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
+			keycode = RC_SCANCODE_NEC32(poll_reply->nec.system     << 24 |
+						     poll_reply->nec.not_system << 16 |
+						     poll_reply->nec.data       << 8  |
+						     poll_reply->nec.not_data);
+		} else if ((poll_reply->nec.system ^ poll_reply->nec.not_system) != 0xff) {
 			deb_data("NEC extended protocol\n");
-			keycode = RC_SCANCODE_NECX(poll_reply->system << 8 |
-						    poll_reply->not_system,
-						    poll_reply->data);
+			keycode = RC_SCANCODE_NECX(poll_reply->nec.system << 8 |
+						    poll_reply->nec.not_system,
+						    poll_reply->nec.data);
 
 		} else {
 			deb_data("NEC normal protocol\n");
-			keycode = RC_SCANCODE_NEC(poll_reply->system,
-						   poll_reply->data);
+			keycode = RC_SCANCODE_NEC(poll_reply->nec.system,
+						   poll_reply->nec.data);
 		}
 
 		break;
@@ -738,19 +748,19 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		deb_data("RC5 protocol\n");
 		protocol = RC_TYPE_RC5;
 		toggle = poll_reply->report_id;
-		keycode = RC_SCANCODE_RC5(poll_reply->system, poll_reply->data);
+		keycode = RC_SCANCODE_RC5(poll_reply->rc5.system, poll_reply->rc5.data);
+
+		if ((poll_reply->rc5.data ^ poll_reply->rc5.not_data) != 0xff) {
+			/* Key failed integrity check */
+			err("key failed integrity check: %02x %02x %02x %02x",
+			    poll_reply->rc5.not_used, poll_reply->rc5.system,
+			    poll_reply->rc5.data, poll_reply->rc5.not_data);
+			goto resubmit;
+		}
 
 		break;
 	}
 
-	if ((poll_reply->data + poll_reply->not_data) != 0xff) {
-		/* Key failed integrity check */
-		err("key failed integrity check: %02x %02x %02x %02x",
-		    poll_reply->system,  poll_reply->not_system,
-		    poll_reply->data, poll_reply->not_data);
-		goto resubmit;
-	}
-
 	rc_keydown(d->rc_dev, protocol, keycode, toggle);
 
 resubmit:

