Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:32259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbZAXFGs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jan 2009 00:06:48 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2786404fgg.17
        for <linux-media@vger.kernel.org>; Fri, 23 Jan 2009 21:06:45 -0800 (PST)
Subject: [PATCH] radio-mr800: fix radio->muted and radio->stereo
From: Alexey Klimov <klimov.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 24 Jan 2009 08:07:04 +0300
Message-Id: <1232773624.6320.17.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Mauro

This is simple fix for mr800 usb radio driver.
It would be great to have it in next upstream pull request if you don't
mind.

---
Move radio->muted and radio->stereo in section where radio mutex is
locked to avoid possible race condition problems or access to memory.
Thanks to David Ellingsworth <david@identd.dyndns.org> for pointing to
this weak place in driver.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 6a6eb9efc6cd linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Fri Jan 23 22:35:12 2009 -0200
+++ b/linux/drivers/media/radio/radio-mr800.c	Sat Jan 24 07:22:38 2009 +0300
@@ -197,9 +197,9 @@
 		return retval;
 	}
 
+	radio->muted = 0;
+
 	mutex_unlock(&radio->lock);
-
-	radio->muted = 0;
 
 	return retval;
 }
@@ -233,9 +233,9 @@
 		return retval;
 	}
 
+	radio->muted = 1;
+
 	mutex_unlock(&radio->lock);
-
-	radio->muted = 1;
 
 	return retval;
 }
@@ -287,9 +287,9 @@
 		return retval;
 	}
 
+	radio->stereo = 0;
+
 	mutex_unlock(&radio->lock);
-
-	radio->stereo = 0;
 
 	return retval;
 }


-- 
Best regards, Klimov Alexey

