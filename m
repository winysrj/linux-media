Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50610 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2KELji (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 06:39:38 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/2] staging/media: Fix trailing statements should be on next line in go7007/go7007-fw.c
Date: Mon,  5 Nov 2012 20:39:33 +0900
Message-Id: <1352115573-8321-1-git-send-email-yamanetoshi@gmail.com>
In-Reply-To: <1352115526-8287-1-git-send-email-yamanetoshi@gmail.com>
References: <1352115526-8287-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fixed below checkpatch error.
- ERROR: trailing statements should be on next line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/go7007/go7007-fw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index f99c05b..cfce760 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -725,7 +725,8 @@ static int vti_bitlen(struct go7007 *go)
 {
 	unsigned int i, max_time_incr = go->sensor_framerate / go->fps_scale;
 
-	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i);
+	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
+		;
 	return i + 1;
 }
 
-- 
1.7.9.5

