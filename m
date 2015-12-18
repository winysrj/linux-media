Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35314 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbbLRNFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 08:05:46 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4/5] staging: media: lirc: place operator on previous line
Date: Fri, 18 Dec 2015 18:35:28 +0530
Message-Id: <1450443929-15305-4-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

checkpatch complains about the logical operator, which should be on the
previous line.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/media/lirc/lirc_parallel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
index e09894d..0156114 100644
--- a/drivers/staging/media/lirc/lirc_parallel.c
+++ b/drivers/staging/media/lirc/lirc_parallel.c
@@ -157,9 +157,9 @@ static unsigned int init_lirc_timer(void)
 			count++;
 		level = newlevel;
 		do_gettimeofday(&now);
-	} while (count < 1000 && (now.tv_sec < tv.tv_sec
-			     || (now.tv_sec == tv.tv_sec
-				 && now.tv_usec < tv.tv_usec)));
+	} while (count < 1000 && (now.tv_sec < tv.tv_sec ||
+				  (now.tv_sec == tv.tv_sec &&
+				   now.tv_usec < tv.tv_usec)));
 
 	timeelapsed = (now.tv_sec + 1 - tv.tv_sec) * 1000000
 		     + (now.tv_usec - tv.tv_usec);
@@ -279,8 +279,8 @@ static void lirc_lirc_irq_handler(void *blah)
 		level = newlevel;
 
 		/* giving up */
-		if (signal > timeout
-		    || (check_pselecd && (in(1) & LP_PSELECD))) {
+		if (signal > timeout ||
+		    (check_pselecd && (in(1) & LP_PSELECD))) {
 			signal = 0;
 			pr_notice("timeout\n");
 			break;
-- 
1.9.1

