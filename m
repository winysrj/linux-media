Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:54519 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752026AbcLBRUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 12:20:23 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 3/6] ir-ctl: 0 is valid scancode
Date: Fri,  2 Dec 2016 17:20:18 +0000
Message-Id: <1480699221-9267-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same for 0xffffffff.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index f19bd05..768daad 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -146,7 +146,7 @@ static bool strtoscancode(const char *p, unsigned *ret)
 	if (end == NULL || end[0] != 0)
 		return false;
 
-	if (arg <= 0 || arg >= 0xffffffff)
+	if (arg < 0 || arg > 0xffffffff)
 		return false;
 
 	*ret = arg;
-- 
2.9.3

