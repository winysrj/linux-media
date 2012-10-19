Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab2JSKnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 06:43:17 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9JAhH92019715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 19 Oct 2012 06:43:17 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] [media] remove include/linux/dvb/dmx.h
Date: Fri, 19 Oct 2012 07:43:11 -0300
Message-Id: <1350643392-2193-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only reason for this header is to make sure that include
linux/time.h were added before uapi/*/dmx.h. Just push down the
time.h header on the few places where this is used, and drop
this new header.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/dmxdev.h    |  1 +
 drivers/media/firewire/firedtv.h   |  1 +
 drivers/media/pci/ttpci/av7110.h   |  1 +
 drivers/media/usb/tlg2300/pd-dvb.c |  1 +
 include/linux/dvb/dmx.h            | 29 -----------------------------
 5 files changed, 4 insertions(+), 29 deletions(-)
 delete mode 100644 include/linux/dvb/dmx.h

diff --git a/drivers/media/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
index 02ebe28..48c6cf9 100644
--- a/drivers/media/dvb-core/dmxdev.h
+++ b/drivers/media/dvb-core/dmxdev.h
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/kernel.h>
+#include <linux/time.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/fs.h>
diff --git a/drivers/media/firewire/firedtv.h b/drivers/media/firewire/firedtv.h
index 4fdcd8c..c2ba085 100644
--- a/drivers/media/firewire/firedtv.h
+++ b/drivers/media/firewire/firedtv.h
@@ -13,6 +13,7 @@
 #ifndef _FIREDTV_H
 #define _FIREDTV_H
 
+#include <linux/time.h>
 #include <linux/dvb/dmx.h>
 #include <linux/dvb/frontend.h>
 #include <linux/list.h>
diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 88b3b2d..a378662 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/i2c.h>
 #include <linux/input.h>
+#include <linux/time.h>
 
 #include <linux/dvb/video.h>
 #include <linux/dvb/audio.h>
diff --git a/drivers/media/usb/tlg2300/pd-dvb.c b/drivers/media/usb/tlg2300/pd-dvb.c
index 30fcb11..ca4994a 100644
--- a/drivers/media/usb/tlg2300/pd-dvb.c
+++ b/drivers/media/usb/tlg2300/pd-dvb.c
@@ -1,6 +1,7 @@
 #include "pd-common.h"
 #include <linux/kernel.h>
 #include <linux/usb.h>
+#include <linux/time.h>
 #include <linux/dvb/dmx.h>
 #include <linux/delay.h>
 #include <linux/gfp.h>
diff --git a/include/linux/dvb/dmx.h b/include/linux/dvb/dmx.h
deleted file mode 100644
index 0be6d8f..0000000
--- a/include/linux/dvb/dmx.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * dmx.h
- *
- * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
- *                  & Ralph  Metzler <ralph@convergence.de>
- *                    for convergence integrated media GmbH
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation; either version 2.1
- * of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
- *
- */
-#ifndef _DVBDMX_H_
-#define _DVBDMX_H_
-
-#include <linux/time.h>
-#include <uapi/linux/dvb/dmx.h>
-
-#endif /*_DVBDMX_H_*/
-- 
1.7.11.7

