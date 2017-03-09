Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35685 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752887AbdCIWvJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 17:51:09 -0500
From: simran singhal <singhalsimran0@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: [PATCH v1 1/7] staging: gc2235: Remove unnecessary typecast of c90 int constant
Date: Fri, 10 Mar 2017 04:20:23 +0530
Message-Id: <1489099829-1264-2-git-send-email-singhalsimran0@gmail.com>
In-Reply-To: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
References: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes unnecessary typecast of c90 int constant.

WARNING: Unnecessary typecast of c90 int constant

Signed-off-by: simran singhal <singhalsimran0@gmail.com>
---
 drivers/staging/media/atomisp/i2c/gc2235.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc2235.c b/drivers/staging/media/atomisp/i2c/gc2235.c
index 3dd5e7f..3f2b11ec 100644
--- a/drivers/staging/media/atomisp/i2c/gc2235.c
+++ b/drivers/staging/media/atomisp/i2c/gc2235.c
@@ -706,10 +706,10 @@ static int distance(struct gc2235_resolution *res, u32 w, u32 h)
 	h_ratio = ((res->height << 13) / h);
 	if (h_ratio == 0)
 		return -1;
-	match   = abs(((w_ratio << 13) / h_ratio) - ((int)8192));
+	match   = abs(((w_ratio << 13) / h_ratio) - 8192);
 
-	if ((w_ratio < (int)8192) || (h_ratio < (int)8192)  ||
-		(match > LARGEST_ALLOWED_RATIO_MISMATCH))
+	if ((w_ratio < 8192) || (h_ratio < 8192)  ||
+	    (match > LARGEST_ALLOWED_RATIO_MISMATCH))
 		return -1;
 
 	return w_ratio + h_ratio;
-- 
2.7.4
