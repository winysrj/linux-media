Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53427 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751918AbdHCVmd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 17:42:33 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] ir-ctl: "ir-ctl -S rc6_mce:0x800f0410" does not work on 32-bit
Date: Thu,  3 Aug 2017 22:42:29 +0100
Message-Id: <20170803214231.9334-3-sean@mess.org>
In-Reply-To: <20170803214231.9334-1-sean@mess.org>
References: <20170803214231.9334-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

0x800f0410 does not fit in 32-bit signed long.

Signed-off-by: Sean Young <sean@mess.org>
---
 utils/ir-ctl/ir-ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index 3d66063a..562a05da 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -152,7 +152,7 @@ static int strtoint(const char *p, const char *unit)
 static bool strtoscancode(const char *p, unsigned *ret)
 {
 	char *end;
-	long arg = strtol(p, &end, 0);
+	long long arg = strtoll(p, &end, 0);
 	if (end == NULL || end[0] != 0)
 		return false;
 
-- 
2.11.0
