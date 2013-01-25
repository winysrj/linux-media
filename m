Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60615 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3AYXGy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 18:06:54 -0500
Received: from mailout-de.gmx.net ([10.1.76.35]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LsMyM-1V0vDA3vs8-011x46 for
 <linux-media@vger.kernel.org>; Sat, 26 Jan 2013 00:06:52 +0100
From: Peter Huewe <peterhuewe@gmx.de>
To: Ben Collins <bcollins@bluecherry.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Huewe <peterhuewe@gmx.de>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/media/solo6x10: Use PTR_RET rather than if(IS_ERR(...)) + PTR_ERR
Date: Sat, 26 Jan 2013 00:10:12 +0100
Message-Id: <1359155412-2080-1-git-send-email-peterhuewe@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found with coccicheck.

The semantic patch that makes this change is available
in scripts/coccinelle/api/ptr_ret.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/media/solo6x10/v4l2.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 571c3a3..ca774cc 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -415,10 +415,7 @@ static int solo_start_thread(struct solo_filehandle *fh)
 {
 	fh->kthread = kthread_run(solo_thread, fh, SOLO6X10_NAME "_disp");
 
-	if (IS_ERR(fh->kthread))
-		return PTR_ERR(fh->kthread);
-
-	return 0;
+	return PTR_RET(fh->kthread);
 }
 
 static void solo_stop_thread(struct solo_filehandle *fh)
-- 
1.7.8.6

