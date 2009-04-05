Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter11.ihug.co.nz ([203.109.136.11]:24971 "EHLO
	mailfilter11.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368AbZDEAyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 20:54:46 -0400
Message-ID: <49D7FF4F.3020707@kahusoft.com>
Date: Sun, 05 Apr 2009 12:46:07 +1200
From: Kevin Wells <kevin.wells@kahusoft.com>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/4] tm6000: Remove reference to em28xx from error message.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kevin Wells <kevin.wells@kahusoft.com>
# Date 1238839620 -46800
# Node ID a293d5babca03bb5a7f21ecb659d55e447194e49
# Parent  3d58b6531a818aafdacde895c34e4517a4dc4104
Remove reference to em28xx from error message.

From: Kevin Wells <kevin.wells@kahusoft.com>

Priority: normal

Signed-off-by: Kevin Wells <kevin.wells@kahusoft.com>

diff -r 3d58b6531a81 -r a293d5babca0 
linux/drivers/media/video/tm6000/tm6000-cards.c
--- a/linux/drivers/media/video/tm6000/tm6000-cards.c    Fri Nov 28 
08:39:00 2008 -0200
+++ b/linux/drivers/media/video/tm6000/tm6000-cards.c    Sat Apr 04 
23:07:00 2009 +1300
@@ -378,7 +378,7 @@
     /* Check to see next free device and mark as used */
     nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
     if (nr >= TM6000_MAXBOARDS) {
-        printk ("tm6000: Supports only %i em28xx 
boards.\n",TM6000_MAXBOARDS);
+        printk("tm6000: Only supports %i boards.\n", TM6000_MAXBOARDS);
         usb_put_dev(usbdev);
         return -ENOMEM;
     }
