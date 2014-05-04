Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:63351 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaEDCJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 22:09:48 -0400
From: Jonathan McCrohan <jmccrohan@gmail.com>
To: linux-media@vger.kernel.org,
	pkg-vdr-dvb-devel@lists.alioth.debian.org
Cc: Jonathan McCrohan <jmccrohan@gmail.com>
Subject: [PATCH 3/6] [dvb-apps] dvb-apps: make zap flush stdout after status line
Date: Sun,  4 May 2014 02:51:18 +0100
Message-Id: <1399168281-20626-4-git-send-email-jmccrohan@gmail.com>
In-Reply-To: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
References: <1399168281-20626-1-git-send-email-jmccrohan@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bug-Debian: http://bugs.debian.org/357126

Signed-off-by: Jonathan McCrohan <jmccrohan@gmail.com>
---
 util/szap/czap.c | 3 ++-
 util/szap/szap.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/util/szap/czap.c b/util/szap/czap.c
index f49c524..062545f 100644
--- a/util/szap/czap.c
+++ b/util/szap/czap.c
@@ -227,9 +227,10 @@ int monitor_frontend (int fe_fd, int human_readable)
 		if (status & FE_HAS_LOCK)
 			printf("FE_HAS_LOCK");
 
-		usleep(1000000);
 
 		printf("\n");
+		fflush(stdout);
+		usleep(1000000);
 
 		if (exit_after_tuning && (status & FE_HAS_LOCK))
 			break;
diff --git a/util/szap/szap.c b/util/szap/szap.c
index 90bdbfb..12f393c 100644
--- a/util/szap/szap.c
+++ b/util/szap/szap.c
@@ -204,6 +204,7 @@ static int monitor_frontend (int fe_fd, int dvr, int human_readable)
 		if (exit_after_tuning && ((status & FE_HAS_LOCK) || (++timeout >= 10)))
 			break;
 
+		fflush(stdout);
 		usleep(1000000);
 	} while (1);
 
-- 
1.9.2

