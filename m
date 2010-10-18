Return-path: <mchehab@pedra>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:17201 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933126Ab0JRVIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 17:08:17 -0400
From: Daniel Drake <dsd@laptop.org>
To: corbet@lwn.net
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH] ov7670: fix QVGA visible area
Message-Id: <20101018210736.D41009D401B@zog.reactivated.net>
Date: Mon, 18 Oct 2010 22:07:36 +0100 (BST)
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The QVGA mode has a green horizontal line on the left hand side, and a red
(or sometimes blue) vertical line at the bottom. Tweak the visible area
to remove them.

Thanks to Mauro for explaining how to fix this.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/ov7670.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index a18dcd0..0b78f33 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -675,10 +675,10 @@ static struct ov7670_win_size {
 		.width		= QVGA_WIDTH,
 		.height		= QVGA_HEIGHT,
 		.com7_bit	= COM7_FMT_QVGA,
-		.hstart		= 164,		/* Empirically determined */
-		.hstop		=  20,
-		.vstart		=  14,
-		.vstop		= 494,
+		.hstart		= 168,		/* Empirically determined */
+		.hstop		=  24,
+		.vstart		=  12,
+		.vstop		= 492,
 		.regs 		= NULL,
 	},
 	/* QCIF */
-- 
1.7.2.3

