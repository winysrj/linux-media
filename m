Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750960AbdAWJMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 04:12:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: hverkuil@xs4all.nl
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Matej=20Hul=C3=ADn?= <mito.hulin@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: radio-cadet, initialize timer with setup_timer
Date: Mon, 23 Jan 2017 10:12:30 +0100
Message-Id: <20170123091230.16248-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matej Hulín <mito.hulin@gmail.com>

Stop accessing timer struct members directly and use the setup_timer
helper intended for that use. It makes the code cleaner and will allow
for easier change of the timer struct internals.

Signed-off-by: Matej Hulín <mito.hulin@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <linux-media@vger.kernel.org>
---
 drivers/media/radio/radio-cadet.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 82affaedf067..cbaf850f4791 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -309,9 +309,7 @@ static void cadet_handler(unsigned long data)
 	/*
 	 * Clean up and exit
 	 */
-	init_timer(&dev->readtimer);
-	dev->readtimer.function = cadet_handler;
-	dev->readtimer.data = data;
+	setup_timer(&dev->readtimer, cadet_handler, data);
 	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
 	add_timer(&dev->readtimer);
 }
@@ -320,9 +318,7 @@ static void cadet_start_rds(struct cadet *dev)
 {
 	dev->rdsstat = 1;
 	outb(0x80, dev->io);        /* Select RDS fifo */
-	init_timer(&dev->readtimer);
-	dev->readtimer.function = cadet_handler;
-	dev->readtimer.data = (unsigned long)dev;
+	setup_timer(&dev->readtimer, cadet_handler, (unsigned long)dev);
 	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
 	add_timer(&dev->readtimer);
 }
-- 
2.11.0

