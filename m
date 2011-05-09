Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:1083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1EIKc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 06:32:29 -0400
From: Huzaifa Sidhpurwala <huzaifas@redhat.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hverkuil@xs4all.nl, hdegoede@redhat.com,
	joe@perches.com, Huzaifa Sidhpurwala <huzaifas@redhat.com>
Subject: [PATCH] Prevent null pointer derefernce of pdev
Date: Mon,  9 May 2011 16:02:24 +0530
Message-Id: <1304937144-15806-1-git-send-email-huzaifas@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Make sure pdev is not dereferenced when it is null

Signed-off-by: Huzaifa Sidhpurwala <huzaifas@redhat.com>
---
 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 780af5f..356cd42 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1850,7 +1850,6 @@ static void usb_pwc_disconnect(struct usb_interface *intf)
 	} else {
 		/* Device is closed, so we can safely unregister it */
 		PWC_DEBUG_PROBE("Unregistering video device in disconnect().\n");
-		pwc_cleanup(pdev);
 
 disconnect_out:
 		/* search device_hint[] table if we occupy a slot, by any chance */
@@ -1860,6 +1859,7 @@ disconnect_out:
 	}
 
 	mutex_unlock(&pdev->modlock);
+	pwc_cleanup(pdev);
 }
 
 
-- 
1.7.1

