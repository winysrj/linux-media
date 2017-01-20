Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:52677 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751961AbdATNIk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:08:40 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] [media] rc: remove excessive spaces from error message
Date: Fri, 20 Jan 2017 13:08:36 +0000
Message-Id: <fab7d213f1b89ce1f53cf882854734215ad5055f.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc_core: Loaded IR protocol module ir-jvc-decoder,                      but protocol jvc still not available

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 075d7a9..2424946 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1084,8 +1084,7 @@ static void ir_raw_load_modules(u64 *protocols)
 		if (!(*protocols & proto_names[i].type & ~available))
 			continue;
 
-		pr_err("Loaded IR protocol module %s, \
-		       but protocol %s still not available\n",
+		pr_err("Loaded IR protocol module %s, but protocol %s still not available\n",
 		       proto_names[i].module_name,
 		       proto_names[i].name);
 		*protocols &= ~proto_names[i].type;
-- 
2.9.3

