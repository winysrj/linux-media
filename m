Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1LFNFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 08:05:07 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH] [media] tm6000: Fix fast USB access quirk
Date: Tue,  6 Dec 2011 14:05:03 +0100
Message-Id: <1323176703-11305-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <4EDE09B7.9010103@redhat.com>
References: <4EDE09B7.9010103@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original patch used the fast USB quirk to enable fast access to
registers in the tm6000_read_write_usb(). The applied patch moved the
check to the tm6000_reset(), probably due to some merge conflicts.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/media/video/tm6000/tm6000-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/video/tm6000/tm6000-core.c
index 59dd63d..5a10bf3 100644
--- a/drivers/media/video/tm6000/tm6000-core.c
+++ b/drivers/media/video/tm6000/tm6000-core.c
@@ -88,7 +88,9 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 req_type, u8 req,
 	}
 
 	kfree(data);
-	msleep(5);
+
+	if ((dev->quirks & TM6000_QUIRK_NO_USB_DELAY) == 0)
+		msleep(5);
 
 	mutex_unlock(&dev->usb_lock);
 	return ret;
-- 
1.7.8

