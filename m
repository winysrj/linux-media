Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39406 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0EVRMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 13:12:10 -0400
Received: by pwi5 with SMTP id 5so874903pwi.19
        for <linux-media@vger.kernel.org>; Sat, 22 May 2010 10:12:10 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 04/12] V4L/DVB: ngene: remove unused #include <linux/version.h>
Date: Sun, 23 May 2010 01:12:06 +0800
Message-Id: <1274548326-3512-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/dvb/ngene/ngene-dvb.c
  drivers/media/dvb/ngene/ngene-i2c.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/dvb/ngene/ngene-dvb.c |    1 -
 drivers/media/dvb/ngene/ngene-i2c.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-dvb.c b/drivers/media/dvb/ngene/ngene-dvb.c
index 96013eb..e5ec893 100644
--- a/drivers/media/dvb/ngene/ngene-dvb.c
+++ b/drivers/media/dvb/ngene/ngene-dvb.c
@@ -37,7 +37,6 @@
 #include <linux/pci.h>
 #include <linux/smp_lock.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/media/dvb/ngene/ngene-i2c.c b/drivers/media/dvb/ngene/ngene-i2c.c
index 2ef54ca..477fe0a 100644
--- a/drivers/media/dvb/ngene/ngene-i2c.c
+++ b/drivers/media/dvb/ngene/ngene-i2c.c
@@ -39,7 +39,6 @@
 #include <linux/pci_ids.h>
 #include <linux/smp_lock.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
 #include <linux/vmalloc.h>
-- 
1.6.1.3

