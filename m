Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33705 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751924AbdHCVmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 17:42:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] ir-ctl: lirc resolution is in microseconds
Date: Thu,  3 Aug 2017 22:42:30 +0100
Message-Id: <20170803214231.9334-4-sean@mess.org>
In-Reply-To: <20170803214231.9334-1-sean@mess.org>
References: <20170803214231.9334-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 562a05da..e7275989 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -689,7 +689,7 @@ static void lirc_features(struct arguments *args, int fd, unsigned features)
 	if (features & LIRC_CAN_REC_MODE2) {
 		printf(_(" - Device can receive raw IR\n"));
 		if (resolution)
-			printf(_(" - Resolution %u nanoseconds\n"), resolution);
+			printf(_(" - Resolution %u microseconds\n"), resolution);
 		if (features & LIRC_CAN_SET_REC_CARRIER)
 			printf(_(" - Set receive carrier\n"));
 		if (features & LIRC_CAN_USE_WIDEBAND_RECEIVER)
-- 
2.11.0
