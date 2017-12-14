Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55321 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753450AbdLNRWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:01 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 03/10] media: imon: remove unused function tv2int
Date: Thu, 14 Dec 2017 17:21:54 +0000
Message-Id: <555f1d8413f9e8b71878b7ec3fea01f7f8914217.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 9c7fd60e951d ("media: rc: Replace timeval with ktime_t in
imon.c"), the function tv2int() is no longer used. Remove it.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/imon.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6c873a3c4720..950d068ba806 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -1168,29 +1168,6 @@ static int imon_ir_change_protocol(struct rc_dev *rc, u64 *rc_proto)
 	return retval;
 }
 
-static inline int tv2int(const struct timeval *a, const struct timeval *b)
-{
-	int usecs = 0;
-	int sec   = 0;
-
-	if (b->tv_usec > a->tv_usec) {
-		usecs = 1000000;
-		sec--;
-	}
-
-	usecs += a->tv_usec - b->tv_usec;
-
-	sec += a->tv_sec - b->tv_sec;
-	sec *= 1000;
-	usecs /= 1000;
-	sec += usecs;
-
-	if (sec < 0)
-		sec = 1000;
-
-	return sec;
-}
-
 /*
  * The directional pad behaves a bit differently, depending on whether this is
  * one of the older ffdc devices or a newer device. Newer devices appear to
-- 
2.14.3
