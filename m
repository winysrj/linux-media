Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:32907 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752472AbeEKIgw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 04:36:52 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Subject: [PATCH 2/3] media: mceusb: add missing break
Date: Fri, 11 May 2018 09:36:49 +0100
Message-Id: <20180511083650.20020-2-sean@mess.org>
In-Reply-To: <20180511083650.20020-1-sean@mess.org>
References: <20180511083650.20020-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fallthrough is not intended here.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 1ca49491abc8..4c0c8008872a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -572,6 +572,7 @@ static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
 			datasize = 1;
 			break;
 		}
+		break;
 	case MCE_CMD_PORT_IR:
 		switch (subcmd) {
 		case MCE_CMD_UNKNOWN:
-- 
2.14.3
