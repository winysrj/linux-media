Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:54319 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZITL6T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 07:58:19 -0400
Received: by pzk34 with SMTP id 34so1873331pzk.22
        for <linux-media@vger.kernel.org>; Sun, 20 Sep 2009 04:58:22 -0700 (PDT)
From: hiranotaka@zng.jp
Date: Sun, 20 Sep 2009 20:57:49 +0900
Message-Id: <87vdjdakw2.fsf@wei.zng.jp>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] pt1: Fix a compile error on arm
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lack of #include <linux/vmalloc.h> caused a compile error on some
architectures.

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>
diff -r 29e4ba1a09bc linux/drivers/media/dvb/pt1/pt1.c
--- a/linux/drivers/media/dvb/pt1/pt1.c	Sat Sep 19 09:45:22 2009 -0300
+++ b/linux/drivers/media/dvb/pt1/pt1.c	Sun Sep 20 20:47:28 2009 +0900
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/vmalloc.h>
 
 #include "dvbdev.h"
 #include "dvb_demux.h"
