Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbcBVTJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 9/9] ivtv-mailbox: avoid confusing smatch
Date: Mon, 22 Feb 2016 16:09:23 -0300
Message-Id: <6a4d1872a94ba8450c9aff6599d1e86b515fd2a9.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
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
index e3ce96763785..4d6a3ad265a5 100644
--- a/drivers/media/pci/ivtv/ivtv-mailbox.c
+++ b/drivers/media/pci/ivtv/ivtv-mailbox.c
@@ -177,8 +177,10 @@ static int get_mailbox(struct ivtv *itv, struct ivtv_mailbox_data *mbdata, int f
 
 		/* Sleep before a retry, if not atomic */
 		if (!(flags & API_NO_WAIT_MB)) {
-			if (time_after(jiffies,
-				       then + msecs_to_jiffies(10*retries)))
+			unsigned int timeout;
+
+			timeout = msecs_to_jiffies(10 * retries);
+			if (time_after(jiffies, then + timeout))
 			       break;
 			ivtv_msleep_timeout(10, 0);
 		}
-- 
2.5.0

