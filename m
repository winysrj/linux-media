Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Axel Lin <axel.lin@ingics.com>
Subject: [PATCH 31/46] [media] via-camera: simplify boolean tests
Date: Wed,  3 Sep 2014 17:33:03 -0300
Message-Id: <19db8385b3c96f001edd5414b1db4a2bedb4a2ef.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using if (foo == false), just use
if (!foo).

That allows a faster mental parsing when analyzing the
code.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 00d431293190..ae6870cb8339 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1276,7 +1276,7 @@ static bool viacam_serial_is_enabled(void)
 			VIACAM_SERIAL_CREG, &cbyte);
 	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
 		return false; /* Not enabled */
-	if (override_serial == 0) {
+	if (!override_serial) {
 		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
 				"refusing to load.\n");
 		printk(KERN_NOTICE "Specify override_serial=1 to force " \
-- 
1.9.3

