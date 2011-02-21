Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41584 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1BUSVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 13:21:04 -0500
Received: by wwa36 with SMTP id 36so6380411wwa.1
        for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 10:21:02 -0800 (PST)
Subject: [PATCH] avoid kernel oops when rmmod saa7134
From: Hussam Al-Tayeb <ht990332@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 20:20:26 +0200
Message-ID: <1298312426.3152.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following is a patch to avoid a kernel oops when running rmmod
saa7134 on kernel 2.6.27.1. The change is as suggested by mchehab on
irc.freenode.org

Signed-off-by: Hussam Al-Tayeb <ht990332@gmail.com>

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -701,7 +701,7 @@
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 
-	rdev->close(rdev);
+	 if (rdev) rdev->close(rdev);
 }
 
 /* class for /sys/class/rc */

