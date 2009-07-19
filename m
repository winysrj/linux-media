Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:10716 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbZGSM7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 08:59:43 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1MSX7E-00013T-1s
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Sun, 19 Jul 2009 16:11:48 +0200
Date: Sun, 19 Jul 2009 14:59:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: ir-kbd-i2c: Drop irrelevant inline keywords
Message-ID: <20090719145936.0c21917f@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Functions which are referenced by their address can't be inlined by
definition.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/ir-kbd-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/ir-kbd-i2c.c	2009-07-19 14:30:29.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/ir-kbd-i2c.c	2009-07-19 14:50:30.000000000 +0200
@@ -127,12 +127,12 @@ static int get_key_haup_common(struct IR
 	return 1;
 }
 
-static inline int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	return get_key_haup_common (ir, ir_key, ir_raw, 3, 0);
 }
 
-static inline int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+static int get_key_haup_xvr(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	return get_key_haup_common (ir, ir_key, ir_raw, 6, 3);
 }


-- 
Jean Delvare
