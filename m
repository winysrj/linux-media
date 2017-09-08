Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:37112 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754832AbdIHOJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 10:09:25 -0400
From: Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: media: omap4iss: Use WARN_ON() instead of BUG_ON().
Date: Fri,  8 Sep 2017 19:38:18 +0530
Message-Id: <1504879698-5855-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use WARN_ON() instead of BUG_ON() to avoid crashing the kernel.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/media/omap4iss/iss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c26c99fd..b1036ba 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -893,7 +893,7 @@ void omap4iss_put(struct iss_device *iss)
 		return;

 	mutex_lock(&iss->iss_mutex);
-	BUG_ON(iss->ref_count == 0);
+	WARN_ON(iss->ref_count == 0);
 	if (--iss->ref_count == 0) {
 		iss_disable_interrupts(iss);
 		/* Reset the ISS if an entity has failed to stop. This is the
--
2.7.4
