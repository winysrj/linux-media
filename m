Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48714 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933825Ab2J3QEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 12:04:33 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so292654wgb.1
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 09:04:31 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@redhat.com, corbet@lwn.net,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: ov7670: Allow 32x maximum gain for yuv422.
Date: Tue, 30 Oct 2012 17:04:23 +0100
Message-Id: <1351613063-19076-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

4x gain ceiling is not enough to capture a decent image in conditions
of total darkness and only a LED light source. Allow a maximum gain
of 32x instead.

This doesn't have any drawback since the image quality in 'normal'
light conditions is the same.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/ov7670.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 5faa3d8..2ea9c51 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -366,7 +366,7 @@ static struct regval_list ov7670_fmt_yuv422[] = {
 	{ REG_RGB444, 0 },	/* No RGB444 please */
 	{ REG_COM1, 0 },	/* CCIR601 */
 	{ REG_COM15, COM15_R00FF },
-	{ REG_COM9, 0x18 }, /* 4x gain ceiling; 0x8 is reserved bit */
+	{ REG_COM9, 0x48 }, /* 32x gain ceiling; 0x8 is reserved bit */
 	{ 0x4f, 0x80 }, 	/* "matrix coefficient 1" */
 	{ 0x50, 0x80 }, 	/* "matrix coefficient 2" */
 	{ 0x51, 0    },		/* vb */
-- 
1.7.9.5

