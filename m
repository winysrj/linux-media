Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab1GNWKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:10:07 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EMA7BT024742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:10:07 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 9/9] [media] mceusb: update version, copyright, author
Date: Thu, 14 Jul 2011 18:09:54 -0400
Message-Id: <1310681394-3530-10-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add note about recent updates coming from Microsoft's publicly available
specs on Windows Media Center remotes and receivers/transmitters.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index fa1d182..053d079 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1,7 +1,7 @@
 /*
  * Driver for USB Windows Media Center Ed. eHome Infrared Transceivers
  *
- * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ * Copyright (c) 2010-2011, Jarod Wilson <jarod@redhat.com>
  *
  * Based on the original lirc_mceusb and lirc_mceusb2 drivers, by Dan
  * Conti, Martin Blatter and Daniel Melander, the latter of which was
@@ -15,6 +15,11 @@
  * Jon Smirl, which included enhancements and simplifications to the
  * incoming IR buffer parsing routines.
  *
+ * Updated in July of 2011 with the aid of Microsoft's official
+ * remote/transceiver requirements and specification document, found at
+ * download.microsoft.com, title
+ * Windows-Media-Center-RC-IR-Collection-Green-Button-Specification-03-08-2011-V2.pdf
+ *
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -41,8 +46,8 @@
 #include <linux/delay.h>
 #include <media/rc-core.h>
 
-#define DRIVER_VERSION	"1.91"
-#define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
+#define DRIVER_VERSION	"1.92"
+#define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
 #define DRIVER_DESC	"Windows Media Center Ed. eHome Infrared Transceiver " \
 			"device driver"
 #define DRIVER_NAME	"mceusb"
-- 
1.7.1

