Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37738 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932426AbcIALEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2016 07:04:39 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Tina Ruchandani <ruchandani.tina@gmail.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] rc/streamzap: fix spelling mistake "sumbiting" -> "submitting"
Date: Thu,  1 Sep 2016 12:03:14 +0100
Message-Id: <20160901110314.27139-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/rc/streamzap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 815243c..4004260 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -499,7 +499,7 @@ static int streamzap_resume(struct usb_interface *intf)
 	struct streamzap_ir *sz = usb_get_intfdata(intf);
 
 	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC)) {
-		dev_err(sz->dev, "Error sumbiting urb\n");
+		dev_err(sz->dev, "Error submitting urb\n");
 		return -EIO;
 	}
 
-- 
2.9.3

