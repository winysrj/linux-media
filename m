Return-path: <mchehab@pedra>
Received: from mtain02-winn.ispmail.ntl.com ([81.103.221.42]:42939 "EHLO
	mtain02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759651Ab0JHVEX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Oct 2010 17:04:23 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] ov7670: disable QVGA mode
Message-Id: <20101008210418.2B1809D401C@zog.reactivated.net>
Date: Fri,  8 Oct 2010 22:04:18 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Capturing at this resolution results in an ugly green horizontal line
at the left side of the image. Disable until fixed.

http://dev.laptop.org/ticket/10231

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 7017e5c..9fffcdd 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -672,7 +672,9 @@ static struct ov7670_win_size {
 		.vstop		= 494,
 		.regs 		= NULL,
 	},
-	/* QVGA */
+#if 0
+	/* QVGA - disabled due to ugly green line.
+	 * http://dev.laptop.org/ticket/10231 */
 	{
 		.width		= QVGA_WIDTH,
 		.height		= QVGA_HEIGHT,
@@ -683,6 +685,7 @@ static struct ov7670_win_size {
 		.vstop		= 494,
 		.regs 		= NULL,
 	},
+#endif
 #if 0
 	/* QCIF - disabled because it only shows a small portion of sensor FOV */
 	{
-- 
1.7.2.3

