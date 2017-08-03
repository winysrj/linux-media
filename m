Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52341 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751930AbdHCVmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 17:42:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] ir-ctl: report LIRCCODE drivers even if we don't supported them
Date: Thu,  3 Aug 2017 22:42:31 +0100
Message-Id: <20170803214231.9334-5-sean@mess.org>
In-Reply-To: <20170803214231.9334-1-sean@mess.org>
References: <20170803214231.9334-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index e7275989..544ad341 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -715,6 +715,8 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			if (min_timeout || max_timeout)
 				printf(_(" - Can set recording timeout min:%u microseconds max:%u microseconds\n"), min_timeout, max_timeout);
 		}
+	} else if (features & LIRC_CAN_REC_LIRCCODE) {
+		printf(_(" - Device can receive using device dependent LIRCCODE mode (not supported)\n"));
 	} else {
 		printf(_(" - Device cannot receive\n"));
 	}
@@ -736,6 +738,8 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 			else
 				printf(_(" - Set transmitter (%d available)\n"), rc);
 		}
+	} else if (features & LIRC_CAN_SEND_LIRCCODE) {
+		printf(_(" - Device can send using device dependent LIRCCODE mode (not supported)\n"));
 	} else {
 		printf(_(" - Device cannot send\n"));
 	}
-- 
2.11.0
