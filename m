Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbZFJToo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 15:44:44 -0400
Message-Id: <200906101944.n5AJiOV9031824@imap1.linux-foundation.org>
Subject: [patch 6/6] tvp514x: try_count off by one
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	roel.kluin@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 10 Jun 2009 12:44:23 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Roel Kluin <roel.kluin@gmail.com>

With `while (try_count-- > 0)' try_count reaches -1 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tvp514x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/tvp514x.c~tvp514x-try_count-off-by-one drivers/media/video/tvp514x.c
--- a/drivers/media/video/tvp514x.c~tvp514x-try_count-off-by-one
+++ a/drivers/media/video/tvp514x.c
@@ -692,7 +692,7 @@ static int ioctl_s_routing(struct v4l2_i
 			break;	/* Input detected */
 	}
 
-	if ((current_std == STD_INVALID) || (try_count <= 0))
+	if ((current_std == STD_INVALID) || (try_count < 0))
 		return -EINVAL;
 
 	decoder->current_std = current_std;
_
