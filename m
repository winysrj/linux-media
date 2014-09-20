Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2979 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbaITMmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 08:42:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/16] cx88: increase API command timeout
Date: Sat, 20 Sep 2014 14:41:44 +0200
Message-Id: <1411216911-7950-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
References: <1411216911-7950-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The timeout is way too small. Especially complicated command like
CX2341X_ENC_STOP_CAPTURE takes much more time than 10 ms. Increase the
timeout to 1 second, just as ivtv does (the cx88-blackbird has the
same IP core for MPEG compression as ivtv).

This solves a nasty issue where STOP_CAPTURE would timeout and the
mailbox is left in a busy state, making it impossible to start streaming
a second time without reloading the driver first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx88/cx88-blackbird.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index f27a3f1..32fb935 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -348,7 +348,7 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	memory_write(dev->core, dev->mailbox, flag);
 
 	/* wait for firmware to handle the API command */
-	timeout = jiffies + msecs_to_jiffies(10);
+	timeout = jiffies + msecs_to_jiffies(1000);
 	for (;;) {
 		memory_read(dev->core, dev->mailbox, &flag);
 		if (0 != (flag & 4))
-- 
2.1.0

