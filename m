Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60844 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2DHXTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2012 19:19:33 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	jrh <jharbestonus@gmail.com>
Subject: [PATCH] media: au0828: Convert BUG_ON to WARN_ONCE
Date: Sun,  8 Apr 2012 18:19:11 -0500
Message-Id: <1333927151-13014-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the mail thread at http://www.mythtv.org/pipermail/mythtv-users/2012-April/331164.html,
a kernel crash is triggered when trying to run mythtv with a HVR950Q tuner.
The crash condition is due to res_free() being called to free something that
has is not reserved. The actual reason for this mismatch of reserve/free is
not known; however, using a BUG_ON rather than a WARN_ON seems unfortunate.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/media/video/au0828/au0828-video.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 0b3e481..5c53e38 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -891,8 +891,13 @@ static int res_locked(struct au0828_dev *dev, unsigned int bit)
 static void res_free(struct au0828_fh *fh, unsigned int bits)
 {
 	struct au0828_dev    *dev = fh->dev;
+	unsigned int bits2 = fh->resources & bits;
 
-	BUG_ON((fh->resources & bits) != bits);
+	if (bits2 != bits) {
+		WARN_ONCE(true, "au0828: Trying to free resource 0x%x"
+			  " without reserving it\n", bits);
+		return;
+	}
 
 	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
-- 
1.7.10

