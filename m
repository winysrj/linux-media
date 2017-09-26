Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:48471 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968064AbdIZUXy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:23:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] ir-ctl: show scancode lirc features
Date: Tue, 26 Sep 2017 21:23:49 +0100
Message-Id: <20170926202352.10276-2-sean@mess.org>
In-Reply-To: <20170926202352.10276-1-sean@mess.org>
References: <20170926202352.10276-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Report if a lirc devices can receive or send using scancodes.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 7dcdd983..32d7162f 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -691,7 +691,12 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			fprintf(stderr, _("warning: %s: unexpected error while retrieving resolution: %m\n"), dev);
 	}
 
+	bool can_receive = false;
 	printf(_("Receive features %s:\n"), dev);
+	if (features & LIRC_CAN_REC_SCANCODE) {
+		printf(_(" - Device can receive scancodes\n"));
+		can_receive = true;
+	}
 	if (features & LIRC_CAN_REC_MODE2) {
 		printf(_(" - Device can receive raw IR\n"));
 		if (resolution)
@@ -721,13 +726,22 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			if (min_timeout || max_timeout)
 				printf(_(" - Can set recording timeout min:%u microseconds max:%u microseconds\n"), min_timeout, max_timeout);
 		}
-	} else if (features & LIRC_CAN_REC_LIRCCODE) {
+		can_receive = true;
+	}
+	if (features & LIRC_CAN_REC_LIRCCODE) {
 		printf(_(" - Device can receive using device dependent LIRCCODE mode (not supported)\n"));
-	} else {
-		printf(_(" - Device cannot receive\n"));
+		can_receive = true;
 	}
 
+	if (!can_receive)
+		printf(_(" - Device cannot receive\n"));
+
+	bool can_send = false;
 	printf(_("Send features %s:\n"), dev);
+	if (features & LIRC_CAN_SEND_SCANCODE) {
+		printf(_(" - Device can send scancodes\n"));
+		can_send = true;
+	}
 	if (features & LIRC_CAN_SEND_PULSE) {
 		printf(_(" - Device can send raw IR\n"));
 		if (features & LIRC_CAN_SET_SEND_CARRIER)
@@ -744,11 +758,15 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			else
 				printf(_(" - Set transmitter (%d available)\n"), rc);
 		}
-	} else if (features & LIRC_CAN_SEND_LIRCCODE) {
+		can_send = true;
+	}
+	if (features & LIRC_CAN_SEND_LIRCCODE) {
 		printf(_(" - Device can send using device dependent LIRCCODE mode (not supported)\n"));
-	} else {
-		printf(_(" - Device cannot send\n"));
+		can_send = true;
 	}
+
+	if (!can_send)
+		printf(_(" - Device cannot send\n"));
 }
 
 static int lirc_send(struct arguments *args, int fd, unsigned features, struct file *f)
-- 
2.13.5
