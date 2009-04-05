Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfilter4.ihug.co.nz ([203.109.136.4]:19695 "EHLO
	mailfilter4.ihug.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbZDEAo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 20:44:59 -0400
Message-ID: <49D7FF55.70109@yahoo.co.nz>
Date: Sun, 05 Apr 2009 12:46:13 +1200
From: Kevin Wells <wells_kevin@yahoo.co.nz>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: [PATCH 3/4] tm6000: Use mask when getting XFERTYPE from bmAttributes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Kevin Wells <kevin.wells@kahusoft.com>
# Date 1238885144 -43200
# Node ID 02d3a231b99e1eef922679f1381eecd0b9990d23
# Parent  3140e621a17b536eb1487f8f9ad5b7b6a8ff8341
Use mask when getting XFERTYPE from bmAttributes

From: Kevin Wells <kevin.wells@kahusoft.com>

Priority: normal

Signed-off-by: Kevin Wells <kevin.wells@kahusoft.com>

diff -r 3140e621a17b -r 02d3a231b99e 
linux/drivers/media/video/tm6000/tm6000-cards.c
--- a/linux/drivers/media/video/tm6000/tm6000-cards.c    Sat Apr 04 
23:39:18 2009 +1300
+++ b/linux/drivers/media/video/tm6000/tm6000-cards.c    Sun Apr 05 
10:45:44 2009 +1200
@@ -446,7 +446,7 @@
                    interface->altsetting[i].desc.bInterfaceNumber,
                    interface->altsetting[i].desc.bInterfaceClass);
 
-            switch (e->desc.bmAttributes) {
+            switch (e->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
             case USB_ENDPOINT_XFER_BULK:
                 if (!dir_out) {
                     get_max_endpoint (usbdev, "Bulk IN", e,
