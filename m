Return-path: <mchehab@pedra>
Received: from mailfe05.c2i.net ([212.247.154.130]:57349 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756209Ab1EZIIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:08:14 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe05.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 130332182 for linux-media@vger.kernel.org; Thu, 26 May 2011 10:08:12 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v2] Correct and add some parameter descriptions.
Date: Thu, 26 May 2011 10:06:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105261006.57202.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 70d02ce19f64fae4ceee563501e8462a76e17b91 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 26 May 2011 10:06:09 +0200
Subject: [PATCH] Correct and add some parameter descriptions.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/video/tda7432.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tda7432.c b/drivers/media/video/tda7432.c
index 3941f95..bd21854 100644
--- a/drivers/media/video/tda7432.c
+++ b/drivers/media/video/tda7432.c
@@ -49,10 +49,11 @@ static int maxvol;
 static int loudness; /* disable loudness by default */
 static int debug;	 /* insmod parameter */
 module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Set debugging level from 0 to 3. Default is off(0).");
 module_param(loudness, int, S_IRUGO);
-MODULE_PARM_DESC(maxvol,"Set maximium volume to +20db (0), default is 0db(1)");
+MODULE_PARM_DESC(loudness, "Turn loudness on(1) else off(0). Default is off(0).");
 module_param(maxvol, int, S_IRUGO | S_IWUSR);
-
+MODULE_PARM_DESC(maxvol, "Set maximium volume to +20dB(0) else +0dB(1). Default is +20dB(0).");
 
 
 /* Structure of address and subaddresses for the tda7432 */
-- 
1.7.1.1

