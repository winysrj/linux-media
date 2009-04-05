Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter2.ihug.co.nz ([203.109.136.2]:56610 "EHLO
	mailfilter2.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbZDEApD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 20:45:03 -0400
Message-ID: <49D7FF59.1000806@yahoo.co.nz>
Date: Sun, 05 Apr 2009 12:46:17 +1200
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH 4/4] tm6000: Clear bit in tm6000_devused when board is disconnected.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kevin Wells <kevin.wells@kahusoft.com>
# Date 1238885821 -43200
# Node ID ca10a33f275b6fefa15ef651df9b657834a28bb0
# Parent  02d3a231b99e1eef922679f1381eecd0b9990d23
Clear bit in tm6000_devused when board is disconnected.

From: Kevin Wells <kevin.wells@kahusoft.com>

Priority: normal

Signed-off-by: Kevin Wells <kevin.wells@kahusoft.com>

diff -r 02d3a231b99e -r ca10a33f275b 
linux/drivers/media/video/tm6000/tm6000-cards.c
--- a/linux/drivers/media/video/tm6000/tm6000-cards.c    Sun Apr 05 
10:45:44 2009 +1200
+++ b/linux/drivers/media/video/tm6000/tm6000-cards.c    Sun Apr 05 
10:57:01 2009 +1200
@@ -559,6 +559,8 @@
 
     dev->state |= DEV_DISCONNECTED;
 
+    tm6000_devused &= ~(1 << dev->devno);
+
     usb_put_dev(dev->udev);
 
     mutex_unlock(&dev->lock);
