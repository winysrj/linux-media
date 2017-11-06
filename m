Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:57091 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753325AbdKFOHW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Nov 2017 09:07:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: av7110: avoid 2038 overflow in debug print
Date: Mon,  6 Nov 2017 15:06:50 +0100
Message-Id: <20171106140710.1619486-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the deprecated do_gettimeofday() in print_time() will overflow
in 2038 on 32-bit architectures. It'sbetter to use a structure that
is safe everywhere. While we're at it, fix the missing leading zeroes
on the sub-second portion.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/ttpci/av7110.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index f89fb23f6c57..6d415bdeef18 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -347,9 +347,9 @@ static int DvbDmxFilterCallback(u8 *buffer1, size_t buffer1_len,
 static inline void print_time(char *s)
 {
 #ifdef DEBUG_TIMING
-	struct timeval tv;
-	do_gettimeofday(&tv);
-	printk("%s: %d.%d\n", s, (int)tv.tv_sec, (int)tv.tv_usec);
+	struct timespec64 ts;
+	ktime_get_real_ts64(&ts);
+	printk("%s: %lld.%09ld\n", s, (s64)ts.tv_sec, ts.tv_nsec);
 #endif
 }
 
-- 
2.9.0
