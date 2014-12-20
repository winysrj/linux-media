Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42103 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753081AbaLTMpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 07:45:34 -0500
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 4/8] [media] em28xx-core: fix missing newlines
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Y2JPX-0006Ua-6C@rmk-PC.arm.linux.org.uk>
Date: Sat, 20 Dec 2014 12:45:31 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Inspection shows that newlines are missing from several kernel messages
in em28xx-core.  Fix these.

Cc: <stable@vger.kernel.org>
Fixes: 9c669b731470 ("[media] em28xx: add suspend/resume to em28xx_ops")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/media/usb/em28xx/em28xx-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 86461a708abe..37456079f490 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1125,7 +1125,7 @@ int em28xx_suspend_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	em28xx_info("Suspending extensions");
+	em28xx_info("Suspending extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->suspend)
@@ -1139,7 +1139,7 @@ int em28xx_resume_extension(struct em28xx *dev)
 {
 	const struct em28xx_ops *ops = NULL;
 
-	em28xx_info("Resuming extensions");
+	em28xx_info("Resuming extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
 		if (ops->resume)
-- 
1.8.3.1

