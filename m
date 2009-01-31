Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:36429 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZAaP3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Jan 2009 10:29:40 -0500
Received: by ewy14 with SMTP id 14so1205429ewy.13
        for <linux-media@vger.kernel.org>; Sat, 31 Jan 2009 07:29:38 -0800 (PST)
Message-ID: <49846E63.8070507@gmail.com>
Date: Sat, 31 Jan 2009 16:29:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: [PATCH] newport: newport_*wait() return 0 on timeout
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With a postfix decrement t reaches -1 on timeout which results in a
return of 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/video/newport.h b/include/video/newport.h
index 1f5ebea..001b935 100644
--- a/include/video/newport.h
+++ b/include/video/newport.h
@@ -453,7 +453,7 @@ static __inline__ int newport_wait(struct newport_regs *regs)
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if (!(regs->cset.status & NPORT_STAT_GBUSY))
 			break;
 	return !t;
@@ -463,7 +463,7 @@ static __inline__ int newport_bfwait(struct newport_regs *regs)
 {
 	int t = BUSY_TIMEOUT;
 
-	while (t--)
+	while (--t)
 		if(!(regs->cset.status & NPORT_STAT_BBUSY))
 			break;
 	return !t;
