Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:54617 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbZD3OQR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 10:16:17 -0400
Received: from ozzy.localnet (dhpc-2-40.sissa.it [147.122.2.220])
	by smtp.sissa.it (Postfix) with ESMTP id 5C3DB1B480A1
	for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 16:16:15 +0200 (CEST)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH] radio_si470x: Drop unused label
Date: Thu, 30 Apr 2009 16:16:21 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301616.23303.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this warning:

/home/nicola/v4l-dvb/v4l/radio-si470x.c: In function 'si470x_fops_release':
/home/nicola/v4l-dvb/v4l/radio-si470x.c:1218: warning: label 'unlock' defined but not used

Priority: normal

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

---
diff -r 83712d149893 -r 97be9e920832 linux/drivers/media/radio/radio-si470x.c
--- a/linux/drivers/media/radio/radio-si470x.c	Wed Apr 29 18:01:48 2009 -0300
+++ b/linux/drivers/media/radio/radio-si470x.c	Thu Apr 30 16:10:24 2009 +0200
@@ -1214,8 +1214,6 @@
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
 	}
-
-unlock:
 	mutex_unlock(&radio->disconnect_lock);
 
 done:

