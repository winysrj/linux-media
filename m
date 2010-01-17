Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52941 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0AQSwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 13:52:08 -0500
Received: by fxm25 with SMTP id 25so488687fxm.21
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 10:52:07 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <op.u6ov64og6dn9rq@denis-laptop.lan>
Subject: [RESEND PATCH] ir-kbd-i2c: Allow to disable Hauppauge filter through
 module parameter
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Date: Sun, 17 Jan 2010 19:51:06 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Samuel Rakitnican" <samuel.rakitnican@gmail.com>
Message-ID: <op.u6oxbgql6dn9rq@denis-laptop.lan>
In-Reply-To: <op.u6ov64og6dn9rq@denis-laptop.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some Hauppauge devices have id=0 so such devices won't work.
For such devices add a module parameter that allow to turn
off filtering.

Signed-off-by: Samuel Rakitničan <semiRocket@gmail.com>
---
diff -r 82bbb3bd0f0a linux/drivers/media/video/ir-kbd-i2c.c
--- a/linux/drivers/media/video/ir-kbd-i2c.c	Mon Jan 11 11:47:33 2010 -0200
+++ b/linux/drivers/media/video/ir-kbd-i2c.c	Sat Jan 16 16:39:14 2010 +0100
@@ -61,6 +61,10 @@
   module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
   MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey (defaults to 0)");

+static int haup_filter = 1;
+module_param(haup_filter, int, 0644);
+MODULE_PARM_DESC(haup_filter, "Hauppauge filter for other remotes, default is 1 (On)");
+

   #define DEVNAME "ir-kbd-i2c"
   #define dprintk(level, fmt, arg...)	if (debug >= level) \
@@ -96,24 +100,27 @@
   	if (!start)
   		/* no key pressed */
   		return 0;
-	/*
-	 * Hauppauge remotes (black/silver) always use
-	 * specific device ids. If we do not filter the
-	 * device ids then messages destined for devices
-	 * such as TVs (id=0) will get through causing
-	 * mis-fired events.
-	 *
-	 * We also filter out invalid key presses which
-	 * produce annoying debug log entries.
-	 */
-	ircode= (start << 12) | (toggle << 11) | (dev << 6) | code;
-	if ((ircode & 0x1fff)==0x1fff)
-		/* invalid key press */
-		return 0;

-	if (dev!=0x1e && dev!=0x1f)
-		/* not a hauppauge remote */
-		return 0;
+	if (haup_filter != 0) {
+		/*
+		 * Hauppauge remotes (black/silver) always use
+		 * specific device ids. If we do not filter the
+		 * device ids then messages destined for devices
+		 * such as TVs (id=0) will get through causing
+		 * mis-fired events.
+		 *
+		 * We also filter out invalid key presses which
+		 * produce annoying debug log entries.
+		 */
+		ircode = (start << 12) | (toggle << 11) | (dev << 6) | code;
+		if ((ircode & 0x1fff) == 0x1fff)
+			/* invalid key press */
+			return 0;
+
+		if (dev != 0x1e && dev != 0x1f)
+			/* not a hauppauge remote */
+			return 0;
+	}

   	if (!range)
   		code += 64;

-- 
Lorem ipsum
