Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 02/29] radio-shark: remove a warning when CONFIG_PM is not defined
Date: Sat,  2 Nov 2013 11:31:10 -0200
Message-Id: <1383399097-11615-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On alpha, allyesconfig doesn't have CONFIG_PM, and produces the following warnings:

	drivers/media/radio/radio-shark.c:274:13: warning: 'shark_resume_leds' defined but not used [-Wunused-function]
	drivers/media/radio/radio-shark2.c:240:13: warning: 'shark_resume_leds' defined but not used [-Wunused-function]

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

