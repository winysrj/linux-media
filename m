Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3KQNv7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 08:51:59 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] radio-shark2: Mark shark_resume_leds() inline to kill compiler warning
Date: Sun, 17 Nov 2013 14:51:56 +0100
Message-Id: <1384696316-17003-1-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This mirrors the patch to the radio-shark driver by Geert Uytterhoeven.

If SHARK_USE_LEDS=1, but CONFIG_PM=n:

drivers/media/radio/radio-shark2.c:240: warning: ‘shark_resume_leds’ defined but not used

Instead of making the #ifdef logic even more complicated (there are already
two definitions of shark_resume_leds()), mark shark_resume_leds() inline to
kill the compiler warning. shark_resume_leds() is small and it has only one
caller.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 9fb6697..8654e0d 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -237,7 +237,7 @@ static void shark_unregister_leds(struct shark_device *shark)
 	cancel_work_sync(&shark->led_work);
 }
 
-static void shark_resume_leds(struct shark_device *shark)
+static inline void shark_resume_leds(struct shark_device *shark)
 {
 	int i;
 
-- 
1.8.4.2

