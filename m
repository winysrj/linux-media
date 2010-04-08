Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:56636 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0DHLu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 07:50:26 -0400
Received: by qw-out-2122.google.com with SMTP id 8so752941qwh.37
        for <linux-media@vger.kernel.org>; Thu, 08 Apr 2010 04:50:25 -0700 (PDT)
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 11/16]  V4L/DVB: DVB: ngene, remove unused #include <linux/version.h>
Date: Thu,  8 Apr 2010 19:50:17 +0800
Message-Id: <1270727417-3872-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unused #include <linux/version.h>('s) in
  drivers/media/dvb/ngene/ngene-core.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/media/dvb/ngene/ngene-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 645e8b8..6dc567b 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -37,7 +37,6 @@
 #include <linux/pci_ids.h>
 #include <linux/smp_lock.h>
 #include <linux/timer.h>
-#include <linux/version.h>
 #include <linux/byteorder/generic.h>
 #include <linux/firmware.h>
 #include <linux/vmalloc.h>
-- 
1.6.1.3

