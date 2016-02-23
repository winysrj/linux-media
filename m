Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbcBWKLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 05:11:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH v2] ivtv-mailbox: avoid confusing smatch
Date: Tue, 23 Feb 2016 07:10:59 -0300
Message-Id: <dbfb8be944cabea5bc1eef31ca5c93d71f081b41.1456222254.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current logic causes smatch to be confused:
	include/linux/jiffies.h:359:41: error: strange non-value function or array
	include/linux/jiffies.h:361:42: error: strange non-value function or array
	include/linux/jiffies.h:359:41: error: strange non-value function or array
	include/linux/jiffies.h:361:42: error: strange non-value function or array

Use a different logic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/ivtv/ivtv-mailbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-mailbox.c b/drivers/media/pci/ivtv/ivtv-mailbox.c
index e3ce96763785..1d3586109b84 100644
--- a/drivers/media/pci/ivtv/ivtv-mailbox.c
+++ b/drivers/media/pci/ivtv/ivtv-mailbox.c
@@ -177,8 +177,10 @@ static int get_mailbox(struct ivtv *itv, struct ivtv_mailbox_data *mbdata, int f
 
 		/* Sleep before a retry, if not atomic */
 		if (!(flags & API_NO_WAIT_MB)) {
-			if (time_after(jiffies,
-				       then + msecs_to_jiffies(10*retries)))
+			unsigned long timeout;
+
+			timeout = msecs_to_jiffies(10 * retries);
+			if (time_after(jiffies, then + timeout))
 			       break;
 			ivtv_msleep_timeout(10, 0);
 		}
-- 
2.5.0

