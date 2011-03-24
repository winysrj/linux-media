Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934100Ab1CXU1v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 16:27:51 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2OKRpK7018963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 24 Mar 2011 16:27:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] lirc_sasem: key debug spew off debug modparam
Date: Thu, 24 Mar 2011 16:27:49 -0400
Message-Id: <1300998469-5855-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/lirc/lirc_sasem.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 63a438d..7080cde 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -570,6 +570,7 @@ static void incoming_packet(struct sasem_context *context,
 	unsigned char *buf = urb->transfer_buffer;
 	long ms;
 	struct timeval tv;
+	int i;
 
 	if (len != 8) {
 		printk(KERN_WARNING "%s: invalid incoming packet size (%d)\n",
@@ -577,12 +578,12 @@ static void incoming_packet(struct sasem_context *context,
 		return;
 	}
 
-#ifdef DEBUG
-	int i;
-	for (i = 0; i < 8; ++i)
-		printk(KERN_INFO "%02x ", buf[i]);
-	printk(KERN_INFO "\n");
-#endif
+	if (debug) {
+		printk(KERN_INFO "Incoming data: ");
+		for (i = 0; i < 8; ++i)
+			printk(KERN_CONT "%02x ", buf[i]);
+		printk(KERN_CONT "\n");
+	}
 
 	/*
 	 * Lirc could deal with the repeat code, but we really need to block it
-- 
1.7.1

