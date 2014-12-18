Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:47710 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaLRLxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 06:53:08 -0500
Received: by mail-pa0-f41.google.com with SMTP id rd3so1269855pab.28
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 03:53:08 -0800 (PST)
From: Chunyan Zhang <zhang.chunyan@linaro.org>
To: m.chehab@samsung.com, david@hardeman.nu, uli-lirc@uli-eckhardt.de,
	hans.verkuil@cisco.com, julia.lawall@lip6.fr, himangi774@gmail.com,
	khoroshilov@ispras.ru, joe@perches.com, dborkman@redhat.com,
	john.stultz@linaro.org, tglx@linutronix.de, davem@davemloft.net,
	dwmw2@infradead.org, computersforpeace@gmail.com, arnd@linaro.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, zhang.lyra@gmail.com
Subject: [PATCH 2/3] mtd: test: Replace timeval with ktime_t in speedtest.c and torturetest.c
Date: Thu, 18 Dec 2014 19:52:01 +0800
Message-Id: <1418903522-19137-3-git-send-email-zhang.chunyan@linaro.org>
In-Reply-To: <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
References: <ktime-mtd-rc-v1>
 <1418903522-19137-1-git-send-email-zhang.chunyan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch changes the 32-bit time type (timeval) to the 64-bit one
(ktime_t), since 32-bit time types will break in the year 2038.

I use ktime_t instead of timeval to define 'start' and 'finish'
which are used to get the time for tow points.

This patch also changes do_gettimeofday() to ktime_get() accordingly,
since ktime_get returns a ktime_t, but do_gettimeofday returns a
struct timeval, and the other reason is that ktime_get() uses
the monotonic clock.

This patch will use a new function 'ktime_ms_delta' which is introduced
in 1/3 of this patch-set to get the millisecond time difference.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mtd/tests/speedtest.c   |   10 +++++-----
 drivers/mtd/tests/torturetest.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/tests/speedtest.c b/drivers/mtd/tests/speedtest.c
index 5ee9f70..87a6e25 100644
--- a/drivers/mtd/tests/speedtest.c
+++ b/drivers/mtd/tests/speedtest.c
@@ -22,6 +22,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/err.h>
@@ -49,7 +50,7 @@ static int pgsize;
 static int ebcnt;
 static int pgcnt;
 static int goodebcnt;
-static struct timeval start, finish;
+static ktime_t start, finish;
 
 static int multiblock_erase(int ebnum, int blocks)
 {
@@ -168,12 +169,12 @@ static int read_eraseblock_by_2pages(int ebnum)
 
 static inline void start_timing(void)
 {
-	do_gettimeofday(&start);
+	start = ktime_get();
 }
 
 static inline void stop_timing(void)
 {
-	do_gettimeofday(&finish);
+	finish = ktime_get();
 }
 
 static long calc_speed(void)
@@ -181,8 +182,7 @@ static long calc_speed(void)
 	uint64_t k;
 	long ms;
 
-	ms = (finish.tv_sec - start.tv_sec) * 1000 +
-	     (finish.tv_usec - start.tv_usec) / 1000;
+	ms = ktime_ms_delta(finish, start);
 	if (ms == 0)
 		return 0;
 	k = goodebcnt * (mtd->erasesize / 1024) * 1000;
diff --git a/drivers/mtd/tests/torturetest.c b/drivers/mtd/tests/torturetest.c
index eeab969..7e77ed4 100644
--- a/drivers/mtd/tests/torturetest.c
+++ b/drivers/mtd/tests/torturetest.c
@@ -26,6 +26,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/init.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/err.h>
@@ -79,18 +80,18 @@ static unsigned char *check_buf;
 static unsigned int erase_cycles;
 
 static int pgsize;
-static struct timeval start, finish;
+static ktime_t start, finish;
 
 static void report_corrupt(unsigned char *read, unsigned char *written);
 
 static inline void start_timing(void)
 {
-	do_gettimeofday(&start);
+	start = ktime_get();
 }
 
 static inline void stop_timing(void)
 {
-	do_gettimeofday(&finish);
+	finish = ktime_get();
 }
 
 /*
@@ -322,8 +323,7 @@ static int __init tort_init(void)
 			long ms;
 
 			stop_timing();
-			ms = (finish.tv_sec - start.tv_sec) * 1000 +
-			     (finish.tv_usec - start.tv_usec) / 1000;
+			ms = ktime_ms_delta(finish, start);
 			pr_info("%08u erase cycles done, took %lu "
 			       "milliseconds (%lu seconds)\n",
 			       erase_cycles, ms, ms / 1000);
-- 
1.7.9.5

