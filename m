Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25483 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2LHMvU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2012 07:51:20 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mchehab@redhat.com
Cc: david@hardeman.nu, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] rc-core: don't return from store_protocols without releasing device mutex
Date: Sat,  8 Dec 2012 07:50:50 -0500
Message-Id: <1354971050-5784-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit c003ab1b ("[media] rc-core: add separate defines for protocol bitmaps
and numbers") has introduced a bug which allows store_protocols() to return
without releasing the device mutex it's holding.

Doing that would cause infinite hangs waiting on device mutex next time
around.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/media/rc/rc-main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 601d1ac1..0510f4d 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -890,7 +890,8 @@ static ssize_t store_protocols(struct device *device,
 
 		if (i == ARRAY_SIZE(proto_names)) {
 			IR_dprintk(1, "Unknown protocol: '%s'\n", tmp);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 
 		count++;
-- 
1.8.0

