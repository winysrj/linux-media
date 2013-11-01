Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3KAWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Nov 2013 18:41:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/11] radio-shark: remove a warning when CONFIG_PM is not defined
Date: Fri,  1 Nov 2013 17:39:21 -0200
Message-Id: <1383334770-27130-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
References: <1383334770-27130-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On alpha, allyesconfig doesn't have CONFIG_PM, and produces the following warnings:

	/devel/v4l/ktest-build/drivers/media/radio/radio-shark.c:274:13: warning: 'shark_resume_leds' defined but not used [-Wunused-function]
	/devel/v4l/ktest-build/drivers/media/radio/radio-shark2.c:240:13: warning: 'shark_resume_leds' defined but not used [-Wunused-function]

That's because those functions are used only at device resume.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/radio/radio-shark.c  | 2 ++
 drivers/media/radio/radio-shark2.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index b91477212413..3db8a8cfe1a8 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -271,6 +271,7 @@ static void shark_unregister_leds(struct shark_device *shark)
 	cancel_work_sync(&shark->led_work);
 }
 
+#ifdef CONFIG_PM
 static void shark_resume_leds(struct shark_device *shark)
 {
 	if (test_bit(BLUE_IS_PULSE, &shark->brightness_new))
@@ -280,6 +281,7 @@ static void shark_resume_leds(struct shark_device *shark)
 	set_bit(RED_LED, &shark->brightness_new);
 	schedule_work(&shark->led_work);
 }
+#endif
 #else
 static int shark_register_leds(struct shark_device *shark, struct device *dev)
 {
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 9fb669721e66..d86d90dab8bf 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -237,6 +237,7 @@ static void shark_unregister_leds(struct shark_device *shark)
 	cancel_work_sync(&shark->led_work);
 }
 
+#ifdef CONFIG_PM
 static void shark_resume_leds(struct shark_device *shark)
 {
 	int i;
@@ -246,6 +247,7 @@ static void shark_resume_leds(struct shark_device *shark)
 
 	schedule_work(&shark->led_work);
 }
+#endif
 #else
 static int shark_register_leds(struct shark_device *shark, struct device *dev)
 {
-- 
1.8.3.1

