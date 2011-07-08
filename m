Return-path: <mchehab@localhost>
Received: from cantor2.suse.de ([195.135.220.15]:53601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1GHJAj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2011 05:00:39 -0400
From: Jean Delvare <jdelvare@suse.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] tea5764: Fix module parameter permissions
Date: Fri, 8 Jul 2011 11:00:37 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Fabio Belavenuto <belavenuto@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107081100.37406.jdelvare@suse.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The third parameter of module_param is supposed to represent sysfs
file permissions. A value of "1" leads to the following:

$ ls -l /sys/module/radio_tea5764/parameters/
total 0
---------x 1 root root 4096 Jul  8 09:17 use_xtal

I am changing it to "0" to align with the other module parameters in
this driver.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Fabio Belavenuto <belavenuto@gmail.com>
---
 drivers/media/radio/radio-tea5764.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.0-rc6.orig/drivers/media/radio/radio-tea5764.c	2011-05-20 10:41:19.000000000 +0200
+++ linux-3.0-rc6/drivers/media/radio/radio-tea5764.c	2011-07-08 09:15:16.000000000 +0200
@@ -596,7 +596,7 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
-module_param(use_xtal, int, 1);
+module_param(use_xtal, int, 0);
 MODULE_PARM_DESC(use_xtal, "Chip have a xtal connected in board");
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "video4linux device number to use");

-- 
Jean Delvare
Suse L3
