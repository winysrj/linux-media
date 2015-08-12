Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:42160 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbbHLQDb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 12:03:31 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] v4l2grab: print function name and ioctl number on failure
Date: Wed, 12 Aug 2015 18:56:32 +0300
Message-Id: <3197193698388412798e8c81d8e30d9a393b670f.1439394992.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the failure error message a little more useful.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 contrib/test/v4l2grab.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/contrib/test/v4l2grab.c b/contrib/test/v4l2grab.c
index 3e1be3de6353..778c51cc391a 100644
--- a/contrib/test/v4l2grab.c
+++ b/contrib/test/v4l2grab.c
@@ -43,7 +43,8 @@ static void xioctl(int fh, unsigned long int request, void *arg)
 	} while (r == -1 && ((errno == EINTR) || (errno == EAGAIN)));
 
 	if (r == -1) {
-		fprintf(stderr, "error %d, %s\n", errno, strerror(errno));
+		fprintf(stderr, "%s(%lu): error %d, %s\n", __func__,
+			_IOC_NR(request), errno, strerror(errno));
 		exit(EXIT_FAILURE);
 	}
 }
-- 
2.5.0

