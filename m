Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38309 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaC2QLX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:11:23 -0400
Subject: [PATCH 07/11] dib0700: NEC scancode cleanup
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:11:21 +0100
Message-ID: <20140329161121.13234.30213.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

the RC RX packet is defined as:

        struct dib0700_rc_response {
		...
                                u8 not_system;
                                u8 system;
		...
                u8 data;
                u8 not_data;

The NEC protocol transmits in the order:
        system
        not_system
        data
        not_data

Note that the code defines the NEC extended scancode as:

        scancode = be16_to_cpu(poll_reply->system16) << 8 | poll_reply->data;

i.e.

        scancode = poll_reply->not_system << 16 |
                   poll_reply->system     << 8  |
                   poll_reply->data;

Which, if the order *is* reversed, would mean that the scancode that
gets defined is in reality:

        scancode = poll_reply->system     << 16 |
                   poll_reply->not_system << 8  |
                   poll_reply->data;

Which is the same as the order used in drivers/media/rc/ir-nec-decoder.c.

This patch changes the code to match my assumption (the generated scancode
should, however, not change).

Signed-off-by: David Härdeman <david@hardeman.nu>
CC: Patrick Boettcher <pboettcher@kernellabs.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 6afe7ea..4f5caf5 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -658,13 +658,8 @@ out:
 struct dib0700_rc_response {
 	u8 report_id;
 	u8 data_state;
-	union {
-		u16 system16;
-		struct {
-			u8 not_system;
-			u8 system;
-		};
-	};
+	u8 system;
+	u8 not_system;
 	u8 data;
 	u8 not_data;
 };
@@ -712,20 +707,27 @@ static void dib0700_rc_urb_completion(struct urb *purb)
 		toggle = 0;
 
 		/* NEC protocol sends repeat code as 0 0 0 FF */
-		if ((poll_reply->system == 0x00) && (poll_reply->data == 0x00)
-		    && (poll_reply->not_data == 0xff)) {
+		if (poll_reply->system     == 0x00 &&
+		    poll_reply->not_system == 0x00 &&
+		    poll_reply->data       == 0x00 &&
+		    poll_reply->not_data   == 0xff) {
 			poll_reply->data_state = 2;
 			break;
 		}
 
-		if ((poll_reply->system ^ poll_reply->not_system) != 0xff) {
+		if (poll_reply->data ^ poll_reply->not_data != 0xff) {
+			deb_data("NEC32 protocol\n");
+			scancode = RC_SCANCODE_NEC32(poll_reply->system     << 24 |
+						     poll_reply->not_system << 16 |
+						     poll_reply->data       << 8  |
+						     poll_reply->not_data);
+		} else if (poll_reply->system ^ poll_reply->not_system != 0xff) {
 			deb_data("NEC extended protocol\n");
-			/* NEC extended code - 24 bits */
-			scancode = RC_SCANCODE_NECX(be16_to_cpu(poll_reply->system16),
+			scancode = RC_SCANCODE_NECX(poll_reply->system << 8 |
+						    poll_reply->not_system,
 						    poll_reply->data);
 		} else {
 			deb_data("NEC normal protocol\n");
-			/* normal NEC code - 16 bits */
 			scancode = RC_SCANCODE_NEC(poll_reply->system,
 						   poll_reply->data);
 		}

